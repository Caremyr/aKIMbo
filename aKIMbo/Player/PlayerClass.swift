//
//  PlayerClass.swift
//  aKIMbo
//
//  Created by Antonio Romano on 22/03/22.
//

import SpriteKit


struct CharacterState{
    var idle: Bool = true
    var isMoving: Bool = false
    var isFacingUp: Bool = false
    var isFacingDown: Bool = true
    var isFacingLeft: Bool = false
    var isFacingRight: Bool = false
    var isAttacking: Bool = false
    var hit: Bool = false
    var isReloading: Bool = false
    var isDashing: Bool = false
}



class Player: SKSpriteNode{
    
    private let sprite = SKSpriteNode(imageNamed: "ParrotIdle")
    
    
    private let frontIdleTextures = [SKTexture(imageNamed: "ParrotIdle2"), SKTexture(imageNamed: "ParrotIdle")]
    private let backIdleTextures = [SKTexture(imageNamed: "ParrotBackIdleFrame2"), SKTexture(imageNamed: "ParrotBackIdleFrame1")]
    private let rightIdleTextures = [SKTexture(imageNamed: "ParrotSideViewRightIdleFrame2"), SKTexture(imageNamed: "ParrotSideViewRightIdleFrame1")]
    private let leftIdleTextures = [SKTexture(imageNamed: "ParrotSideViewLeftIdleFrame2"), SKTexture(imageNamed: "ParrotSideViewLeftIdleFrame1")]
    
    private let frontWalkTextures = [SKTexture(imageNamed: "ParrotWalkingFrontFrame1"), SKTexture(imageNamed: "ParrotWalkingFrontFrame2")]
    private let backWalkTextures = [SKTexture(imageNamed: "ParrotWalkingBackFrame1"), SKTexture(imageNamed: "ParrotWalkingBackFrame2")]
    private let rightWalkTextures = [SKTexture(imageNamed: "ParrotWalkingRightFrame1"), SKTexture(imageNamed: "ParrotWalkingRightFrame2")]
    private let leftWalkTextures = [SKTexture(imageNamed: "ParrotWalkingLeftFrame1"), SKTexture(imageNamed: "ParrotWalkingLeftFrame2")]
    
    
    
    var lives: Int = 1
    var invincible: Bool = false
    var state: CharacterState = CharacterState()
    
    override init(texture: SKTexture?, color: NSColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
   
    init(){
        super.init(texture: SKTexture(), color: .white, size: CGSize(width: 0, height: 0))
        self.lives = 1
        self.name = "player"
        self.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = true
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.categoryBitMask = ColliderTypes.player
        addSprite()
    }
    
    init(lives: Int){
        super.init(texture: SKTexture(), color: .white, size: CGSize(width: 0, height: 0))
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: sprite.size.width*0.45, height: sprite.size.height*0.85))//SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
        self.lives = lives
        self.name = "player"
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = true
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.categoryBitMask = ColliderTypes.player
        addSprite()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSprite(){
        self.addChild(sprite)
    }
    
    
    func animation(){
        if self.state.idle{
            if self.state.isFacingUp{
                sprite.run(.animate(with: backIdleTextures, timePerFrame: 0.4), completion: {
                    self.animation()
                })
            }
            if self.state.isFacingLeft{
                sprite.run(.animate(with: leftIdleTextures, timePerFrame: 0.4), completion: {
                    self.animation()
                })
            }
            if self.state.isFacingRight{
                sprite.run(.animate(with: rightIdleTextures, timePerFrame: 0.4), completion: {
                    self.animation()
                })
            }
            if self.state.isFacingDown{
                sprite.run(.animate(with: frontIdleTextures, timePerFrame: 0.4), completion: {
                    self.animation()
                })
            }
        }
    }
    
