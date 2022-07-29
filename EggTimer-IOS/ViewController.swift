//
//  ViewController.swift
//  EggTimer-IOS
//
//  Created by Maricel Sumulong on 7/27/22.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    //VARIABLE OR IBOUTLETS DECLARATION
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var softButton: UIButton!
    @IBOutlet weak var medButton: UIButton!
    @IBOutlet weak var hardButton: UIButton!
    @IBOutlet weak var softImg: UIImageView!
    @IBOutlet weak var medImg: UIImageView!
    @IBOutlet weak var hardImg: UIImageView!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var percLabel: UILabel!
    
    let hardness : [String : Int] = ["soft":1, "medium":7, "hard":12]
    var countStart = 0
    var totalTime : Int = 0
    var timer = Timer()
    var perc : Float = 0.00
    var secondsElapsed : Int = 0
    var player : AVAudioPlayer!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        percLabel.isHidden = true
        
    }

    @IBAction func buttonPressed(_ sender: UIButton) {
        
        //VALIDATIONS
        
        //1. IF TIMER IS ALREADY DONE AND WANTS A NEW EGG
        if (perc == 1.0) {
            
            countStart = 0
            perc = 0.00
            titleLabel.text = "New Timer Begins..."
            
            totalTime = 60 * hardness[sender.currentTitle!.lowercased()]!
            startTimer(sender: sender)
            
        } else if (countStart < (60 * hardness[sender.currentTitle!.lowercased()]!) && perc > 0.00) {
            //3. EXTENDING TIMER
            
            totalTime = (60 * hardness[sender.currentTitle!.lowercased()]!) - countStart
            startTimer(sender: sender)
           
          } else if (countStart > (60 * hardness[sender.currentTitle!.lowercased()]!)) {
            //2. IF ELAPSED TIME IS GREATER THAN NEW TIME
           
                let dialogMessage = UIAlertController(title: "Alert", message: "Selected timer has already fully elapsed. Do you still want to continue current timer?", preferredStyle: .alert)
                let yes = UIAlertAction(title: "Yes", style: .default, handler: { (action) -> Void in
                    
                })
                let no = UIAlertAction(title: "No", style: .default, handler: { (action) -> Void in
                    self.perc = 1.0
                })
                dialogMessage.addAction(yes)
                dialogMessage.addAction(no)
                self.present(dialogMessage, animated: true, completion: nil)
            
            }  else {
            
                    totalTime = 60 * hardness[sender.currentTitle!.lowercased()]!
                    startTimer(sender: sender)
        
               }

    }
    
    func startTimer(sender: UIButton) {
        
        percLabel.isHidden = false
        
        timer.invalidate()
        
        resetImage() //removes all shadow
        
        switch (sender.currentTitle!.lowercased()) {
            
            case "soft":
                addShadow(img: softImg)
            case "medium":
                addShadow(img: medImg)
            default:
                addShadow(img: hardImg)
            
        }
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        
    }
    
    func resetImage() {
        
        removeShadow(img: softImg)
        removeShadow(img: medImg)
        removeShadow(img: hardImg)
        
    }
    
    func addShadow(img : UIImageView) {
        
        img.layer.shadowColor = UIColor.black.cgColor
        img.layer.shadowRadius = 3.0
        img.layer.shadowOpacity = 1.0
        img.layer.shadowOffset = CGSize(width: 6, height: 6)
        img.layer.masksToBounds = false
        
    }
    
    func removeShadow(img : UIImageView) {
        
        img.layer.shadowColor = UIColor.clear.cgColor
        img.layer.shadowRadius = 3.0
        img.layer.shadowOpacity = 1.0
        img.layer.shadowOffset = CGSize(width: 6, height: 6)
        img.layer.masksToBounds = false
        
    }
    
    @objc func update() {
        
        if perc != 1.00 || perc != 1.0 {
            
            countStart += 1
            perc = Float(countStart) / Float(totalTime)
            //print(perc)
            if perc >= 0.5 {
                titleLabel.text = "You're halfway there!"
            }
            progressBar.progress = perc
            let secRemaining = totalTime - countStart
            let (h,m,s) = secondsToHoursMinutesSeconds(secRemaining)
            let newTime = convertTimeToString(h: h, m: m, s: s)
            percLabel.text = String(format: "%.2f", perc * 100) + "% cooked.\n\(newTime) remaining."
            
        } else {
          
            timer.invalidate()
            //print("Time's Up!")
            playSound()
            progressBar.progress = 1.0
            percLabel.text = "100% cooked."
            titleLabel.text = "Done!"
            percLabel.isHidden = true
            
            
          }
        
    }
    
    func secondsToHoursMinutesSeconds(_ seconds: Int) -> (Int, Int, Int) {
    
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    
    }
    
    func convertTimeToString(h: Int, m: Int, s: Int) -> String {
        
        var newtime : String = ""
        
//        if h < 10 {
//            newtime += "0"+String(h) + ":"
//        } else {
//            newtime += String(h) + ":"
//          }
        
        if m < 10 {
            newtime += "0"+String(m) + ":"
        } else {
            newtime += String(m) + ":"
          }
        
        if s < 10 {
            newtime += "0"+String(s)
        } else {
            newtime += String(s)
          }
        
        return newtime
        
    }
    
    func playSound() {
        let url = Bundle.main.url(forResource: "B", withExtension: "wav")
        player = try! AVAudioPlayer(contentsOf: url!)
        player.play()

    }
    
}

