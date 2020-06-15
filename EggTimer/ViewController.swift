//
//  ViewController.swift
//  EggTimer
//
//  Created by Maricel Sumulong on 5/9/20.
//  Copyright © 2020 Maricel Sumulong. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var timerLeftLabel: UILabel!
    
    @IBOutlet weak var progressBar: UIProgressView!
    
    let eggTimes: [String:Int] = ["Soft":3, "Medium":7, "Hard":12]
    
    var secondsPassed = 0
    
    var timer = Timer()
    
    var progress = 1.0
    
    var totalTime = 0
    
    var previousHardness = 0
    
    var player: AVAudioPlayer!
    
    @IBAction func hardnessSelected(_ sender: UIButton) {
    
        timer.invalidate()
        
        //sender.backgroundColor = UIColor.black
        
        let hardness = sender.currentTitle!
        
        // SCENARIOS
        
        // IF THIS A NEW EGG
        
        if progressBar.progress >= 1 {
            
            totalTime = eggTimes[hardness]! * 60
            progressBar.progress = 0.0
            secondsPassed = 0
            titleLabel.text = "New Timer Begins..."
            
        } else {
            
            // USER DECIDED TO CHANGE HARDNESS OF EGG WHILE A TIMER IS ALREADY RUNNING
            
            if (eggTimes[hardness]! * 60) < secondsPassed {
                
                titleLabel.text = "Unable to make changes right now! Timer continues..."
                
            } else {
                
                totalTime = eggTimes[hardness]! * 60
                if progressBar.progress > 0 {
                    titleLabel.text = "Extending Timer..."
                }
                
              }
        
    }
    
    timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    
    }
    
    @objc func updateTimer() {
    
        if secondsPassed < totalTime {
            secondsPassed += 1
            let perc = Float(secondsPassed) / Float(totalTime)
            if perc >= 0.5 {
                titleLabel.text = "You're halfway there!"
            }
            timerLeftLabel.text = String(format: "%.2f", perc * 100) + "% cooked"
            progressBar.progress = perc
        } else {
            titleLabel.text = "You're Eggs Are Done!"
            timer.invalidate()
            progressBar.progress = 1.0
            playSound()
        }
        
    }
    
    func playSound() { //parameter : DataType
        let url = Bundle.main.url(forResource: "alarm_sound", withExtension: "mp3")
        player = try! AVAudioPlayer(contentsOf: url!)
        player.play()

    }
    
}

