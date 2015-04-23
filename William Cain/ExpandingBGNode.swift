//
//  ExpandingBGNode.swift
//  William Cain
//
//  Created by William Cain on 4/22/15.
//  Copyright (c) 2015 Liam Cain. All rights reserved.
//

import SpriteKit

class ExpandingBGNode: SKSpriteNode {
    
    var expanded: Bool = false
    private let distance: CGFloat = 1000.0
    private let duration = 1.2
    private let scaleMax: CGFloat = 8.0
    private var homePosition: CGPoint?
    
    init(){
        let texture = SKTexture(imageNamed: "circle")
        super.init(texture: texture, color: UIColor.clearColor(), size: CGSize(width: 250, height: 250))
    }

    required init?(coder aDecoder: NSCoder) {
        let texture = SKTexture(imageNamed: "circle")
        super.init(texture: texture, color: UIColor.clearColor(), size: CGSize(width: 250, height: 250))
    }
    
    override func setScale(scale: CGFloat) {
        if !expanded {
            super.setScale(scale)
        }
    }
    
    func expand(){
        var duration = self.duration
        
        if actionForKey("expand") != nil {
            return
        } else if actionForKey("shrink") != nil {
            removeAllActions()
            duration = duration/2
        }
        
        homePosition = position
        expanded = true
        hidden = false
        
        let expandAction = SKAction.scaleTo(scaleMax, duration: duration)
//        let expandAction = SKAction.group([SKAction.scaleTo(scaleMax, duration: duration),
//                                           SKAction.moveByX(0, y:-homePosition!.y-distance, duration: duration/2)])
        runAction(expandAction, withKey: "expand")
    }
    
    func shrink(){
        var duration = self.duration
        
        if actionForKey("shrink") != nil {
            return
        } else if actionForKey("expand") != nil {
            removeAllActions()
            duration = duration/2
        }
        
        let shrinkAction = SKAction.scaleTo(0.3, duration: duration)
//        let shrinkAction = SKAction.group([SKAction.scaleTo(0.3, duration: duration),
//                                           SKAction.moveTo(homePosition!, duration: duration/2)])
        
        runAction(SKAction.sequence([shrinkAction, SKAction.runBlock({ () -> Void in
            self.expanded = false
            self.hidden = true
        })]), withKey:"shrink")
    }

}
