//
//  GlobalValues.swift
//  aKIMbo
//
//  Created by Antonio Romano on 22/03/22.
//

import Foundation
import GameController

let pi = 3.14


struct ColliderTypes{
    static let player: UInt32 = 1
    static let enemy: UInt32 = 2
    static let bullet: UInt32 = 3
    static let enemyBullet: UInt32 = 4
    static let wall: UInt32 = 5
}


//let MAX_SPEED: Double = 300
let MAX_SPEED: Double = 225
let ACCELERATION: Double = 50
let FRICTION: Double = 100
//let MAX_DASH_SPEED: Double = 500
//let DASH_ACCELLERATION: Double = 200
let BULLET_SPEED: Double = 400
//let ENEMY_BULLET_SPEED: Double = 300
let ENEMY_BULLET_SPEED: Double = 600
//let MAX_ENEMY_SPEED: Double = 100
let MAX_ENEMY_SPEED: Double = 150
let MAX_ENEMY_LVL1: Int = 5
let MAX_ENEMY_LVL2: Int = 10
let MAX_ENEMY_LVL3: Int = 20
let MIN_DISTANCE_SPAWN_FROM_PLAYER: Double = 200
let MAX_PLAYER_BULLET_DISTANCE: Double = 400
let MAX_ENEMY_BULLET_DISTANCE: Double = 3000

let RELOAD_TIME: Double = 1

var controller1: GCController = GCController()
var jsState: Bool = false



