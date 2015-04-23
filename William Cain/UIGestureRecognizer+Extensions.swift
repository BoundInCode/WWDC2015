//
//  UIGestureRecognizer+Extensions.swift
//  William Cain
//
//  Created by William Cain on 4/22/15.
//  Copyright (c) 2015 Liam Cain. All rights reserved.
//

import SpriteKit

public extension UIGestureRecognizer {

    public func locationInNode(node: SKNode) -> CGPoint {
        var scenePoint: CGPoint = node.scene!.convertPointFromView(self.locationInView(node.scene!.view!))
        return node.convertPoint(scenePoint, fromNode: node.scene!)
    }

    
    public func locationOfTouch(touch: UITouch, inNode:SKNode) -> CGPoint {
        return touch.locationInNode(inNode)
    }
}

public extension UIPanGestureRecognizer {
    public func translationInNode(node: SKNode) -> CGPoint {
        var p: CGPoint = translationInView(node.scene!.view!)
        p.y = -p.y
        return p
    }
    
    public func velocityInNode(node: SKNode) -> CGPoint {
        var p: CGPoint = velocityInView(node.scene!.view!)
        p.y = -p.y
        return p
    }
}
