//
//  GamePlay.swift
//  TonesOfMisery
//
//  Created by Ramsey Shafi on 5/30/16.
//  Copyright © 2016 Apportable. All rights reserved.
//

import Foundation
import UIKit

class GamePlay: CCNode, CCPhysicsCollisionDelegate {
    weak var character: CCSprite!
    weak var gamePhysicsNode : CCPhysicsNode!
    weak var deathGround: CCNode!
    weak var deathGround2: CCNode!
    weak var scoreLabel: CCLabelTTF!
    weak var gameOverScore: CCLabelTTF!
    weak var scoreString: CCLabelTTF!
    weak var gameOverLabel: CCLabelTTF!
    weak var restartButton: CCButton!
    weak var quitButton: CCButton!
    weak var pauseNode: CCNode!
    weak var pauseButton: CCButton!
    weak var highScore: CCLabelTTF!
    weak var highScoreLabel: CCLabelTTF!
    weak var newHighScore: CCLabelTTF!
    weak var restartIcon: CCNode!
    weak var quitIcon: CCNode!
    weak var numberCoin: CCLabelTTF!
    weak var coinLabel: CCLabelTTF!
 //   weak var coin: CCSprite!
    var coinCurrency: Int = UserDefaults.standard.integer(forKey: "myCoins") {
        didSet {
            UserDefaults.standard.set(coinCurrency, forKey: "myCoins")
            UserDefaults.standard.synchronize()
            coinLabel.string = "\(coinCurrency)"
        }
    }
    var scrollSpeed : CGFloat = 160
    var platCount: Int = 0
    var grass : [CCNode] = []
    var grounds = [CCNode]()
    var sinceTouch: CCTime = 0
    var gameOverCount: Int = UserDefaults.standard.integer(forKey: "myAds") {
        didSet {
            UserDefaults.standard.set(gameOverCount, forKey:"myAds")
            UserDefaults.standard.synchronize()
        }
    }
    var gameOver = false
    var isGround = false
    let firstGrassPosition : CGFloat = 20
    let distanceBetweenGrass : CGFloat = 180
    var score : Int = 0 {
        didSet {
            scoreLabel.string = "\(score)"
            gameOverScore.string = "\(score)"
        }
    }
    var highscore: Int = UserDefaults.standard.integer(forKey: "myHighScore")  {
        didSet {
            UserDefaults.standard.set(highscore, forKey:"myHighScore")
            UserDefaults.standard.synchronize()
        }
    }
    
    func didLoadFromCCB() {
        isUserInteractionEnabled = true
        for _ in 0...2 {
            spawnNewGrass2()
        }
        grounds.append(deathGround)
        grounds.append(deathGround2)
        gamePhysicsNode.collisionDelegate = self
        deathGround.physicsBody.collisionType = "grassHit"
//        coin.physicsBody.sensor = true
    }
    
