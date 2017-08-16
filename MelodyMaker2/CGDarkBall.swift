//
//  CGDarkBall.swift
//  MelodyMaker
//
//  Created by Carlos García on 5/25/16.
//  Copyright (c) 2016 Audio Programming. All rights reserved.
//

import Foundation
import SpriteKit

class CGDarkBall: SKNode {
    
    let b01 = SKSpriteNode(imageNamed: "black")
    let b02 = SKSpriteNode(imageNamed: "grey")
    let b03 = SKSpriteNode(imageNamed: "white")
    
    let fxb01 = SKSpriteNode(imageNamed: "fxBlack")
    let fxb02 = SKSpriteNode(imageNamed: "fxGrey")
    let fxb03 = SKSpriteNode(imageNamed: "fxWhite")
    
    // Tempo
    var fistBeat = Int()
    
    // Octave and type of the balls
    var mov = 0             // To activate the mov of the ball
    
    var selBall:Int = 1    // Set type of balls
    var volume:Float = 0.5
    
    // To gestures
    var inRot: CGFloat = 0.0
    var fnRot: CGFloat = 0.0
    var actRot = 0
    
    var long: CGFloat = CGFloat()
    var actLong = 0
    
    var oneClick = false
    var active = true            // To activate fx and sounds
    var timerReset = NSTimer()
    
    override init() {
        let scle: CGFloat = 0.15  //Image size with a scale value
        let scleFx:CGFloat = 0.1
        let opact: CGFloat = 0.6 //Opacity
        let opactFx: CGFloat = 0.06 //Opacity
        
        super.init()
        userInteractionEnabled = true
        
        b01.hidden = true
        b02.hidden = false
        b03.hidden = true
        
        fxb01.hidden = true
        fxb02.hidden = false
        fxb03.hidden = true
        
        b01.xScale = scle
        b01.yScale = scle
        fxb01.xScale = scleFx
        fxb01.yScale = scleFx
        
        b02.xScale = scle
        b02.yScale = scle
        fxb02.xScale = scleFx
        fxb02.yScale = scleFx
        
        b03.xScale = scle
        b03.yScale = scle
        fxb03.xScale = scleFx
        fxb03.yScale = scleFx
        
        b01.alpha = opact
        b02.alpha = opact
        b03.alpha = opact
        
        fxb01.alpha = opactFx
        fxb02.alpha = opactFx
        fxb03.alpha = opactFx
        
        
        addChild(fxb01)
        addChild(fxb02)
        addChild(fxb03)
        
        addChild(b01)
        addChild(b02)
        addChild(b03)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            
            let location = touch.locationInNode(self)
            
            if self.nodeAtPoint(location) == self.b01 ||
                self.nodeAtPoint(location) == self.b02 ||
                self.nodeAtPoint(location) == self.b03 {
                    print(fistBeat)
                    oneClick = true
                    timerReset.invalidate()
                    timerReset = NSTimer.scheduledTimerWithTimeInterval(0.7, target: self, selector: #selector(CGDarkBall.cancelPoint), userInfo: nil, repeats: false)
            }
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            
            let location = touch.locationInNode(self)
            
            if self.nodeAtPoint(location) == self.b01 {
                b01.position = location
                b02.position = location
                b03.position = location
                
                fxb01.position = location
                fxb02.position = location
                fxb03.position = location
                
                mov = 1
            }
            
            if self.nodeAtPoint(location) == self.b02 {
                b01.position = location
                b02.position = location
                b03.position = location
                
                fxb01.position = location
                fxb02.position = location
                fxb03.position = location
                
                mov = 1
            }
            
            if self.nodeAtPoint(location) == self.b03 {
                b01.position = location
                b02.position = location
                b03.position = location
                
                fxb01.position = location
                fxb02.position = location
                fxb03.position = location
                
                mov = 1
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            
            let location = touch.locationInNode(self)
            
            if self.nodeAtPoint(location) == self.b01 {
                mov = 0
            }
            
            if self.nodeAtPoint(location) == self.b02 {
                mov = 0
            }
            
            if self.nodeAtPoint(location) == self.b03 {
                mov = 0
            }
        }
    }
    
    func cancelPoint(){
        oneClick = false
    }
}