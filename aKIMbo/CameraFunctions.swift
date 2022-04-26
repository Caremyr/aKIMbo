//
//  CameraFunctions.swift
//  aKIMbo
//
//  Created by Antonio Romano on 22/03/22.
//

import Foundation
import SpriteKit

extension SKCameraNode{

func cameraMovement(velocity: CGVector){
    self.position.x += velocity.dx
    self.position.y += velocity.dy
    }
}
