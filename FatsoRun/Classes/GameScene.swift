//
//  GameScene.swift
//  FatsoRun
//
//  Created by Trygve Sanne Hardersen on 27/02/15.
//  Copyright (c) 2015 HypoBytes Ltd. All rights reserved.
//

import SpriteKit

protocol GameSceneDelegate {
    
    func inviteUser()
    
}

class GameScene: SKScene {
    
    var gameSceneDelegate:GameSceneDelegate?
    
    private var spaceships:Array<SKSpriteNode>! = Array()
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "Fatso Run";
        myLabel.fontSize = 40;
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        
        self.addChild(myLabel)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            
            if (self.spaceships.count == 4) {
                
                self.gameSceneDelegate?.inviteUser()
                
                self.removeChildrenInArray(self.spaceships)
                self.spaceships.removeAll(keepCapacity: false)
                
                continue
            }
            
            let location = touch.locationInNode(self)
            
            let sprite = SKSpriteNode(imageNamed:"Spaceship")
            
            sprite.xScale = 0.5
            sprite.yScale = 0.5
            sprite.position = location
            
            let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
            
            sprite.runAction(SKAction.repeatActionForever(action))
            
            self.addChild(sprite)
            
            // track this event using all trackers
            // flurry
            Flurry.logEvent("spaceship");
            // google analytics
            let tracker = GAI.sharedInstance().defaultTracker
            let event = GAIDictionaryBuilder.createEventWithCategory("spaceship", action: nil, label: nil, value: nil).build()
            GAI.sharedInstance().defaultTracker.send(event)
            // taptream
            let e = TSEvent.eventWithName("spaceship", oneTimeOnly: false) as TSEvent
            TSTapstream.instance().fireEvent(e)
            
            self.spaceships.append(sprite)

        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
