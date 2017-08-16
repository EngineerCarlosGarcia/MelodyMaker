//
//  CGDrum.swift
//  MelodyMaker
//
//  Created by Carlos García on 5/25/16.
//  Copyright (c) 2016 Audio Programming. All rights reserved.
//

import Foundation
import SpriteKit

class CGDrum: SKNode {
    
    let b01 = SKSpriteNode(imageNamed: "gold")
    
    let fxb01 = SKSpriteNode(imageNamed: "fxGold")
    
    // Tempo
    var fistBeat = Int()
    
    // Octave and type of the balls
    var mov = 0             // To activate the mov of the ball
    
    var octave:Float = 0    // Set index of the ball's octave
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
        
        b01.hidden = false
        
        fxb01.hidden = false
        
        b01.xScale = scle
        b01.yScale = scle
        fxb01.xScale = scleFx
        fxb01.yScale = scleFx
        
        b01.alpha = opact
        
        fxb01.alpha = opactFx
        
        addChild(fxb01)
        
        addChild(b01)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            
            let location = touch.locationInNode(self)
            
            if self.nodeAtPoint(location) == self.b01 {
                    print(fistBeat)
                    oneClick = true
                    timerReset.invalidate()
                    timerReset = NSTimer.scheduledTimerWithTimeInterval(0.7, target: self, selector: #selector(CGDrum.cancelPoint), userInfo: nil, repeats: false)
            }
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            
            let location = touch.locationInNode(self)
            
            if self.nodeAtPoint(location) == self.b01 {
                b01.position = location
                
                fxb01.position = location
                
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
        }
    }
    
    func cancelPoint(){
        oneClick = false
    }
}
