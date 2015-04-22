//
//  MenuSprite.swift
//  William Cain
//
//  Created by Liam Cain on 4/18/15.
//  Copyright (c) 2015 Liam Cain. All rights reserved.
//

import SpriteKit

class MenuSprite: SKSpriteNode {
    
    var selected: Bool
    private var bgSprite: SKSpriteNode
    
    init(){
        selected = false
        let texture = SKTexture(imageNamed: "circle")
        bgSprite = SKSpriteNode(texture: texture)
        
        super.init(texture: texture, color: UIColor.clearColor(), size: CGSize(width: 10, height: 10))
        
        userInteractionEnabled = true
        physicsBody = SKPhysicsBody(circleOfRadius:75.0)
        physicsBody!.affectedByGravity = false;
        physicsBody!.collisionBitMask = 0x00000000
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        bgSprite.size = CGSize(width: 150.0, height: 150.0)
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        bgSprite.size = CGSize(width: 200.0, height: 200.0)
        bgSprite.physicsBody?.applyTorque(50.0)
    }
    
    override func touchesCancelled(touches: Set<NSObject>!, withEvent event: UIEvent!) {
        bgSprite.size = CGSize(width: 200.0, height: 200.0)
    }
}