//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Alberto Muñoz on 25/2/16.
//  Copyright © 2016 Alberto. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    var audioPlayer: AVAudioPlayer!
    
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!
    
    var recordedAudio: RecordedAudio!

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if let slowSoundPath = NSBundle.mainBundle().pathForResource("movie_quote", ofType: "mp3") {
//            let slowSoundUrl = NSURL.fileURLWithPath(slowSoundPath)
//            do {
//                audioPlayer = try AVAudioPlayer(contentsOfURL:slowSoundUrl)
//                audioPlayer.enableRate = true
//            } catch {
//                print("Error getting the audio file")
//            }
//        } else {
//            print("The path is empty")
//        }
        
        audioEngine = AVAudioEngine()
        audioFile = try! AVAudioFile(forReading: recordedAudio.filePathUrl)
    
        do {
            audioPlayer = try AVAudioPlayer(contentsOfURL:recordedAudio.filePathUrl)
            audioPlayer.enableRate = true
        } catch {
            print("Error trying to create Audio Player")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playSlowSound(sender: UIButton) {
        playSound(0.5)
    }

    @IBAction func playFastSound(sender: UIButton) {
        playSound(1.5)
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func playDarthVaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    
    func playAudioWithVariablePitch(pitch: Float) {
        
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        try! audioEngine.start()
        
        audioPlayerNode.play()
    }
    
    func playSound(rate: Float) {
        audioPlayer.stop()
        audioPlayer.rate = rate
        audioPlayer.play()
    }
    
    @IBAction func stopSound(sender: UIButton) {
        audioPlayer.stop()
        audioPlayer.currentTime = 0.0
    }
}
