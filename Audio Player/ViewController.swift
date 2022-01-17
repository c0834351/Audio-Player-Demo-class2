//
//  ViewController.swift
//  Audio Player
//
//  Created by Mohammad Kiani on 2021-01-17.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var scrubber: UISlider!
    @IBOutlet weak var volumeSlider: UISlider!
    
    
    var player=AVAudioPlayer()
    
//    var path=Bundle.main.path(forResource: "bach", ofType: "mp3")
    
    var timer=Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        do{
//       try player=AVAudioPlayer(contentsOf: URL(fileURLWithPath: path!)
//        )
//            scrubber.maximumValue=Float(player.duration)
//        }catch{
//            print(error)
//        }
        playAudioForPath(forResourses: "bach", ofType: "mp3")
        
        let gesture=UITapGestureRecognizer(target: self, action: #selector(sliderTap))
        scrubber.addGestureRecognizer(gesture)
        
  }

    @objc func sliderTap(_ g: UITapGestureRecognizer){
        let s:UISlider?=(g.view as? UISlider)
        
        let pt: CGPoint = g.location(in: s)
        let percentage = pt.x / (s?.bounds.size.width)!
        let delta = Float(percentage) * Float((s?.maximumValue)!-(s?.minimumValue)!)
        let value = (s?.minimumValue)! + delta
        s?.setValue(Float(value), animated: true)
      //  player.volume = s!.value
        player.currentTime=TimeInterval(s!.value)
    }
    
    @IBOutlet weak var playBtn: UIBarButtonItem!
    @IBAction func playAudio(_ sender: UIBarButtonItem) {
        if player.isPlaying{
            sender.image=UIImage(systemName: "play.fill")
            player.pause()
            timer.invalidate()
        }
        else{
            sender.image=UIImage(systemName: "pause.fill")
            player.play()
            timer=Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateScrubber), userInfo: nil, repeats: true)
        }
    }
    
    @objc func updateScrubber(){
        scrubber.value=Float(player.currentTime)
        if(scrubber.value==scrubber.minimumValue){
            playBtn.image=UIImage(systemName: "play.fill")
    
        }
    }
    @IBAction func stopAudio(_ sender: UIBarButtonItem) {
        player.stop()
        timer.invalidate()
        scrubber.value=scrubber.minimumValue
        playBtn.image=UIImage(systemName: "play.fill")
        player.currentTime=0
    }
    
    @IBAction func volumeChange(_ sender: UISlider) {
        player.volume=volumeSlider.value
        
    }
    
    
    @IBAction func scrubberMoved(_ sender: UISlider) {
        player.currentTime=TimeInterval(scrubber.value)
        if player.isPlaying{
            player.play()
        }
        
    }
    
    func playAudioForPath(forResourses name: String?, ofType type: String?){
       let path=Bundle.main.path(forResource: name, ofType: type)
        
        do{
       try player=AVAudioPlayer(contentsOf: URL(fileURLWithPath: path!)
        )
            scrubber.maximumValue=Float(player.duration)
        }catch{
            print(error)
        }
    }
    
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if event?.subtype == .motionShake{
            let audioArray = ["bach", "boing","explosion","hit","warble","knife","wah","shoot","swish"]
            
            let randomNum=Int.random(in: 0..<audioArray.count)
//            path=Bundle.main.path(forResource: audioArray[randomNum], ofType: "mp3")
            
            playAudioForPath(forResourses: audioArray[randomNum], ofType: "mp3")
        }
    }
    
    
    
    
}

