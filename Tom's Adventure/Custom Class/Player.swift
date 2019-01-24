//
//  Player.swift
//  Tom's Adventure
//
//  Created by 90309776 on 1/11/19.
//  Copyright © 2019 90309776. All rights reserved.
//

import SpriteKit
import Foundation

class Player {
    
    var sprite: SKSpriteNode!
    var arm: SKSpriteNode!
    
    var camera: SKCameraNode!
    var speed: CGFloat!
    var isJumping = false
    var hasFired = false
    
    var angle = CGFloat(0)
    init() {
        speed = CGFloat(10)
    }
    
    func createPhysicsBodyAndBody() {
        sprite.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: sprite.size.width, height: sprite.size.height))
        sprite.physicsBody?.isDynamic          = true // 2
        sprite.physicsBody?.affectedByGravity  = true
        sprite.physicsBody?.allowsRotation     = false
        sprite.physicsBody?.friction = CGFloat(1)
        sprite.physicsBody?.categoryBitMask    = GameData.PhysicsCategory.player // 3
        //sprite.physicsBody?.contactTestBitMask = GameData.PhysicsCategory.deathzone
        sprite.physicsBody?.collisionBitMask   = GameData.PhysicsCategory.wall | GameData.PhysicsCategory.deathzone
        sprite.physicsBody?.mass = CGFloat(0.1111)
        
        arm = sprite.childNode(withName: "arm") as? SKSpriteNode
        
    }
    
    /*
     There is an initital tolerance radius for a deadzone that allows for micro adjustment.
     Extending from that radius, the the acceleration zone that is towards the maxSpeedDistance
     
     example: deadZone = 20, maxSpeedDistance = 50, then acceleration zone would be a radius of 30
     after the deadZone
    
     Speed of the player is dependent on the ratio of distance after the deadZone / maxSpeedDistance
     The base speed is then mutliplied by this ratio and so is the base duration
     
     This allows for the player to make micro adjustable movements to more accurately position the player
     to where the user wants the player to be.
     */
    
    func move(input: InputHandler) {
        let baseSpeed = CGFloat(3)
        let baseDuration = CGFloat(0.1)
        let maxSpeedDistance = CGFloat(50)
        let deadZone = CGFloat(20)
        if input.isTouched {
            var joystickDeltaDistance = calcDistance(pointA: input.initialPoint, pointB: input.joystickSprite.position)
            if joystickDeltaDistance > maxSpeedDistance {
                joystickDeltaDistance = maxSpeedDistance
            }

            if joystickDeltaDistance > deadZone {
                let leftOverDistance = joystickDeltaDistance - deadZone
                let ratio = leftOverDistance / (maxSpeedDistance - deadZone)
            
                if input.joystickPosition.x < input.initialPoint.x {
                    let moveAction = SKAction.move(by: CGVector(dx: -baseSpeed * ratio, dy: 0), duration: TimeInterval(baseDuration * ratio))
                    sprite.run(moveAction)
                } else if input.joystickPosition.x > input.initialPoint.x {

                    let moveAction = SKAction.move(by: CGVector(dx: baseSpeed * ratio, dy: 0), duration: TimeInterval(baseDuration * ratio))
                    sprite.run(moveAction)
                }
            }
        }
    }
    
    func jump() {
        if !isJumping {
            isJumping = true
            sprite.physicsBody?.affectedByGravity = false
            let jumpAction = SKAction.move(by: CGVector(dx: 0, dy: 65), duration: 0.25)
            sprite.run(SKAction.sequence([SKAction.wait(forDuration: 0.22), SKAction.run{self.sprite.physicsBody?.affectedByGravity = true}]))
            
            
            sprite.run(jumpAction)
            sprite.run(SKAction.sequence([SKAction.wait(forDuration: 0.5), SKAction.run {
                self.isJumping = false
                }]))
        }
    }
    
    func died(spawnpoint: CGPoint) {
        
        //self.sprite.position = spawnpoint
        sprite.run(SKAction.run {
            self.sprite.position = spawnpoint
        })
        //sprite.run(SKAction.sequence([SKAction.wait(forDuration: 3), SKAction.run{print(self.sprite.position)}]))
    }
    
    func createAndShootRocket(scene: GameEngine) {
        let proj = Projectile()
        proj.sprite.isHidden = true
        scene.addChild(proj.sprite)
        proj.sprite.isHidden = false
        proj.fire(angle: angle, player: self)
    }
    
    func calculateProjectileImpulse(pointB: CGPoint) {
        let maxDistance: CGFloat = 150
        let baseMagnitude: CGFloat = 55
        let pointA = self.sprite.position
        if calcDistance(pointA: pointA, pointB: pointB) < maxDistance {
            let impulseAngle = atan2(pointB.y - self.sprite.position.y, pointB.x - self.sprite.position.x)
            let dx = -cos(impulseAngle)
            let dy = -sin(impulseAngle)
            let currentDistanceToContactedWall = calcDistance(pointA: pointA, pointB: pointB) - arm.size.width
            let distanceRatio = 1 - (currentDistanceToContactedWall / maxDistance)
            let magnitude = baseMagnitude * distanceRatio
            self.sprite.physicsBody?.applyImpulse(CGVector(dx: dx * magnitude, dy: dy * magnitude))
        } else {
            //print("more than 300 btw")
        }
        
    }
    
    func orientateArm(input: InputHandler) {
        angle = atan2(input.joystickPosition.y - input.initialPoint.y, input.joystickPosition.x - input.initialPoint.x)
        //print("angle: \(angle)")
        arm.zRotation = angle
    }
    
    func calcDistance(pointA: CGPoint, pointB: CGPoint ) -> CGFloat{
        //let convertedPoint = self.barrel.convert(self.bar, to: )
        
        let xDifference = pointB.x - pointA.x
        let yDIfference = pointB.y - pointA.y
        
        return CGFloat(sqrt(xDifference * xDifference + yDIfference * yDIfference))
    }
    
//    func calcDistance(pointB: CGPoint ) -> CGFloat{
//        //let convertedPoint = self.barrel.convert(self.bar, to: )
//
//        let xDifference = pointB.x - self.sprite.position.x
//        let yDIfference = pointB.y - self.sprite.position.y
//
//        return CGFloat(sqrt(xDifference * xDifference + yDIfference * yDIfference))
//    }
    
    
}
