//
//  SilmeMovement.swift
//  aKIMbo
//
//  Created by Antonio Romano on 22/03/22.
//

import Foundation
import SpriteKit

func followObjectMovement(object: SKShapeNode, direction: CGVector){
    object.position.x += direction.dx
    object.position.y += direction.dy
}


func slimeMovement(player: Player, delta: TimeInterval){
    for x in 0..<slimeOnScreen.count{
        if slimeOnScreen[x].lives > 0{
            if slimeOnScreen[x].playerIsDetected == true{
                if getDistanceBetween(point1: slimeOnScreen[x].sprite.position, point2: player.position) <= slimeOnScreen[x].attackRadius{
                    if slimeOnScreen[x].isMoving || slimeOnScreen[x].isAttacking == false{
                        slimeOnScreen[x].isMoving = false
                        slimeOnScreen[x].isAttacking = true
                        slimeOnScreen[x].sprite.removeAllActions()
                        slimeOnScreen[x].sprite.run(.animate(with: slimeAttacking, timePerFrame: 0.4), completion: {
                            slimeOnScreen[x].isAttacking = false
                            slimeOnScreen[x].isMoving = true
                        })
                        
                    }
                    print("ATTACK")
                }else{
                if slimeOnScreen[x].isMoving == false{
                    slimeOnScreen[x].isAttacking = false
                    slimeOnScreen[x].isMoving = true
                    slimeOnScreen[x].sprite.removeAllActions()
                    slimeOnScreen[x].sprite.run(.repeatForever(.animate(with: slimeMoving, timePerFrame: 0.4)))
                }
                let direction = getDirectionVectorBetween(start: slimeOnScreen[x].sprite.position, end: player.position)
                slimeOnScreen[x].sprite.position.x += direction.dx * MAX_ENEMY_SPEED*delta
                slimeOnScreen[x].sprite.position.y += direction.dy * MAX_ENEMY_SPEED*delta
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
                print("Player detected")
            }
        }
    }
}

//func slimeAttack(angle: Double, direction: CGVector){
//
//}

enum AXIS: Int{
    case x = 0
    case y = 1
}

//func spawnRange(playerPosition: CGPoint, maxValue: Double, axis: AXIS) -> Double{
//    if axis == .x{
//        let left = Bool.random()
//        if left{
//            return Double.random(in: 32...playerPosition.x - MIN_DISTANCE_SPAWN_FROM_PLAYER)
//        }else{
//
//            return Double.random(in: playerPosition.x + MIN_DISTANCE_SPAWN_FROM_PLAYER...maxValue - 32)
//        }
//    }else{
//        let left = Bool.random()
//        if left{
//            return Double.random(in: 32...playerPosition.y - MIN_DISTANCE_SPAWN_FROM_PLAYER)
//        }else{
//            return Double.random(in: playerPosition.y + MIN_DISTANCE_SPAWN_FROM_PLAYER...maxValue - 32)
//        }
//    }
//}
