//
//  GameScene.swift
//  Tom's Adventure
//
//  Created by 90309776 on 10/2/18.
//  Copyright © 2018 90309776. All rights reserved.
//

import SpriteKit
import GameplayKit

class Level1: GameEngine {
    
    var hasLoaded = false
    
    var currentStage = 1
    var stagesArray: [GameStage] = []
    var stage1 = GameStage(tp: CGPoint(x: -10000, y: -10000), cp: CGPoint(x: 0, y: 0))
    var stage2 = GameStage(tp: CGPoint(x: 330, y: -60), cp: CGPoint(x: 668, y: 0))
    
   
    
    override func sceneDidLoad() {
        stagesArray = [stage1, stage2]
        stage1.spawnPoint = childNode(withName: "spawnPoint1")?.position
        print(stage1.spawnPoint)
        stage2.spawnPoint = childNode(withName: "spawnPoint2")?.position
        print(stage2.spawnPoint)
        spawnPoint = stage1.spawnPoint
        
        hasLoaded = true
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
    }
    
   
    
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        if hasLoaded {
            stageCheck()
        }
        
        
        
    }

    
    func stageCheck() {
        
        if currentStage == 1 && player.sprite.position.x > stage2.transitionPoint.x && stage2.yInRange(player: player){
            //print(player.sprite.position.x)
            currentStage = 2
            spawnPoint = stage2.spawnPoint
            player.camera.position = stage2.cameraPoint
        }
        
        if currentStage == 2 && player.sprite.position.x < stage2.transitionPoint.x {
            currentStage = 1
            spawnPoint = stage1.spawnPoint
            player.camera.position = stage1.cameraPoint
        }
        
    }
    
}



