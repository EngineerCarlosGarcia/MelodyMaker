//
//  GameScene.swift
//  MelodyMaker2
//
//  Created by Carlos García on 7/1/17.
//  Copyright (c) 2017 Audio Programming. All rights reserved.
//

import SpriteKit
import AudioKit
import UIKit

class GameScene: SKScene {
    
    /////// AudioKit ///////
    var osc1 = AKOscillator()
    var osc2 = AKOscillator()
    var osc3 = AKOscillator()
    
    ////// Timer //////
    var startTime = NSTimeInterval()
    var timer = NSTimer()
    var elapsedTime = NSTimeInterval()
    
    ////// Measure //////
    var activeState = 1    //Make that sound and movements are activated once time only
    var bpm = 60         //Tempo in beats
    var bpmBn = 60       //To change tempo initial in rotation
    var bpmFn = 60       //To change tempo final after rotation
    var durRef = Double() //Duration from balls fx
    var minBeat = 4.0      //4 = 16th, 2 = 8th, 1 = 4th, 0.5 = 2th
    var click = 1
    
    ////// Screen size and normalize //////
    var screenW:CGFloat = CGFloat()
    var screenH:CGFloat = CGFloat()
    
    ////// Balls, notes //////
    var balls = [CGBall]()
    var darkBalls = [CGDarkBall]()
    var drumBalls = [CGDrum]()
    var notes = [[CGNote]]()
    
    let imgNoteNames = ["note0Red", "note1Oran", "note2Yell", "note3Green", "note4Green2", "note5Blue", "note6BluePur", "note7Purp"]
    let imgFxNoteNames = ["fxNote0Red", "fxNote1Oran", "fxNote2Yell", "fxNote3Green", "fxNote4Green2", "fxNote5Blue", "fxNote6BluePur", "fxNote7Purp"]
    let sizeNotes: [CGFloat] = [0.2, 0.22, 0.28, 0.3, 0.32, 0.34, 0.36, 0.38]
    
    ////// Lines and fx //////
    // to balls
    var lines = [[[SKSpriteNode]]]()
    var actBalls = [[[SKSpriteNode]]]()
    var numBallsFx = 0      // Number of create balls
    var refBeats = [[[Int]]]()
    //to dark balls
    var darkLines = [[[SKSpriteNode]]]()
    var darkActBalls = [[[SKSpriteNode]]]()
    var numDarkBallsFx = 0
    var refDarkBeats = [[[Int]]]()
    //to drum balls
    var drumLines = [[[SKSpriteNode]]]()
    var drumActBalls = [[[SKSpriteNode]]]()
    var numDrumBallsFx = 0
    var refDrumBeats = [[[Int]]]()
    
    let lnDiv: [CGFloat] = [100, 130, 160, 190, 220, 250, 280, 310] //Number divitions from lines
    
    ////// Musitian notes scales //////
    var musicScale: [Double] = [60, 62, 65, 67, 69, 72, 74, 77]
    
    ////// To gestures
    var movRot: CGFloat = CGFloat()
    var actDoubleTouch = false
    let maxlenght: CGFloat = 140.0  // max ball size
    
    ////// Menu sides //////
    let menuL = SKSpriteNode(imageNamed: "menuL")
    let menuR = SKSpriteNode(imageNamed: "menuR")
    
    ////// Master Balls //////
    let masterTempo = SKSpriteNode(imageNamed: "mstrTempo")
    let masterKey = SKSpriteNode(imageNamed: "mstrKey")
    let masterAmp = SKSpriteNode(imageNamed: "mstrAmp")
    
    var tempoInRot = CGFloat()
    var tempoFnRot = CGFloat()
    var tempoActRot = 0
    var bpmLabel = SKLabelNode(fontNamed:"HelveticaNeue-Bold")
    
    var keyInRot = CGFloat()
    var keyFnRot = CGFloat()
    var keyActRot = 0
    var semiTone = 0
    var keyLabel = SKLabelNode(fontNamed:"HelveticaNeue-Bold")
    
    var ampInRot = CGFloat()
    var ampFnRot = CGFloat()
    var ampActRot = 0
    var volume = 50
    var volumeIn = 50
    var volumeFn = 50
    var ampLabel = SKLabelNode(fontNamed:"HelveticaNeue-Bold")
    
    
    
