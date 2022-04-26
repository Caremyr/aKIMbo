//
//  CrossairClass.swift
//  aKIMbo
//
//  Created by Antonio Romano on 22/03/22.
//

import SpriteKit

class Crossair: SKSpriteNode{
    
    private var sprite: SKSpriteNode = SKSpriteNode(imageNamed: "Crossair2")
    
    override init(texture: SKTexture?, color: NSColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    init(){
        super.init(texture: SKTexture(), color: .white, size: CGSize(width: 0, height: 0))
        self.zPosition = 500
        addSprite()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSprite(){
        self.addChild(sprite)
    }
}
