//
//  CGNote.swift
//  Melody03
//
//  Created by Oscar Bonifacio on 5/12/16.
//  Copyright © 2016 PifaAppsCorp. All rights reserved.
//

import Foundation
import SpriteKit
import Darwin

class CGNote: SKNode {
    
    var note:SKSpriteNode = SKSpriteNode()
    var fxNote:SKSpriteNode = SKSpriteNode()
    
    var mov = 0
    
    //Gestures
    var oneClick = false
    var active = true
    var timerReset = NSTimer()
    
    init(noteImg: String, noteFxImg: String, size: CGFloat) {
        
        note = SKSpriteNode(imageNamed: noteImg)
        fxNote = SKSpriteNode(imageNamed: noteFxImg)
        
        let scle: CGFloat = size  //Image size with a scale value
        let opact: CGFloat = 0.6 //Opacity
        
        super.init()
        userInteractionEnabled = true
        
        note.hidden = false
        fxNote.hidden = false
        
        note.xScale = scle
        note.yScale = scle
        
        fxNote.xScale = scle
        fxNote.yScale = scle
        
        
        note.alpha = opact
        fxNote.alpha = opact
        
        addChild(fxNote)
        addChild(note)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            
            let location = touch.locationInNode(self)
            
            if self.nodeAtPoint(location) == self.note {
                oneClick = true
                timerReset.invalidate()
                timerReset = NSTimer.scheduledTimerWithTimeInterval(0.7, target: self, selector: #selector(CGNote.cancelPoint), userInfo: nil, repeats: false)
            }
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            
            let location = touch.locationInNode(self)
            
            if self.nodeAtPoint(location) == self.note {
                note.position = location
                fxNote.position = location
                
                mov = 1
            }
            
            if self.nodeAtPoint(location) == self.fxNote {
                note.position = location
                fxNote.position = location
                
                mov = 1
            }
            
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            
            let location = touch.locationInNode(self)
            
            if self.nodeAtPoint(location) == self.note {
                mov = 0
            }
            
            if self.nodeAtPoint(location) == self.fxNote {
                mov = 0
            }
        }
    }
    
    func cancelPoint(){
        oneClick = false
    }
}