    func animationIdle(angle: Double){
        if self.state.idle{
            if angle <= pi/4 && angle >= -pi/4{
                if state.isFacingUp == false && state.idle{
                    self.state.isFacingDown = false
                    self.state.isFacingLeft = false
                    self.state.isFacingRight = false
                    self.state.isFacingUp = true
                    sprite.run(.repeatForever(SKAction.animate(with: backIdleTextures, timePerFrame: 0.4)))
                }
            }
            if angle > pi/4 && angle < 3*pi/4{
                if state.isFacingLeft == false && state.idle{
                    self.state.isFacingDown = false
                    self.state.isFacingRight = false
                    self.state.isFacingUp = false
                    self.state.isFacingLeft = true
                    sprite.run(.repeatForever(.animate(with: leftIdleTextures, timePerFrame: 0.4)))
                }
            }
            if angle < -pi/4 && angle > -3*pi/4{
                if state.isFacingRight == false && state.idle{
                    self.state.isFacingDown = false
                    self.state.isFacingLeft = false
                    self.state.isFacingUp = false
                    self.state.isFacingRight = true
                    sprite.run(.repeatForever(.animate(with: rightIdleTextures, timePerFrame: 0.4)))
                }
            }
            if (angle <= -3/4*pi && angle > -pi) || (angle >= 3/4*pi && angle <= pi){
                if state.isFacingDown == false && state.idle{
                    self.state.isFacingLeft = false
                    self.state.isFacingRight = false
                    self.state.isFacingUp = false
                    self.state.isFacingDown = true
                    sprite.run(.repeatForever(.animate(with: frontIdleTextures, timePerFrame: 0.4)))
                }
            }
        }
    }
    
    func animationWalk(angle: Double){
        if self.state.isMoving{
            if angle <= pi/4 && angle >= -pi/4{
                if state.isFacingUp == false && state.isMoving{
                    self.state.isFacingDown = false
                    self.state.isFacingLeft = false
                    self.state.isFacingRight = false
                    self.state.isFacingUp = true
                    sprite.run(.repeatForever(SKAction.animate(with: backWalkTextures, timePerFrame: 0.4)))
                }
            }
            if angle > pi/4 && angle < 3*pi/4{
                if state.isFacingLeft == false && state.isMoving{
                    self.state.isFacingDown = false
                    self.state.isFacingRight = false
                    self.state.isFacingUp = false
                    self.state.isFacingLeft = true
                    sprite.run(.repeatForever(.animate(with: leftWalkTextures, timePerFrame: 0.4)))
                }
            }
            if angle < -pi/4 && angle > -3*pi/4{
                if state.isFacingRight == false && state.isMoving{
                    self.state.isFacingDown = false
                    self.state.isFacingLeft = false
                    self.state.isFacingUp = false
                    self.state.isFacingRight = true
                    sprite.run(.repeatForever(.animate(with: rightWalkTextures, timePerFrame: 0.4)))
                }
            }
            if (angle <= -3/4*pi && angle > -pi) || (angle >= 3/4*pi && angle <= pi){
                if state.isFacingDown == false && state.isMoving{
                    self.state.isFacingLeft = false
                    self.state.isFacingRight = false
                    self.state.isFacingUp = false
                    self.state.isFacingDown = true
                    sprite.run(.repeatForever(.animate(with: frontWalkTextures, timePerFrame: 0.4)))
                }
            }
        }
    }
    
    func updateFacing(angle: Double){
        self.state.isFacingDown = false
        self.state.isFacingLeft = false
        self.state.isFacingRight = false
        self.state.isFacingUp = false
        if angle <= pi/4 && angle >= -pi/4{
            self.state.isFacingDown = false
            self.state.isFacingLeft = false
            self.state.isFacingRight = false
            self.state.isFacingUp = true
        }
        if angle > pi/4 && angle < 3*pi/4{
            self.state.isFacingDown = false
            self.state.isFacingRight = false
            self.state.isFacingUp = false
            self.state.isFacingLeft = true
      }
        if angle < -pi/4 && angle > -3*pi/4{
            self.state.isFacingDown = false
            self.state.isFacingLeft = false
            self.state.isFacingUp = false
            self.state.isFacingRight = true
        }
        if (angle <= -3/4*pi && angle > -pi) || (angle >= 3/4*pi && angle <= pi){
            self.state.isFacingLeft = false
            self.state.isFacingRight = false
            self.state.isFacingUp = false
            self.state.isFacingDown = true
        }
    }
    func resetFacingState(){
        state.isFacingUp = false
        state.isFacingDown = false
        state.isFacingLeft = false
        state.isFacingRight = false
    }
}
