//
//  ViewController.swift
//  aKIMbo
//
//  Created by Antonio Romano on 21/03/22.
//

import Cocoa
import SpriteKit
import GameplayKit

class ViewController: NSViewController {

//    @IBOutlet var skView: SKView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
//        let scene = GameScene(size: CGSize(width: 1280, height: 1000))
        let scene = SplashScreen(size: CGSize(width: 1280, height: 1000))
//        let scene = MainMenu(size: CGSize(width: 1280, height: 1000))
        let skView = self.view as! SKView
        scene.scaleMode = .aspectFit
        scene.size = skView.bounds.size
                
                // Present the scene
        skView.presentScene(scene)
        skView.ignoresSiblingOrder = true
//        skView.showsPhysics = true
        
        skView.showsFPS = false
        skView.showsNodeCount = false
        skView.showsPhysics = false
    }
}

extension SKView {
    open override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
//        NSCursor.hide()
        window?.acceptsMouseMovedEvents = true
    }
}

