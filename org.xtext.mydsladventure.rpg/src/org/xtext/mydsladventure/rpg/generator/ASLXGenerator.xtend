/*
 * generated by Xtext 2.15.0
 */
package org.xtext.mydsladventure.rpg.generator

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.AbstractGenerator
import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.xtext.generator.IGeneratorContext
import myDSLAdventure.Game
import myDSLAdventure.Player
import myDSLAdventure.Weapon
import myDSLAdventure.RoomList
import myDSLAdventure.ExitList
import myDSLAdventure.Monster
import myDSLAdventure.MonsterList
import myDSLAdventure.MonsterEquipment
import myDSLAdventure.MonsterPlacement
import myDSLAdventure.Exit
import myDSLAdventure.Room
import java.util.List
import java.util.ArrayList

/**
 * Generates code from your model files on save.
 * 
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#code-generation
 */
class ASLXGenerator extends AbstractGenerator {
	
	Player player;
	List<RoomList> rooms;
	ExitList gameExits;
	List<Monster> monsters = new ArrayList<Monster>();
	List<MonsterPlacement> monsterPlacements = new ArrayList<MonsterPlacement>();
	List<MonsterEquipment> monsterEquipments = new ArrayList<MonsterEquipment>();
	
	String projectName;

	override void doGenerate(Resource resource, IFileSystemAccess2 fsa, IGeneratorContext context) {
		projectName = resource.URI.trimFileExtension.segment(resource.URI.trimFileExtension.segmentCount - 1);
		
		fsa.generateFile(resource.URI.trimFileExtension.appendFileExtension("aslx").lastSegment, 
			resource.allContents.filter(Game).toIterable.head.compile.toString);
			
		var zipFile = new QuestArchiveBuilder()
			.addFile(
				resource.URI.trimFileExtension.appendFileExtension("aslx").lastSegment,
				fsa.readTextFile(resource.URI.trimFileExtension.appendFileExtension("aslx").lastSegment).toString()
			)
			.addFilesFromResources(".*generator/resources/CombatLib/.*\\.aslx")
			.addFilesFromResources(".*generator/resources/CombatLib/.*\\.xml")
			.stream
			
		fsa.generateFile(resource.URI.trimFileExtension.appendFileExtension("quest").lastSegment, zipFile);
	}
	
	def findRoom(String id) {
		for (list : rooms) {
			for (room : list.rooms) {
				if (room.name.equals(id))
					return room;
			}
		}
	}
		
	def dispatch compile(RoomList rooms) '''
		«FOR room : rooms.rooms»
			« room.compile »
		«ENDFOR»
	'''

	def dispatch compile(Player player) '''
		<object name="player">
	      <inherit name="editor_object" />
	      <inherit name="editor_player" />
	      <statusattributes type="stringdictionary">
	      	<item>
	      	  <key>hitpoints</key>
	      	  <value></value>
	      	</item>
	      	<item>
	      	  <key>equipped</key>
			  <value></value>
			</item>
		</statusattributes>
	      «player.weapon.compile»
	      <object name="map">
            <inherit name="editor_object" />
            <look type="script">
              picture ("«projectName».png")
              msg ("You are in " + game.currentroom)
            </look>
            <inventoryverbs type="stringlist">
              <value>Look at</value>
              <value>Drop</value>
            </inventoryverbs>
            <take />
          </object>
	    </object>
	'''	

	
	def dispatch compile(Monster monster) '''
		    <object name="«monster.name»">
	          <inherit name="editor_object" />
	          <inherit name="multi_monster" />
	          <visible />
	          <alias>«monster.fullName»</alias>
	          <level type="int">0</level>
	          <hitpoints type="int">« monster.health »</hitpoints>
	          <xp type="int">0</xp>
	          <monstertype>Human</monstertype>
	          <attacktype>Natural</attacktype>
	          <descscript type="script">
                  picture ("«projectName»/«monster.name».png")
                  msg("A «monster.fullName»")
	          </descscript>
	          <lookwhendead>Looks like a dead «monster.fullName».</lookwhendead>
	          <nocorpse type="boolean">false</nocorpse>
	          <attackasgroup />
	          <object name="base_attack_«monster.name»">
	            <inherit name="editor_object" />
	            <inherit name="monster_attack" />
	            <damagedicenumber type="int">«monster.baseDamage»</damagedicenumber>
	            <attackdesc>% uses «monster.baseWeaponName»</attackdesc>
	          </object>
	          «FOR meq : monsterEquipments»
	          	«IF meq.monster.equals(monster)»
		          «meq.weapon.compile»
  		          <object name="Weapon_«meq.weapon.name»">
  		            <inherit name="editor_object" />
  		            <inherit name="monster_attack" />
                    <damagedicenumber type="int">«meq.weapon.damage»</damagedicenumber>
  		            <attackdesc>% uses «meq.weapon.fullName»</attackdesc>
  		          </object>
	          	«ENDIF»
	          «ENDFOR»
	        </object>
	'''
	
