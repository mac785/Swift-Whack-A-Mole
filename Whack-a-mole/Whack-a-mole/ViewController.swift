//
//  ViewController.swift
//  Whack-a-mole
//
//  Created by Jamie Moseley on 2/2/17.
//  Copyright © 2017 Jamie Moseley. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    let emptyHoleImage = UIImage(named: "EmptyHole.png")
    let holeWithMoleImage = UIImage(named: "HoleWithMole.png")
    let dizzyMoleImage = UIImage(named: "HoleWithSoreMole.png")
    let leavingMoleImage = UIImage(named: "HoleWithEscapingMole.png")
    let holeWithEvilMoleImage = UIImage(named: "HoleWithEvilMole.png")
    let backgroundImageSpecial = UIImage(named: "11463.jpg")
    
    var evilMoleNoise = AVAudioPlayer()
    
    var score = 0
    
    @IBOutlet var scoreLabel:UILabel!
    @IBOutlet var backgroundImage:UIImageView!
    
    func moleMaker(theTimer: Timer){
        let hole = (pickRandomInt(min: 1, max: 4)*10)+pickRandomInt(min: 0, max: 2)
        let moleMade = view.viewWithTag(hole) as! UIButton
        let rand = pickRandomInt(min: 1, max: 15)
        if(rand == 15){
            moleMade.setImage(holeWithEvilMoleImage, for: UIControlState.normal)
            Timer.scheduledTimer(timeInterval: randomDoubleBetween(start: 1.0, end: 1.5), target: self, selector: #selector(takeMoleAway), userInfo: moleMade, repeats: false)
        }
        else{
            moleMade.setImage(holeWithMoleImage, for: UIControlState.normal)
            Timer.scheduledTimer(timeInterval: randomDoubleBetween(start: 1.0, end: 1.5), target: self, selector: #selector(takeMoleAway), userInfo: moleMade, repeats: false)
        }
    }
    
    func takeMoleAway(theTimer: Timer){
        let theButton = theTimer.userInfo as! UIButton
        if(theButton.image(for: UIControlState.normal)==holeWithMoleImage){
            theButton.setImage(leavingMoleImage, for: UIControlState.normal)
            score -= 2
            scoreLabel.text = "Score: "+String(score)
            Timer.scheduledTimer(timeInterval: randomDoubleBetween(start: 0.1, end: 0.25), target: self, selector: #selector(makeEmptyHole), userInfo: theButton, repeats: false)
        }
        else if(theButton.image(for: UIControlState.normal)==holeWithEvilMoleImage){
            theButton.setImage(leavingMoleImage, for: UIControlState.normal)
            Timer.scheduledTimer(timeInterval: randomDoubleBetween(start: 0.1, end: 0.25), target: self, selector: #selector(makeEmptyHole), userInfo: theButton, repeats: false)
        }
//        sender.setImage(emptyHoleImage, for: UIControlState.normal)
    }
    
    func makeEmptyHole(theTimer: Timer){
        let theButton = theTimer.userInfo as! UIButton
        theButton.setImage(emptyHoleImage, for: UIControlState.normal)
        Timer.scheduledTimer(timeInterval: randomDoubleBetween(start: 1.0, end: 1.5), target: self, selector: #selector(moleMaker), userInfo: nil, repeats: false)
    }
    
    @IBAction func moleMasher(sender: UIButton){
        if(sender.image(for: UIControlState.normal)==emptyHoleImage){
            score -= 30
            scoreLabel.text = "Score: "+String(score)
        }
        if(sender.image(for: UIControlState.normal)==holeWithEvilMoleImage){
            Timer.scheduledTimer(timeInterval: randomDoubleBetween(start: 0.1, end: 0.25), target: self, selector: #selector(makeEmptyHole), userInfo: sender, repeats: false)
            score -= 50
            scoreLabel.text = "Score: "+String(score)
            evilMode()
        }
        if(sender.image(for: UIControlState.normal)==holeWithMoleImage){
            sender.setImage(dizzyMoleImage, for: UIControlState.normal)
            Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(resetHole), userInfo: sender, repeats: false)
            score += 10
            scoreLabel.text = "Score: "+String(score)
            Timer.scheduledTimer(timeInterval: randomDoubleBetween(start: 0.5, end: 1.0), target: self, selector: #selector(moleMaker), userInfo: nil, repeats: false)
        }
    }
    
    func evilMode(){
        backgroundImage.image = backgroundImageSpecial
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(normalMode), userInfo: nil, repeats: false)
        evilMoleNoise.stop()
        evilMoleNoise.currentTime = 0
        evilMoleNoise.play()
    }
    
    func normalMode(){
        backgroundImage.image = nil
    }
    
    func resetHole(theTimer: Timer){
        let sender = theTimer.userInfo as! UIButton
        if (sender.image(for: UIControlState.normal)==dizzyMoleImage){
            sender.isEnabled = true
            sender.setImage(emptyHoleImage, for: UIControlState.normal)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        Timer.scheduledTimer(timeInterval: randomDoubleBetween(start: 0.25, end: 0.5), target: self, selector: #selector(moleMaker), userInfo: nil, repeats: false)
        Timer.scheduledTimer(timeInterval: randomDoubleBetween(start: 0.25, end: 0.5), target: self, selector: #selector(moleMaker), userInfo: nil, repeats: false)
        Timer.scheduledTimer(timeInterval: randomDoubleBetween(start: 0.25, end: 0.5), target: self, selector: #selector(moleMaker), userInfo: nil, repeats: false)
        loadSounds()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pickRandomInt(min: Int, max: Int) -> Int
    {
        return min + Int(arc4random_uniform(UInt32(max - min + 1)))
    }
    
    func randomDoubleBetween(start:Double, end:Double)-> Double
    {
        let randInRange0To1 = Double(arc4random())/Double(UINT32_MAX)
        return start+(end-start)*randInRange0To1
    }
    func loadSounds(){
        let evilAudio = URL(fileURLWithPath: Bundle.main.path(forResource: "BetterAudio", ofType:"mp3")!)
        do
        {
            try evilMoleNoise = AVAudioPlayer(contentsOf: evilAudio, fileTypeHint: "mp3")
        }
        catch
        {
            print ("I had a problem loading the Evil audio file.")
        }
        evilMoleNoise.prepareToPlay()
    }
}

