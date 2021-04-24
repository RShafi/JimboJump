//
//  Grass.swift
//  TonesOfMisery
//
//  Created by Ramsey Shafi on 5/30/16.
//  Copyright © 2016 Apportable. All rights reserved.
//

import Foundation

class Grass1: CCNode, CCPhysicsCollisionDelegate {
    weak var obstacle : CCNode!
    weak var hitPart: CCNode!
    let obstacleMinimumPositionY : CGFloat = 150
    let obstacleMaximumPositionY : CGFloat = 200
    let obstacleDistance : CGFloat = 110
    
    func setupRandomPosition() {
        let randomPrecision : UInt32 = 100
        let range = obstacleMaximumPositionY - obstacleDistance - obstacleMinimumPositionY
        let random = CGFloat(arc4random_uniform(randomPrecision)) / CGFloat(randomPrecision)
        obstacle.position = ccp(obstacle.position.x, obstacleMinimumPositionY + (random * range));
    }
    
    func didLoadFromCCB() {
        obstacle.physicsBody.collisionType = "grassLand"
    }
}
