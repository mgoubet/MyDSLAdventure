/*
 * generated by Xtext 2.15.0
 */
package org.xtext.mydsladventure.rpg.validation

import java.util.ArrayList
import org.eclipse.xtext.validation.Check
import myDSLAdventure.Room
import myDSLAdventure.MyDSLAdventurePackage
import myDSLAdventure.Game
import myDSLAdventure.Player
import myDSLAdventure.ExitList

/**
 * This class contains custom validation rules. 
 * 
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#validation
 */
class RPGValidator extends AbstractRPGValidator {

	@Check
	def checkUniqueRoomVerbs(Room room) {
		
		val roomVerbs = new ArrayList<String>();
		
		for(exit : room.exits) {
			
			if(exit.action.startsWith("go ")) {
				
				val msg = '''Cannot start exit verb "«exit.action»" with 'go' (in room: «room.name»)'''
				error(msg, exit, MyDSLAdventurePackage.Literals.EXIT__ACTION)
				
			} else if(roomVerbs.contains(exit.action)) {
				
				val msg = '''Duplicate exit verb "«exit.action»" (in room: «room.name»)'''
				error(msg, exit, MyDSLAdventurePackage.Literals.EXIT__ACTION)
				
			} else {
				roomVerbs.add(exit.action)
			}
		}	

		for(action : room.actions) {
			
			if(action.verb.startsWith("go ")) {
				
				val msg = '''Cannot start action verb "«action.verb»" with 'go' (in room: «room.name»)'''
				error(msg, action, MyDSLAdventurePackage.Literals.ACTION__VERB)
				
			} else if(roomVerbs.contains(action.verb)) {
				
				val msg = '''Duplicate action verb "«action.verb»" (in room: «room.name»)'''
				error(msg, action, MyDSLAdventurePackage.Literals.ACTION__VERB)
				
			} else {
				roomVerbs.add(action.verb)
			}
		}
	}

	
	
	
	@Check
	def checkSingleEndsAndPlayer(Game game) {
		 
		var hasPlayer = false
		var hasEnds = false
		var index = 0
		
		for(gameElementList : game.gameElementLists) {
			
			if(gameElementList instanceof Player) {
				if(hasPlayer) {
					val msg =  "Too many Player declarations (exactly one required)"
					error(msg, game, MyDSLAdventurePackage.Literals.GAME__GAME_ELEMENT_LISTS, index)
				} else {
					hasPlayer = true
				}
			} else if(gameElementList instanceof ExitList) {
				if(hasEnds) {
					val msg = "Too many Ends declarations (exactly one required)"
					error(msg, game, MyDSLAdventurePackage.Literals.GAME__GAME_ELEMENT_LISTS, index)
				} else {
					hasEnds = true
				}
			}
			
			index++	
		}
		
		if(!hasEnds) {
			val msg = "Missing Ends declaration (exactly one required)"
			error(msg, game, MyDSLAdventurePackage.Literals.GAME__GAME_TITLE)
		}
		
		if(!hasPlayer) {
			val msg = "Missing Player declaration (exactly one required)"
			error(msg, game, MyDSLAdventurePackage.Literals.GAME__GAME_TITLE)
		}
	}
}
