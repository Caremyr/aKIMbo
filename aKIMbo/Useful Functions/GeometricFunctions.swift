//
//  GeometricFunctions.swift
//  aKIMbo
//
//  Created by Antonio Romano on 22/03/22.
//

import Foundation
import SwiftUI


extension CGVector{
    func getMagnitude()->Double{
        let modulo = sqrt(self.dx*self.dx + self.dy*self.dy)
        return modulo
    }
    
    func normalized()->CGVector{
        let modulo = sqrt(self.dx*self.dx + self.dy*self.dy)
        let x = self.dx/modulo
        let y = self.dy/modulo
        return CGVector(dx: x, dy: y)
    }
    
    
    func moveTowardZero(value: Double)->CGVector{
//        let direction = self.normalized()
        var x: Double = self.dx
        var y: Double = self.dy
//          X POSSIBILITY
            if x > 0{
                if x >= value{
                    x -= value
                }else{
                    x -= x
                }
            }else if x < 0{
                if -x >= value{
                    x += value
                }else{
                    x += -x
                }
            }
        
//          Y POSSIBILITY
            if y > 0{
                if y >= value{
                    y -= value
                }else{
                    y -= y
                }
            }else if y < 0{
                if -y >= value{
                    y += value
                }else{
                    y += -y
                }
            }
        return CGVector(dx: x, dy: y)
    }
    
    func clamped(maxLength: Double) -> CGVector{
        let direzione = self.normalized()
        let modulo = sqrt(self.dx*self.dx + self.dy*self.dy)
        if modulo > maxLength{
            let newX = direzione.dx * maxLength
            let newY = direzione.dy * maxLength
            return CGVector(dx: newX, dy: newY)
        }else{
            return self
        }
    }
}








func getDistanceBetween(point1: CGPoint, point2: CGPoint) -> Double{
    let x = point1.x - point2.x
    let y = point1.y - point2.y
    let distance = sqrt(pow(x, 2)+pow(y, 2))
    return distance
}

func getDirectionVectorBetween(start: CGPoint, end: CGPoint) -> CGVector{
    let x = end.x - start.x
    let y = end.y - start.y
    let direction = CGVector(dx: x, dy: y).normalized()
    return direction
}

func getAngleBetweenOriginAndVector(vector: CGVector) -> Angle{
    let origin = CGVector(dx: 1, dy: 0)
    let angle = acos((vector*origin)/vector.getMagnitude()*1)
    return Angle(radians: angle)
}

func getAngleBetweenOriginAndVector(vector: CGVector) -> Double{
    let origin = CGVector(dx: 1, dy: 0)
    let angle = acos((vector*origin)/vector.getMagnitude()*1)
    return angle
}

func getMiddlePoint(firstPoint: CGPoint, secondPoint: CGPoint)->CGPoint{
    let midx = (firstPoint.x + secondPoint.x)/2
    let midy = (firstPoint.y + secondPoint.y)/2
    let midPoint = CGPoint(x: midx, y: midy)
    return midPoint
}

func getMouseAngle(point1: CGPoint, point2: CGPoint) -> Double{
    let x = point1.x - point2.x
    let y = point1.y - point2.y
    let angle = -atan2(x,y)
    return angle
}
