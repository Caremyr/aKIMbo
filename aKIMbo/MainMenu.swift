//
//  MainMenu.swift
//  aKIMbo
//
//  Created by Antonio Romano on 02/04/22.
//

import SpriteKit
import GameController
import GameplayKit

class MainMenu: SKScene{
    
    private var animationIndex: Int = 0
    private var animationStatus: Bool = false
    private var timerValue: Int = 10
    
    let slime1: SKSpriteNode = SKSpriteNode(imageNamed: "SlimeLevel1")
    
    let titleImage: SKSpriteNode = SKSpriteNode(imageNamed: "Akimbo_white_border")
    
    let pressLMBLabel: SKLabelNode = SKLabelNode(fontNamed: "Grand9k Pixel")
    
    
    func setUpControllerObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(connectControllers), name: NSNotification.Name.GCControllerDidConnect, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(disconnectController), name: NSNotification.Name.GCControllerDidDisconnect, object: nil)
    }
    
    @objc func connectControllers() {
        var count = 0
        for controller in GCController.controllers() {
            count = count + 1
            //            print(count)
            //            print(controller.extendedGamepad != nil)
            //            print(controller.microGamepad != nil)
            //            print(controller.gamepad != nil)
            if (controller.extendedGamepad != nil && controller.playerIndex == .indexUnset) {
                if (count == 1) {
                    controller.playerIndex = .index1
                }
                else if (count == 2) {
                    controller.playerIndex = .index2
                }
                else if (count == 3) {
                    controller.playerIndex = .index3
                }
                else if (count == 4) {
                    controller.playerIndex = .index4
                }
                controller.extendedGamepad?.valueChangedHandler = nil
                setupExtendedController(controller: controller)
            }
        }
        if count > 0{
            jsState = true
        }else{
            jsState = false
        }
    }
    
    @objc func disconnectController() {
        controller1 = GCController()
        jsState = false
    }
    
    func setupExtendedController(controller: GCController) {
        controller.extendedGamepad?.valueChangedHandler = { (gamepad: GCExtendedGamepad, element: GCControllerElement) in
            // not calling
        }
    }
    
    
    
    func timer(){
        let wait = SKAction.wait(forDuration: 1)
        let go = SKAction.run({
            if self.timerValue > 0 {
                self.timerValue -= 1
            }else{
                if !self.animationStatus{
                    self.animationStatus = true
                    self.animationIndex = Int.random(in: 0...2)
                    switch(self.animationIndex){
                    case 0:
                        self.slime1.position.x = self.size.width + 15
                        self.slime1.position.y = self.size.height*0.2
                        self.slime1.run(.repeatForever(.animate(with: slimeMoving, timePerFrame: 0.5)))
                        self.slime1.run(.move(to: CGPoint(x: -20, y: self.size.height*0.2), duration: 5), completion: {
                            self.timerValue = 10
                            self.animationStatus = false
                            self.slime1.removeFromParent()
                        })
                        self.addChild(self.slime1)
                    case 1:
                        self.slime1.position.x = -15
                        self.slime1.position.y = self.size.height*0.2
                        self.slime1.run(.repeatForever(.animate(with: slimeMoving, timePerFrame: 0.5)))
                        self.slime1.run(.move(to: CGPoint(x: self.size.width/2, y: self.size.height*0.2), duration: 5), completion: {
                            self.slime1.removeAllActions()
                            self.slime1.run(.sequence([.wait(forDuration: 2),.animate(with: slimeDeath, timePerFrame: 0.1)]), completion: {
                                self.timerValue = 10
                                self.animationStatus = false
                                self.slime1.removeFromParent()
                            })
                        })
                        self.addChild(self.slime1)

                    case 2:
                        self.slime1.position.x = self.size.width/2
                        self.slime1.position.y = self.size.height*0.2
                        self.slime1.run(.animate(with: slimeSpawnAnimation, timePerFrame: 0.1), completion: {
                            self.slime1.run(.repeatForever(.animate(with: slimeMoving, timePerFrame: 0.5)))
                            self.slime1.run(.sequence([.wait(forDuration: 1), .moveTo(x: self.size.width + 15, duration: 5)]), completion: {
                                self.timerValue = 10
                                self.animationStatus = false
                                self.slime1.removeFromParent()
                            })
                        })
                        self.addChild(self.slime1)
                    default:
                        print("")
                    }
                }
            }
        })
        
        let actions = SKAction.sequence([wait, go])
        run(.repeatForever(actions))
    }
    
    override func didMove(to view: SKView) {
//        setUpControllerObservers()
//        connectControllers()
//        if GCController.controllers().isEmpty == false{
//            controller1 = GCController.controllers()[0]
//            print("Connected")
//        }
        timer()
        backgroundColor = .black
        titleImage.setScale(2.2)
        
        titleImage.position = CGPoint(x: size.width/2, y: size.height*0.7)
        pressLMBLabel.position = CGPoint(x: size.width/2, y: size.height*0.35)
        
        pressLMBLabel.run(.repeatForever(.sequence([.fadeOut(withDuration: 1), .fadeIn(withDuration: 1)])))
        
        addChild(pressLMBLabel)
        addChild(titleImage)
    }
    
    override func mouseDown(with event: NSEvent) {
        let scena = CommandsScene(size: CGSize(width: 1280, height: 1000))
        let transition = SKTransition.fade(withDuration: 2)
        scena.scaleMode = .aspectFit
        scena.size = size
        scene?.view?.presentScene(scena, transition: transition)
    }
    
    func startGame(){
        if controller1.extendedGamepad?.buttonMenu.isPressed ?? false{
            let scena = CommandsScene(size: CGSize(width: 1280, height: 1000))
            let transition = SKTransition.fade(withDuration: 2)
            scena.scaleMode = .aspectFit
            scena.size = size
            scene?.view?.presentScene(scena, transition: transition)
        }
    }
    override func update(_ currentTime: TimeInterval) {
        setUpControllerObservers()
        connectControllers()
        if jsState{
            if controller1.productCategory.contains("DualShock"){
                if pressLMBLabel.text != "Press Options to continue"{
                        pressLMBLabel.text = "Press Options to continue"
                }
            }else{
                if pressLMBLabel.text != "Press Start to continue"{
                        pressLMBLabel.text = "Press Start to continue"
                }
                
            }
        }else{
            if pressLMBLabel.text != "Press Left Mouse Button to continue"{
                pressLMBLabel.text = "Press Left Mouse Button to continue"
            }
        }
        
        if GCController.controllers().isEmpty == false{
            if controller1.extendedGamepad == nil{
            controller1 = GCController.controllers()[0]
            }
        }
        startGame()
    }
}
