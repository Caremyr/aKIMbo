////
////  HUDClass.swift
////  aKIMbo
////
////  Created by Antonio Romano on 22/03/22.
////
//
//import SpriteKit
//
//class HUD: SKNode{
//    private var livesSprite = SKSpriteNode()
//    private var labelTime = SKLabelNode()
//    private var labelPoints = SKLabelNode()
//    private var labelBullets = SKLabelNode()
//    
//    override init() {
//        super.init()
//        self.zPosition = 1000
//        addSprites()
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    func addSprites(){
//        livesSprite = SKSpriteNode(imageNamed: "Hearth")
//        addChild(livesSprite)
//    }
//}