	def dispatch compile(Exit exit) '''
		<exit alias="« exit.action »" to="« exit.goto.name »">
			<message>« exit.description »</message>
		</exit>
	'''


	def dispatch compile(Room room) '''
		  <object name="« room.name »">
		    <inherit name="editor_room" />
		    <isroom />
		    <alias>«room.fullName»</alias>
		    <description>« room.description »</description>
		    <descprefix>You are in</descprefix>
		    <objectslistprefix>You can see</objectslistprefix>
		    <usedefaultprefix type="boolean">false</usedefaultprefix>
		    <beforeenter type="script">
		    	game.currentroom = "«room.name»"
		    </beforeenter>
			«FOR exit : room.exits»
				« exit.compile »
			«ENDFOR»
			«FOR gameExit : gameExits.room»
				«IF gameExit.equals(room)»
					<enter type="script">
						finish
					</enter>
				«ENDIF»
			«ENDFOR»
			«IF player.startRoom.equals(room) »
				« player.compile »
			«ENDIF»
			«FOR placement: monsterPlacements »
				«IF placement.room.equals(room)»
					«FOR monster: monsters»
						«IF monster.equals(placement.monster)»
							« monster.compile »
						«ENDIF»
					«ENDFOR»
				«ENDIF»
			«ENDFOR»
		  </object>
	'''

	def dispatch compile(Weapon weapon) '''
      <object name="«weapon.name»">
        <inherit name="editor_object" />
        <inherit name="weapon" />
        <canberusted type="boolean">false</canberusted>
        <canbevenomed type="boolean">false</canbevenomed>
        <damagedicenumber type="int">«weapon.damage»</damagedicenumber>
        <alias>«weapon.fullName»</alias>
        <notindescription type="boolean">false</notindescription>
        <destroyonsale type="boolean">false</destroyonsale>
      </object>
    '''
	
	def dispatch compile(Game game) {
	
	this.player = game.gameElementLists.filter(Player).get(0);
	this.rooms = game.gameElementLists.filter(RoomList).toList();
	this.gameExits = game.gameElementLists.filter(ExitList).get(0);

	for (MonsterList list : game.gameElementLists.filter(MonsterList).toList()) {
		this.monsterPlacements.addAll(list.monsterStatements.filter(MonsterPlacement).toList());
		this.monsterEquipments.addAll(list.monsterStatements.filter(MonsterEquipment).toList());
		this.monsters.addAll(list.monsterStatements.filter(Monster).toList());
	}
	
	'''
	<asl version="580">
	  <include ref="English.aslx" />
	  <include ref="Core.aslx" />
	  <include ref="CombatLib.aslx" />
	  <game name="« game.gameTitle »">
	    <gameid>3a5e3f9b-f412-4085-b1c1-06d83237d484</gameid>
	    <version>1.0</version>
	    <firstpublished>2019</firstpublished>
        <start type="script">
        	CombatInitialise
        </start>
        <feature_advancedwearables />
	    <turnoffcompass />
	    <attr name="currentroom" type="string"></attr>
	  </game>
		 «FOR elem : game.gameElementLists.filter(RoomList) »
			« elem.compile »
		 «ENDFOR»

	</asl>
	
	'''
	
	}
	
}
