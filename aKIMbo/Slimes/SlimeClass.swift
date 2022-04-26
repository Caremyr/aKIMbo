////
////  SlimeClass.swift
////  aKIMbo
////
////  Created by Antonio Romano on 22/03/22.
////
//
//import SpriteKit
//
//
//enum SlimeType: Int{
//    case level1 = 100
//    case level2 =  200
//    case level3 = 300
//}
//
//class Slime: SKSpriteNode{
//    let sprite = SKSpriteNode(imageNamed: "SlimeLevel1")
//
//    var lives: Int = 1
//    var level: SlimeType = .level1
//    var playerDetected: Bool = false
//    var visionRadius: Double = 150
//    var shootAreaRadius: Double = 200
//    var state: CharacterState = CharacterState()
//
//    override init(texture: SKTexture?, color: NSColor, size: CGSize) {
//        super.init(texture: texture, color: color, size: size)
//        self.name = "enemy"
//        self.physicsBody = SKPhysicsBody(texture: texture!, size: size)
//        self.physicsBody?.affectedByGravity = false
//        self.physicsBody?.isDynamic = false
//        self.physicsBody?.allowsRotation = false
//        self.physicsBody?.categoryBitMask = ColliderTypes.enemy
//        self.physicsBody?.collisionBitMask = ColliderTypes.player
//        self.physicsBody?.collisionBitMask = ColliderTypes.bullet
//        self.physicsBody?.contactTestBitMask = ColliderTypes.player
//        self.physicsBody?.contactTestBitMask = ColliderTypes.bullet
//        addSprite()
//    }
//
//
//    init(level: SlimeType){
//        super.init(texture: SKTexture(), color: .white, size: CGSize(width: 0, height: 0))
//        self.name = "enemy"
//        self.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
//        self.physicsBody?.affectedByGravity = false
//        self.physicsBody?.isDynamic = false
//        self.physicsBody?.allowsRotation = false
//        self.physicsBody?.categoryBitMask = ColliderTypes.enemy
//        self.physicsBody?.collisionBitMask = ColliderTypes.player
//        self.physicsBody?.collisionBitMask = ColliderTypes.bullet
//        self.physicsBody?.contactTestBitMask = ColliderTypes.player
//        self.physicsBody?.contactTestBitMask = ColliderTypes.bullet
//        self.level = level
//        if level == .level1{
//            self.lives = 1
//        }else if level == .level2{
//            self.lives = 2
//        }else{
//            self.lives = 3
//        }
//        addSprite()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    private func addSprite(){
//        self.addChild(sprite)
//    }
//
//    func checkDeath(points: inout Double){
//        if lives == 0{
//            points += Double(self.level.rawValue)
//            self.removeFromParent()
//        }
//    }
//}

import SpriteKit

struct Slime2{
    var sprite: SKSpriteNode
    var lives: Int
    var name: String
    var points: Int
    var playerIsDetected: Bool = false
    var isMoving: Bool = false
    var isAttacking: Bool = false
    var visionRadius: Double = 500
    var attackRadius: Double = 300
    var hitStopper: Double = 1
}

let slimeSpawnAnimation = [SKTexture(imageNamed: "SlimeLevel1SpawnAnimationFrame1"), SKTexture(imageNamed: "SlimeLevel1SpawnAnimationFrame2"), SKTexture(imageNamed: "SlimeLevel1SpawnAnimationFrame3"), SKTexture(imageNamed: "SlimeLevel1SpawnAnimationFrame4"), SKTexture(imageNamed: "SlimeLevel1SpawnAnimationFrame5"), SKTexture(imageNamed: "SlimeLevel1SpawnAnimationFrame6"), SKTexture(imageNamed: "SlimeLevel1SpawnAnimationFrame7"), SKTexture(imageNamed: "SlimeLevel1SpawnAnimationFrame8")]
let slimeSpawnAnimation2 = [SKTexture(imageNamed: "SlimeLevel2SpawnAnimationFrame1"), SKTexture(imageNamed: "SlimeLevel2SpawnAnimationFrame2"), SKTexture(imageNamed: "SlimeLevel2SpawnAnimationFrame3"), SKTexture(imageNamed: "SlimeLevel2SpawnAnimationFrame4"), SKTexture(imageNamed: "SlimeLevel2SpawnAnimationFrame5"), SKTexture(imageNamed: "SlimeLevel2SpawnAnimationFrame6"), SKTexture(imageNamed: "SlimeLevel2SpawnAnimationFrame7"), SKTexture(imageNamed: "SlimeLevel2SpawnAnimationFrame8")]
let slimeSpawnAnimation3 = [SKTexture(imageNamed: "SlimeLevel3SpawnAnimationFrame1"), SKTexture(imageNamed: "SlimeLevel3SpawnAnimationFrame2"), SKTexture(imageNamed: "SlimeLevel3SpawnAnimationFrame3"), SKTexture(imageNamed: "SlimeLevel3SpawnAnimationFrame4"), SKTexture(imageNamed: "SlimeLevel3SpawnAnimationFrame5"), SKTexture(imageNamed: "SlimeLevel3SpawnAnimationFrame6"), SKTexture(imageNamed: "SlimeLevel3SpawnAnimationFrame7"), SKTexture(imageNamed: "SlimeLevel3SpawnAnimationFrame8")]

