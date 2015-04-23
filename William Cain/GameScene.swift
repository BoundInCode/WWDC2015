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
    var isTouching: Bool = false
    var isTransitioning: Bool = false
    var isOutOfBounds = false
    
    var previousTouchAngle: CGFloat
    
    var absoluteRotation: Double
    var prevRotation: CGFloat = CGFloat(0.0)
    var numRevolutions: Int
    
    var touchPos: CGPoint?
    var totalTouchAngle: CGFloat
    var startingRotationForTouch: CGFloat
    var endingVelocity: CGFloat = CGFloat(0.0)
    var tappedPosition: Int?
    
    let ANGLE_BASE: CGFloat = CGFloat(20000.0 * M_PI * 2.0)
    let ARC_LEN: Double = M_PI / 6.0
    
    var cropNode: SKCropNode?
    var expandingBGNode: ExpandingBGNode?
    var titleNode: DSMultilineLabelNode?
    var descriptionNode: DSMultilineLabelNode?
    
    weak var currentPanHandler: SKNode?
    
    override init(){
        isTouching = false
        selectedNode = nil
        spiral = nil
//        absoluteRotation = 0;//8 * 2.f * M_PI;
        absoluteRotation = 0
        numRevolutions = 0//8;
        numRevolutions = 0
        previousTouchAngle = 0.0
        touchPos = nil
        totalTouchAngle = 0.0
        startingRotationForTouch = 0.0
        
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        isTouching = false
        selectedNode = nil
        spiral = nil
        absoluteRotation = ARC_LEN * 3
        numRevolutions = 0
        numRevolutions = 0
        previousTouchAngle = 0.0
        touchPos = nil
        totalTouchAngle = 0.0
        startingRotationForTouch = 0.0
        super.init(coder: aDecoder)
    }
    
    override func willHandlePan(pan: UIPanGestureRecognizer) -> Bool {
        return true
    }
    
    override func handlesTaps() -> Bool {
        return true
    }
    
    override func didMoveToView(view: SKView) {
        setupPanGestureRecognizer()
        setupTapGestureRecognizer()
        
        backgroundColor = SKColor(red: 1, green: 1, blue: 1, alpha: 1)
        
        spiral = SpiralNode()
        spiral!.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMidY(frame))
        addChild(spiral!)
        
        cropNode = SKCropNode()
        cropNode!.zPosition = 2000
        addChild(cropNode!)
        
        expandingBGNode = ExpandingBGNode()
        expandingBGNode?.hidden = true
        expandingBGNode?.zPosition = 1000
        let center = CGPoint(x: CGRectGetMidX(frame), y:CGRectGetMidY(frame))
        expandingBGNode?.position = center
        expandingBGNode?.colorBlendFactor = 1
        cropNode!.maskNode = expandingBGNode!
        cropNode!.addChild(expandingBGNode!)
        
        titleNode = DSMultilineLabelNode(fontNamed: "Helvetica")
        titleNode!.text = "Hello"
        titleNode!.paragraphWidth = view.frame.width * 1.0
        titleNode!.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        titleNode!.anchorPoint = CGPoint(x:0,y:1)
        titleNode!.fontSize = 48
        titleNode!.zPosition = 2000
        titleNode!.fontColor = SKColor.whiteColor()
        titleNode!.hidden = true
        titleNode!.position = CGPointMake(center.x, self.frame.height * 0.91)
        
        cropNode!.addChild(titleNode!)
        
        descriptionNode = DSMultilineLabelNode(fontNamed: "Helvetica")
        descriptionNode!.text = "Hello"
        descriptionNode!.paragraphWidth = view.frame.width * 1.1
        descriptionNode!.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        descriptionNode!.fontSize = 26
        descriptionNode!.zPosition = 2000
        descriptionNode!.fontColor = SKColor.whiteColor()
        descriptionNode!.hidden = true
        descriptionNode!.anchorPoint = CGPoint(x:0,y:1)
        descriptionNode!.position = CGPointMake(center.x, self.frame.height * 0.38)
        
        cropNode!.addChild(descriptionNode!)
        
        spiral!.zRotation = CGFloat(M_PI * 2 * -2.32)
        absoluteRotation = M_PI * 2 * -2.32
        prevRotation = CGFloat(absoluteRotation)
        numRevolutions = -2
        isOutOfBounds = true
        
        for g in view.gestureRecognizers! {
            (g as! UIGestureRecognizer).enabled = false
        }
        
        self.runAction(SKAction.sequence([SKAction.waitForDuration(5.0), SKAction.runBlock({ () -> Void in
            for g in view.gestureRecognizers! {
                (g as! UIGestureRecognizer).enabled = true
            }
            self.titleNode!.hidden = false
        })]))
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
    
    func radiansToDegrees(rads: CGFloat) -> CGFloat {
        return rads * CGFloat(180.0 / M_PI)
    }
    
    func polarCoordinate(vec: CGPoint) -> CGPoint {
        let flippedVec: CGPoint = CGPoint(x: vec.x, y: view!.frame.size.height - vec.y)
        let center = CGPoint(x: CGRectGetMidX(view!.frame), y:CGRectGetMidY(view!.frame))
        let diff = flippedVec - center
        return CGPoint(x:flippedVec.distanceTo(center), y: -atan2(diff.y, diff.x))
    }
   
    func spin() {
        var y = 0.0
        var x = 0.0
        var r = 0.1
        var s = r
        var theta: Double = 0//M_PI / 2.0
        
        if isTransitioning || isOutOfBounds || isTouching {
            
        } else {
            var currentRotation: CGFloat
            var angleDiff: CGFloat
            
            if tappedNode != nil {
                let destinationRadians = Double(tappedPosition!-3) * ARC_LEN
                var destinationAngle = -radiansToDegrees(CGFloat(destinationRadians))
                currentRotation = radiansToDegrees(CGFloat(absoluteRotation))
                
//                NSLog("\(tappedPosition)       \(destinationAngle)           \(currentRotation)")
                angleDiff = (destinationAngle - currentRotation) * 10.0
                
                let isSlow: Bool = abs(spiral!.physicsBody!.angularVelocity) < 0.3
                let isClose: Bool = abs(angleDiff) < CGFloat(3.0)

                if  isClose && isSlow {
                    tappedNode = nil
                    tappedPosition = nil
                }
                if abs(angleDiff) < 40.0 {
                    spiral!.physicsBody?.angularDamping += 0.0142 * abs(spiral!.physicsBody!.angularVelocity)
                }
            } else {
                currentRotation = radiansToDegrees(CGFloat(absoluteRotation)) + CGFloat(15.0)
                angleDiff = currentRotation - round(currentRotation / 30.0) * 30.0
            }
            
            if(abs(spiral!.physicsBody!.angularVelocity) < 0.28 && tappedNode == nil && abs(angleDiff) > 14.7){
                spiral!.physicsBody!.angularVelocity = 0.0
            } else {
                spiral!.physicsBody?.angularDamping += 0.02
                if abs(spiral!.physicsBody!.angularVelocity) < 0.8 {
                    spiral!.physicsBody?.applyTorque(angleDiff * CGFloat(10.0))
                }
            }
        }
        
        for child in spiral!.children as! [MenuSprite] {
            child.hidden = (child.size.width <= 0.0)
            
            theta = ARC_LEN * Double(child.positionInSpiral)
            
            let oneRev = 2.0 * M_PI
//            r = 0.8 * (absoluteRotation + theta + oneRev) + 0.1
            r = 0.8 * (absoluteRotation + theta + oneRev) + 0.1
            if(r < 0){
                r = 0
            }
            
            var scaleCoefficient = 0.03
            var positionCoefficient = 25.0
            
            s = r * 20.0
            
            x = r * cos(theta) * positionCoefficient
            y = r * sin(theta) * positionCoefficient
        
            child.position = CGPoint(x: x, y: y)
            child.setScale(CGFloat(r*scaleCoefficient))
            child.alpha = CGFloat(r * 0.05 + 0.05)
            
            if tappedNode != nil && child == tappedNode {
                child.alpha += 0.1
            }
            
            let relativeDist = abs(CGRectGetMidX(self.frame) - spiral!.convertPoint(child.position, toNode:self.scene!).x) * 0.01
            child.zRotation = -spiral!.zRotation
            child.zPosition = 1
        
            var relativeVel: Double = abs(Double(spiral!.physicsBody!.angularVelocity)) / 5.0
            relativeVel = min(1.0, relativeVel)
        
            var maxScale = s + (500.0 - s) * (1.0 - relativeVel)
            maxScale = max(s, maxScale)
            maxScale = min(200.0, maxScale)
        
            if(theta+absoluteRotation > 1.2) && (theta + absoluteRotation < 1.9){
                if tappedNode == nil {
                    selectedNode = child
                    expandingBGNode?.color = selectedNode!.bgColor
//                    expandingBGNode?.hidden = false
                }
                var maxOpacity: CGFloat = CGFloat(1.0 - relativeVel)
                var opacity = maxOpacity - relativeDist
                opacity = max(opacity, 0.8)
                child.alpha = opacity
                child.zPosition = 1000 - relativeDist
        
                var childScale = CGFloat(maxScale) - relativeDist * 300.0
                childScale = max(CGFloat(s), childScale)
        
                
                child.setScale(childScale * CGFloat(0.0025))
                
//                if(child == selectedNode){
//                    child.setScale(CGFloat(0.7))
//                }
            }
        }
        if selectedNode != nil {
            cropNode?.zPosition = selectedNode!.zPosition - 1
            expandingBGNode?.setScale(selectedNode!.xScale)
            expandingBGNode?.position = convertPoint(selectedNode!.position, fromNode: spiral!)
        }
    }
    
    override func nodesAtPoint(p: CGPoint) -> [AnyObject] {
        var nodes = super.nodesAtPoint(p)
        nodes.append(self)
        return nodes
    }

    func handleTapGesture(tap: UIGestureRecognizer) {
        let nodes: [AnyObject] = nodesAtPoint(tap.locationInNode(self))
        for node in nodes {
            let n = node as! SKNode
            if n.handlesTaps() {
                n.tap(tap)
                return
            }
        }
        self.tap(tap)
    }
    
    func handlePanGesture(pan: UIPanGestureRecognizer) {
        if (pan.state == UIGestureRecognizerState.Began) {
            currentPanHandler = self
//            var touchLocation: CGPoint = pan.locationInNode(self)
    
            // adjust touch location for initial movement
//            var velocity: CGPoint = pan.velocityInNode(self)
//            touchLocation = CGPointMake(touchLocation.x - velocity.x*0.05, touchLocation.y - velocity.y*0.05)
            
            let nodes: [AnyObject] = nodesAtPoint(pan.locationInNode(self))
            for node in nodes {
                let n = node as! SKNode
                if (n.willHandlePan(pan)) {
                    currentPanHandler = n
                    n.pan(pan)
                    return
                }
            }
            
        } else if currentPanHandler != nil {
            currentPanHandler!.pan(pan)
            if (pan.state == UIGestureRecognizerState.Ended || pan.state == UIGestureRecognizerState.Cancelled) {
                currentPanHandler = nil
            }
        }
    }
    
    override func tap(tap: UIGestureRecognizer) {
        if expandingBGNode!.expanded {
            expandingBGNode?.shrink()
//            descriptionNode!.hidden = true
            return
        }
        
        var p = tap.locationInNode(spiral!)
        tappedNode = closestItemToPoint(p)
        tappedPosition = tappedNode?.positionInSpiral
        NSLog("\(tappedNode)  \n\n    \(selectedNode) ")
        if selectedNode != nil && tappedNode != nil && tappedNode! == selectedNode! {
            expandingBGNode?.expand()
            selectedNode?.alpha = 1.0
            titleNode!.text = selectedNode!.title
            titleNode?.hidden = false
            
            descriptionNode!.text = selectedNode!.information
            descriptionNode!.hidden = false
//            isTransitioning = true
//            spiral!.physicsBody?.angularDamping = 0.0
//            if tappedNode == selectedNode {
//                selectedNode!.selected = true
//                isTransitioning = true
//            } else {
//                selectedNode = tappedNode
//            }
        }
    }
    
    func closestItemToPoint(p: CGPoint) -> MenuSprite? {
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

    override func pan(pan: UIPanGestureRecognizer){
        if expandingBGNode!.expanded {
            expandingBGNode?.shrink()
//            descriptionNode!.hidden = true
            return
        }
        
        var p = pan.locationInView(self.view)
        if pan.state == UIGestureRecognizerState.Began {
            panBeganAtPoint(p)
        } else if pan.state == UIGestureRecognizerState.Ended || pan.state == UIGestureRecognizerState.Failed {
            panEndedAtPoint(p)
        } else {
            panMovedToPoint(p)
        }
    }

    func panBeganAtPoint(p: CGPoint) {
        isTouching = true
        touchPos = p
        
        let touchPolarCoord = polarCoordinate(p)

        startingRotationForTouch = CGFloat(absoluteRotation) + ANGLE_BASE
        totalTouchAngle = ANGLE_BASE
        previousTouchAngle = touchPolarCoord.y
        spiral!.physicsBody?.angularDamping = 1.0
    }

    
    func panMovedToPoint(p: CGPoint) {
        touchPos = p
        var touchPolarCoord = polarCoordinate(touchPos!)
    
        if(abs(totalTouchAngle - ANGLE_BASE) > 0.01){
            tappedNode = nil
            tappedPosition = nil
        }
        
        let center = CGPoint(x: CGRectGetMidX(view!.frame), y:CGRectGetMidY(view!.frame))
        
        // dragging across the center
        if(p.distanceTo(center) > 60.0){
            let rotationAngle = previousTouchAngle - touchPolarCoord.y
            spiral!.runAction(SKAction.rotateByAngle(rotationAngle, duration: 0.002))
        } else {
            let rotationAngle = previousTouchAngle - touchPolarCoord.y
            spiral!.runAction(SKAction.rotateByAngle(rotationAngle, duration: 2.0))
        }
        endingVelocity = previousTouchAngle - touchPolarCoord.y
        totalTouchAngle += touchPolarCoord.y - previousTouchAngle
        previousTouchAngle = touchPolarCoord.y
    }


    func panEndedAtPoint(p: CGPoint){
        isTouching = false
        spiral!.physicsBody?.angularDamping = 0.3
        spiral!.removeAllActions()
        spiral!.physicsBody?.applyTorque(CGFloat(endingVelocity*100.0))
    }



    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        if (prevRotation < CGFloat(-M_PI_2)) && (spiral!.zRotation > CGFloat(M_PI_2)) {
            numRevolutions--
        } else if(prevRotation > CGFloat(M_PI/2.0)) && (spiral!.zRotation < CGFloat(-M_PI/2.0)) {
            numRevolutions++
        }
        
//        if(!isTouching){
//            //        breathe = powf(.5*(sinf(currentTime*2.0f)+.5f), 2);
////            var maxBreathe = 0.5f - abs(spiral.physicsBody.angularVelocity * 0.1f)
////            maxBreathe = max(0.01f, maxBreathe)
////            breathe = (.37f * cosf(M_PI / 2 * currentTime) + .45f) * maxBreathe
//        } else {
////            breathe -= spiral.physicsBody.angularVelocity * 0.01f
//        }
        
        let oneRev: Double = 2.0 * M_PI
        absoluteRotation = Double(numRevolutions) * oneRev + Double(spiral!.zRotation)
        
        if !isTransitioning {
            var torque: CGFloat
//            NSLog("%f", absoluteRotation)
            if absoluteRotation < -11.5 * ARC_LEN {
                isOutOfBounds = true
                torque = CGFloat(-absoluteRotation * 10.0)
                spiral!.physicsBody?.applyTorque(torque)
            } else if absoluteRotation > ARC_LEN * 2.5 {
                isOutOfBounds = true
                torque = CGFloat((-absoluteRotation+ARC_LEN)*40.0)
                spiral!.physicsBody?.applyTorque(torque)
            } else {
                isOutOfBounds = false
            }
        }
        prevRotation = spiral!.zRotation
//        NSLog("\(absoluteRotation)")
        
        spin()
    }
}

