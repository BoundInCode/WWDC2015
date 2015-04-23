//
//  SKNode+Extensions.swift
//  William Cain
//
//  Created by William Cain on 4/21/15.
//  Copyright (c) 2015 Liam Cain. All rights reserved.
//

import SpriteKit

public extension SKNode {
    
    public func tap(tap: UIGestureRecognizer){
        
    }
    
    public func pan(pan: UIPanGestureRecognizer){
        
    }
    
    public func willHandlePan(pan: UIPanGestureRecognizer) -> Bool {
        return false
    }
    
    public func handlesTaps() -> Bool {
        return false
    }
    
    public func handlesPan() -> Bool {
        return false
    }

}