let slimeIdle = [SKTexture(imageNamed: "SlimeIdleFrame2"), SKTexture(imageNamed: "SlimeLevel1")]
let slimeIdle2 = [SKTexture(imageNamed: "SlimeLevel2IdleFrame1"), SKTexture(imageNamed: "SlimeLevel2IdleFrame2")]
let slimeIdle3 = [SKTexture(imageNamed: "SlimeLevel3IdleFrame1"), SKTexture(imageNamed: "SlimeLevel3SpawnAnimationFrame8")]

let slimeDeath = [SKTexture(imageNamed: "Level1SlimeDeathFrame1"), SKTexture(imageNamed: "Level1SlimeDeathFrame2"),SKTexture(imageNamed: "Level1SlimeDeathFrame3"), SKTexture(imageNamed: "Level1SlimeDeathFrame4"), SKTexture(imageNamed: "Level1SlimeDeathFrame5"), SKTexture(imageNamed: "Level1SlimeDeathFrame6"), SKTexture(imageNamed: "Level1SlimeDeathFrame7"), SKTexture(imageNamed: "Level1SlimeDeathFrame8"), SKTexture(imageNamed: "Level1SlimeDeathFrame9"), SKTexture(imageNamed: "Level1SlimeDeathFrame10")]
let slimeDeath2 = [SKTexture(imageNamed: "SlimeLevel2DeathFrame1"), SKTexture(imageNamed: "SlimeLevel2DeathFrame2"),SKTexture(imageNamed: "SlimeLevel2DeathFrame3"), SKTexture(imageNamed: "SlimeLevel2DeathFrame4"), SKTexture(imageNamed: "SlimeLevel2DeathFrame5"), SKTexture(imageNamed: "SlimeLevel2DeathFrame6"), SKTexture(imageNamed: "SlimeLevel2DeathFrame7"), SKTexture(imageNamed: "SlimeLevel2DeathFrame8"), SKTexture(imageNamed: "SlimeLevel2DeathFrame9"), SKTexture(imageNamed: "SlimeLevel2DeathFrame10")]
let slimeDeath3 = [SKTexture(imageNamed: "SlimeLevel3DeathFrame1"), SKTexture(imageNamed: "SlimeLevel3DeathFrame2"),SKTexture(imageNamed: "SlimeLevel3DeathFrame3"), SKTexture(imageNamed: "SlimeLevel3DeathFrame4"), SKTexture(imageNamed: "SlimeLevel3DeathFrame5"), SKTexture(imageNamed: "SlimeLevel3DeathFrame6"), SKTexture(imageNamed: "SlimeLevel3DeathFrame7"), SKTexture(imageNamed: "SlimeLevel3DeathFrame8"), SKTexture(imageNamed: "SlimeLevel3DeathFrame9"), SKTexture(imageNamed: "SlimeLevel3DeathFrame10")]

let slimeMoving = [SKTexture(imageNamed: "Level1SlimeWalkingFrame1"), SKTexture(imageNamed: "Level1SlimeWalkingFrame2")]
let slimeMoving2 = [SKTexture(imageNamed: "SlimeLevel2WalkingAnimationFrame1"), SKTexture(imageNamed: "SlimeLevel2WalkingAnimationFrame2")]
let slimeMoving3 = [SKTexture(imageNamed: "SlimeLevel3WalkingAnimationFrame1"), SKTexture(imageNamed: "SlimeLevel3WalkingAnimationFrame2")]


let slimeAttacking = [SKTexture(imageNamed: "SlimeShootingFrame1"),SKTexture(imageNamed: "SlimeShootingFrame2"),SKTexture(imageNamed: "SlimeShootingFrame3"),SKTexture(imageNamed: "SlimeShootingFrame4")]
let slimeAttacking2 = [SKTexture(imageNamed: "SlimeLevel2ShootingFrame1"),SKTexture(imageNamed: "SlimeLevel2ShootingFrame2"),SKTexture(imageNamed: "SlimeLevel2ShootingFrame3"),SKTexture(imageNamed: "SlimeLevel2ShootingFrame4")]
let slimeAttacking3 = [SKTexture(imageNamed: "SlimeLevel3ShootingFrame1"),SKTexture(imageNamed: "SlimeLevel3ShootingFrame2"),SKTexture(imageNamed: "SlimeLevel3ShootingFrame3"),SKTexture(imageNamed: "SlimeLevel3ShootingFrame4")]

let slimeBulletAttack = [SKTexture(imageNamed: "Level1SlimeBulletFrame2"), SKTexture(imageNamed: "Level1SlimeBulletFrame3"),SKTexture(imageNamed: "Level1SlimeBulletFrame1")]
let slimeBulletAttack2 = [SKTexture(imageNamed: "Level2SlimeBullet"), SKTexture(imageNamed: "Level2SlimeBulletFrame1"),SKTexture(imageNamed: "Level2SlimeBulletFrame2")]
let slimeBulletAttack3 = [SKTexture(imageNamed: "Level3SlimeBullet"), SKTexture(imageNamed: "Level3SlimeBulletFrame1"),SKTexture(imageNamed: "Level3SlimeBulletFrame2")]



let slimeHit2 = [SKTexture(imageNamed: "Level2SlimeHitFrame1"), SKTexture(imageNamed: "Level2SlimeHitFrame2")]
let slimeHit3 = [SKTexture(imageNamed: "Level3SlimeHitFrame1"), SKTexture(imageNamed: "Level3SlimeHitFrame2")]



var slimeCounter: Int = 0
var slimeOnScreen: [Slime2] = []


