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
        
        // Family
        let familyItem = MenuSprite(image: "family", type: SpriteType.Large, title: "Family", color: SKColor(red:0.24, green:0.45, blue:0.77, alpha:1))
        addChild(familyItem)
        familyItem.positionInSpiral = 1
        familyItem.information = "I was born and raised in Yardley, Pennsylvania.\n\nI am the youngest of three kids. Growing up, my family would spend the summer at the Jersey Shore."
        
        // HGP
        let hgpItem = MenuSprite(image: "hgp", type: SpriteType.Small, title: "Holy Ghost Prep", color: SKColor(red:0.08, green:0.18, blue:0.33, alpha:1))
        addChild(hgpItem)
        hgpItem.positionInSpiral = 2
        hgpItem.information = "I went to HGP, a private Catholic high school where I first learned how to program.\n\nI attribute a lot of my success to the fantastic teachers I had there."
        
        // Totem Warfare
        let totemWarefareItem = MenuSprite(image: "totemwarfare", type: SpriteType.Small, title: "Totem Warfare", color: SKColor(red:0.3, green:0.51, blue:0.67, alpha:1))
        addChild(totemWarefareItem)
        totemWarefareItem.positionInSpiral = 3
        totemWarefareItem.information = "This was the first big project I attempted. It was a multi-player iOS game that used Game Center's realtime API to create a simple tower defense game."
        
        // Marist
        let maristItem = MenuSprite(image: "marist", type: SpriteType.Small, title: "Marist College", color: SKColor(red:0.81, green:0.24, blue:0.18, alpha:1))
        addChild(maristItem)
        maristItem.positionInSpiral = 4
        maristItem.information = "After high school, I went to Marist College in New York. I am still here pursing my Bachelor's in Computer Science."
        
        // Swivvy
        let swivvyItem = MenuSprite(image: "swivvy", type: SpriteType.Large, title: "Swivvy", color: SKColor(red:0.9, green:0.08, blue:0.09, alpha:1))
        addChild(swivvyItem)
        swivvyItem.positionInSpiral = 5
        swivvyItem.information = "Originally created for a Game Jam, Swivvy was the first iOS app I released on the App Store. It was made using cocos2d and box2d for the physics."
        
        // Sublime Text
        let sublimeTextItem = MenuSprite(image: "sublimetext", type: SpriteType.Small, title: "Sublime Text Plugins", color: SKColor(red:1, green:0.44, blue:0, alpha:1))
        addChild(sublimeTextItem)
        sublimeTextItem.positionInSpiral = 6
        sublimeTextItem.information = "For a while, I was very active in the Sublime Text open source community. I made a several plugins for the text editor with a wide range of complexity.\n\nThe most popular \"AutoFileName\" is still very widely used."
        
        // Zworkbench
        let zworkbenchItem = MenuSprite(image: "qatqi", type: SpriteType.Large, title: "ZWorkbench Inc.", color: SKColor(red:0, green:0, blue:0, alpha:1))
        addChild(zworkbenchItem)
        zworkbenchItem.positionInSpiral = 7
        zworkbenchItem.information = "My freshman year of college, I begin interning for a small iOS development team. I helped work on QatQi, a word game. I worked there for 2 Summers and learned a lot about real-world development."
        
        // Morgan Stanley Hackathons
        let morganStanleyItem = MenuSprite(image: "hackathon", type: SpriteType.Small, title: "Hackathon", color: SKColor(red:0.64, green:0.41, blue:0.62, alpha:1))
        addChild(morganStanleyItem)
        morganStanleyItem.positionInSpiral = 8
        morganStanleyItem.information = "Received 3rd Place in Morgan Stanley's Annual Global Trading Placement Engine Challenge. We had to create a predictive algorithm to balance server load, thereby minimizing costs."
        
        // BackRow
        let backrowItem = MenuSprite(image: "backrow", type: SpriteType.Large, title: "hackMarist", color: SKColor(red:0.15, green:0.15, blue:0.15, alpha:1))
        addChild(backrowItem)
        backrowItem.positionInSpiral = 9
        backrowItem.information = "BackRow is an iOS app that allows people to play a \"whisper down the lane\"-esque game with friends. It was originally developed originally for a hackathon."
        
        // ScheduleSlide
        let scheduleSlideItem = MenuSprite(image: "scheduleslide", type: SpriteType.Large, title: "hackMarist", color: SKColor(red:0.34, green:0.76, blue:0.43, alpha:1))
        addChild(scheduleSlideItem)
        scheduleSlideItem.positionInSpiral = 10
        scheduleSlideItem.information = "For hackMarist 2014, my friends and I created a schedule app that manages tasks for you based on priority. In addition, it would split tasks up into orderly chunks, allowing users to either stay on top of their tasks or simply \"slide\" them to another day."
        
        // Morgan Stanley Hackathon
        let morganStanleyItem2 = MenuSprite(image: "hackathon", type: SpriteType.Small, title: "Hackathon", color: SKColor(red:0.64, green:0.41, blue:0.62, alpha:1))
        addChild(morganStanleyItem2)
        morganStanleyItem2.positionInSpiral = 11
        morganStanleyItem2.information = "Once again placed in the Top 3 at a Morgan Stanley hackathon. This time, we created an app that acted as a front to a location-based forum that would analyze user sentiment using a provided API."
        
        // Compiler
        let compilerItem = MenuSprite(image: "hackathon", type: SpriteType.Small, title: "Compiler in Swift", color: SKColor(red:0.64, green:0.41, blue:0.62, alpha:1))
        addChild(compilerItem)
        compilerItem.positionInSpiral = 12
        compilerItem.information = "This semester, I have been building a compiler using Swift that translates a provided grammar into 6502 opcode."
        
        // Grep
        let grepItem = MenuSprite(image: "hackathon", type: SpriteType.Small, title: "Grep in Java", color: SKColor(red:0.64, green:0.41, blue:0.62, alpha:1))
        addChild(grepItem)
        grepItem.positionInSpiral = 13
        grepItem.information = "In addition, I have also been using Java to build a command-line tool that takes a regular expression, creates a corresponding NFA and DFA then outputs matching lines from a given input file."
        
        // Amazon
        let amazonItem = MenuSprite(image: "amazon", type: SpriteType.Large, title: "Amazon", color: SKColor(red:0.96, green:0.56, blue:0.04, alpha:1))
        addChild(amazonItem)
        amazonItem.positionInSpiral = 14
        amazonItem.information = "This upcoming Summer, I will be working of Amazon on their Amazon Music team."
        
        physicsBody = SKPhysicsBody(circleOfRadius: 100.0, center:CGPoint(x: 0,y: 0))
        physicsBody!.affectedByGravity = false;
        physicsBody!.collisionBitMask = 0x00000000;
        physicsBody!.allowsRotation = true;
        physicsBody!.mass = 150.0;
        //        self.userInteractionEnabled = YES;
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}