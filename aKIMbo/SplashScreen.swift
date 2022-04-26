//
//  SplashScreen.swift
//  aKIMbo
//
//  Created by Antonio Romano on 02/04/22.
//

import SpriteKit

class SplashScreen: SKScene{
    let logo: SKSpriteNode = SKSpriteNode(imageNamed: "mamtAcoloriBianco")
    
    override func didMove(to view: SKView) {
        backgroundColor = .black
        logo.alpha = 0
        logo.setScale(0.5)
        logo.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(logo)
        logo.run(.sequence([.wait(forDuration: 1), .fadeIn(withDuration: 1), .wait(forDuration: 0.3), .playSoundFileNamed("MamtSound", waitForCompletion: false), .wait(forDuration: 1.5), .fadeOut(withDuration: 1)]), completion: {
            let scena = MainMenu(size: CGSize(width: 1280, height: 1000))
            let transition = SKTransition.fade(withDuration: 2)
            scena.scaleMode = .aspectFit
            scena.size = self.size
            self.scene?.view?.presentScene(scena, transition: transition)
        })
    }
}
