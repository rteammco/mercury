//
//  Teams.swift
//  Mercury
//
//  Created by Richard Teammco on 12/9/16.
//  Copyright © 2016 Richard Teammco. All rights reserved.
//
//  All GameObjects are assigned a Team, which defines their interaction with the Player. GameObjects on the "friendly" Team cannot harm or be harmed by the Player. On the contrary, "enemy" Team objects explicity oppose the Player.

enum Team {
  case friendly
  case enemy
  case neutral
}
