/*
 * generated by Xtext 2.15.0
 */
package org.xtext.mydsladventure.rpg.ui.labeling

import com.google.inject.Inject
import org.eclipse.emf.edit.ui.provider.AdapterFactoryLabelProvider
import org.eclipse.xtext.ui.label.DefaultEObjectLabelProvider
import myDSLAdventure.RoomList
import myDSLAdventure.WeaponList
import myDSLAdventure.MonsterList
import myDSLAdventure.Monster
import myDSLAdventure.ExitList
import myDSLAdventure.Room
import myDSLAdventure.Weapon
import myDSLAdventure.Game
import myDSLAdventure.Exit
import myDSLAdventure.Action
import myDSLAdventure.MonsterPlacement
import myDSLAdventure.MonsterEquipment
import myDSLAdventure.Player

/**
 * Provides labels for EObjects.
 * 
 * See https://www.eclipse.org/Xtext/documentation/304_ide_concepts.html#label-provider
 */
class RPGLabelProvider extends DefaultEObjectLabelProvider {

	@Inject
	new(AdapterFactoryLabelProvider delegate) {
		super(delegate);
	}
	
	def text(MonsterList monsterList) {
		return '''Monsters [« monsterList.monsterStatements.filter(Monster).length »]'''
	}

	def text(WeaponList weaponList) {
		return '''Weapons [« weaponList.weapons.length »]'''
	}
	
	def text(RoomList roomList) {
		return '''Rooms [« roomList.rooms.length »]'''
	}
	
	def text(ExitList exitList) {
		return '''Ends [« exitList.room.length »]'''
	}
	
	def text(Exit exit) {
		return exit.action
	}
	
	def text(Action action) {
		return action.verb
	}
	
	def text(MonsterPlacement placement) {
		return '''«placement.monster.name» in «placement.room.name»'''
	}
	
	def text(MonsterEquipment equipment) {
		return '''«equipment.monster.name» has «equipment.weapon.name»'''
	}
	
	def text(Player player) {
		
		if(player.weapon !== null) {
			return '''Player («player.healthPoints» HP) has «player.weapon.name» in «player.startRoom.name»'''
		} else {
			return '''Player («player.healthPoints» HP) in «player.startRoom.name»'''
		}
	}
	
	def image(Game game) {
		"controller.png"
	}
	
	def image(Room room) {
		"Door_green.png"
	}
	
	def image(RoomList roomList) {
		"Door_green.png"
	}
	
	def image(Exit exit) {
		"Door_red.png"
	}
	
	def image(ExitList exitList) {
		"Door_red.png"
	}
	
	def image(Weapon weapon) {
		"Weapon.gif"
	}
	
	def image(WeaponList weaponList) {
		"Weapon.gif"
	}
	
	def image(Monster monster) {
		"Monster.gif"
	}
	
	def image(MonsterList monsterList) {
		"Monster.gif"
	}
}
