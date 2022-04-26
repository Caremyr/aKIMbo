//
//  Comandi.swift
//  aKIMbo
//
//  Created by Antonio Romano on 05/04/22.
//

import SpriteKit
import GameController

class CommandsScene: SKScene{
    private var WASD = SKLabelNode(fontNamed: "Grand9k Pixel")
    private var movementInfos = SKLabelNode(fontNamed: "Grand9k Pixel")
    private var R = SKLabelNode(fontNamed: "Grand9k Pixel")
    private var reload = SKLabelNode(fontNamed: "Grand9k Pixel")
    private var mouse = SKLabelNode(fontNamed: "Grand9k Pixel")
    private var mouseInfos = SKLabelNode(fontNamed: "Grand9k Pixel")
    private var pressLMB = SKLabelNode(fontNamed: "Grand9k Pixel")

    
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
    

    override func didMove(to view: SKView) {
        self.backgroundColor = .black
        
        WASD.text = "WASD"
        WASD.fontSize = 40
        WASD.position.x = size.width * 0.3
        WASD.position.y = size.height * 0.7
        movementInfos.text = "to move"
        movementInfos.horizontalAlignmentMode = .left
        movementInfos.position.x = size.width * 0.45
        movementInfos.position.y = WASD.position.y
        mouse.text = "MOUSE"
        mouse.fontSize = 40
        mouse.position.x = size.width * 0.3
        mouse.position.y = size.height * 0.5
        mouseInfos.text = "to aim and shoot"
        mouseInfos.horizontalAlignmentMode = .left
        mouseInfos.position.x = size.width*0.45
        mouseInfos.position.y = mouse.position.y
        R.text = "R"
        R.fontSize = 40
        R.position.x = size.width*0.3
        R.position.y = size.height*0.3
        reload.text = "to reload"
        reload.horizontalAlignmentMode = .left
        reload.position.x = size.width*0.45
        reload.position.y = R.position.y
        
        
        pressLMB.text = "Left mouse button to continue"
        pressLMB.fontSize = 15
        pressLMB.position.x = size.width*0.8
        pressLMB.position.y = size.height*0.05
        pressLMB.run(.repeatForever(.sequence([.fadeOut(withDuration: 1), .fadeIn(withDuration: 1)])))
        

        
        
        
        addChild(WASD)
        addChild(movementInfos)
        addChild(mouse)
        addChild(mouseInfos)
        addChild(R)
        addChild(reload)
        addChild(pressLMB)
    }
    
    override func mouseDown(with event: NSEvent) {
        let scena = GameScene(size: CGSize(width: 1280, height: 1000))
        let transition = SKTransition.fade(withDuration: 2)
        scena.scaleMode = .aspectFit
        scena.size = size
        scene?.view?.presentScene(scena, transition: transition)
    }
    
    func continueFunc(){
        if controller1.extendedGamepad?.buttonA.isPressed ?? false{
            let scena = GameScene(size: CGSize(width: 1280, height: 1000))
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
            if WASD.text != "􀫁"{
                WASD.text = "􀫁"
            }
            
            if controller1.productCategory.contains("DualShock"){
                if pressLMB.text != "Press 􀀲 to continue"{
                    pressLMB.text = "Press 􀀲 to continue"
                    mouse.text = "􀫂 + 􀨒"
                    R.text = "􀨃"
                }
            }else{
                if pressLMB.text != "Press 􀀄 to continue"{
                    pressLMB.text = "Press 􀀄 to continue"
                    mouse.text = "􀫂 + 􀨚"
                    R.text = "􀀲"
                }
                
            }
        }else{
            if pressLMB.text != "Press Left Mouse Button to continue"{
                pressLMB.text = "Press Left Mouse Button to continue"
                WASD.text = "WASD"
                mouse.text = "MOUSE"
                R.text = "R"
            }
        }
        
        if GCController.controllers().isEmpty == false{
            if controller1.extendedGamepad == nil{
            controller1 = GCController.controllers()[0]
            }
        }
        continueFunc()
    }
}

