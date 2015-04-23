//
//  MenuSprite.swift
//  William Cain
//
//  Created by Liam Cain on 4/18/15.
//  Copyright (c) 2015 Liam Cain. All rights reserved.
//

import SpriteKit

enum SpriteType {
    case Small
    case Large
}

class MenuSprite: SKSpriteNode {
    
    var selected: Bool
    
    var title: String
    var information: String?
    var positionInSpiral: Int = -1
    var bgColor: SKColor
    
    private var bgSprite: SKSpriteNode
    private var type: SpriteType
    
    init(image:String, type:SpriteType, title: String, color:SKColor){
        
        selected = false
    
        self.title = title
        self.type = type
        
        bgSprite = SKSpriteNode(imageNamed: image)
        bgSprite.texture?.filteringMode = SKTextureFilteringMode.Nearest
        bgSprite.color = color
        bgSprite.size = CGSize(width: 250, height: 250)
        bgColor = color
        
        let texture = SKTexture(imageNamed: "circle")
        super.init(texture: texture, color: UIColor.clearColor(), size: CGSize(width: 240, height: 240))
        
        self.addChild(bgSprite)
        userInteractionEnabled = true
        physicsBody = SKPhysicsBody(circleOfRadius:75.0)
        physicsBody!.affectedByGravity = false;
        physicsBody!.collisionBitMask = 0x00000000
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
//        bgSprite.size = CGSize(width: 150.0, height: 150.0)
//    }
//    
//    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
//        bgSprite.size = CGSize(width: 200.0, height: 200.0)
//        bgSprite.physicsBody?.applyTorque(50.0)
//    }
//    
//    override func touchesCancelled(touches: Set<NSObject>!, withEvent event: UIEvent!) {
//        bgSprite.size = CGSize(width: 200.0, height: 200.0)
//    }
}