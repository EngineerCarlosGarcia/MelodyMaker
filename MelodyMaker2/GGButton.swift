//
//  GGButton.swift
//  Test03
//
//  Created by Carlos García on 4/23/16.
//  Copyright (c) 2016 Audio Programming. All rights reserved.
//

import SpriteKit

class GGButton: SKNode {
    var defaultButton: SKSpriteNode
    var activeButton: SKSpriteNode
    var sizeButton:CGFloat
    var action:() -> Void
    
    
    init(defaultButtonImage: String, activeButtonImage: String, sizeImage: CGFloat, buttonAction:() -> Void) {
        defaultButton = SKSpriteNode(imageNamed: defaultButtonImage)
        activeButton = SKSpriteNode(imageNamed: activeButtonImage)
        sizeButton = sizeImage
        activeButton.hidden = true
        action = buttonAction
        
        super.init()
        
        userInteractionEnabled = true
        
        defaultButton.size = CGSize(width: sizeButton, height: sizeButton)

        activeButton.size = CGSize(width: sizeButton, height: sizeButton)
    
        defaultButton.name = defaultButtonImage
        activeButton.name = activeButtonImage
        
        addChild(defaultButton)
        addChild(activeButton)
    }
    
    /**
    Required so XCode doesn't throw warnings
    */
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        activeButton.hidden = false
        defaultButton.hidden = true
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch: UITouch = touches.first! as UITouch
        let location: CGPoint = touch.locationInNode(self)
        
        if defaultButton.containsPoint(location) {
            activeButton.hidden = false
            defaultButton.hidden = true
        } else {
            activeButton.hidden = true
            defaultButton.hidden = false
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch: UITouch = touches.first! as UITouch
        let location: CGPoint = touch.locationInNode(self)
        
        if defaultButton.containsPoint(location) {
            action()
        }
        
        activeButton.hidden = true
        defaultButton.hidden = false
    }
}