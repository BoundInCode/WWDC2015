//
//  SpiralNode.swift
//  William Cain
//
//  Created by Liam Cain on 4/18/15.
//  Copyright (c) 2015 Liam Cain. All rights reserved.
//

import Foundation
import SpriteKit

class SpiralNode: SKNode {
    
    override init(){
        super.init()
        
        for var i = 0; i < 10; ++i {
            
            let menuItem = MenuSprite()
            addChild(menuItem)
//            menuItem.size = CGSize(width: 10.0, height: 10.0)
        }
        
        physicsBody = SKPhysicsBody(circleOfRadius: 100.0, center:CGPoint(x: 0,y: 0))
        physicsBody!.affectedByGravity = false;
        physicsBody!.collisionBitMask = 0x00000000;
        physicsBody!.allowsRotation = true;
        physicsBody!.mass = 120.0;
        //        self.userInteractionEnabled = YES;
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}