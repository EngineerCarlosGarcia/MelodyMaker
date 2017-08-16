//
//  CGLine.swift
//  Melody03
//
//  Created by Oscar Bonifacio on 5/13/16.
//  Copyright © 2016 PifaAppsCorp. All rights reserved.
//

import Foundation
import SpriteKit

class CGLine: SKNode {
    let line = SKSpriteNode(imageNamed: "line")
    var point01 = CGBall()
    var point02: CGNote!
    
    init(b1: CGBall, n1: CGNote) {
        point01 = b1
        point02 = n1
        
        super.init()
        userInteractionEnabled = true
        
        line.hidden = true
        
        addChild(line)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
}