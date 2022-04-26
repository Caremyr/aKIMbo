//
//  BulletClass.swift
//  aKIMbo
//
//  Created by Antonio Romano on 22/03/22.
//

import SpriteKit


class Bullet: SKShapeNode{
    
    var bulletDirection = CGVector.zero
    var isShot: Bool = false
    var initialiPosition: CGPoint = CGPoint.zero
    
    override init(){
        super.init()
        bulletDirection = CGVector.zero
        isShot = false
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class Bullet2: SKSpriteNode{
    
    var sprite = SKSpriteNode(imageNamed: "Bullet")
    
    var bulletDirection = CGVector.zero
    var isShot: Bool = false
    var initialPosition: CGPoint = CGPoint.zero

    
    override init(texture: SKTexture?, color: NSColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(){
        super.init(texture: SKTexture(), color: .white, size: CGSize(width: 0, height: 0))
        self.name = "bullet"
        self.isShot = true
        self.sprite.zPosition = 5
        self.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = true
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.categoryBitMask = ColliderTypes.bullet
        self.physicsBody?.collisionBitMask = ColliderTypes.enemy
        self.physicsBody?.contactTestBitMask = ColliderTypes.enemy
        addSprite()
    }
    
    func addSprite(){
        addChild(sprite)
    }
}

class Bullet3: SKSpriteNode{
    
    var sprite = SKSpriteNode(imageNamed: "Level1SlimeBulletFrame1")
    
    var bulletDirection = CGVector.zero
    var isShot: Bool = false
    var initialPosition: CGPoint = CGPoint.zero

    
    override init(texture: SKTexture?, color: NSColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(){
        super.init(texture: SKTexture(), color: .white, size: CGSize(width: 0, height: 0))
        self.name = "slimeBullet"
        self.isShot = true
        self.sprite.zPosition = 5
        self.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = true
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.categoryBitMask = ColliderTypes.bullet
        self.physicsBody?.collisionBitMask = ColliderTypes.player
        self.physicsBody?.contactTestBitMask = ColliderTypes.player
        addSprite()
    }
    
    func addSprite(){
        addChild(sprite)
    }
}