    /*override toucheBegan*/ func touchesBegan(touch: CCTouch!, withEvent: CCTouchEvent!) {
        if isGround == true {
            if gameOver == false {
                character.physicsBody.applyImpulse(ccp(0,250))
                isGround = false
                character.animationManager.runAnimations(forSequenceNamed: "Jump")
            }
        }
    }
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, characterHit: CCNode!, grassHit: CCNode!) -> ObjCBool {
        triggerGameOver()
        return true
    }
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, characterHit: CCNode!, grassLand: CCNode!) -> ObjCBool {
        if isGround == false {
            isGround = true
            character.animationManager.runAnimations(forSequenceNamed: "Default Timeline")
        }
        return true
    }

    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, characterHit: CCNode!, coinGrab: CCNode!) -> ObjCBool {
        coinCurrency += 1
  //      coin.visible = false
        return true
}

    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, characterHit: CCNode!, noGround: CCNode!) -> Bool {
        isGround = false
        return true
    }
    
    func pauseGame() {
        CCDirector.shared().pause()
        pauseNode.visible = true
    }
    
    func quit() {
        let quitScene = CCBReader.load(asScene: "MainScene")
        CCDirector.shared().present(quitScene)
    }
    
    func spawnNewGrass() {
        var prevGrassPos = firstGrassPosition
        if grass.count > 0 {
            prevGrassPos = grass.last!.position.x
        }
        // create and add a new grass
        let newGrass = CCBReader.load("Grass") as! Grass1
        newGrass.position = ccp(prevGrassPos + distanceBetweenGrass + 50, 120)
        newGrass.setupRandomPosition()
        gamePhysicsNode.addChild(newGrass)
        grass.append(newGrass)
    }
    
    func spawnNewGrass2() {
        var prevGrassPos = firstGrassPosition
        if grass.count > 0 {
            prevGrassPos = grass.last!.position.x
        }
        // create and add a new grass
        let newGrass = CCBReader.load("Grass2") as! Grass2
        newGrass.position = ccp(prevGrassPos + distanceBetweenGrass + 50, 120)
        newGrass.setupRandomPosition()
        gamePhysicsNode.addChild(newGrass)
        grass.append(newGrass)
    }
    
    func spawnNewGrass3() {
        var prevGrassPos = firstGrassPosition
        if grass.count > 0 {
            prevGrassPos = grass.last!.position.x
        }
        // create and add a new grass
        let newGrass = CCBReader.load("Grass3") as! Grass3
        newGrass.position = ccp(prevGrassPos + distanceBetweenGrass + 100, 120)
        newGrass.setupRandomPosition()
        gamePhysicsNode.addChild(newGrass)
        grass.append(newGrass)
    }
    
   // func spawnCoin() {
  //      coin.visible = true
  //  }
    func restart() {
        let scene = CCBReader.load(asScene: "GamePlay")
        CCDirector.shared().present(scene)
    }
    
    override func update(_ delta: CCTime) {
        //Now you need to use that variable to manipulate the scroll speed of your character!
       character.position = ccp(character.position.x + scrollSpeed * CGFloat(delta), character.position.y)
       gamePhysicsNode.position = ccp(gamePhysicsNode.position.x - scrollSpeed * CGFloat(delta), gamePhysicsNode.position.y)
        
        let velocityY = clampf(Float(character.physicsBody.velocity.y), -Float(CGFloat.greatestFiniteMagnitude), 200)
        character.physicsBody.velocity = ccp(0, CGFloat(velocityY))
        
        for obstacle in Array(grass.reversed()) {
            let obstacleWorldPosition = gamePhysicsNode.convert(toWorldSpace: obstacle.position)
            let obstacleScreenPosition = convert(toNodeSpace: obstacleWorldPosition)
            
            // obstacle moved past left side of screen?
            if obstacleScreenPosition.x < (-obstacle.contentSize.width) {
                obstacle.removeFromParent()
                grass.remove(at: grass.index(of: obstacle)!)
                
                // for each removed obstacle, add a new one
                spawnNewGrass2()
                scrollSpeed = scrollSpeed + 1.5
                score = score + 1
                platCount += 1
                print("platCount ", platCount)
                if platCount == 5 {
      //              spawnCoin()
                }
            }
        }
        for ground in grounds {
            let groundWorldPosition = gamePhysicsNode.convert(toWorldSpace: ground.position)
            let groundScreenPosition = convert(toNodeSpace: groundWorldPosition)
            if groundScreenPosition.x <= (-ground.contentSize.width) {
                ground.position = ccp(ground.position.x + ground.contentSize.width * 2, ground.position.y)
            }
        }
        
        
        if scrollSpeed > 200 {
            gamePhysicsNode.gravity.y = -450
        }
        
        if scrollSpeed > 250 {
            gamePhysicsNode.gravity.y = -550
        }
        
      //  if score % 10 == 0 {
      //      Grass2().grassCoin.visible = true
    //    }
    }
    
    func triggerGameOver() {
        if gameOver == false {
            gameOver = true
            scoreString.visible = true
            gameOverScore.visible = true
            gameOverLabel.visible = true
            scoreLabel.visible = false
            pauseButton.visible = false
            restartButton.visible = true
            quitButton.visible = true
            highScore.visible = true
            highScoreLabel.visible = true
            quitIcon.visible = true
            restartIcon.visible = true
            character.animationManager.runAnimations(forSequenceNamed: "Dead")
            character.stopAllActions()
            scrollSpeed = 0
            if score > highscore {
                highscore = score
                newHighScore.visible = true
                print(highscore)
            }
            highScoreLabel.string = "\(highscore)"
            let move = CCActionEaseBounceOut(action: CCActionMoveBy(duration: 0.2, position: ccp(0, 4)))
            let moveBack = CCActionEaseBounceOut(action: move?.reverse())
            let shakeSequence = CCActionSequence(array: [move!, moveBack])
            run(shakeSequence)
            gameOverCount += 1
           /* if gameOverCount == 3 {
                 Chartboost.showInterstitial(CBLocationGameOver)
                 gameOverCount -= gameOverCount
            }*/
            print(gameOverCount)
        }
    }
   
}

