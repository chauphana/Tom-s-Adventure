//
//  GameStage.swift
//  Tom's Adventure
//
//  Created by 90309776 on 1/19/19.
//  Copyright © 2019 90309776. All rights reserved.
//

import SpriteKit
import Foundation

class GameStage {
    
    var transitionPoint: CGPoint!
    var cameraPoint: CGPoint!
    var spawnPoint: CGPoint!
    
    init(tp: CGPoint, cp: CGPoint) {
        self.transitionPoint = tp
        self.cameraPoint = cp
    }
    
    //Checks if coordinate value is within
    //the standard range for a new level doorway
    func xInRange(player: Player) -> Bool {
        if player.sprite.position.x <= transitionPoint.x + 30
            && player.sprite.position.x >= transitionPoint.x - 30 {
            return true
        } else {
            return false
        }
        
    }
    
    
    func yInRange(player: Player) -> Bool {
        if player.sprite.position.y <= transitionPoint.y + 50
            && player.sprite.position.y >= transitionPoint.y - 50 {
            return true
        } else {
            return false
        }
    }
    
    
    
    
}
