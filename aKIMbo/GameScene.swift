//
//  GameScene.swift
//  aKIMbo
//
//  Created by Antonio Romano on 21/03/22.
//

import SpriteKit
import GameplayKit
import GameController

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var spawning: Bool = false
    var cantSpawn: Bool = false
    
    var myHeight: CGFloat
    var myWidth: CGFloat
    
    override init(size: CGSize) {
        let playableHeight = size.height
        let playableMargin = (size.height-playableHeight)/2
        
        myHeight = size.height
        myWidth = size.width
        
        gameArea = CGRect(x: 0, y: playableMargin, width: size.width, height: playableHeight)
        horizontalNumberOfTiles = Int(size.width/32)
        verticalNumberOfTiles = Int(size.height/32)
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let blackScreen = SKShapeNode(rectOf: CGSize(width: 2000, height: 2000))
    var gameOverLabel = SKLabelNode(fontNamed: "Grand9k Pixel")
    var yourScore: SKLabelNode = SKLabelNode(fontNamed: "Grand9K Pixel")
    let pressRLabel = SKLabelNode(fontNamed: "Grand9k Pixel")
//    var jsState: Bool = false
    var gameOver: Bool = false
    var gameArea: CGRect
    
    var lastUpdate: TimeInterval!
    var delta: TimeInterval!
    
    var backgroundMusic = SKAudioNode(fileNamed: "DoomSoundtrack")
    
    
    
    //    HUD **************
    
    var hud = SKNode()
    var point: Int = 0
    var labelPoints = SKLabelNode(fontNamed: "Grand9K Pixel")
    var lives: Int = 1
    var imageHeart = SKSpriteNode(imageNamed: "Heart")
    var labelLives = SKLabelNode(fontNamed: "Grand9K Pixel")
    var time: Int = 60
    var labelTimer = SKLabelNode(fontNamed: "Grand9K Pixel")
    var reloadLable = SKLabelNode(fontNamed: "Grand9K Pixel")
    
    var reloadPlayerLabel = SKLabelNode(fontNamed: "Grand9k Pixel")
    
    //    GROUND
    
    var horizontalNumberOfTiles: Int
    var verticalNumberOfTiles: Int
    var totalTiles: Int = 0
    
    
    //    *****************
    
    private var enemyCountInGame: Int = 0
    private var enemyKilled: Int = 0
    
    private var sceneCamera = SKCameraNode()
    private var midPoint: CGPoint = CGPoint()
    private let crossair = Crossair()
    private var angle: Double = 0
    
    
    private var dashDirection: CGVector = CGVector.zero
    private var inputVector: CGVector = CGVector.zero  //DIREZIONE
    private var velocity: CGVector = CGVector.zero     //VELOCITA' VETTORE
    private var left: Bool = false
    private var right: Bool = false
    private var up: Bool = false
    private var down: Bool = false
    
    
    private var player = Player()
    private var pistol = SKSpriteNode(imageNamed: "WeaponIdle")
    private var pistolFrames = [SKTexture(imageNamed: "WeaponShoot1"), SKTexture(imageNamed: "WeaponShoot2"), SKTexture(imageNamed: "WeaponIdle")]
    private var shootingPoint = SKNode()
    private var pistol2 = SKSpriteNode(imageNamed: "WeaponIdle")
    private var pistolFrames2 = [SKTexture(imageNamed: "WeaponShoot1"), SKTexture(imageNamed: "WeaponShoot2"), SKTexture(imageNamed: "WeaponIdle")]
    private var shootingPoint2 = SKNode()
    private var shots: Int = 6
    private var shots2: Int = 6
    private var lastDirectionJs: CGVector = CGVector(dx: 0, dy: 1)
    
    
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
//
//        if GCController.controllers().isEmpty == false{
//            controller1 = GCController.controllers()[0]
////            print("Connected")
//        }
        
        self.physicsWorld.contactDelegate = self
        self.backgroundColor = .black
        
        enemyCountInGame = 0
        enemyKilled = 0
        
        floorGenerator()
        
        hud.zPosition = 1000
        hud.scene?.anchorPoint = CGPoint.zero
        
        imageHeart.setScale(2)
        imageHeart.position = convert(CGPoint(x: -size.width/2 + 30, y: size.height/2 - 30), to: sceneCamera)
        imageHeart.zPosition = 1000
        labelLives.text = String(format: "x%d", lives)
        labelLives.fontSize = 20
        labelLives.position.x = imageHeart.position.x + 30
        labelLives.position.y = imageHeart.position.y - 10
        labelLives.zPosition = 1000
        labelTimer.position = convert(CGPoint(x: 0, y: size.height/2 - 40), to: sceneCamera)
        labelTimer.text = "1:00"
        labelTimer.fontSize = 20
        labelTimer.zPosition = 1000
        labelPoints.position = convert(CGPoint(x: size.width/2 - 140, y: size.height/2 - 40), to: sceneCamera)
        labelPoints.text = String(format: "Points %d", point)
        labelPoints.horizontalAlignmentMode = .left
        labelPoints.fontSize = 20
        labelPoints.zPosition = 1000
        reloadLable.position = convert(CGPoint(x: size.width/2 - 110, y: -size.height/2 + 40), to: sceneCamera)
        reloadLable.text = String(format: "%d/6", shots)
        reloadLable.fontSize = 20
        reloadLable.zPosition = 1000
        
        reloadPlayerLabel.text = "Reloading"
        reloadPlayerLabel.fontSize = 10
        reloadPlayerLabel.fontColor = .clear
        reloadPlayerLabel.zPosition = 1000
        addChild(reloadPlayerLabel)
        
        timer()
        
        hud.addChild(labelLives)
        hud.addChild(imageHeart)
        hud.addChild(labelPoints)
        hud.addChild(labelTimer)
        hud.addChild(reloadLable)
        
        addChild(sceneCamera)
        camera = sceneCamera
        //        sceneCamera.run(.playSoundFileNamed("DoomSoundtrack", waitForCompletion: false))
        sceneCamera.addChild(hud)
        
        player = Player(lives: 1)
        player.position = CGPoint(x: size.width/2, y: size.height/2)
        sceneCamera.position = player.position
        player.zPosition = 2
        player.animation()
        
        pistol.zPosition = 1
        pistol.addChild(shootingPoint)
        pistol.anchorPoint = CGPoint(x: 0, y: 0)
        pistol.setScale(1.3)
        pistol2.zPosition = 3
        pistol2.addChild(shootingPoint2)
        pistol2.anchorPoint = CGPoint(x: 0, y: 0)
        pistol2.setScale(1.3)
        shootingPoint.position.x = pistol.position.x + pistol.frame.width + 1
        shootingPoint.position.y = pistol.position.y + pistol.frame.height - 4
        shootingPoint2.position.x = pistol2.position.x + pistol2.frame.width + 1
        shootingPoint2.position.y = pistol2.position.y + pistol2.frame.height - 4
        
        addChild(backgroundMusic)
        addChild(player)
        crossair.setScale(0.7)
        addChild(crossair)
        addChild(pistol)
        addChild(pistol2)
    }
    
    //*******************************
    //GROUND SECTION
    func assignPhysicsBodyToWall(myArray: [SKSpriteNode], totalTiles: Int){
        myArray[totalTiles].name = "wall"
        myArray[totalTiles].physicsBody = SKPhysicsBody(texture: myArray[totalTiles].texture!, size: myArray[totalTiles].size)
        myArray[totalTiles].physicsBody?.categoryBitMask = ColliderTypes.wall
        myArray[totalTiles].physicsBody?.contactTestBitMask = ColliderTypes.bullet | ColliderTypes.enemyBullet
        myArray[totalTiles].physicsBody?.affectedByGravity = false
        myArray[totalTiles].physicsBody?.isDynamic = false
        myArray[totalTiles].physicsBody?.restitution = 0
    }
    
    func floorGenerator(){
        for rowIndex in 0..<verticalNumberOfTiles{
            for columnIndex in 0..<horizontalNumberOfTiles{
                //Riga in basso
                if(rowIndex == 0){
                    myArray.append(SKSpriteNode(imageNamed: "WallTile1"))
                    assignPhysicsBodyToWall(myArray: myArray, totalTiles: totalTiles)
                } else if (rowIndex == 1){
                    //Seconda riga in basso
                    if(columnIndex == 0){
                        myArray.append(SKSpriteNode(imageNamed: "WallTile2"))
                        assignPhysicsBodyToWall(myArray: myArray, totalTiles: totalTiles)
                    } else if (columnIndex == horizontalNumberOfTiles-1){
                        myArray.append(SKSpriteNode(imageNamed: "WallTile2"))
                        assignPhysicsBodyToWall(myArray: myArray, totalTiles: totalTiles)
                    } else {
                        myArray.append(SKSpriteNode(imageNamed: "FloorTile2"))
                    }
                }
                else if(rowIndex == verticalNumberOfTiles-3){
                    if(columnIndex == 0){
                        myArray.append(SKSpriteNode(imageNamed: "WallTile2"))
                        assignPhysicsBodyToWall(myArray: myArray, totalTiles: totalTiles)
                        
                    } else if(columnIndex == horizontalNumberOfTiles-1){
                        myArray.append(SKSpriteNode(imageNamed: "WallTile2"))
                        assignPhysicsBodyToWall(myArray: myArray, totalTiles: totalTiles)
                        
                    } else {
                        myArray.append(SKSpriteNode(imageNamed: "FloorTile2"))
                    }
                }
                else if(rowIndex == verticalNumberOfTiles-2){
                    if(columnIndex == 0){
                        myArray.append(SKSpriteNode(imageNamed: "WallTile2"))
                        assignPhysicsBodyToWall(myArray: myArray, totalTiles: totalTiles)
                        
                    }else if (columnIndex == horizontalNumberOfTiles-1){
                        myArray.append(SKSpriteNode(imageNamed: "WallTile2"))
                        assignPhysicsBodyToWall(myArray: myArray, totalTiles: totalTiles)
                    }else {
                        myArray.append(SKSpriteNode(imageNamed: "WallTile3"))
                    }
                }else if(rowIndex == verticalNumberOfTiles-1){
                    myArray.append(SKSpriteNode(imageNamed: "WallTile2"))
                    assignPhysicsBodyToWall(myArray: myArray, totalTiles: totalTiles)
                    
                }else if(columnIndex == 0){
                    if(rowIndex != 0 && rowIndex != 1 && rowIndex != verticalNumberOfTiles-1 && rowIndex != verticalNumberOfTiles-2){
                        myArray.append(SKSpriteNode(imageNamed: "WallTile2"))
                        assignPhysicsBodyToWall(myArray: myArray, totalTiles: totalTiles)
                        
                    }
                }else if(columnIndex == 1){
                    if(rowIndex != 0 && rowIndex != 1 && rowIndex != verticalNumberOfTiles-1 && rowIndex != verticalNumberOfTiles-2){
                        myArray.append(SKSpriteNode(imageNamed: "FloorTile2"))
                    }
                }else if(columnIndex == horizontalNumberOfTiles-2){
                    if(rowIndex != 0 && rowIndex != 1 && rowIndex != verticalNumberOfTiles-1 && rowIndex != verticalNumberOfTiles-2){
                        myArray.append(SKSpriteNode(imageNamed: "FloorTile2"))
                    }
                }else if(columnIndex == horizontalNumberOfTiles-1){
                    if(rowIndex != 0 && rowIndex != 1){
                        myArray.append(SKSpriteNode(imageNamed: "WallTile2"))
                        assignPhysicsBodyToWall(myArray: myArray, totalTiles: totalTiles)
                    }
                }else{
                    myArray.append(SKSpriteNode(imageNamed: "FloorTile"))
                }
                myArray[totalTiles].zPosition = 0
                myArray[totalTiles].position = CGPoint(x: -size.width/4 + CGFloat(32*columnIndex), y: -size.height/4 + CGFloat(32*rowIndex))
                addChild(myArray[totalTiles])
                totalTiles += 1
            }
        }
    }
    
    
    
    
    
    
    
    //    ***********************************************
    //SHOOTING SECTION
    func shootDirection(fromPistol pistol: CGPoint, atPoint position: CGPoint)->CGVector{
        let x = position.x - pistol.x
        let y = position.y - pistol.y
        var direction = CGVector(dx: x + Double.random(in: -40...40), dy: y + Double.random(in: -40...40))
        direction = direction.normalized()
        let bulletVelocity = direction*BULLET_SPEED*delta
        return bulletVelocity
    }
    
    func shootDirectionJoystick(fromPistol pistol: CGPoint)->CGVector{
        let x: CGFloat
        let y: CGFloat
        if controller1.extendedGamepad?.rightThumbstick.xAxis.value ?? 0 != 0 && controller1.extendedGamepad?.rightThumbstick.yAxis.value ?? 0 != 0{
            x = CGFloat(controller1.extendedGamepad?.rightThumbstick.xAxis.value ?? 0)
            y = CGFloat(controller1.extendedGamepad?.rightThumbstick.yAxis.value ?? 1)
        }else{
            x = lastDirectionJs.dx
            y = lastDirectionJs.dy
        }
        var direction = CGVector(dx: x , dy: y)
        direction = direction.normalized()
        let bulletVelocity = direction*BULLET_SPEED*delta
        return bulletVelocity
    }
    
    func shootDirectionSlime(from point: CGPoint, atPoint position: CGPoint, withSpeed speed: Double)->CGVector{
        let x = position.x - point.x
        let y = position.y - point.y
        var direction = CGVector(dx: x, dy: y)
        direction = direction.normalized()
        let bulletVelocity = direction*speed*delta
        return bulletVelocity
    }
    
    func spawnBullet(from position: CGPoint, directedTo direction: CGPoint){
        let bullet = Bullet2()
        bullet.sprite.setScale(2)
        bullet.position = position //convert(shootingPoint.position, from: pistol)
        bullet.initialPosition = player.position
        bullet.bulletDirection = shootDirection(fromPistol: position, atPoint: direction)
        bullet.zRotation = angle + pi/2
        
        addChild(bullet)
    }
    
    func spawnBulletJoystick(from position: CGPoint){
        let bullet = Bullet2()
        bullet.sprite.setScale(2)
        bullet.position = position //convert(shootingPoint.position, from: pistol)
        bullet.initialPosition = player.position
        bullet.bulletDirection = shootDirectionJoystick(fromPistol: position)
        bullet.zRotation = angle + pi/2
        
        addChild(bullet)
    }
    
    func slimeSpawnBullet(from position: CGPoint, directedTo direction: CGPoint, level: String){
        let bullet = Bullet3()
        switch(level){
        case "lvl1":
            bullet.sprite.run(.repeatForever(.animate(with: slimeBulletAttack, timePerFrame: 0.3)))
        case "lvl2":
            bullet.run(.setTexture(SKTexture(imageNamed: "Level2SlimeBullet")))
            bullet.sprite.run(.repeatForever(.animate(with: slimeBulletAttack2, timePerFrame: 0.3)))
        default:
            bullet.run(.setTexture(SKTexture(imageNamed: "Level3SlimeBullet")))
            bullet.sprite.run(.repeatForever(.animate(with: slimeBulletAttack3, timePerFrame: 0.3)))
        }
        bullet.position = position
        //convert(shootingPoint.position, from: pistol)
        bullet.sprite.setScale(2)
        bullet.bulletDirection = shootDirectionSlime(from: position, atPoint: direction, withSpeed: ENEMY_BULLET_SPEED)
        addChild(bullet)
    }
    
    func moveBullets(){
        enumerateChildNodes(withName: "bullet"){ singleBullet, _ in
            let bullet = singleBullet as! Bullet2
            if bullet.isShot == true{
                bullet.position.x += bullet.bulletDirection.dx
                bullet.position.y += bullet.bulletDirection.dy
                if sqrt(pow(bullet.initialPosition.x - bullet.position.x, 2) + pow(bullet.initialPosition.y - bullet.position.y, 2)) >= MAX_PLAYER_BULLET_DISTANCE
                {
                    bullet.removeFromParent()
                }
            }
        }
    }
    
    func moveBullets(objectName: String){  //ONLY FOR SLIME
        enumerateChildNodes(withName: objectName){ singleBullet, _ in
            let bullet = singleBullet as! Bullet3
            if bullet.isShot == true{
                bullet.position.x += bullet.bulletDirection.dx
                bullet.position.y += bullet.bulletDirection.dy
                if sqrt(pow(bullet.position.x, 2) + pow(bullet.position.y, 2)) >= MAX_ENEMY_BULLET_DISTANCE{
                    bullet.removeFromParent()
                }
            }
        }
    }
    
    func followMouse(mousePos: CGPoint){
        if jsState == false{
            let x = mousePos.x - player.position.x
            let y = mousePos.y - player.position.y
            angle = -atan2(x,y)
            pistol.zRotation = angle + 3.14/2
            pistol2.zRotation = angle + pi/2
        }else{
//            let x = CGFloat(controller1.extendedGamepad!.leftThumbstick.xAxis.value) - player.position.x
//            let y = CGFloat(controller1.extendedGamepad!.leftThumbstick.yAxis.value) - player.position.y
            if controller1.extendedGamepad?.rightThumbstick.xAxis.value ?? 0 != 0 && controller1.extendedGamepad?.rightThumbstick.yAxis.value ?? 0 != 0{
                angle = -atan2(CGFloat(controller1.extendedGamepad!.rightThumbstick.xAxis.value),CGFloat(controller1.extendedGamepad!.rightThumbstick.yAxis.value))
                lastDirectionJs = CGVector(dx: CGFloat(controller1.extendedGamepad!.rightThumbstick.xAxis.value), dy: CGFloat(controller1.extendedGamepad!.rightThumbstick.yAxis.value))
            }else{
                angle = -atan2(lastDirectionJs.dx, lastDirectionJs.dy)
            }
            pistol.zRotation = angle + 3.14/2
            pistol2.zRotation = angle + pi/2
        }
    }
    
    func adjustPistol(){ //-pi e 0
        if angle >= -3*pi/4 && angle < -pi/4 {
            pistol.yScale = 1
            pistol2.yScale = 1
            pistol.zPosition = 1
            pistol2.zPosition = 3
            pistol.position.x = player.position.x + 10
            pistol.position.y = player.position.y
            pistol2.position.x = player.position.x
            pistol2.position.y = player.position.y - 5
            
            
            // pi e 0
        }else if angle < pi/4 && angle >= -pi/4{
            pistol.zPosition = 1
            pistol2.zPosition = 1
            pistol2.yScale = -1
            pistol.yScale = 1
            pistol.position.x = player.position.x + 20
            pistol.position.y = player.position.y
            pistol2.position.x = player.position.x - 20
            pistol2.position.y = player.position.y
        }else if angle >= pi/4 && angle < 3*pi/4{
            pistol.yScale = -1
            pistol2.yScale = -1
            pistol.zPosition = 3
            pistol2.zPosition = 1
            pistol.position.x = player.position.x
            pistol.position.y = player.position.y - 5
            pistol2.position.x = player.position.x - 10
            pistol2.position.y = player.position.y
        }else{
            pistol.zPosition = 3
            pistol2.zPosition = 3
            pistol2.yScale = 1
            pistol.yScale = -1
            pistol.position.x = player.position.x + 20
            pistol.position.y = player.position.y
            pistol2.position.x = player.position.x - 20
            pistol2.position.y = player.position.y
        }
    }
    
    func reload(){
        if shots <= 0{
            shots = 6
            player.state.isReloading = false
            pistol.run(.playSoundFileNamed("PistolReload", waitForCompletion: false))
        }
        if shots2 <= 0{
            shots2 = 6
        }
    }
    
    func manualReloadJs(){
        if controller1.extendedGamepad?.buttonX.isPressed ?? false{
            if shots < 6{
                shots = 0
                player.state.isReloading = true
                run(.sequence([.wait(forDuration: RELOAD_TIME), .run {
                    self.reload()
                }]))
            }
        }
    }
    
    
    
    //SLIME*****************
    func slimeMovement(player: Player, delta: TimeInterval){
        for x in 0..<slimeOnScreen.count{
            if slimeOnScreen[x].lives > 0{
                if slimeOnScreen[x].playerIsDetected == true{
                    if getDistanceBetween(point1: slimeOnScreen[x].sprite.position, point2: player.position) <= slimeOnScreen[x].attackRadius{
                        if slimeOnScreen[x].isMoving || slimeOnScreen[x].isAttacking == false{
                            slimeOnScreen[x].isMoving = false
                            slimeOnScreen[x].isAttacking = true
                            slimeOnScreen[x].sprite.removeAllActions()
                            switch(slimeOnScreen[x].name){
                            case "lvl1":
                                slimeOnScreen[x].sprite.run(.animate(with: slimeAttacking, timePerFrame: 0.4), completion: {
                                    self.slimeAttack(from: slimeOnScreen[x].sprite.position, level: slimeOnScreen[x].name)
                                    slimeOnScreen[x].isAttacking = false
                                    slimeOnScreen[x].isMoving = true
                                })
                            case "lvl2":
                                slimeOnScreen[x].sprite.run(.animate(with: slimeAttacking2, timePerFrame: 0.4), completion: {
                                    self.slimeAttack(from: slimeOnScreen[x].sprite.position, level: slimeOnScreen[x].name
                                    )
                                    slimeOnScreen[x].isAttacking = false
                                    slimeOnScreen[x].isMoving = true
                                })
                            default:
                                slimeOnScreen[x].sprite.run(.animate(with: slimeAttacking3, timePerFrame: 0.4), completion: {
                                    self.slimeAttack(from: slimeOnScreen[x].sprite.position, level: slimeOnScreen[x].name
                                    )
                                    slimeOnScreen[x].isAttacking = false
                                    slimeOnScreen[x].isMoving = true
                                })
                                
                            }
                            
                            
                        }
                    }else{
                        if slimeOnScreen[x].isMoving == false{
                            slimeOnScreen[x].isAttacking = false
                            slimeOnScreen[x].isMoving = true
                            slimeOnScreen[x].sprite.removeAllActions()
                            switch(slimeOnScreen[x].name){
                            case "lvl1":
                                slimeOnScreen[x].sprite.run(.repeatForever(.animate(with: slimeMoving, timePerFrame: 0.4)))
                            case "lvl2":
                                slimeOnScreen[x].sprite.run(.repeatForever(.animate(with: slimeMoving2, timePerFrame: 0.4)))
                            default:
                                slimeOnScreen[x].sprite.run(.repeatForever(.animate(with: slimeMoving3, timePerFrame: 0.4)))
                            }
                        }
                        let direction = getDirectionVectorBetween(start: slimeOnScreen[x].sprite.position, end: player.position)
                        slimeOnScreen[x].sprite.position.x += direction.dx * MAX_ENEMY_SPEED * slimeOnScreen[x].hitStopper*delta
                        slimeOnScreen[x].sprite.position.y += direction.dy * MAX_ENEMY_SPEED * slimeOnScreen[x].hitStopper*delta
                    }
                }
            }
        }
    }
    
    
    
    func checkPlayerDetection(player: Player){
        for x in 0..<slimeOnScreen.count{
            if slimeOnScreen[x].playerIsDetected == false{
                if getDistanceBetween(point1: slimeOnScreen[x].sprite.position, point2: player.position) < slimeOnScreen[x].visionRadius{
                    slimeOnScreen[x].playerIsDetected = true
                    //                    print("Player detected")
                }
            }
        }
    }
    
    func slimeAttack(from point: CGPoint, level: String){
        slimeSpawnBullet(from: point, directedTo: player.position, level: level)
    }
    
    
    func shootTrigger(){
        if controller1.extendedGamepad?.rightTrigger.isPressed == true {
            if player.state.isAttacking == false{
                player.state.isAttacking = true
                if gameOver == false{
                    if shots > 0{
                        shots -= 1
                        spawnBulletJoystick(from: convert(shootingPoint.position, from: pistol))
                        pistol.run(.animate(with: pistolFrames, timePerFrame: 0.1))
                        pistol.run(.playSoundFileNamed("PistolShot", waitForCompletion: false))
                    }else if shots <= 0{
                        //            print("EMPTY")
                        pistol.run(.playSoundFileNamed("PistolNoAmmo", waitForCompletion: false))
                        if player.state.isReloading == false{
                            player.state.isReloading = true
                            run(.wait(forDuration: RELOAD_TIME), completion: {
                                self.reload()
                            })
                        }
                    }
                    if shots2 > 0{
                        shots2 -= 1
                        spawnBulletJoystick(from: convert(shootingPoint2.position, from: pistol2))
                        pistol2.run(.animate(with: pistolFrames, timePerFrame: 0.1))
                    }else if shots <= 0{
                        //            print("EMPTY")
                        if player.state.isReloading == false{
                            player.state.isReloading = true
                            run(.wait(forDuration: RELOAD_TIME), completion: {
                                self.reload()
                            })
                        }
                    }
                    
                }
            }
        }
        else{
            player.state.isAttacking = false
        }
    }
    
    override func mouseDown(with event: NSEvent) {
        if gameOver == false{
            if shots > 0{
                shots -= 1
                spawnBullet(from: convert(shootingPoint.position, from: pistol), directedTo: event.location(in: self))
                pistol.run(.animate(with: pistolFrames, timePerFrame: 0.1))
                pistol.run(.playSoundFileNamed("PistolShot", waitForCompletion: false))
            }else if shots <= 0{
                //            print("EMPTY")
                pistol.run(.playSoundFileNamed("PistolNoAmmo", waitForCompletion: false))
                if player.state.isReloading == false{
                    player.state.isReloading = true
                    run(.wait(forDuration: RELOAD_TIME), completion: {
                        self.reload()
                    })
                }
            }
            if shots2 > 0{
                shots2 -= 1
                spawnBullet(from: convert(shootingPoint2.position, from: pistol2), directedTo: event.location(in: self))
                pistol2.run(.animate(with: pistolFrames, timePerFrame: 0.1))
            }else if shots <= 0{
                //            print("EMPTY")
                if player.state.isReloading == false{
                    player.state.isReloading = true
                    run(.wait(forDuration: RELOAD_TIME), completion: {
                        self.reload()
                    })
                }
            }
            
        }
    }
    
    override func rightMouseDown(with event: NSEvent) {
        
    }
    
    override func mouseUp(with event: NSEvent) {
    }
    
    override func mouseMoved(with event: NSEvent) {
        crossair.position = event.location(in: self)
        followMouse(mousePos: event.location(in: self))
    }
    
    override func mouseDragged(with event: NSEvent) {
        crossair.position = event.location(in: self)
        followMouse(mousePos: event.location(in: self))
    }
    
    
    
    
    func checkSpawn(slime: SKSpriteNode){
        let radius = CGRect(x: player.position.x, y: player.position.y, width: 150, height: 150)
        
        
        let myGeneratedPosition = CGPoint(x: CGFloat.random(in: 8...size.width-8), y: CGFloat.random(in: 16...size.height-8))
        
        //        print(size.height)
        
        if(radius.contains(myGeneratedPosition)){
            checkSpawn(slime: slime)
        } else {
            slime.position = myGeneratedPosition
        }
        
        
    }
    
    
    //    ***********************************************
    //SPAWN SECTION
    func spawnEnemies(){
        //        print("Entering the function")
        if enemyKilled < 10{
            //            print("Entering enemyKilled")
            if enemyCountInGame < MAX_ENEMY_LVL1{
                //                print("Entering spawning enemy")
                //                spawning = true
                slimeOnScreen.append(Slime2(sprite: SKSpriteNode(imageNamed: "SlimeLevel1"), lives: 1, name: "lvl1", points: 100))
                slimeCounter+=1
                enemyCountInGame+=1
                slimeOnScreen[slimeCounter-1].sprite.name = "slime\(slimeCounter)"
                checkSpawn(slime: slimeOnScreen[slimeCounter-1].sprite)
                //                slimeOnScreen[slimeCounter-1].sprite.position = CGPoint(x: Double.random(in: 32...size.width-32), y: Double.random(in: 32...size.height-32))
                //                guard slimeOnScreen[slimeCounter-1].sprite.position.x > size.width/2 + MIN_DISTANCE_SPAWN_FROM_PLAYER || slimeOnScreen[slimeCounter-1].sprite.position.x < size.width/2 - MIN_DISTANCE_SPAWN_FROM_PLAYER ||  slimeOnScreen[slimeCounter-1].sprite.position.y > size.height/2 + MIN_DISTANCE_SPAWN_FROM_PLAYER || slimeOnScreen[slimeCounter-1].sprite.position.y < size.height/2 - MIN_DISTANCE_SPAWN_FROM_PLAYER else{
                //                    enemyCountInGame-=1
                //                    return
                //                }
                slimeOnScreen[slimeCounter-1].sprite.zPosition = 5
                slimeOnScreen[slimeCounter-1].sprite.physicsBody = SKPhysicsBody(texture: slimeOnScreen[slimeCounter-1].sprite.texture!, size: slimeOnScreen[slimeCounter-1].sprite.size)
                slimeOnScreen[slimeCounter-1].sprite.physicsBody?.affectedByGravity = false
                slimeOnScreen[slimeCounter-1].sprite.physicsBody?.isDynamic = false
                slimeOnScreen[slimeCounter-1].sprite.physicsBody?.allowsRotation = false
                slimeOnScreen[slimeCounter-1].sprite.physicsBody?.categoryBitMask = ColliderTypes.enemy
                slimeOnScreen[slimeCounter-1].sprite.physicsBody?.collisionBitMask = ColliderTypes.player
                slimeOnScreen[slimeCounter-1].sprite.physicsBody?.collisionBitMask = ColliderTypes.bullet
                slimeOnScreen[slimeCounter-1].sprite.physicsBody?.contactTestBitMask = ColliderTypes.player
                slimeOnScreen[slimeCounter-1].sprite.physicsBody?.contactTestBitMask = ColliderTypes.bullet
                
                slimeOnScreen[slimeCounter-1].sprite.run(.sequence([.animate(with: slimeSpawnAnimation, timePerFrame: 0.1), .wait(forDuration: 0.1), .repeatForever(.animate(with: slimeIdle, timePerFrame: 0.4))]))
                
                addChild(slimeOnScreen[slimeCounter-1].sprite)
                
                
                run(.wait(forDuration: 0.3),completion: {
                    //                    print("Can Now Spawn")
                    self.spawning = false
                })
            } else {
                cantSpawn = true
            }
        }
        else if enemyKilled >= 10 && enemyKilled < 30{
            if enemyCountInGame < MAX_ENEMY_LVL2{
                let level2 = Bool.random()
                if level2{
                    slimeOnScreen.append(Slime2(sprite: SKSpriteNode(imageNamed: "SlimeLevel2"), lives: 3, name: "lvl2", points: 250))
                    slimeOnScreen[slimeCounter].attackRadius *= 0
                }else{
                    slimeOnScreen.append(Slime2(sprite: SKSpriteNode(imageNamed: "SlimeLevel1"), lives: 1, name: "lvl1", points: 100))
                }
                slimeCounter+=1
                enemyCountInGame+=1
                
                slimeOnScreen[slimeCounter-1].sprite.name = "slime\(slimeCounter)"
                checkSpawn(slime: slimeOnScreen[slimeCounter-1].sprite)
                //                slimeOnScreen[slimeCounter-1].sprite.position = CGPoint(x: Double.random(in: 32...size.width-32), y: Double.random(in: 32...size.height-32))
                slimeOnScreen[slimeCounter-1].sprite.zPosition = 5
                slimeOnScreen[slimeCounter-1].sprite.physicsBody = SKPhysicsBody(texture: slimeOnScreen[slimeCounter-1].sprite.texture!, size: slimeOnScreen[slimeCounter-1].sprite.size)
                slimeOnScreen[slimeCounter-1].sprite.physicsBody?.affectedByGravity = false
                slimeOnScreen[slimeCounter-1].sprite.physicsBody?.isDynamic = false
                slimeOnScreen[slimeCounter-1].sprite.physicsBody?.allowsRotation = false
                slimeOnScreen[slimeCounter-1].sprite.physicsBody?.categoryBitMask = ColliderTypes.enemy
                slimeOnScreen[slimeCounter-1].sprite.physicsBody?.collisionBitMask = ColliderTypes.player
                slimeOnScreen[slimeCounter-1].sprite.physicsBody?.collisionBitMask = ColliderTypes.bullet
                slimeOnScreen[slimeCounter-1].sprite.physicsBody?.contactTestBitMask = ColliderTypes.player
                slimeOnScreen[slimeCounter-1].sprite.physicsBody?.contactTestBitMask = ColliderTypes.bullet
                if level2{
                    slimeOnScreen[slimeCounter-1].sprite.run(.sequence([.animate(with: slimeSpawnAnimation2, timePerFrame: 0.1), .wait(forDuration: 0.1), .repeatForever(.animate(with: slimeIdle2, timePerFrame: 0.4))]))
                }else{
                    slimeOnScreen[slimeCounter-1].sprite.run(.sequence([.animate(with: slimeSpawnAnimation, timePerFrame: 0.1), .wait(forDuration: 0.1), .repeatForever(.animate(with: slimeIdle, timePerFrame: 0.4))]))
                }
                addChild(slimeOnScreen[slimeCounter-1].sprite)
                
                run(.wait(forDuration: 0.3),completion: {
                    print("Can Now Spawn")
                    self.spawning = false
                })
            } else {
                cantSpawn = true
            }
        }else{
            if enemyCountInGame < MAX_ENEMY_LVL3{
                let livello = Int.random(in: 0...2)
                if livello == 2{
                    slimeOnScreen.append(Slime2(sprite: SKSpriteNode(imageNamed: "SlimeLevel2"), lives: 3, name: "lvl2", points: 200))
                    slimeOnScreen[slimeCounter].attackRadius *= 0
                }else if livello == 1{
                    slimeOnScreen.append(Slime2(sprite: SKSpriteNode(imageNamed: "SlimeLevel1"), lives: 1, name: "lvl1", points: 50))
                }else{
                    slimeOnScreen.append(Slime2(sprite: SKSpriteNode(imageNamed: "SlimeLevel3"), lives: 5, name: "lvl3", points: 500))
                    slimeOnScreen[slimeCounter].attackRadius *= 2
                    slimeOnScreen[slimeCounter].visionRadius *= 2
                }
                slimeCounter+=1
                enemyCountInGame+=1
                slimeOnScreen[slimeCounter-1].sprite.name = "slime\(slimeCounter)"
                checkSpawn(slime: slimeOnScreen[slimeCounter-1].sprite)
                //                slimeOnScreen[slimeCounter-1].sprite.position = CGPoint(x: Double.random(in: 32...size.width-32), y: Double.random(in: 32...size.height-32))
                slimeOnScreen[slimeCounter-1].sprite.physicsBody = SKPhysicsBody(texture: slimeOnScreen[slimeCounter-1].sprite.texture!, size: slimeOnScreen[slimeCounter-1].sprite.size)
                slimeOnScreen[slimeCounter-1].sprite.zPosition = 5
                slimeOnScreen[slimeCounter-1].sprite.physicsBody?.affectedByGravity = false
                slimeOnScreen[slimeCounter-1].sprite.physicsBody?.isDynamic = false
                slimeOnScreen[slimeCounter-1].sprite.physicsBody?.allowsRotation = false
                slimeOnScreen[slimeCounter-1].sprite.physicsBody?.categoryBitMask = ColliderTypes.enemy
                slimeOnScreen[slimeCounter-1].sprite.physicsBody?.collisionBitMask = ColliderTypes.player
                slimeOnScreen[slimeCounter-1].sprite.physicsBody?.collisionBitMask = ColliderTypes.bullet
                slimeOnScreen[slimeCounter-1].sprite.physicsBody?.contactTestBitMask = ColliderTypes.player
                slimeOnScreen[slimeCounter-1].sprite.physicsBody?.contactTestBitMask = ColliderTypes.bullet
                if livello == 2{
                    slimeOnScreen[slimeCounter-1].sprite.run(.sequence([.animate(with: slimeSpawnAnimation2, timePerFrame: 0.1), .wait(forDuration: 0.1), .repeatForever(.animate(with: slimeIdle2, timePerFrame: 0.4))]))
                }else if livello == 1{
                    slimeOnScreen[slimeCounter-1].sprite.run(.sequence([.animate(with: slimeSpawnAnimation, timePerFrame: 0.1), .wait(forDuration: 0.1), .repeatForever(.animate(with: slimeIdle, timePerFrame: 0.4))]))
                }else{
                    slimeOnScreen[slimeCounter-1].sprite.run(.sequence([.animate(with: slimeSpawnAnimation3, timePerFrame: 0.1), .wait(forDuration: 0.1), .repeatForever(.animate(with: slimeIdle3, timePerFrame: 0.4))]))
                }
                addChild(slimeOnScreen[slimeCounter-1].sprite)
                
                run(.wait(forDuration: 0.3),completion: {
                    print("Can Now Spawn")
                    self.spawning = false
                })
            } else {
                cantSpawn = true
            }
        }
        
        if (cantSpawn){
            spawning = false
        }
    }
    
    
    func gameOverFunc(){
        removeAllChildren()
        removeAllActions()
        gameOver = true
//        let pressRLabel = SKLabelNode(fontNamed: "Grand9k Pixel")
        if jsState{
            if controller1.productCategory.contains("DualShock"){
                if pressRLabel.text != "Press 􀨃 to restart"{
                    pressRLabel.text = "Press 􀨃 to restart"
                }
            }else{
                if pressRLabel.text != "Press 􀀲 to restart"{
                    pressRLabel.text = "Press 􀀲 to restart"
                }
            }
            
        }else{
            if pressRLabel.text != "Press R to restart"{
                    pressRLabel.text = "Press R to restart"
            }
        }
        pressRLabel.fontSize = 20
        pressRLabel.run(.repeatForever(.sequence([.fadeOut(withDuration: 1), .fadeIn(withDuration: 1)])))
        blackScreen.fillColor = .black
        gameOverLabel.text = "GAME OVER"
        yourScore.text = "Score: \(point)"
        yourScore.position = CGPoint(x: size.width/2, y: size.height/2)
        gameOverLabel.position = CGPoint(x: size.width/2, y: size.height/2)
        gameOverLabel.position.y += size.height*0.1
        pressRLabel.position = yourScore.position
        pressRLabel.position.y -= size.height*0.4
        let newCamera = SKCameraNode()
        camera = newCamera
        newCamera.position = blackScreen.position
        addChild(pressRLabel)
        addChild(blackScreen)
        addChild(gameOverLabel)
        addChild(yourScore)
    }
    
    
    
    //    COLLIDER SECTION
    
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody = SKPhysicsBody()
        var secondBody = SKPhysicsBody()
        
        if contact.bodyA.node?.name == "player"{
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        }else if contact.bodyB.node?.name == "player"{
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if contact.bodyA.node?.name == "bullet"{
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        }else if contact.bodyB.node?.name == "bullet"{
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        let name = secondBody.node?.name
        guard name?.contains("slime") != nil else{
            return
        }
        
        if (firstBody.node?.name == "bullet" || firstBody.node?.name == "slimeBullet") && secondBody.node?.name == "wall"{
            firstBody.node?.removeFromParent()
        }
        
        if firstBody.node?.name == "player" && (name!.contains("slime") || secondBody.node?.name == "slimeBullet"){
            gameOverFunc()
        }
        
        if firstBody.node?.name == "bullet" && name!.contains("slime"){
            firstBody.node?.removeFromParent()
            for index in 0..<slimeOnScreen.count{
                if slimeOnScreen[index].sprite.name == name!{
                    slimeOnScreen[index].lives -= 1
                    if slimeOnScreen[index].lives <= 0{
                        enemyKilled+=1
                        point += slimeOnScreen[index].points
                        enemyCountInGame-=1
                        slimeOnScreen[index].sprite.removeAllActions()
                        slimeOnScreen[index].sprite.physicsBody = SKPhysicsBody()
                        slimeOnScreen[index].sprite.physicsBody?.affectedByGravity = false
                        switch(slimeOnScreen[index].name){
                        case "lvl1":
                            slimeOnScreen[index].sprite.run(.animate(with: slimeDeath, timePerFrame: 0.1), completion: {
                                slimeOnScreen[index].sprite.removeFromParent()
                                //                            slimeOnScreen.remove(at: index)
                            })
                        case "lvl2":
                            slimeOnScreen[index].sprite.run(.animate(with: slimeDeath2, timePerFrame: 0.1), completion: {
                                slimeOnScreen[index].sprite.removeFromParent()
                                //                            slimeOnScreen.remove(at: index)
                            })
                        default:
                            slimeOnScreen[index].sprite.run(.animate(with: slimeDeath3, timePerFrame: 0.1), completion: {
                                slimeOnScreen[index].sprite.removeFromParent()
                                //                            slimeOnScreen.remove(at: index)
                            })
                        }
                        break
                    }else{
                        switch(slimeOnScreen[index].name){
                        case "lvl1":
                            break
                        case "lvl2":
                            slimeOnScreen[index].hitStopper = 0
                            slimeOnScreen[index].sprite.run(.animate(with: slimeHit2, timePerFrame: 0.2), completion: {
                                slimeOnScreen[index].hitStopper = 1
                                slimeOnScreen[index].sprite.run(.repeatForever(.animate(with: slimeIdle2, timePerFrame: 0.4)))
                            })
                        default:
                            slimeOnScreen[index].hitStopper = 0
                            slimeOnScreen[index].sprite.run(.animate(with: slimeHit3, timePerFrame: 0.2), completion: {
                                slimeOnScreen[index].hitStopper = 1
                                slimeOnScreen[index].sprite.run(.repeatForever(.animate(with: slimeIdle3, timePerFrame: 0.4)))
                            })
                        }
                    }
                }
            }
        }
    }
    
    //CONTROLLER
    func leftStick(){
        let input = controller1.extendedGamepad?.leftThumbstick
        if input?.xAxis.value ?? 0 > 0{
            right = true
            left = false
        }else if input?.xAxis.value ?? 0 < 0 {
            left = true
            right = false
        }else{
            right = false
            left = false
        }
        
        if input?.yAxis.value ?? 0 > 0{
            up = true
            down = false
            
        }else if input?.yAxis.value ?? 0 < 0{
            up = false
            down = true
        }else{
            up = false
            down = false
        }
    }
    
    
    override func keyDown(with event: NSEvent) {
        if player.state.idle == true{
            player.state.idle = false
            player.resetFacingState()
        }
        if player.state.isMoving == false{
            player.state.isMoving = true
        }
        switch Int(event.keyCode){
        case Key.a.rawValue:
            left = true
        case Key.d.rawValue:
            right = true
        case Key.w.rawValue:
            up = true
        case Key.s.rawValue:
            down = true
        case Key.r.rawValue:
            if gameOver{
                let restartScene = GameScene(size: CGSize(width: 1280, height: 1000))
                let transition = SKTransition.fade(withDuration: 2)
                restartScene.scaleMode = .aspectFit
                restartScene.size = size
                scene?.view?.presentScene(restartScene, transition: transition)
            }else{
                if shots < 6{
                    shots = 0
                    player.state.isReloading = true
                    run(.sequence([.wait(forDuration: RELOAD_TIME), .run {
                        self.reload()
                    }]))
                }
            }
            //        case Key.space.rawValue:
            //            dashDirection = inputVector.normalized()
        default:
            break
        }
    }
    
    override func keyUp(with event: NSEvent) {
        if player.state.isMoving == true{
            player.resetFacingState()
            player.state.isMoving = false
        }
        if player.state.idle == false{
            player.state.idle = true
            
        }
        switch Int(event.keyCode){
        case Key.a.rawValue:
            left = false
        case Key.d.rawValue:
            right = false
        case Key.w.rawValue:
            up = false
        case Key.s.rawValue:
            down = false
        default:
            break
        }
    }
    
    func restartJoystick(){
        if gameOver{
            if controller1.extendedGamepad?.buttonX.isPressed ?? false{
                let restartScene = GameScene(size: CGSize(width: 1280, height: 1000))
                let transition = SKTransition.fade(withDuration: 2)
                restartScene.scaleMode = .aspectFit
                restartScene.size = size
                scene?.view?.presentScene(restartScene, transition: transition)
            }
        }
    }
    
    func timer(){
        let wait = SKAction.wait(forDuration: 1)
        let go = SKAction.run({
            if self.time > 0 {
                self.time -= 1
            }else{
                self.gameOverFunc()
            }
        })
        
        let actions = SKAction.sequence([wait, go])
        run(.repeatForever(actions))
    }
    
    func updateTimer(){
        if time == 60{
            labelTimer.text = "1:00"
        }else if time < 10{
            labelTimer.text = String(format: "0:0%d", time)
        }
        else{
            labelTimer.text = String(format: "0:%d", time)
        }
    }
    
    func updatePoints(){
        labelPoints.text = "Points \(point)"
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        
        setUpControllerObservers()
        connectControllers()
        // Called before each frame is rendered
        defer{ lastUpdate = currentTime}
        guard lastUpdate != nil else{
            return
        }
        delta = currentTime-lastUpdate
        guard delta < 1 else{
            return
        }
        
        if GCController.controllers().isEmpty == false{
            if controller1.extendedGamepad == nil{
            controller1 = GCController.controllers()[0]
            }
        }
        
        if player.state.isReloading{
            reloadLable.text = "Reloading"
        }else{
            if shots > 0{
                reloadLable.text = String(format: "%d/6", shots)
            }else{
                reloadLable.text = "Empty"
                
            }
        }
        
        updateTimer()
        
        
        inputVector = CGVector.zero
        inputVector.dx = getDirection(key: .d, directionState: right).dx + getDirection(key: .a, directionState: left).dx
        inputVector.dy = getDirection(key: .w, directionState: up).dy + getDirection(key: .s, directionState: down).dy
        
        if inputVector != CGVector.zero {
            inputVector = inputVector.normalized()
            inputVector = inputVector*ACCELERATION*delta
            velocity += inputVector
            velocity = velocity.clamped(maxLength: MAX_SPEED * delta)
        }else{
            velocity = velocity.moveTowardZero(value: FRICTION*delta)
        }
        
        if jsState{
            leftStick()
            shootTrigger()
            manualReloadJs()
        }
        
        playerMovement(player: player, velocity: velocity)
        playerMovement(player: crossair, velocity: velocity) //For the crossair
        if jsState{
            followMouse(mousePos: CGPoint.zero)
        }
        adjustPistol()
        reloadPlayerLabel.position.x = player.position.x
        reloadPlayerLabel.position.y = player.position.y + 22
        if player.state.isReloading{
            reloadPlayerLabel.fontColor = .white
            run(.sequence([.wait(forDuration: RELOAD_TIME), .run {
                self.reloadPlayerLabel.fontColor = .clear
            }]))
        }
        if jsState{
            sceneCamera.position = player.position
        }else{
            midPoint = getMiddlePoint(firstPoint: player.position, secondPoint: crossair.position)
            sceneCamera.position = CGPoint(x: midPoint.x, y: midPoint.y)
        }
        
        moveBullets()
        moveBullets(objectName: "slimeBullet")
        //        spawnEnemies()
        
        if(spawning == false){
            spawning = true
            spawnEnemies()
        }
        
        //        if(!spawning){
        //            spawnEnemies()
        //        }
        
        updatePoints()
        checkPlayerDetection(player: player)
        slimeMovement(player: player, delta: delta)
        
        player.animationWalk(angle: angle)
        player.animationIdle(angle: angle)
        restartJoystick()
        
        if gameOver{
            if jsState{
                if controller1.productCategory.contains("DualShock"){
                    if pressRLabel.text != "Press 􀨃 to restart"{
                        pressRLabel.text = "Press 􀨃 to restart"
                    }
                }else{
                    if pressRLabel.text != "Press 􀀲 to restart"{
                        pressRLabel.text = "Press 􀀲 to restart"
                    }
                }
                
            }else{
                if pressRLabel.text != "Press R to restart"{
                        pressRLabel.text = "Press R to restart"
                }
            }
        }
        
    }
}