    override func didMoveToView(view: SKView) {
        /////// AudioKitStart ///////
        AudioKit.output = osc2
        AudioKit.output = osc1
        AudioKit.start()
        
        ////// Timer //////
        timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: #selector(GameScene.updateTime), userInfo: nil, repeats: true)
        startTime = NSDate.timeIntervalSinceReferenceDate()
        
        ////// size and normalize //////
        screenW = CGRectGetWidth(self.frame)
        screenH = CGRectGetHeight(self.frame)
        
        ////// Background //////
        let bg = SKSpriteNode(imageNamed: "bg2")
        bg.size = CGSize(width: screenW, height: screenH)
        bg.position = CGPoint(x: screenW * 0.5, y: screenH * 0.5)
        bg.zPosition = -1
        self.addChild(bg)
        
        ////// Menu sides //////
        menuL.size = CGSize(width: screenH * 0.09, height: screenH * 0.26)
        menuL.position = CGPointMake(screenH * 0.045, screenH * 0.5)
        self.addChild(menuL)
        
        menuR.size = CGSize(width: screenH * 0.06, height: screenH * 0.5)
        menuR.position = CGPointMake(screenW - screenH * 0.03, screenH * 0.5)
        self.addChild(menuR)
        
        ////// Balls and notes //////
        for _ in 0..<8{
            let notePosition = [CGNote]()
            notes.append(notePosition)
        }
        
        let buttonBall = GGButton(defaultButtonImage: "btnBall", activeButtonImage: "btnBall", sizeImage: screenH * 0.07, buttonAction: addBall)
        let buttonDarkBall = GGButton(defaultButtonImage: "btnDark", activeButtonImage: "btnDark", sizeImage: screenH * 0.07, buttonAction: addDarkBall)
        let buttonDrum = GGButton(defaultButtonImage: "btnGold", activeButtonImage: "btnGold", sizeImage: screenH * 0.07, buttonAction: addDrum)
        
        buttonDarkBall.position = CGPointMake(screenH * 0.045, screenH * 0.58)
        buttonBall.position = CGPointMake(screenH * 0.045, screenH * 0.5)
        buttonDrum.position = CGPointMake(screenH * 0.045, screenH * 0.42)
        
        self.addChild(buttonDarkBall)
        self.addChild(buttonBall)
        self.addChild(buttonDrum)
        
        let buttonNote7 = GGButton(defaultButtonImage: "NPurpBtnDef08", activeButtonImage: "NPurpBtnAct08", sizeImage: screenH * 0.05, buttonAction: addNote7)
        let buttonNote6 = GGButton(defaultButtonImage: "NBluePurBtnDef07", activeButtonImage: "NBluPurBtnAct07", sizeImage: screenH * 0.05, buttonAction: addNote6)
        let buttonNote5 = GGButton(defaultButtonImage: "NBlueBtnDef06", activeButtonImage: "NBlueBtnAct06", sizeImage: screenH * 0.05, buttonAction: addNote5)
        let buttonNote4 = GGButton(defaultButtonImage: "NGreen2BtnDef05", activeButtonImage: "NGreen2BtnAct05", sizeImage: screenH * 0.05, buttonAction: addNote4)
        let buttonNote3 = GGButton(defaultButtonImage: "NGreenBtnDef04", activeButtonImage: "NGreenBtnAct04", sizeImage: screenH * 0.05, buttonAction: addNote3)
        let buttonNote2 = GGButton(defaultButtonImage: "NYellBtnDef03", activeButtonImage: "NYellBtnAct03", sizeImage: screenH * 0.05, buttonAction: addNote2)
        let buttonNote1 = GGButton(defaultButtonImage: "NOranBtnDef02", activeButtonImage: "NOranBtnAct02", sizeImage: screenH * 0.05, buttonAction: addNote1)
        let buttonNote0 = GGButton(defaultButtonImage: "NRedBtnDef01", activeButtonImage: "NRedBtnAct01", sizeImage: screenH * 0.05, buttonAction: addNote0)
        
        buttonNote7.position = CGPointMake(screenW - screenH * 0.03, screenH * 0.71)
        buttonNote6.position = CGPointMake(screenW - screenH * 0.03, screenH * 0.65)
        buttonNote5.position = CGPointMake(screenW - screenH * 0.03, screenH * 0.59)
        buttonNote4.position = CGPointMake(screenW - screenH * 0.03, screenH * 0.53)
        buttonNote3.position = CGPointMake(screenW - screenH * 0.03, screenH * 0.47)
        buttonNote2.position = CGPointMake(screenW - screenH * 0.03, screenH * 0.41)
        buttonNote1.position = CGPointMake(screenW - screenH * 0.03, screenH * 0.35)
        buttonNote0.position = CGPointMake(screenW - screenH * 0.03, screenH * 0.29)
        
        self.addChild(buttonNote7)
        self.addChild(buttonNote6)
        self.addChild(buttonNote5)
        self.addChild(buttonNote4)
        self.addChild(buttonNote3)
        self.addChild(buttonNote2)
        self.addChild(buttonNote1)
        self.addChild(buttonNote0)
        
        ////// Master Balls //////
        /// Tempo
        masterTempo.size = CGSize(width: screenH * 0.15, height: screenH * 0.15)
        masterTempo.position = CGPoint(x: screenW * (2.0 / 6.0), y: screenH * 0.1)
        self.addChild(masterTempo)
        
        bpmLabel.text = "bpm: \(bpm)"
        bpmLabel.fontSize = 30
        bpmLabel.position = CGPoint(x: screenW * 0.5, y: screenH * 0.9)
        self.addChild(bpmLabel)
        let secBPM = SKAction.sequence([SKAction.fadeInWithDuration(0.5), SKAction.fadeOutWithDuration(NSTimeInterval(1.0))])
        bpmLabel.runAction(secBPM)
        
        /// Key
        masterKey.size = CGSize(width: screenH * 0.15, height: screenH * 0.15)
        masterKey.position = CGPoint(x: screenW * (3.0 / 6.0), y: screenH * 0.1)
        self.addChild(masterKey)
        
        keyLabel.text = "key: C"
        keyLabel.fontSize = 30
        keyLabel.position = CGPoint(x: screenW * 0.5, y: screenH * 0.85)
        self.addChild(keyLabel)
        let secKey = SKAction.sequence([SKAction.fadeInWithDuration(0.5), SKAction.fadeOutWithDuration(NSTimeInterval(1.0))])
        keyLabel.runAction(secKey)
        
        /// Tempo
        masterAmp.size = CGSize(width: screenH * 0.15, height: screenH * 0.15)
        masterAmp.position = CGPoint(x: screenW * (4.0 / 6.0), y: screenH * 0.1)
        self.addChild(masterAmp)
        
        ampLabel.text = "vol: \(volume)"
        ampLabel.fontSize = 30
        ampLabel.position = CGPoint(x: screenW * 0.5, y: screenH * 0.8)
        self.addChild(ampLabel)
        let secAmp = SKAction.sequence([SKAction.fadeInWithDuration(0.5), SKAction.fadeOutWithDuration(NSTimeInterval(1.0))])
        ampLabel.runAction(secAmp)
        
        ////// UI Gestures //////
        let rotationGR = UIRotationGestureRecognizer(target: self, action: #selector(GameScene.handleRotation(_:)))
        self.view!.addGestureRecognizer(rotationGR)
        
        let sizeTouch = UIPinchGestureRecognizer(target: self, action: #selector(GameScene.handelSize(_:)))
        self.view!.addGestureRecognizer(sizeTouch)
        
        let doubleTouch = UITapGestureRecognizer(target: self, action: #selector(GameScene.doubleTap(_:)))
        doubleTouch.numberOfTapsRequired = 2
        self.view!.addGestureRecognizer(doubleTouch)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            //let location = touch.locationInNode(self)
            
            /*/Set fist beat in all balls to 1
             for i in 0..<balls.count{
             balls[i].fistBeat = 1
             }*/
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            
            if self.nodeAtPoint(location) == self.masterTempo {
                masterTempo.position = location
            }
            
            if self.nodeAtPoint(location) == self.masterKey {
                masterKey.position = location
            }
            
            if self.nodeAtPoint(location) == self.masterAmp {
                masterAmp.position = location
            }
        }
    }
    
    
    //////// MAIN FUNCTION ////////
    override func update(currentTime: CFTimeInterval) {
        ///// AudioKit Osc On /////
        
        ////// Set and change tempo //////
        durRef = (60.0 / Double(bpm)) * (2.0)
        
        ////// Sound with touch //////
        for i in 0..<notes.count{
            for j in 0..<notes[i].count{
                if notes[i][j].oneClick == true && notes[i][j].active == true {
                    osc2.amplitude = 0.5
                    let note = musicScale[i]
                    osc2.frequency = note.midiNoteToFrequency()
                    osc2.play()
                }
            }
        }
        
        
        ////////// LINE DISTACES //////////
        ////// Line distance in balls
        for ball in 0..<balls.count{
            for i in 0..<notes.count{
                for j in 0..<notes[i].count{
                    switch lines[ball][i][j].size.width {
                    case 0...lnDiv[0]:
                        refBeats[ball][i][j] = 1
                        
                    case lnDiv[0]...lnDiv[1]:
                        refBeats[ball][i][j] = 2
                        
                    case lnDiv[1]...lnDiv[2]:
                        refBeats[ball][i][j] = 3
                        
                    case lnDiv[2]...lnDiv[3]:
                        refBeats[ball][i][j] = 4
                        
                    case lnDiv[3]...lnDiv[4]:
                        refBeats[ball][i][j] = 5
                        
                    case lnDiv[4]...lnDiv[5]:
                        refBeats[ball][i][j] = 6
                        
                    case lnDiv[5]...lnDiv[6]:
                        refBeats[ball][i][j] = 7
                        
                    case lnDiv[6]...lnDiv[7]:
                        refBeats[ball][i][j] = 8
                        
                    default:
                        refBeats[ball][i][j] = 9
                        break
                    }
                    
                    switch lines[ball][i][j].size.width {
                    case 0...lnDiv[7]:
                        lines[ball][i][j].hidden = false
                        actBalls[ball][i][j].hidden = false
                    default:
                        lines[ball][i][j].hidden = true
                        actBalls[ball][i][j].hidden = true
                        break
                    }
                    
                    if balls[ball].mov == 1 || notes[i][j].mov == 1{ ///// buscar algo mas eficiente
                        actBalls[ball][i][j].hidden = true
                    } else {
                        actBalls[ball][i][j].hidden = false
                    }
                }
            }
        }
        ////// Line distance in dark balls
        for ball in 0..<darkBalls.count{
            for i in 0..<notes.count{
                for j in 0..<notes[i].count{
                    switch darkLines[ball][i][j].size.width {
                    case 0...lnDiv[0]:
                        refDarkBeats[ball][i][j] = 1
                        
                    case lnDiv[0]...lnDiv[1]:
                        refDarkBeats[ball][i][j] = 2
                        
                    case lnDiv[1]...lnDiv[2]:
                        refDarkBeats[ball][i][j] = 3
                        
                    case lnDiv[2]...lnDiv[3]:
                        refDarkBeats[ball][i][j] = 4
                        
                    case lnDiv[3]...lnDiv[4]:
                        refDarkBeats[ball][i][j] = 5
                        
                    case lnDiv[4]...lnDiv[5]:
                        refDarkBeats[ball][i][j] = 6
                        
                    case lnDiv[5]...lnDiv[6]:
                        refDarkBeats[ball][i][j] = 7
                        
                    case lnDiv[6]...lnDiv[7]:
                        refDarkBeats[ball][i][j] = 8
                        
                    default:
                        refDarkBeats[ball][i][j] = 9
                        break
                    }
                    
                    switch darkLines[ball][i][j].size.width {
                    case 0...lnDiv[7]:
                        darkLines[ball][i][j].hidden = false
                        darkActBalls[ball][i][j].hidden = false
                    default:
                        darkLines[ball][i][j].hidden = true
                        darkActBalls[ball][i][j].hidden = true
                        break
                    }
                    
                    if darkBalls[ball].mov == 1 || notes[i][j].mov == 1{ ///// buscar algo mas eficiente
                        darkActBalls[ball][i][j].hidden = true
                    } else {
                        darkActBalls[ball][i][j].hidden = false
                    }
                }
            }
        }
        ////// Line distance in drum balls
        for ball in 0..<drumBalls.count{
            for i in 0..<notes.count{
                for j in 0..<notes[i].count{
                    switch drumLines[ball][i][j].size.width {
                    case 0...lnDiv[0]:
                        refDrumBeats[ball][i][j] = 1
                        
                    case lnDiv[0]...lnDiv[1]:
                        refDrumBeats[ball][i][j] = 2
                        
                    case lnDiv[1]...lnDiv[2]:
                        refDrumBeats[ball][i][j] = 3
                        
                    case lnDiv[2]...lnDiv[3]:
                        refDrumBeats[ball][i][j] = 4
                        
                    case lnDiv[3]...lnDiv[4]:
                        refDrumBeats[ball][i][j] = 5
                        
                    case lnDiv[4]...lnDiv[5]:
                        refDrumBeats[ball][i][j] = 6
                        
                    case lnDiv[5]...lnDiv[6]:
                        refDrumBeats[ball][i][j] = 7
                        
                    case lnDiv[6]...lnDiv[7]:
                        refDrumBeats[ball][i][j] = 8
                        
                    default:
                        refDrumBeats[ball][i][j] = 9
                        break
                    }
                    
                    switch drumLines[ball][i][j].size.width {
                    case 0...lnDiv[7]:
                        drumLines[ball][i][j].hidden = false
                        drumActBalls[ball][i][j].hidden = false
                    default:
                        drumLines[ball][i][j].hidden = true
                        drumActBalls[ball][i][j].hidden = true
                        break
                    }
                    
                    if drumBalls[ball].mov == 1 || notes[i][j].mov == 1{ ///// buscar algo mas eficiente
                        drumActBalls[ball][i][j].hidden = true
                    } else {
                        drumActBalls[ball][i][j].hidden = false
                    }
                }
            }
        }
        
        
        
        
        ////////// MEASURE //////////
        if click == 1 && activeState == 1{
            // Balls
            fxBallsStart(1)
            movntActBalls(1)
            //
            actSounds(1, rbeat: 1)
            actSounds(2, rbeat: 8)
            actSounds(3, rbeat: 7)
            actSounds(4, rbeat: 6)
            actSounds(5, rbeat: 5)
            actSounds(6, rbeat: 4)
            actSounds(7, rbeat: 3)
            actSounds(8, rbeat: 2)
            
            // Dark balls
            fxDarkBallsStart(1)
            movntDarkActBalls(1)
            //
            actDarkSounds(1, rbeat: 1)
            actDarkSounds(2, rbeat: 8)
            actDarkSounds(3, rbeat: 7)
            actDarkSounds(4, rbeat: 6)
            actDarkSounds(5, rbeat: 5)
            actDarkSounds(6, rbeat: 4)
            actDarkSounds(7, rbeat: 3)
            actDarkSounds(8, rbeat: 2)
            
            // Drum balls
            fxDrumBallsStart(1)
            movntDrumActBalls(1)
            //
            actDrumSounds(1, rbeat: 1)
            actDrumSounds(2, rbeat: 8)
            actDrumSounds(3, rbeat: 7)
            actDrumSounds(4, rbeat: 6)
            actDrumSounds(5, rbeat: 5)
            actDrumSounds(6, rbeat: 4)
            actDrumSounds(7, rbeat: 3)
            actDrumSounds(8, rbeat: 2)
            
            
            // Next click
            activeState = 2
        }
        if click == 2 && activeState == 2{
            // Balls
            fxBallsStart(2)
            movntActBalls(2)
            //
            actSounds(1, rbeat: 2)
            actSounds(2, rbeat: 1)
            actSounds(3, rbeat: 8)
            actSounds(4, rbeat: 7)
            actSounds(5, rbeat: 6)
            actSounds(6, rbeat: 5)
            actSounds(7, rbeat: 4)
            actSounds(8, rbeat: 3)
            
            // Dark balls
            fxDarkBallsStart(2)
            movntDarkActBalls(2)
            //
            actDarkSounds(1, rbeat: 2)
            actDarkSounds(2, rbeat: 1)
            actDarkSounds(3, rbeat: 8)
            actDarkSounds(4, rbeat: 7)
            actDarkSounds(5, rbeat: 6)
            actDarkSounds(6, rbeat: 5)
            actDarkSounds(7, rbeat: 4)
            actDarkSounds(8, rbeat: 3)
            
            // Drum balls
            fxDrumBallsStart(2)
            movntDrumActBalls(2)
            //
            actDrumSounds(1, rbeat: 2)
            actDrumSounds(2, rbeat: 1)
            actDrumSounds(3, rbeat: 8)
            actDrumSounds(4, rbeat: 7)
            actDrumSounds(5, rbeat: 6)
            actDrumSounds(6, rbeat: 5)
            actDrumSounds(7, rbeat: 4)
            actDrumSounds(8, rbeat: 3)
            
            
            // Next click
            activeState = 3
        }
        if click == 3 && activeState == 3{
            // Balls
            fxBallsStart(3)
            movntActBalls(3)
            //
            actSounds(1, rbeat: 3)
            actSounds(2, rbeat: 2)
            actSounds(3, rbeat: 1)
            actSounds(4, rbeat: 8)
            actSounds(5, rbeat: 7)
            actSounds(6, rbeat: 6)
            actSounds(7, rbeat: 5)
            actSounds(8, rbeat: 4)
            
            // Dark balls
            fxDarkBallsStart(3)
            movntDarkActBalls(3)
            //
            actDarkSounds(1, rbeat: 3)
            actDarkSounds(2, rbeat: 2)
            actDarkSounds(3, rbeat: 1)
            actDarkSounds(4, rbeat: 8)
            actDarkSounds(5, rbeat: 7)
            actDarkSounds(6, rbeat: 6)
            actDarkSounds(7, rbeat: 5)
            actDarkSounds(8, rbeat: 4)
            
            // Drum balls
            fxDrumBallsStart(3)
            movntDrumActBalls(3)
            //
            actDrumSounds(1, rbeat: 3)
            actDrumSounds(2, rbeat: 2)
            actDrumSounds(3, rbeat: 1)
            actDrumSounds(4, rbeat: 8)
            actDrumSounds(5, rbeat: 7)
            actDrumSounds(6, rbeat: 6)
            actDrumSounds(7, rbeat: 5)
            actDrumSounds(8, rbeat: 4)
            
            
            // Next click
            activeState = 4
        }
        if click == 4 && activeState == 4{
            // Balls
            fxBallsStart(4)
            movntActBalls(4)
            //
            actSounds(1, rbeat: 4)
            actSounds(2, rbeat: 3)
            actSounds(3, rbeat: 2)
            actSounds(4, rbeat: 1)
            actSounds(5, rbeat: 8)
            actSounds(6, rbeat: 7)
            actSounds(7, rbeat: 6)
            actSounds(8, rbeat: 5)
            
            // Dark balls
            fxDarkBallsStart(4)
            movntDarkActBalls(4)
            //
            actDarkSounds(1, rbeat: 4)
            actDarkSounds(2, rbeat: 3)
            actDarkSounds(3, rbeat: 2)
            actDarkSounds(4, rbeat: 1)
            actDarkSounds(5, rbeat: 8)
            actDarkSounds(6, rbeat: 7)
            actDarkSounds(7, rbeat: 6)
            actDarkSounds(8, rbeat: 5)
            
            // Drum balls
            fxDrumBallsStart(4)
            movntDrumActBalls(4)
            //
            actDrumSounds(1, rbeat: 4)
            actDrumSounds(2, rbeat: 3)
            actDrumSounds(3, rbeat: 2)
            actDrumSounds(4, rbeat: 1)
            actDrumSounds(5, rbeat: 8)
            actDrumSounds(6, rbeat: 7)
            actDrumSounds(7, rbeat: 6)
            actDrumSounds(8, rbeat: 5)
            
            
            // Next click
            activeState = 5
        }
        if click == 5 && activeState == 5{
            // Balls
            fxBallsStart(5)
            movntActBalls(5)
            //
            actSounds(1, rbeat: 5)
            actSounds(2, rbeat: 4)
            actSounds(3, rbeat: 3)
            actSounds(4, rbeat: 2)
            actSounds(5, rbeat: 1)
            actSounds(6, rbeat: 8)
            actSounds(7, rbeat: 7)
            actSounds(8, rbeat: 6)
            
            // Dark balls
            fxDarkBallsStart(5)
            movntDarkActBalls(5)
            //
            actDarkSounds(1, rbeat: 5)
            actDarkSounds(2, rbeat: 4)
            actDarkSounds(3, rbeat: 3)
            actDarkSounds(4, rbeat: 2)
            actDarkSounds(5, rbeat: 1)
            actDarkSounds(6, rbeat: 8)
            actDarkSounds(7, rbeat: 7)
            actDarkSounds(8, rbeat: 6)
            
            // Drum balls
            fxDrumBallsStart(5)
            movntDrumActBalls(5)
            //
            actDrumSounds(1, rbeat: 5)
            actDrumSounds(2, rbeat: 4)
            actDrumSounds(3, rbeat: 3)
            actDrumSounds(4, rbeat: 2)
            actDrumSounds(5, rbeat: 1)
            actDrumSounds(6, rbeat: 8)
            actDrumSounds(7, rbeat: 7)
            actDrumSounds(8, rbeat: 6)
            
            
            // Next click
            activeState = 6
        }
        if click == 6 && activeState == 6{
            // Balls
            fxBallsStart(6)
            movntActBalls(6)
            //
            actSounds(1, rbeat: 6)
            actSounds(2, rbeat: 5)
            actSounds(3, rbeat: 4)
            actSounds(4, rbeat: 3)
            actSounds(5, rbeat: 2)
            actSounds(6, rbeat: 1)
            actSounds(7, rbeat: 8)
            actSounds(8, rbeat: 7)
            
            // Dark balls
            fxDarkBallsStart(6)
            movntDarkActBalls(6)
            //
            actDarkSounds(1, rbeat: 6)
            actDarkSounds(2, rbeat: 5)
            actDarkSounds(3, rbeat: 4)
            actDarkSounds(4, rbeat: 3)
            actDarkSounds(5, rbeat: 2)
            actDarkSounds(6, rbeat: 1)
            actDarkSounds(7, rbeat: 8)
            actDarkSounds(8, rbeat: 7)
            
            // Drum balls
            fxDrumBallsStart(6)
            movntDrumActBalls(6)
            //
            actDrumSounds(1, rbeat: 6)
            actDrumSounds(2, rbeat: 5)
            actDrumSounds(3, rbeat: 4)
            actDrumSounds(4, rbeat: 3)
            actDrumSounds(5, rbeat: 2)
            actDrumSounds(6, rbeat: 1)
            actDrumSounds(7, rbeat: 8)
            actDrumSounds(8, rbeat: 7)
            
            
            // Next click
            activeState = 7
        }
        if click == 7 && activeState == 7{
            // Balls
            fxBallsStart(7)
            movntActBalls(7)
            //
            actSounds(1, rbeat: 7)
            actSounds(2, rbeat: 6)
            actSounds(3, rbeat: 5)
            actSounds(4, rbeat: 4)
            actSounds(5, rbeat: 3)
            actSounds(6, rbeat: 2)
            actSounds(7, rbeat: 1)
            actSounds(8, rbeat: 8)
            
            // Dark balls
            fxDarkBallsStart(7)
            movntDarkActBalls(7)
            //
            actDarkSounds(1, rbeat: 7)
            actDarkSounds(2, rbeat: 6)
            actDarkSounds(3, rbeat: 5)
            actDarkSounds(4, rbeat: 4)
            actDarkSounds(5, rbeat: 3)
            actDarkSounds(6, rbeat: 2)
            actDarkSounds(7, rbeat: 1)
            actDarkSounds(8, rbeat: 8)
            
            // Drum balls
            fxDrumBallsStart(7)
            movntDrumActBalls(7)
            //
            actDrumSounds(1, rbeat: 7)
            actDrumSounds(2, rbeat: 6)
            actDrumSounds(3, rbeat: 5)
            actDrumSounds(4, rbeat: 4)
            actDrumSounds(5, rbeat: 3)
            actDrumSounds(6, rbeat: 2)
            actDrumSounds(7, rbeat: 1)
            actDrumSounds(8, rbeat: 8)
            
            
            // Next click
            activeState = 8
        }
        if click == 8 && activeState == 8{
            // Balls
            fxBallsStart(8)
            movntActBalls(8)
            //
            actSounds(1, rbeat: 8)
            actSounds(2, rbeat: 7)
            actSounds(3, rbeat: 6)
            actSounds(4, rbeat: 5)
            actSounds(5, rbeat: 4)
            actSounds(6, rbeat: 3)
            actSounds(7, rbeat: 2)
            actSounds(8, rbeat: 1)
            
            // Dark balls
            fxDarkBallsStart(8)
            movntDarkActBalls(8)
            //
            actDarkSounds(1, rbeat: 8)
            actDarkSounds(2, rbeat: 7)
            actDarkSounds(3, rbeat: 6)
            actDarkSounds(4, rbeat: 5)
            actDarkSounds(5, rbeat: 4)
            actDarkSounds(6, rbeat: 3)
            actDarkSounds(7, rbeat: 2)
            actDarkSounds(8, rbeat: 1)
            
            // Drum balls
            fxDrumBallsStart(8)
            movntDrumActBalls(8)
            //
            actDrumSounds(1, rbeat: 8)
            actDrumSounds(2, rbeat: 7)
            actDrumSounds(3, rbeat: 6)
            actDrumSounds(4, rbeat: 5)
            actDrumSounds(5, rbeat: 4)
            actDrumSounds(6, rbeat: 3)
            actDrumSounds(7, rbeat: 2)
            actDrumSounds(8, rbeat: 1)
            
            
            // Next click
            activeState = 1
        }
        
        
        
        //To move and resize the lines
        for ball in 0..<balls.count{
            for i in 0..<notes.count{
                for j in 0..<notes[i].count{
                    moveLine(balls[ball].b02.position, punto2: notes[i][j].note.position, line: lines[ball][i][j])
                }
            }
        }
        
        //To move and resize the dark lines
        for ball in 0..<darkBalls.count{
            for i in 0..<notes.count{
                for j in 0..<notes[i].count{
                    moveLine(darkBalls[ball].b02.position, punto2: notes[i][j].note.position, line: darkLines[ball][i][j])
                }
            }
        }
        
        //To move and resize the drum lines
        for ball in 0..<drumBalls.count{
            for i in 0..<notes.count{
                for j in 0..<notes[i].count{
                    moveLine(drumBalls[ball].b01.position, punto2: notes[i][j].note.position, line: drumLines[ball][i][j])
                }
            }
        }
        
        
        
        
        // To activate or unactivate the balls and notes
        for ball in 0..<balls.count{
            if actDoubleTouch == true && balls[ball].active == true && balls[ball].oneClick == true {
                balls[ball].b01.alpha = 0.2
                balls[ball].b02.alpha = 0.2
                balls[ball].b03.alpha = 0.2
                balls[ball].active = false
            } else if actDoubleTouch == true && balls[ball].active == false && balls[ball].oneClick == true {
                balls[ball].b01.alpha = 0.6
                balls[ball].b02.alpha = 0.6
                balls[ball].b03.alpha = 0.6
                balls[ball].active = true
            }
        }
        //
        for ball in 0..<darkBalls.count{
            if actDoubleTouch == true && darkBalls[ball].active == true && darkBalls[ball].oneClick == true {
                darkBalls[ball].b01.alpha = 0.2
                darkBalls[ball].b02.alpha = 0.2
                darkBalls[ball].b03.alpha = 0.2
                darkBalls[ball].active = false
            } else if actDoubleTouch == true && darkBalls[ball].active == false && darkBalls[ball].oneClick == true {
                darkBalls[ball].b01.alpha = 0.6
                darkBalls[ball].b02.alpha = 0.6
                darkBalls[ball].b03.alpha = 0.6
                darkBalls[ball].active = true
            }
        }
        //
        for ball in 0..<drumBalls.count{
            if actDoubleTouch == true && drumBalls[ball].active == true && drumBalls[ball].oneClick == true {
                drumBalls[ball].b01.alpha = 0.2
                drumBalls[ball].active = false
            } else if actDoubleTouch == true && drumBalls[ball].active == false && drumBalls[ball].oneClick == true {
                drumBalls[ball].b01.alpha = 0.6
                drumBalls[ball].active = true
            }
        }
        //
        for i in 0..<notes.count{
            for j in 0..<notes[i].count{
                if actDoubleTouch == true && notes[i][j].active == true && notes[i][j].oneClick == true {
                    notes[i][j].note.alpha = 0.2
                    notes[i][j].active = false
                } else if actDoubleTouch == true && notes[i][j].active == false && notes[i][j].oneClick == true {
                    notes[i][j].note.alpha = 0.6
                    notes[i][j].active = true
                }
            }
        }
        //
        actDoubleTouch = false
        
        
        ////////// REMOVE NODES //////////
        // balls and notes
        if balls.first != nil {
            for ball in 0..<balls.count{
                for i in 0..<notes.count{
                    for j in 0..<notes[i].count{
                        if notes[i][j].note.position.x > (screenW - (screenW * 0.01)) {
                            notes[i][j].removeFromParent()
                            notes[i][j].active = false
                            lines[ball][i][j].removeFromParent()
                            actBalls[ball][i][j].removeFromParent()
                        }
                    }
                }
                
                if balls[ball].b02.position.x > (screenW - (screenW * 0.01)) {
                    balls[ball].removeFromParent()
                    balls[ball].active = false
                    for i in 0..<notes.count{
                        for j in 0..<notes[i].count{
                            lines[ball][i][j].removeFromParent()
                            actBalls[ball][i][j].removeFromParent()
                        }
                    }
                }
            }
        } else {
            for i in 0..<notes.count{
                for j in 0..<notes[i].count{
                    if notes[i][j].note.position.x > (screenW - (screenW * 0.01)) {
                        notes[i][j].removeFromParent()
                    }
                }
            }
        }
        // dark balls
        if darkBalls.first != nil {
            for ball in 0..<darkBalls.count{
                for i in 0..<notes.count{
                    for j in 0..<notes[i].count{
                        if notes[i][j].note.position.x > (screenW - (screenW * 0.01)) {
                            notes[i][j].removeFromParent()
                            notes[i][j].active = false
                            darkLines[ball][i][j].removeFromParent()
                            darkActBalls[ball][i][j].removeFromParent()
                        }
                    }
                }
                
                if darkBalls[ball].b02.position.x > (screenW - (screenW * 0.01)) {
                    darkBalls[ball].removeFromParent()
                    darkBalls[ball].active = false
                    for i in 0..<notes.count{
                        for j in 0..<notes[i].count{
                            darkLines[ball][i][j].removeFromParent()
                            darkActBalls[ball][i][j].removeFromParent()
                        }
                    }
                }
            }
        }
        // drum balls
        if drumBalls.first != nil {
            for ball in 0..<drumBalls.count{
                for i in 0..<notes.count{
                    for j in 0..<notes[i].count{
                        if notes[i][j].note.position.x > (screenW - (screenW * 0.01)) {
                            notes[i][j].removeFromParent()
                            notes[i][j].active = false
                            drumLines[ball][i][j].removeFromParent()
                            drumActBalls[ball][i][j].removeFromParent()
                        }
                    }
                }
                
                if drumBalls[ball].b01.position.x > (screenW - (screenW * 0.01)) {
                    drumBalls[ball].removeFromParent()
                    drumBalls[ball].active = false
                    for i in 0..<notes.count{
                        for j in 0..<notes[i].count{
                            drumLines[ball][i][j].removeFromParent()
                            drumActBalls[ball][i][j].removeFromParent()
                        }
                    }
                }
            }
        }
    }
    /////////////////////////////////////////////////
    
    ////// Timer function //////
    func updateTime() {
        let currentTime = NSDate.timeIntervalSinceReferenceDate()
        elapsedTime = currentTime - startTime
        
        let minTimer = (60.0 / Double(bpm)) * (1 / minBeat)
        
        if elapsedTime >= minTimer{
            click += 1
            startTime = NSDate.timeIntervalSinceReferenceDate()
            
            if click == 9{
                click = 1
            }
        }
    }
    
    ////// Add balls and notes //////
    /// balls
    func addBall(){
        // To generate random position values
        let xPos = randomBetweenNumbers(screenW * 0.05, secondNum: screenW * 0.95)
        let yPos = randomBetweenNumbers(screenH * 0.05, secondNum: screenH * 0.95)
        
        // Creating and positioning the ball
        let ball = CGBall()
        ball.b01.position = CGPointMake(xPos, yPos)
        ball.b02.position = CGPointMake(xPos, yPos)
        ball.b03.position = CGPointMake(xPos, yPos)
        ball.fxb01.position = CGPointMake(xPos, yPos)
        ball.fxb02.position = CGPointMake(xPos, yPos)
        ball.fxb03.position = CGPointMake(xPos, yPos)
        ball.fistBeat = click
        balls.append(ball)
        
        // Creating lines and actBalls arrays in array
        let arrayInLines = [[SKSpriteNode]]()
        lines.append(arrayInLines)
        for _ in 0...7{
            let linesPosition = [SKSpriteNode]()
            lines[numBallsFx].append(linesPosition)
        }
        
        let arrayInActBalls = [[SKSpriteNode]]()
        actBalls.append(arrayInActBalls)
        for _ in 0...7{
            let actBallsPosition = [SKSpriteNode]()
            actBalls[numBallsFx].append(actBallsPosition)
        }
        
        //Reference beat
        let arrayInRefBeats = [[Int]]()
        refBeats.append(arrayInRefBeats)
        for _ in 0...7{
            let refBeatsPosition = [Int]()
            refBeats[numBallsFx].append(refBeatsPosition)
        }
        
        // Scanned if notes exist to create their connection lines and reference beats
        for i in 0..<notes.count{
            for j in 0..<notes[i].count{
                let line = SKSpriteNode(imageNamed: "line")
                let actBall = SKSpriteNode(imageNamed: "ballActive")
                line.alpha = 0.1
                actBall.alpha = 0.0
                actBall.size = CGSize(width: 15.0, height: 15.0)
                lines[numBallsFx][i].append(line)
                actBalls[numBallsFx][i].append(actBall)
                addChild(line)
                addChild(actBall)
                
                moveLine(ball.b02.position, punto2: notes[i][j].note.position, line: lines[numBallsFx][i][j])
                
                let refBeat = 1
                refBeats[numBallsFx][i].append(refBeat)
            }
        }
        
        addChild(ball)  // add ball into screen
        numBallsFx += 1    // add 1 to position of balls array into array
    }
    func addDarkBall(){
        // To generate random position values
        let xPos = randomBetweenNumbers(screenW * 0.05, secondNum: screenW * 0.95)
        let yPos = randomBetweenNumbers(screenH * 0.05, secondNum: screenH * 0.95)
        
        // Creating and positioning the ball
        let darkBall = CGDarkBall()
        darkBall.b01.position = CGPointMake(xPos, yPos)
        darkBall.b02.position = CGPointMake(xPos, yPos)
        darkBall.b03.position = CGPointMake(xPos, yPos)
        darkBall.fxb01.position = CGPointMake(xPos, yPos)
        darkBall.fxb02.position = CGPointMake(xPos, yPos)
        darkBall.fxb03.position = CGPointMake(xPos, yPos)
        darkBall.fistBeat = click
        darkBalls.append(darkBall)
        
        // Creating lines and actBalls arrays in array
        let arrayInDarkLines = [[SKSpriteNode]]()
        darkLines.append(arrayInDarkLines)
        for _ in 0...7{
            let darkLinesPosition = [SKSpriteNode]()
            darkLines[numDarkBallsFx].append(darkLinesPosition)
        }
        
        let arrayInDarkActBalls = [[SKSpriteNode]]()
        darkActBalls.append(arrayInDarkActBalls)
        for _ in 0...7{
            let DarkActBallsPosition = [SKSpriteNode]()
            darkActBalls[numDarkBallsFx].append(DarkActBallsPosition)
        }
        
        //Reference beat
        let arrayInRefDarkBeats = [[Int]]()
        refDarkBeats.append(arrayInRefDarkBeats)
        for _ in 0...7{
            let refDarkBeatsPosition = [Int]()
            refDarkBeats[numDarkBallsFx].append(refDarkBeatsPosition)
        }
        
        // Scanned if notes exist to create their connection lines
        for i in 0..<notes.count{
            for j in 0..<notes[i].count{
                let darkLine = SKSpriteNode(imageNamed: "line")
                let darkActBall = SKSpriteNode(imageNamed: "ballActive")
                darkLine.alpha = 0.1
                darkActBall.alpha = 0.0
                darkActBall.size = CGSize(width: 15.0, height: 15.0)
                darkLines[numDarkBallsFx][i].append(darkLine)
                darkActBalls[numDarkBallsFx][i].append(darkActBall)
                addChild(darkLine)
                addChild(darkActBall)
                
                moveLine(darkBall.b02.position, punto2: notes[i][j].note.position, line: darkLines[numDarkBallsFx][i][j])
                
                let refDarkBeat = 1
                refDarkBeats[numDarkBallsFx][i].append(refDarkBeat)
            }
        }
        
        addChild(darkBall)  // add ball into screen
        numDarkBallsFx += 1    // add 1 to position of balls array into array
    }
    func addDrum(){
        // To generate random position values
        let xPos = randomBetweenNumbers(screenW * 0.05, secondNum: screenW * 0.95)
        let yPos = randomBetweenNumbers(screenH * 0.05, secondNum: screenH * 0.95)
        
        // Creating and positioning the ball
        let drumBall = CGDrum()
        drumBall.b01.position = CGPointMake(xPos, yPos)
        drumBall.fxb01.position = CGPointMake(xPos, yPos)
        drumBall.fistBeat = click
        drumBalls.append(drumBall)
        
        // Creating lines and actBalls arrays in array
        let arrayInDrumLines = [[SKSpriteNode]]()
        drumLines.append(arrayInDrumLines)
        for _ in 0...7{
            let drumLinesPosition = [SKSpriteNode]()
            drumLines[numDrumBallsFx].append(drumLinesPosition)
        }
        
        let arrayInDrumActBalls = [[SKSpriteNode]]()
        drumActBalls.append(arrayInDrumActBalls)
        for _ in 0...7{
            let DrumActBallsPosition = [SKSpriteNode]()
            drumActBalls[numDrumBallsFx].append(DrumActBallsPosition)
        }
        
        //Reference beat
        let arrayInRefDrumBeats = [[Int]]()
        refDrumBeats.append(arrayInRefDrumBeats)
        for _ in 0...7{
            let refDrumBeatPosition = [Int]()
            refDrumBeats[numDrumBallsFx].append(refDrumBeatPosition)
        }
        
        // Scanned if notes exist to create their connection lines
        for i in 0..<notes.count{
            for j in 0..<notes[i].count{
                let drumLine = SKSpriteNode(imageNamed: "line")
                let drumActBall = SKSpriteNode(imageNamed: "ballActive")
                drumLine.alpha = 0.1
                drumActBall.alpha = 0.0
                drumActBall.size = CGSize(width: 15.0, height: 15.0)
                drumLines[numDrumBallsFx][i].append(drumLine)
                drumActBalls[numDrumBallsFx][i].append(drumActBall)
                addChild(drumLine)
                addChild(drumActBall)
                
                moveLine(drumBall.b01.position, punto2: notes[i][j].note.position, line: drumLines[numDrumBallsFx][i][j])
                
                let refDrumBeat = 1
                refDrumBeats[numDrumBallsFx][i].append(refDrumBeat)
            }
        }
        
        addChild(drumBall)  // add ball into screen
        numDrumBallsFx += 1    // add 1 to position of balls array into array
    }
    /// notes
    func addNote0(){
        addNote(0)
    }
    func addNote1(){
        addNote(1)
    }
    func addNote2(){
        addNote(2)
    }
    func addNote3(){
        addNote(3)
    }
    func addNote4(){
        addNote(4)
    }
    func addNote5(){
        addNote(5)
    }
    func addNote6(){
        addNote(6)
    }
    func addNote7(){
        addNote(7)
    }
    /// notes make function
    func addNote(selNote: Int){
        // To generate random position values
        let xPos = randomBetweenNumbers(screenW * 0.05, secondNum: screenW * 0.95)
        let yPos = randomBetweenNumbers(screenH * 0.05, secondNum: screenH * 0.95)
        
        // Creating and positioning the note
        let note = CGNote(noteImg: imgNoteNames[selNote], noteFxImg: imgFxNoteNames[selNote], size: sizeNotes[selNote])
        note.note.position = CGPointMake(xPos, yPos)
        note.fxNote.position = CGPointMake(xPos, yPos)
        notes[selNote].append(note)
        addChild(note)
        
        // Scanned if balls exist to create their connection lines
        for ball in 0..<balls.count{
            for note in 0..<notes.count{
                
                if note == selNote {
                    let line = SKSpriteNode(imageNamed: "line")
                    let actBall = SKSpriteNode(imageNamed: "ballActive")
                    line.alpha = 0.1
                    actBall.alpha = 0.0
                    actBall.size = CGSize(width: 15.0, height: 15.0)
                    lines[ball][note].append(line)
                    actBalls[ball][note].append(actBall)
                    addChild(line)
                    addChild(actBall)
                    
                    for j in 0..<notes[note].count{
                        moveLine(balls[ball].b02.position, punto2: notes[note][j].note.position, line: lines[ball][note][j])
                    }
                    
                    let refBeat = 1
                    refBeats[ball][note].append(refBeat)
                }
            }
        }
        
        // Scanned if dark balls exist to create their connection lines
        for ball in 0..<darkBalls.count{
            for note in 0..<notes.count{
                if note == selNote {
                    let darkLine = SKSpriteNode(imageNamed: "line")
                    let darkActBall = SKSpriteNode(imageNamed: "ballActive")
                    darkLine.alpha = 0.1
                    darkActBall.alpha = 0.1
                    darkActBall.size = CGSize(width: 15.0, height: 15.0)
                    darkLines[ball][note].append(darkLine)
                    darkActBalls[ball][note].append(darkActBall)
                    addChild(darkLine)
                    addChild(darkActBall)
                    
                    for j in 0..<notes[note].count{
                        moveLine(darkBalls[ball].b02.position, punto2: notes[note][j].note.position, line: darkLines[ball][note][j])
                    }
                    
                    let refDarkBeat = 1
                    refDarkBeats[ball][note].append(refDarkBeat)
                }
            }
        }
        
        // Scanned if drum balls exist to create their connection lines
        for ball in 0..<drumBalls.count{
            for note in 0..<notes.count{
                if note == selNote {
                    let drumLine = SKSpriteNode(imageNamed: "line")
                    let drumActBall = SKSpriteNode(imageNamed: "ballActive")
                    drumLine.alpha = 0.1
                    drumActBall.alpha = 0.1
                    drumActBall.size = CGSize(width: 15.0, height: 15.0)
                    drumLines[ball][note].append(drumLine)
                    drumActBalls[ball][note].append(drumActBall)
                    addChild(drumLine)
                    addChild(drumActBall)
                    
                    for j in 0..<notes[note].count{
                        moveLine(drumBalls[ball].b01.position, punto2: notes[note][j].note.position, line: drumLines[ball][note][j])
                    }
                    
                    let refDrumBeat = 1
                    refDrumBeats[ball][note].append(refDrumBeat)
                }
            }
        }
    }
    
    
    ////// Select musitian scale
    func selectScale (select: Int) {
        
        switch select {
        case 0:
            musicScale = [60, 62, 65, 67, 69, 72, 74, 77] //MelodyScale
        case 1:
            musicScale = [60, 62, 64, 65, 67, 69, 71, 72] //Major
        case 2:
            musicScale = [72, 74, 75, 77, 79, 80, 82, 84] //Natural minor
        case 3:
            musicScale = [72, 74, 75, 77, 79, 80, 83, 84] //Harmonic minor
        case 4:
            musicScale = [72, 74, 75, 77, 79, 81, 83, 84] //Melodic minor
        case 5:
            musicScale = [72, 74, 76, 78, 80, 82, 84, 86] //whole tones
        case 6:
            musicScale = [72, 73, 75, 76, 77, 80, 81, 84] //Chromatic
        case 7:
            musicScale = [72, 74, 76, 79, 81, 84, 87, 89] //Mayor pentatonic
        case 8:
            musicScale = [72, 75, 77, 79, 82, 84, 87, 89] //Minor pentatonic
        case 9:
            musicScale = [72, 75, 76, 77, 78, 79, 82, 83] //Octatonic
        default:
            break
        }
    }
    
    
    ////// Action balls functions //////
    ////////// balls
    func fxBallsStart(click: Int){
        let secb1 = SKAction.sequence([SKAction.scaleTo(0.1, duration: 0.0),
            SKAction.scaleTo(0.2, duration: NSTimeInterval(durRef * 0.15)),
            SKAction.scaleTo(0.3, duration: NSTimeInterval(durRef * 0.85))
            ])
        //let secb2 = SKAction.sequence([SKAction.fadeInWithDuration(0.0),
        //SKAction.fadeOutWithDuration(NSTimeInterval(durRef))])
        let secb2 = SKAction.sequence([SKAction.fadeAlphaTo(0.0, duration: NSTimeInterval(durRef * 0.0)),
            SKAction.fadeAlphaTo(1.0, duration: NSTimeInterval(durRef * 0.05)),
            SKAction.fadeAlphaTo(0.0, duration: NSTimeInterval(durRef * 0.95))
            ])
        
        for i in 0..<balls.count{
            if balls[i].fistBeat == click && balls[i].active == true {
                balls[i].fxb01.runAction(secb1)
                balls[i].fxb01.runAction(secb2)
                
                balls[i].fxb02.runAction(secb1)
                balls[i].fxb02.runAction(secb2)
                
                balls[i].fxb03.runAction(secb1)
                balls[i].fxb03.runAction(secb2)
            }
        }
    }
    //movement in active balls
    func movntActBalls(fbeat: Int){
        
        var timeMove = 0.0
        
        for ball in 0..<balls.count{
            for i in 0..<notes.count{
                for j in 0..<notes[i].count{
                    if balls[ball].fistBeat == fbeat && lines[ball][i][j].size.width < lnDiv[7] && balls[ball].active == true && notes[i][j].active == true {
                        
                        switch refBeats[ball][i][j] {
                        case 1:
                            timeMove = durRef * 0.0
                        case 2:
                            timeMove = durRef * 0.125
                        case 3:
                            timeMove = durRef * 0.250
                        case 4:
                            timeMove = durRef * 0.375
                        case 5:
                            timeMove = durRef * 0.500
                        case 6:
                            timeMove = durRef * 0.625
                        case 7:
                            timeMove = durRef * 0.750
                        case 8:
                            timeMove = durRef * 0.875
                        default:
                            break
                        }
                        
                        let sec1 = SKAction.sequence([SKAction.moveTo(balls[ball].b02.position, duration: 0.0),
                            SKAction.moveTo(notes[i][j].note.position, duration: NSTimeInterval(timeMove))
                            ])
                        let sec2 = SKAction.sequence([SKAction.fadeInWithDuration(timeMove * 0.95), SKAction.fadeOutWithDuration(timeMove * 0.05)])
                        actBalls[ball][i][j].runAction(sec1)
                        actBalls[ball][i][j].runAction(sec2)
                    }
                }
            }
        }
    }
    
    ////////// Dark balls
    func fxDarkBallsStart(click: Int){
        let secb1 = SKAction.sequence([SKAction.scaleTo(0.1, duration: 0.0),
            SKAction.scaleTo(0.2, duration: NSTimeInterval(durRef * 0.15)),
            SKAction.scaleTo(0.3, duration: NSTimeInterval(durRef * 0.85))
            ])
        let secb2 = SKAction.sequence([SKAction.fadeAlphaTo(0.0, duration: NSTimeInterval(durRef * 0.0)),
            SKAction.fadeAlphaTo(1.0, duration: NSTimeInterval(durRef * 0.05)),
            SKAction.fadeAlphaTo(0.0, duration: NSTimeInterval(durRef * 0.95))
            ])
        
        for i in 0..<darkBalls.count{
            if darkBalls[i].fistBeat == click && darkBalls[i].active == true {
                darkBalls[i].fxb01.runAction(secb1)
                darkBalls[i].fxb01.runAction(secb2)
                
                darkBalls[i].fxb02.runAction(secb1)
                darkBalls[i].fxb02.runAction(secb2)
                
                darkBalls[i].fxb03.runAction(secb1)
                darkBalls[i].fxb03.runAction(secb2)
            }
        }
    }
    //movement in active dark balls
    func movntDarkActBalls(fbeat: Int){
        
        var timeMove = 0.0
        
        for ball in 0..<darkBalls.count{
            for i in 0..<notes.count{
                for j in 0..<notes[i].count{
                    if darkBalls[ball].fistBeat == fbeat && darkLines[ball][i][j].size.width < lnDiv[7] && darkBalls[ball].active == true && notes[i][j].active == true {
                        
                        switch refDarkBeats[ball][i][j] {
                        case 1:
                            timeMove = durRef * 0.0
                        case 2:
                            timeMove = durRef * 0.125
                        case 3:
                            timeMove = durRef * 0.250
                        case 4:
                            timeMove = durRef * 0.375
                        case 5:
                            timeMove = durRef * 0.500
                        case 6:
                            timeMove = durRef * 0.625
                        case 7:
                            timeMove = durRef * 0.750
                        case 8:
                            timeMove = durRef * 0.875
                        default:
                            break
                        }
                        
                        let sec1 = SKAction.sequence([SKAction.moveTo(darkBalls[ball].b02.position, duration: 0.0),
                            SKAction.moveTo(notes[i][j].note.position, duration: NSTimeInterval(timeMove))
                            ])
                        let sec2 = SKAction.sequence([SKAction.fadeInWithDuration(timeMove * 0.95), SKAction.fadeOutWithDuration(timeMove * 0.05)])
                        darkActBalls[ball][i][j].runAction(sec1)
                        darkActBalls[ball][i][j].runAction(sec2)
                    }
                }
            }
        }
    }
    
    ////////// Drum balls
    func fxDrumBallsStart(click: Int){
        let secb1 = SKAction.sequence([SKAction.scaleTo(0.1, duration: 0.0),
            SKAction.scaleTo(0.2, duration: NSTimeInterval(durRef * 0.15)),
            SKAction.scaleTo(0.3, duration: NSTimeInterval(durRef * 0.85))
            ])
        let secb2 = SKAction.sequence([SKAction.fadeAlphaTo(0.0, duration: NSTimeInterval(durRef * 0.0)),
            SKAction.fadeAlphaTo(1.0, duration: NSTimeInterval(durRef * 0.05)),
            SKAction.fadeAlphaTo(0.0, duration: NSTimeInterval(durRef * 0.95))
            ])
        
        for i in 0..<drumBalls.count{
            if drumBalls[i].fistBeat == click && drumBalls[i].active == true {
                drumBalls[i].fxb01.runAction(secb1)
                drumBalls[i].fxb01.runAction(secb2)
            }
        }
    }
    //movement in active drum balls
    func movntDrumActBalls(fbeat: Int){
        
        var timeMove = 0.0
        
        for ball in 0..<drumBalls.count{
            for i in 0..<notes.count{
                for j in 0..<notes[i].count{
                    if drumBalls[ball].fistBeat == fbeat && drumLines[ball][i][j].size.width < lnDiv[7] && drumBalls[ball].active == true && notes[i][j].active == true {
                        
                        switch refDrumBeats[ball][i][j] {
                        case 1:
                            timeMove = durRef * 0.0
                        case 2:
                            timeMove = durRef * 0.125
                        case 3:
                            timeMove = durRef * 0.250
                        case 4:
                            timeMove = durRef * 0.375
                        case 5:
                            timeMove = durRef * 0.500
                        case 6:
                            timeMove = durRef * 0.625
                        case 7:
                            timeMove = durRef * 0.750
                        case 8:
                            timeMove = durRef * 0.875
                        default:
                            break
                        }
                        
                        let sec1 = SKAction.sequence([SKAction.moveTo(drumBalls[ball].b01.position, duration: 0.0),
                            SKAction.moveTo(notes[i][j].note.position, duration: NSTimeInterval(timeMove))
                            ])
                        let sec2 = SKAction.sequence([SKAction.fadeInWithDuration(timeMove * 0.95), SKAction.fadeOutWithDuration(timeMove * 0.05)])
                        drumActBalls[ball][i][j].runAction(sec1)
                        drumActBalls[ball][i][j].runAction(sec2)
                    }
                }
            }
        }
    }
    
    
    
    /////////// Play a sound in balls ////////////   //////////////////////////   ////////////////////////
    ////////// balls
    func actSounds(fbeat: Int, rbeat: Int){
        for ball in 0..<balls.count{
            for i in 0..<notes.count{
                for j in 0..<notes[i].count{
                    if balls[ball].fistBeat == fbeat && refBeats[ball][i][j] == rbeat && balls[ball].active == true {
                        if notes[i][j].active == true {
                            fxNotesStart(notes[i][j])
                            osc1.amplitude = balls[ball].volume
                            osc1.play()
                        }
                    }
                }
            }
        }
    }
    
    
    ////////// darkBalls
    func actDarkSounds(fbeat: Int, rbeat: Int){
        for ball in 0..<darkBalls.count{
            for i in 0..<notes.count{
                for j in 0..<notes[i].count{
                    if darkBalls[ball].fistBeat == fbeat && refDarkBeats[ball][i][j] == rbeat && darkBalls[ball].active == true {
                        if notes[i][j].active == true {
                            // note fx
                            fxNotesStart(notes[i][j])
                            
                            // sounds
                            switch darkBalls[ball].selBall {
                            case 1:
                                //patch?.tr01Amp(darkBalls[ball].volume) //////////////////////////////////////////////////////
                                //patch?.tr01Trig(1)
                                break
                            case 2:
                                //patch?.squa01Amp(darkBalls[ball].volume) //////////////////////////////////////////////////////
                                //patch?.squa01Trig(1)
                                break
                            case 3:
                                //patch?.effe01Amp(darkBalls[ball].volume) //////////////////////////////////////////////////////
                                //patch?.effe01Trig(1)
                                break
                            default:
                                break
                            }
                            
                        }
                    }
                }
            }
        }
    }
    
    
    ////////// drums
    func actDrumSounds(fbeat: Int, rbeat: Int){
        for ball in 0..<drumBalls.count{
            for i in 0..<notes.count{
                for j in 0..<notes[i].count{
                    if drumBalls[ball].fistBeat == fbeat && refDrumBeats[ball][i][j] == rbeat && drumBalls[ball].active == true {
                        if notes[i][j].active == true {
                            fxNotesStart(notes[i][j])
                            //patch?.drum01Amp(drumBalls[ball].volume) //////////////////////////////////////////////////////
                            //patch?.drum01Act(Float(i)) //////////////////////////////////////////////////////
                        }
                    }
                }
            }
        }
    }
    
    
    
    //Activate notes fx
    func fxNotesStart(note: CGNote){
        let secb1 = SKAction.sequence([SKAction.scaleTo(0.2, duration: 0.0),
            SKAction.scaleTo(0.4, duration: NSTimeInterval(durRef * 0.15)),
            SKAction.scaleTo(0.6, duration: NSTimeInterval(durRef * 0.85))
            ])
        let secb2 = SKAction.sequence([SKAction.fadeInWithDuration(0.0),
            SKAction.fadeOutWithDuration(NSTimeInterval(durRef))])
        
        note.fxNote.runAction(secb1)
        note.fxNote.runAction(secb2)
    }
    
    
    ////// Action lines functions //////
    ////////// Movement of the line func
    func moveLine(punto1: CGPoint, punto2: CGPoint, line: SKSpriteNode) {
        //Center
        line.position = CGPointMake((punto1.x + punto2.x) / 2.0, (punto1.y + punto2.y) / 2.0)
        
        let long = distance(punto1, p2: punto2)
        
        //Length of the line
        line.size = CGSize(width: long, height: screenH * 0.015)
        
        
        //Rotation
        let longX = punto2.x - punto1.x
        
        let longY = punto2.y - punto1.y
        
        let tan = longY / longX
        let angulo = atan(tan)
        
        line.zRotation = angulo
    }
    
    ////// Simplify Functions //////
    //Generate a random CGFloat number
    func randomBetweenNumbers(firstNum: CGFloat, secondNum: CGFloat) -> CGFloat{
        return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs(firstNum - secondNum) + min(firstNum, secondNum)
    }
    //Function to obtain distance
    func distance(p1: CGPoint, p2: CGPoint) -> CGFloat{
        let dist:CGFloat = sqrt(pow(p1.y - p2.y, 2.0) + pow(p1.x - p2.x, 2.0))
        return dist
    }
    
    ////// UI Gesture Recognizer //////
    func handleRotation(gesture: UIRotationGestureRecognizer){
        
        movRot = (CGFloat(gesture.rotation)) * -1
        
        let p1:CGPoint = gesture.locationOfTouch(0, inView: self.view)
        let p2:CGPoint = gesture.locationOfTouch(1, inView: self.view)
        
        switch gesture.state {
        case .Began:
            for ball in 0..<balls.count{
                if self.nodeAtPoint(p1) == self.balls[ball].b01 && self.nodeAtPoint(p2) == self.balls[ball].b01 || self.nodeAtPoint(p1) == self.balls[ball].b02 && self.nodeAtPoint(p2) == self.balls[ball].b02 || self.nodeAtPoint(p1) == self.balls[ball].b03 && self.nodeAtPoint(p2) == self.balls[ball].b03 {
                    balls[ball].inRot = balls[ball].fnRot
                    balls[ball].actRot = 1
                }
            }
            for ball in 0..<darkBalls.count{
                if self.nodeAtPoint(p1) == self.darkBalls[ball].b01 && self.nodeAtPoint(p2) == self.darkBalls[ball].b01 || self.nodeAtPoint(p1) == self.darkBalls[ball].b02 && self.nodeAtPoint(p2) == self.darkBalls[ball].b02 || self.nodeAtPoint(p1) == self.darkBalls[ball].b03 && self.nodeAtPoint(p2) == self.darkBalls[ball].b03 {
                    darkBalls[ball].inRot = darkBalls[ball].fnRot
                    darkBalls[ball].actRot = 1
                }
            }
            
            /// Tempo
            if self.nodeAtPoint(p1) == self.masterTempo && self.nodeAtPoint(p2) == self.masterTempo {
                tempoInRot = tempoFnRot
                tempoActRot = 1
                bpmBn = bpmFn
            }
            
            /// Key
            if self.nodeAtPoint(p1) == self.masterKey && self.nodeAtPoint(p2) == self.masterKey {
                keyInRot = keyFnRot
                keyActRot = 1
            }
            
            /// Volume
            if self.nodeAtPoint(p1) == self.masterAmp && self.nodeAtPoint(p2) == self.masterAmp {
                ampInRot = ampFnRot
                volumeIn = volumeFn
                ampActRot = 1
            }
            
        case .Changed:
            for ball in 0..<balls.count{
                if balls[ball].actRot == 1 {
                    balls[ball].b01.zRotation = balls[ball].inRot + movRot
                    balls[ball].b02.zRotation = balls[ball].inRot + movRot
                    balls[ball].b03.zRotation = balls[ball].inRot + movRot
                    
                    if balls[ball].b02.zRotation < -2.5 {
                        balls[ball].b01.hidden = true
                        balls[ball].fxb01.hidden = true
                        balls[ball].b02.hidden = true
                        balls[ball].fxb02.hidden = true
                        balls[ball].b03.hidden = false
                        balls[ball].fxb03.hidden = false
                        balls[ball].octave = 12
                    }
                    if -2.5 <= balls[ball].b02.zRotation && balls[ball].b02.zRotation <= 2.5 {
                        balls[ball].b01.hidden = true
                        balls[ball].fxb01.hidden = true
                        balls[ball].b02.hidden = false
                        balls[ball].fxb02.hidden = false
                        balls[ball].b03.hidden = true
                        balls[ball].fxb03.hidden = true
                        balls[ball].octave = 0
                    }
                    if balls[ball].b02.zRotation > 2.5 {
                        balls[ball].b01.hidden = false
                        balls[ball].fxb01.hidden = false
                        balls[ball].b02.hidden = true
                        balls[ball].fxb02.hidden = true
                        balls[ball].b03.hidden = true
                        balls[ball].fxb03.hidden = true
                        balls[ball].octave = -12
                    }
                }
            }
            for ball in 0..<darkBalls.count{
                if darkBalls[ball].actRot == 1 {
                    darkBalls[ball].b01.zRotation = darkBalls[ball].inRot + movRot
                    darkBalls[ball].b02.zRotation = darkBalls[ball].inRot + movRot
                    darkBalls[ball].b03.zRotation = darkBalls[ball].inRot + movRot
                    
                    if darkBalls[ball].b02.zRotation < -2.5 {
                        darkBalls[ball].b01.hidden = true
                        darkBalls[ball].fxb01.hidden = true
                        darkBalls[ball].b02.hidden = true
                        darkBalls[ball].fxb02.hidden = true
                        darkBalls[ball].b03.hidden = false
                        darkBalls[ball].fxb03.hidden = false
                        darkBalls[ball].selBall = 1
                    }
                    if -2.5 <= darkBalls[ball].b02.zRotation && darkBalls[ball].b02.zRotation <= 2.5 {
                        darkBalls[ball].b01.hidden = true
                        darkBalls[ball].fxb01.hidden = true
                        darkBalls[ball].b02.hidden = false
                        darkBalls[ball].fxb02.hidden = false
                        darkBalls[ball].b03.hidden = true
                        darkBalls[ball].fxb03.hidden = true
                        darkBalls[ball].selBall = 2
                    }
                    if darkBalls[ball].b02.zRotation > 2.5 {
                        darkBalls[ball].b01.hidden = false
                        darkBalls[ball].fxb01.hidden = false
                        darkBalls[ball].b02.hidden = true
                        darkBalls[ball].fxb02.hidden = true
                        darkBalls[ball].b03.hidden = true
                        darkBalls[ball].fxb03.hidden = true
                        darkBalls[ball].selBall = 3
                    }
                }
            }
            
            /// Tempo
            if tempoActRot == 1 {
                
                if bpm < 0 {
                    tempoFnRot = tempoInRot + movRot
                    bpm = 0
                    bpmFn = 0
                    tempoActRot = 0
                } else {
                    masterTempo.zRotation = tempoInRot + movRot
                    bpm = bpmBn - Int(movRot * 20.0)
                    let sec = SKAction.sequence([SKAction.fadeInWithDuration(0.5),
                        SKAction.fadeOutWithDuration(NSTimeInterval(1.0))])
                    
                    bpmLabel.runAction(sec)
                }
                
                bpmLabel.text = "bpm: \(bpm)"
            }
            
            /// Key
            if keyActRot == 1 {
                masterKey.zRotation = keyInRot + movRot
                switch masterKey.zRotation {
                case (-2.4)...(-2.2):
                    semiTone = 12
                    keyLabel.text = "key: C+1"
                case (-2.2)...(-2.0):
                    semiTone = 11
                    keyLabel.text = "key: +B"
                case (-2.0)...(-1.8):
                    semiTone = 10
                    keyLabel.text = "key: +A#"
                case (-1.8)...(-1.6):
                    semiTone = 9
                    keyLabel.text = "key: +A"
                case (-1.6)...(-1.4):
                    semiTone = 8
                    keyLabel.text = "key: +G#"
                case (-1.4)...(-1.2):
                    semiTone = 7
                    keyLabel.text = "key: +G"
                case (-1.2)...(-1.0):
                    semiTone = 6
                    keyLabel.text = "key: +F#"
                case (-1.0)...(-0.8):
                    semiTone = 5
                    keyLabel.text = "key: +F"
                case (-0.8)...(-0.6):
                    semiTone = 4
                    keyLabel.text = "key: +E"
                case (-0.6)...(-0.4):
                    semiTone = 3
                    keyLabel.text = "key: +D#"
                case (-0.4)...(-0.2):
                    semiTone = 2
                    keyLabel.text = "key: +D"
                case (-0.2)...(-0.0):
                    semiTone = 1
                    keyLabel.text = "key: +C#"
                case (0.0)...(0.2):
                    semiTone = 0
                    keyLabel.text = "key: C"
                case (0.2)...(0.4):
                    semiTone = -1
                    keyLabel.text = "key: -B"
                case (0.4)...(0.6):
                    semiTone = -2
                    keyLabel.text = "key: -Bb"
                case (0.6)...(0.8):
                    semiTone = -3
                    keyLabel.text = "key: -A"
                case (0.8)...(1.0):
                    semiTone = -4
                    keyLabel.text = "key: -Ab"
                case (1.0)...(1.2):
                    semiTone = -5
                    keyLabel.text = "key: -G"
                case (1.2)...(1.4):
                    semiTone = -6
                    keyLabel.text = "key: -Gb"
                case (1.4)...(1.6):
                    semiTone = -7
                    keyLabel.text = "key: -F"
                case (1.6)...(1.8):
                    semiTone = -8
                    keyLabel.text = "key: -E"
                case (1.8)...(2.0):
                    semiTone = -9
                    keyLabel.text = "key: -Eb"
                case (2.0)...(2.2):
                    semiTone = -10
                    keyLabel.text = "key: -D"
                case (2.2)...(2.4):
                    semiTone = -11
                    keyLabel.text = "key: -Db"
                case (2.4)...(2.6):
                    semiTone = -12
                    keyLabel.text = "key: C-1"
                default:
                    break
                }
                let secKey = SKAction.sequence([SKAction.fadeInWithDuration(0.5), SKAction.fadeOutWithDuration(NSTimeInterval(1.0))])
                keyLabel.runAction(secKey)
            }
            
            /// Volume
            if ampActRot == 1 {
                masterAmp.zRotation = ampInRot + movRot
                volume = volumeIn - Int(movRot * 10)
                
                if 0 <= volume && volume <= 100 {
                    
                    // patch?.masterAmp(Float(volume) / 100.0) //////////////////////////////////////////////////////
                    ampLabel.text = "vol: \(volume)"
                    let secAmp = SKAction.sequence([SKAction.fadeInWithDuration(0.5), SKAction.fadeOutWithDuration(NSTimeInterval(1.0))])
                    ampLabel.runAction(secAmp)
                } else if volume < 0 {
                    volume = 0
                } else {
                    volume = 100
                }
                
            }
            
            
        case .Ended:
            for ball in 0..<balls.count{
                if balls[ball].actRot == 1 {
                    balls[ball].fnRot = balls[ball].inRot + movRot
                    balls[ball].actRot = 0
                }
            }
            for ball in 0..<darkBalls.count{
                if darkBalls[ball].actRot == 1 {
                    darkBalls[ball].fnRot = darkBalls[ball].inRot + movRot
                    darkBalls[ball].actRot = 0
                }
            }
            
            /// Tempo
            if tempoActRot == 1 {
                tempoFnRot = tempoInRot + movRot
                bpmFn = bpmBn - Int(movRot * 20.0)
                tempoActRot = 0
            }
            
            /// Key
            if keyActRot == 1 {
                keyFnRot = keyInRot + movRot
                keyActRot = 0
            }
            
            /// Volume
            if ampActRot == 1 {
                if 0 <= volume && volume <= 100 {
                    volumeFn = volumeIn - Int(movRot * 10)
                }
                ampFnRot = ampInRot + movRot
                ampActRot = 0
            }
        default:
            break
        }
    }
    
    
    
    func handelSize(gesture: UIPinchGestureRecognizer){
        let p1:CGPoint = gesture.locationOfTouch(0, inView: self.view)
        let p2:CGPoint = gesture.locationOfTouch(1, inView: self.view)
        
        switch gesture.state {
        case .Began:
            for ball in 0..<balls.count{
                if self.nodeAtPoint(p1) == self.balls[ball].b01 && self.nodeAtPoint(p2) == self.balls[ball].b01 || self.nodeAtPoint(p1) == self.balls[ball].b02 && self.nodeAtPoint(p2) == self.balls[ball].b02 || self.nodeAtPoint(p1) == self.balls[ball].b03 && self.nodeAtPoint(p2) == self.balls[ball].b03 {
                    balls[ball].actLong = 1
                }
            }
            for ball in 0..<darkBalls.count{
                if self.nodeAtPoint(p1) == self.darkBalls[ball].b01 && self.nodeAtPoint(p2) == self.darkBalls[ball].b01 || self.nodeAtPoint(p1) == self.darkBalls[ball].b02 && self.nodeAtPoint(p2) == self.darkBalls[ball].b02 || self.nodeAtPoint(p1) == self.darkBalls[ball].b03 && self.nodeAtPoint(p2) == self.darkBalls[ball].b03 {
                    darkBalls[ball].actLong = 1
                }
            }
            for ball in 0..<drumBalls.count{
                if self.nodeAtPoint(p1) == self.drumBalls[ball].b01 && self.nodeAtPoint(p2) == self.drumBalls[ball].b01 {
                    drumBalls[ball].actLong = 1
                }
            }
        case .Changed:
            for ball in 0..<balls.count{
                // balls
                if balls[ball].actLong == 1 /*&& 80.0 <= balls[ball].b02.size.width*/ && balls[ball].b02.size.width <= maxlenght {
                    balls[ball].long = distance(p1, p2: p2)
                    balls[ball].b01.size = CGSize(width: balls[ball].long, height: balls[ball].long)
                    balls[ball].b02.size = CGSize(width: balls[ball].long, height: balls[ball].long)
                    balls[ball].b03.size = CGSize(width: balls[ball].long, height: balls[ball].long)
                    
                    balls[ball].fxb01.size = CGSize(width: balls[ball].long * 1.5, height: balls[ball].long * 1.5)
                    balls[ball].fxb02.size = CGSize(width: balls[ball].long * 1.5, height: balls[ball].long * 1.5)
                    balls[ball].fxb03.size = CGSize(width: balls[ball].long * 1.5, height: balls[ball].long * 1.5)
                    
                    balls[ball].volume = Double(balls[ball].long / maxlenght)
                }
                /*if balls[ball].actLong == 1 && balls[ball].b02.size.width < 80.0 {
                 balls[ball].b02.size = CGSize(width: 80.0, height: 80.0)
                 balls[ball].actLong = 0
                 }*/
                if balls[ball].actLong == 1 && balls[ball].b02.size.width > maxlenght{
                    balls[ball].b01.size = CGSize(width: maxlenght, height: maxlenght)
                    balls[ball].b02.size = CGSize(width: maxlenght, height: maxlenght)
                    balls[ball].b03.size = CGSize(width: maxlenght, height: maxlenght)
                    balls[ball].fxb01.size = CGSize(width: maxlenght * 1.3, height: maxlenght * 1.3)
                    balls[ball].fxb02.size = CGSize(width: maxlenght * 1.3, height: maxlenght * 1.3)
                    balls[ball].fxb03.size = CGSize(width: maxlenght * 1.3, height: maxlenght * 1.3)
                    balls[ball].actLong = 0
                }
            }
            // dark balls
            for ball in 0..<darkBalls.count{
                if darkBalls[ball].actLong == 1 && darkBalls[ball].b02.size.width <= maxlenght {
                    darkBalls[ball].long = distance(p1, p2: p2)
                    darkBalls[ball].b01.size = CGSize(width: darkBalls[ball].long, height: darkBalls[ball].long)
                    darkBalls[ball].b02.size = CGSize(width: darkBalls[ball].long, height: darkBalls[ball].long)
                    darkBalls[ball].b03.size = CGSize(width: darkBalls[ball].long, height: darkBalls[ball].long)
                    
                    darkBalls[ball].fxb01.size = CGSize(width: darkBalls[ball].long * 1.5, height: darkBalls[ball].long * 1.5)
                    darkBalls[ball].fxb02.size = CGSize(width: darkBalls[ball].long * 1.5, height: darkBalls[ball].long * 1.5)
                    darkBalls[ball].fxb03.size = CGSize(width: darkBalls[ball].long * 1.5, height: darkBalls[ball].long * 1.5)
                    
                    darkBalls[ball].volume = Float((darkBalls[ball].long / maxlenght) - (0.3))
                }
                if darkBalls[ball].actLong == 1 && darkBalls[ball].b02.size.width > maxlenght{
                    darkBalls[ball].b01.size = CGSize(width: maxlenght, height: maxlenght)
                    darkBalls[ball].b02.size = CGSize(width: maxlenght, height: maxlenght)
                    darkBalls[ball].b03.size = CGSize(width: maxlenght, height: maxlenght)
                    darkBalls[ball].fxb01.size = CGSize(width: maxlenght * 1.3, height: maxlenght * 1.3)
                    darkBalls[ball].fxb02.size = CGSize(width: maxlenght * 1.3, height: maxlenght * 1.3)
                    darkBalls[ball].fxb03.size = CGSize(width: maxlenght * 1.3, height: maxlenght * 1.3)
                    darkBalls[ball].actLong = 0
                }
            }
            // drum balls
            for ball in 0..<drumBalls.count{
                if drumBalls[ball].actLong == 1 && drumBalls[ball].b01.size.width <= maxlenght {
                    drumBalls[ball].long = distance(p1, p2: p2)
                    drumBalls[ball].b01.size = CGSize(width: drumBalls[ball].long, height: drumBalls[ball].long)
                    
                    drumBalls[ball].fxb01.size = CGSize(width: drumBalls[ball].long * 1.5, height: drumBalls[ball].long * 1.5)
                    
                    drumBalls[ball].volume = Float((drumBalls[ball].long / maxlenght) - (0.3))
                }
                if drumBalls[ball].actLong == 1 && drumBalls[ball].b01.size.width > maxlenght{
                    drumBalls[ball].b01.size = CGSize(width: maxlenght, height: maxlenght)
                    drumBalls[ball].actLong = 0
                }
            }
            
        case .Ended:
            for ball in 0..<balls.count{
                if balls[ball].actLong == 1 {
                    balls[ball].actLong = 0
                }
            }
            for ball in 0..<darkBalls.count{
                if darkBalls[ball].actLong == 1 {
                    darkBalls[ball].actLong = 0
                }
            }
            for ball in 0..<drumBalls.count{
                if drumBalls[ball].actLong == 1 {
                    drumBalls[ball].actLong = 0
                }
            }
        default:
            break
        }
    }
    
    func doubleTap(gesture: UITapGestureRecognizer){
        actDoubleTouch = true
    }

    
}
