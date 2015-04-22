//
//  GameScene.swift
//  William Cain
//
//  Created by Liam Cain on 4/18/15.
//  Copyright (c) 2015 Liam Cain. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, UIGestureRecognizerDelegate {
    
    var spiral: SpiralNode?
    var tappedNode: MenuSprite?
    var selectedNode: MenuSprite?
    var isTouching: Bool
    var isTransitioning: Bool
    
    var previousTouchAngle: CGFloat
    
    var rotation: Double
    var absoluteRotation: Double
    var prevRotation: Double
    var numRevolutions: Int
    
    var breathe: Double
    
    var touchPos: CGPoint?
    var totalTouchAngle: Double
    var startingRotationForTouch: Double
    
    let ANGLE_BASE: Double = 20000.0 * M_PI * 2.0
    let ARC_LEN: Double = M_PI / 6.0
    
    override init(){
        isTouching = false
        selectedNode = nil
        spiral = nil
        absoluteRotation = 0;//8 * 2.f * M_PI;
        prevRotation = 0.0
        numRevolutions = 0//8;
        breathe = 0.0
        numRevolutions = 0
        previousTouchAngle = 0.0
        prevRotation = 0.0
        rotation = 0.0
        touchPos = nil
        totalTouchAngle = 0.0
        startingRotationForTouch = 0.0
        
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        isTouching = false
        selectedNode = nil
        spiral = nil
        absoluteRotation = 0;//8 * 2.f * M_PI;
        prevRotation = 0.0
        numRevolutions = 0//8;
        breathe = 0.0
        numRevolutions = 0
        previousTouchAngle = 0.0
        prevRotation = 0.0
        rotation = 0.0
        touchPos = nil
        totalTouchAngle = 0.0
        startingRotationForTouch = 0.0
        super.init(coder: aDecoder)
    }
    
    override func didMoveToView(view: SKView) {
        setupPanGestureRecognizer()
        setupTapGestureRecognizer()
        
        
        backgroundColor = SKColor(red: 1, green: 1, blue: 1, alpha: 1)
        
        spiral = SpiralNode()
//        spiral!.position = CGPoint(x: 0, y: CGRectGetMidY(frame))
        spiral!.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMidY(frame))
        addChild(spiral!)
        
        absoluteRotation = 0;//8 * 2.f * M_PI;
        prevRotation = 0.0
        numRevolutions = 0//8;
        breathe = 0.0
        
        self.userInteractionEnabled = true
    }
    
    func setupTapGestureRecognizer() {
        var tap: UITapGestureRecognizer = UITapGestureRecognizer()
        tap.addTarget(self, action: "handleTapGesture:")
        self.scene!.view?.addGestureRecognizer(tap)
    }
    
    func setupPanGestureRecognizer(){
        var tap: UIPanGestureRecognizer = UIPanGestureRecognizer()
        tap.addTarget(self, action: "handlePanGesture:")
        self.scene!.view?.addGestureRecognizer(tap)
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        isTouching = true;
        
        let firstTouch: UITouch? = touches.first as? UITouch
        touchPos = firstTouch!.locationInView(self.view)
        let touchPolarCoord: CGPoint = polarCoordinate(touchPos!)
        
        // Check for Tap
        let tapPos: CGPoint = firstTouch!.locationInNode(spiral!)
        let tappedNode = spiral!.nodeAtPoint(tapPos)
        if (tappedNode.isKindOfClass(MenuSprite) && tappedNode.alpha > 0.75){
            selectedNode = tappedNode as? MenuSprite
            selectedNode!.selected = true
            startingRotationForTouch = round(absoluteRotation / ARC_LEN) * ARC_LEN + ANGLE_BASE
        } else {
            startingRotationForTouch = absoluteRotation + ANGLE_BASE
        }
        totalTouchAngle = ANGLE_BASE
        previousTouchAngle = touchPolarCoord.y;
        spiral!.physicsBody!.angularDamping = 1.0;
    }
    
    func radiansToDegrees(rads: Double) -> Double {
        return rads * 180.0 / M_PI
    }
    
    func polarCoordinate(vec: CGPoint) -> CGPoint {
        let flippedVec: CGPoint = CGPoint(x: vec.x, y: view!.frame.size.height - vec.y)
        let center = CGPoint(x: CGRectGetMidY(view!.frame), y:CGRectGetMidY(view!.frame))
        let diff = flippedVec - center
        return CGPoint(x:flippedVec.distanceTo(center), y: -atan2(diff.y, diff.x))
    }
   
    func spin() {
        var y = 0.0
        var x = 0.0
        var r = 0.1
        var s = r
        var theta: Double = 0.0
    
    if (isTouching) {
        let targetRotation = startingRotationForTouch - totalTouchAngle - 2.0 * ANGLE_BASE
    
        var angleDiff: Double =  targetRotation - absoluteRotation - M_PI/2.0
        while (angleDiff <= -M_PI){ angleDiff = M_PI*2.0 + angleDiff }
        while (angleDiff >=  M_PI){ angleDiff = M_PI*2.0 - angleDiff }
    
        if(selectedNode != nil){
            angleDiff = angleDiff * 0.01
        }
        let finalTorque: CGFloat = CGFloat(angleDiff * 350.0)
        spiral!.physicsBody?.applyTorque(finalTorque)
    } else {
        let newRotation = radiansToDegrees(absoluteRotation) + 15.0
        var angleDiff = newRotation - round(newRotation / 30.0) * 30.0;
        
        if(abs(spiral!.physicsBody!.angularVelocity) < 0.28 && abs(angleDiff) > 14.7){
            spiral!.physicsBody!.angularVelocity = 0.0
        } else {
            let finalTorque = CGFloat(angleDiff * 5.0)
            spiral!.physicsBody!.angularDamping += 0.009
            spiral!.physicsBody!.applyTorque(CGFloat(angleDiff * 5.0))
        }
    }
    
    for child in spiral!.children as! [MenuSprite] {
        let tempBreathe: Double = absoluteRotation + theta + 2.0 * M_PI
        r = 0.4 * tempBreathe + 0.1 - breathe
        if(r < 0){
            r = 0
        }
        
        s = (r * 0.12) * 1.1 * 100.0
    
        x = r * cos(theta) * 40.0
        y = r * sin(theta) * 40.0
    
        child.position = CGPoint(x: x, y: y)
        child.size = CGSize(width: s, height: s)
        child.alpha = CGFloat(r * 0.05 + 0.05)
    
        
        let relativeDist = abs(CGRectGetMidX(self.frame) - spiral!.convertPoint(child.position, fromNode:self.scene!).x) * 0.01
//        child.zPosition = 10 - relativeDist
    
        var relativeVel: Double = abs(Double(spiral!.physicsBody!.angularVelocity)) / 5.0
        relativeVel = min(1.0, relativeVel)
    
        var maxScale = s + (500.0 - s) * (1.0 - relativeVel)
        maxScale = max(s, maxScale)
        maxScale = min(200.0, maxScale)
    
//        if(theta+absoluteRotation > 1.2) && (theta + absoluteRotation < 1.9){
////            var maxOpacity = 1.0 - relativeVel
////            var opacity = maxOpacity - relativeDist;
////            opacity = max(opacity, 0.2)
////            child.alpha = opacity
//    
//            var childScale = CGFloat(maxScale) - relativeDist * 300.0
//            childScale = max(CGFloat(s), childScale)
//    
//            if(child.selected){
//                child.size = CGSizeMake(180.0, 180.0)
//            } else {
//                child.size = CGSizeMake(childScale, childScale)
//            }
//        }
        child.userInteractionEnabled = child.alpha > 0.9
        theta += ARC_LEN
        }
    }

    func handleTapGesture(tap: UITouch) {
        for node in nodesAtPoint(tap.locationInNode(self)) {
            if node.handlesTaps {
                node.tap(tap)
                return
            }
        }
    }
    
    func tap(tap: UITouch) {
        var p = tap.locationInNode(spiral)
        tappedNode = closestLevelToPoint(p)
        
        if tappedNode != nil {
            isTransitioning = true
            spiral!.physicsBody?.angularDamping = 0.0
        }
    }
    
    func closestLevelToPoint(p: CGPoint) -> MenuSprite? {
        var closest: MenuSprite? = nil
        var distance: CGFloat = 9999.0
        var closestDistance: CGFloat = 9999.0
        
        for menuItem in spiral!.children {
            distance = menuItem.position.distanceTo(p)
            if distance < closestDistance {
                closest = menuItem as? MenuSprite
                closestDistance = distance
            }
        }
        return closest
        }
    }


    func pan(pan: UIPanGestureRecognizer){
        var p = pan.locationInView()
        if pan.state == UIGestureRecognizerState.Began {
            panBeganAtPoint(p)
        } else if pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateFailed {
            panEndedAtPoint(p)
        } else {
            panMovedToPoint(p)
        }
    }
    
    func panBeganAtPoint(p: CGPoint) {
        isTouching = true
    
        let touchPolarCoord = polarCoordinate(p)

        startingRotationForTouch = absoluteRotation + ANGLE_BASE
        totalTouchAngle = ANGLE_BASE
        previousTouchAngle = touchPolarCoord.y
        spiral!.physicsBody?.angularDamping = 1.0
    }
    
    
    -(void)panMovedToPoint:(CGPoint)p {
    touchPos = p;
    CGPoint touchPolarCoord = [self polarCoordinate:touchPos];
    
    if(ABS(totalTouchAngle - ANGLE_BASE) > 0.01f){
    _tappedNode = nil;
    tappedLevelNum = -1;
    }
    if(CGPointDistance(p, CGPointMake(384.f, 512.f)) > 60.f){
    [_spiral runAction:[SKAction rotateByAngle: previousTouchAngle-touchPolarCoord.y duration:0.001f]];
    }
    endingVelocity = previousTouchAngle-touchPolarCoord.y;
    totalTouchAngle += touchPolarCoord.y - previousTouchAngle;
    previousTouchAngle = touchPolarCoord.y;
    
    //testing -----
    float targetRotation = startingRotationForTouch - totalTouchAngle - 2.0f*ANGLE_BASE;
    float angleDiff =  targetRotation - absoluteRotation;// - M_PI/2;
    
    
    while (angleDiff <= -M_PI) angleDiff += M_PI*2.0f;
    while (angleDiff >=  M_PI) angleDiff -= M_PI*2.0f;
    
    
    //    [_spiral.physicsBody applyTorque: angleDiff * 300.0f];
    //end testing -----
    }
    
    -(void)panEndedAtPoint:(CGPoint)p {
    isTouching = false;
    _spiral.physicsBody.angularDamping = 0.3f;
    [_spiral removeAllActions];
    [_spiral.physicsBody applyTorque:endingVelocity*200.f];
    }



    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        /* Called before each frame is rendered */
        
        if (prevRotation < -M_PI_2) && (spiral!.zRotation > CGFloat(M_PI_2)) {
            numRevolutions--
        } else if(prevRotation > M_PI/2.0) && (spiral!.zRotation < CGFloat(-M_PI/2.0)) {
            numRevolutions++
        }
        
        if(!isTouching){
            //        breathe = powf(.5*(sinf(currentTime*2.0f)+.5f), 2);
//            var maxBreathe = 0.5f - abs(spiral.physicsBody.angularVelocity * 0.1f)
//            maxBreathe = max(0.01f, maxBreathe)
//            breathe = (.37f * cosf(M_PI / 2 * currentTime) + .45f) * maxBreathe
        } else {
//            breathe -= spiral.physicsBody.angularVelocity * 0.01f
        }
        
        let oneRev: Double = 2.0 * M_PI
        absoluteRotation = Double(numRevolutions) * oneRev + Double(spiral!.zRotation)
        prevRotation = Double(spiral!.zRotation)
        spin()
    }
}
