//
//  GameEngine.swift
//  Tom's Adventure
//
//  Created by 90309776 on 1/11/19.
//  Copyright © 2019 90309776. All rights reserved.
//

import SpriteKit
import Foundation



class GameEngine: SKScene, SKPhysicsContactDelegate {
    
    
    var walls: [SKSpriteNode] = []
    var player: Player = Player()
    var inputHandler: InputHandler = InputHandler()
    var spawnPoint: CGPoint!
    
    override func didMove(to view: SKView) {
        initNodes()

        physicsWorld.contactDelegate = self
        self.camera = player.camera
        player.camera.addChild(inputHandler.joystickSprite)
        player.camera.addChild(inputHandler.joystickInitialSprite)
    }
    
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        let objectA = contact.bodyA.node as! SKSpriteNode
        let objectB = contact.bodyB.node as! SKSpriteNode
        //print("thers contac")
        
        //print("a: \(objectA.name), b: \(objectB.name)")
        
        if objectA.name == "wall" && objectB.name == "proj" {
            let proj = objectB
            print("contact")
            player.calculateProjectileImpulse(pointB: objectB.position)
            proj.removeFromParent()
        }
        
        if objectA.name == "player" && objectB.name == "deathzone" {
            
            player.died(spawnpoint: spawnPoint)
            //print(player.sprite.position)
        }
        
    }
    
    
    
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        for touch in touches {
            let location = touch.location(in: self)
            if location.x < player.camera.position.x {
                inputHandler.initialTouch(initialPoint: touchLocation, player: player)
            } else if location.x > player.camera.position.x {
                inputHandler.didTouchJump(location: location, player: player)
                inputHandler.didTouchShoot(location: location, player: player, scene: self)
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        for touch in touches {
            let location = touch.location(in: self)
            if location.x < player.camera.position.x {
                inputHandler.movedJoystick(point: touchLocation, player: player)
                player.orientateArm(input: inputHandler)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        for touch in touches {
            let location = touch.location(in: self)
            if location.x < player.camera.position.x {
                inputHandler.endedTouch()
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        player.move(input: inputHandler)
        //print(player.sprite.position)
        if player.sprite.position == CGPoint(x: 0, y: 0) {
            print("yaya wtf")
        }
    }
    
    func initNodes() {
        player.sprite = childNode(withName: "player") as? SKSpriteNode
        player.createPhysicsBodyAndBody()
        player.camera = childNode(withName: "camera") as? SKCameraNode
        print("worked")
        
        inputHandler.jump = player.camera.childNode(withName: "jump") as? SKSpriteNode
        inputHandler.shoot = player.camera.childNode(withName: "shoot") as? SKSpriteNode
        
        for child in children {
            if child.name == "wall" {
                
                var tempNode = child as! SKSpriteNode
                
                tempNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: tempNode.size.width, height: tempNode.size.height))
                tempNode.physicsBody?.pinned = true
                tempNode.physicsBody?.isDynamic          = true // 2
                tempNode.physicsBody?.affectedByGravity  = false
                tempNode.physicsBody?.allowsRotation = false
                tempNode.physicsBody?.categoryBitMask    = GameData.PhysicsCategory.wall // 3
                tempNode.physicsBody?.contactTestBitMask = GameData.PhysicsCategory.rocket
                tempNode.physicsBody?.collisionBitMask   = GameData.PhysicsCategory.player | GameData.PhysicsCategory.rocket
                
            }
            else if child.name == "deathzone" {
                var tempNode = child as! SKSpriteNode
                
                tempNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: tempNode.size.width, height: tempNode.size.height))
                tempNode.physicsBody?.pinned = true
                tempNode.physicsBody?.isDynamic          = true // 2
                tempNode.physicsBody?.affectedByGravity  = false
                tempNode.physicsBody?.allowsRotation = false
                tempNode.physicsBody?.categoryBitMask    = GameData.PhysicsCategory.deathzone // 3
                tempNode.physicsBody?.contactTestBitMask = GameData.PhysicsCategory.player
                tempNode.physicsBody?.collisionBitMask   = GameData.PhysicsCategory.player | GameData.PhysicsCategory.rocket
            }
            
        }
        
        
        
    }
    
    
}
