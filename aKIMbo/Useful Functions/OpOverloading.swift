//
//  OpOverloading.swift
//  aKIMbo
//
//  Created by Antonio Romano on 22/03/22.
//

import Foundation

func +(left: CGVector, right: CGVector)->CGVector{
    let newX = left.dx + right.dx
    let newY = left.dy + right.dy
    return CGVector(dx: newX, dy: newY)
}

func *(left: CGVector, right: CGVector)->CGVector{
    let newX = left.dx * right.dx
    let newY = left.dy * right.dy
    return CGVector(dx: newX, dy: newY)
}

func *(left: CGVector, right: Double)->CGVector{
    let newX = left.dx * right
    let newY = left.dy * right
    return CGVector(dx: newX, dy: newY)
}

func *(left: CGVector, right: CGVector)->Double{
    let newX = left.dx * right.dx
    let newY = left.dy * right.dy
    return newX+newY
}

func +=(left: inout CGVector, right: CGVector){
    left.dx += right.dx
    left.dy += right.dy
}

