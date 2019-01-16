/*
 * generated by Xtext 2.15.0
 */
package org.xtext.mydsladventure.rpg.generator

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.AbstractGenerator
import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.xtext.generator.IGeneratorContext
import myDSLAdventure.Game
import myDSLAdventure.GameElementList
import myDSLAdventure.Player
import myDSLAdventure.Weapon
import myDSLAdventure.RoomList
import myDSLAdventure.WeaponList
import myDSLAdventure.ExitList
import myDSLAdventure.MonsterList
import myDSLAdventure.MonsterDescription
import myDSLAdventure.MonsterEquipment
import myDSLAdventure.MonsterPlacement
import myDSLAdventure.Exit
import myDSLAdventure.Room
import myDSLAdventure.RoomId
import myDSLAdventure.WeaponId
import myDSLAdventure.MonsterStatement
import java.util.List

/**
 * Generates code from your model files on save.
 * 
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#code-generation
 */
class RPGGenerator extends AbstractGenerator {
	
	Player player;
	List<RoomList> rooms;
	ExitList gameExits;

	override void doGenerate(Resource resource, IFileSystemAccess2 fsa, IGeneratorContext context) {
		fsa.generateFile(resource.URI.trimFileExtension.appendFileExtension("aslx").lastSegment, 
			resource.allContents.filter(Game).toIterable.head.compile.toString);
	}
	
	def findRoom(RoomId id) {
		for (list : rooms) {
			for (room : list.room) {
				if (room.roomid.roomId.equals(id.roomId))
					return room;
			}
		}
	}
	
	def dispatch compile(MonsterList monsterList) '''TODO'''
	def dispatch compile(RoomList rooms) '''
		«FOR room : rooms.room»
			« room.compile »
		«ENDFOR»
	'''
	def dispatch compile(WeaponList monsterList) '''TODO'''

	def dispatch compile(Player player) '''
		<object name="player">
	      <inherit name="editor_object" />
	      <inherit name="editor_player" />
	    </object>	
	'''
	
	def dispatch compile(ExitList monsterList) '''
	TODO
	'''
	
	
	def dispatch compile(GameElementList monsterList) '''TODO'''
	def dispatch compile(MonsterStatement monsterList) '''TODO'''
	
	def dispatch compile(MonsterDescription monsterList) '''TODO'''
	def dispatch compile(MonsterEquipment monsterList) '''TODO'''
	def dispatch compile(MonsterPlacement monsterList) '''TODO'''
	
	def dispatch compile(Exit exit) '''
		<exit alias="« exit.action »" to="« findRoom(exit.goto).roomName »">
			<message>« exit.description »</message>
		</exit>
	'''
	
	def dispatch compile(RoomId id) ''' « id.roomId » '''

	def dispatch compile(Room room) '''
		  <object name="« room.roomName »">
		    <inherit name="editor_room" />
		    <isroom />
		    <description>« room.description »</description>
		    <descprefix>You are in</descprefix>
		    <objectslistprefix>You can see</objectslistprefix>
		    <usedefaultprefix type="boolean">false</usedefaultprefix>
			«FOR exit : room.exits»
				« exit.compile »
			«ENDFOR»
			«FOR gameExit : gameExits.room»
				«IF gameExit.roomId.equals(room.roomid.roomId)»
					<exit alias="exitName">
						<runscript />
						<script type="script">
							msg(You did great, you are so awesome, well done. See you next time)
							finish
						</script>
					</exit>
				«ENDIF»
			«ENDFOR»
			«IF player.startRoom.roomId.equals(room.roomid.roomId) »
				« player.compile »
			«ENDIF»
		  </object>
	'''
	
	
	def dispatch compile(WeaponId monsterList) '''TODO'''
	def dispatch compile(Weapon monsterList) '''TODO'''
	
	def dispatch compile(Game game) {
	
	this.player = game.gameelementlist.filter(Player).get(0);
	this.rooms = game.gameelementlist.filter(RoomList).toList();
	this.gameExits = game.gameelementlist.filter(ExitList).get(0);
	
	'''
	<asl version="580">
	  <include ref="English.aslx" />
	  <include ref="Core.aslx" />
	  <game name="« game.gameTitle »">
	    <gameid>3a5e3f9b-f412-4085-b1c1-06d83237d484</gameid>
	    <version>1.0</version>
	    <firstpublished>2019</firstpublished>
	    <showhealth />
	    <turnoffcompass />
	    <onhealthzero type="script">
	    	msg("WASTED")
	    	finish
	    </onhealthzero>
	  </game>
	
		 «FOR elem : game.gameelementlist.filter(RoomList) »
			« elem.compile »
		 «ENDFOR»
	 	 «FOR elem : game.gameelementlist.filter(WeaponList) »
	 		« elem.compile »
	 	 «ENDFOR»
 	 	 «FOR elem : game.gameelementlist.filter(MonsterList) »
 	 		« elem.compile »
 	 	 «ENDFOR»
 	 	 «FOR elem : game.gameelementlist.filter(ExitList) »
 	 		« elem.compile »
 	 	 «ENDFOR»
	
	</asl>
	
	'''
	
	}
	
}
