//
//  InputHandler.swift
//  Tom's Adventure
//
//  Created by 90309776 on 1/11/19.
//  Copyright © 2019 90309776. All rights reserved.
//

import SpriteKit
import Foundation

class InputHandler {
    
    var joystickSprite: SKSpriteNode!
    var joystickInitialSprite: SKSpriteNode!
    var initialPoint: CGPoint!
    var joystickPosition: CGPoint!
    var isTouched: Bool
    
    var offsetPoint: CGPoint!
    
    var jump: SKSpriteNode!
    var shoot: SKSpriteNode!
    
    
    init() {
        isTouched = false
        createJoystick()
        joystickSprite.isHidden = true
        joystickInitialSprite.isHidden = true
        joystickSprite.zPosition = 3
        joystickInitialSprite.zPosition = 3
        
    }
    
    func initialTouch(initialPoint: CGPoint, player: Player) {
        
        if !isTouched {
            isTouched = true
            
            /*
             CONVERTS INITIALPOINT FROM THE COORD SYSTEM IN PLAYER.SPRITE.SCENE
             TO THE COORDINATE SYSTEM OF PLAYER.CAMERA
            */
            
            let convertedPoint = player.camera.convert(initialPoint, from: player.sprite.scene!)
            self.initialPoint = convertedPoint
            //joystickSprite.position = initialPoint
            joystickInitialSprite.position = convertedPoint
            joystickInitialSprite.isHidden = false
            joystickSprite.isHidden = false
            joystickSprite.alpha = 1.0
        }
        
        
        
        //offsetPoint = CGPoint(x: initialPoint.x - player.camera.position.x, y: initialPoint.y - player.camera.position.y)
        
        
    }
    

    func movedJoystick(point: CGPoint, player: Player) {
        //isTouched = true
        if isTouched {
            let convertedPoint = player.camera.convert(point, from: player.sprite.scene!)
            joystickSprite.alpha = 0.5
            joystickSprite.position = convertedPoint
            joystickPosition = joystickSprite.position
        }
        //print(joystickInitialSprite.position)
    }
    
    func endedTouch() {
        if isTouched {
            joystickSprite.position = initialPoint
            joystickInitialSprite.isHidden = true
            self.joystickSprite.isHidden = true
            self.isTouched = false
        }
    }
    
    
    func createJoystick() {
        joystickSprite = SKSpriteNode()
        
        joystickSprite.size = CGSize(width: 100, height: 100)
        joystickSprite.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        joystickSprite.color = UIColor.green
        joystickSprite.position = CGPoint(x: 0, y: 0)
        
        joystickInitialSprite = SKSpriteNode()
        joystickInitialSprite.size = CGSize(width: 30, height: 30)
        joystickInitialSprite.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        joystickInitialSprite.color = UIColor.blue
        joystickSprite.position = CGPoint(x: 0, y: 0)
        
        self.initialPoint = joystickSprite.position
        self.joystickPosition = joystickSprite.position
        
    }
    
    func didTouchJump(location: CGPoint, player: Player) {
       // print(player.sprite.scene?.convert(location, to: player.camera))
        
        let convertedPoint = player.sprite.scene?.convert(location, to: player.camera)
        if jump.contains(convertedPoint!) {
            player.jump()
        }
        
    }
    
    func didTouchShoot(location: CGPoint, player: Player, scene: GameEngine) {
        //let adjustedPoint = CGPoint(x: location.x + player.camera.position.x, y: location.y + player.camera.position.y)
        //player.sprite.scene?.convert(location, to: player.camera)
        //print(player.sprite.scene?.convert(location, to: player.camera))
        
        let convertedPoint = player.sprite.scene?.convert(location, to: player.camera)
        
        if shoot.contains(convertedPoint!) {
            if !player.hasFired {
                player.hasFired = true
                player.createAndShootRocket(scene: scene)
                
                let toggleHasFiredAction = SKAction.sequence([SKAction.wait(forDuration: 0.25), SKAction.run{player.hasFired = false}])
                player.sprite.run(toggleHasFiredAction)
            }
        }
    }
    

}
