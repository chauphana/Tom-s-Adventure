//
//  File.swift
//  Tom's Adventure
//
//  Created by 90309776 on 1/15/19.
//  Copyright © 2019 90309776. All rights reserved.
//

import SpriteKit
import Foundation

class Projectile {
    
    var sprite: SKSpriteNode!
    
    init() {
        //self.sprite = SKSpriteNode(color: UIColor.green, size: CGSize(width: 10, height: 10))
        self.sprite = SKSpriteNode(color: UIColor.blue, size: CGSize(width: 10, height: 10))
        //self.sprite = SKSpriteNode(imageNamed: "ball.jpg")
        //self.sprite.size = CGSize(width: 10, height: 10)
        self.sprite.name = "proj"
        self.sprite.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        sprite.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: sprite.size.width, height: sprite.size.height))
        sprite.physicsBody?.isDynamic          = true // 2
        sprite.physicsBody?.affectedByGravity  = false
        sprite.physicsBody?.allowsRotation     = false
        //sprite.physicsBody?.mass = 5000
        sprite.physicsBody?.categoryBitMask    = GameData.PhysicsCategory.rocket // 3
        sprite.physicsBody?.contactTestBitMask = GameData.PhysicsCategory.wall
        sprite.physicsBody?.collisionBitMask   = GameData.PhysicsCategory.wall
        
        
        
    }
    
    func fire(angle: CGFloat, player: Player) {
        //finds the coordinates on a unit circle to adjust for delta changes
        let dx = cos(angle)
        let dy = sin(angle)
        
        //unitcircle coordinates multiplied by a magnititude
        sprite.position = CGPoint(x: player.sprite.position.x + dx * 20, y: player.sprite.position.y + dy * 20)
        
        sprite.run(SKAction.move(by: CGVector(dx: 2000.0 * dx, dy: 2000.0 * dy), duration: 5))

    }
    //idea use the same angle calculation as the arm to calc trajectory
    
    func contactedWall() {
        
    }
    
    
    
}
