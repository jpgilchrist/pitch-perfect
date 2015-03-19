//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by James Gilchrist on 3/7/15.
//  Copyright (c) 2015 James Gilchrist. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    @IBOutlet weak var recordedAudioTitleLabel: UILabel!
    @IBOutlet weak var playWithReverb: UISwitch!

    let audioEngine = AVAudioEngine()
    let audioPlayer = AVAudioPlayerNode()
    let audioPitchEffect = AVAudioUnitTimePitch()
    let audioDelayEffect = AVAudioUnitDelay()
    let audioReverbEffect = AVAudioUnitReverb()
    
    var receivedAudio: RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioEngine.attachNode(audioPlayer)
        audioEngine.attachNode(audioPitchEffect)
        audioEngine.attachNode(audioDelayEffect)
        audioEngine.attachNode(audioReverbEffect)
        
        recordedAudioTitleLabel.text = receivedAudio.title
        playWithReverb.on = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func snailPlaybackButton(sender: UIButton) {
        playRecording(rate: 0.5, overlap: nil, pitch: nil)
    }
    
    @IBAction func rabbitPlaybackButton(sender: UIButton) {
        playRecording(rate: 2.0, overlap: nil, pitch: nil)
    }
    
    @IBAction func chipmunkPlaybackButton(sender: UIButton) {
        playRecording(rate: nil, overlap: nil, pitch: 1000.0)
    }
    
    @IBAction func darthVaderPlaybackButton(sender: UIButton) {
        playRecording(rate: nil, overlap: nil, pitch: -1000.0)
    }
    
    @IBAction func playReverbPlaybackButton(sender: UIButton) {
        playRecording(rate: nil, overlap: nil, pitch: nil, reverb: true)
    }
    
    @IBAction func stopPlaybackButton(sender: UIButton) {
        audioPlayer.stop()
        audioEngine.stop()
    }
    
    func playRecording(#rate: Float?, overlap: Float?, pitch: Float?) {
        playRecording(rate: rate, overlap: overlap, pitch: pitch, reverb: false)
    }
    
    func playRecording(#rate: Float?, overlap: Float?, pitch: Float?, reverb: Bool) {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        //setup rate, pitch, and overlap; if nil set to defaults
        if rate != nil {
            audioPitchEffect.rate = rate!
        } else {
            audioPitchEffect.rate = 1.0
        }
        
        if overlap != nil {
            audioPitchEffect.overlap = overlap!
        } else {
            audioPitchEffect.overlap = 8.0
        }
        
        if pitch != nil {
            audioPitchEffect.pitch = pitch!
        } else {
            audioPitchEffect.pitch = 1.0
        }
        
        if playWithReverb.on {
            audioDelayEffect.delayTime = 0.25
            audioDelayEffect.feedback = 80
            audioReverbEffect.loadFactoryPreset(AVAudioUnitReverbPreset.LargeHall2)
        } else {
            audioDelayEffect.delayTime = 0.0
            audioDelayEffect.feedback = 0
            audioReverbEffect.loadFactoryPreset(AVAudioUnitReverbPreset.SmallRoom)
        }
        
        audioEngine.connect(audioPlayer, to: audioPitchEffect, format: receivedAudio.audioFile.processingFormat)
        audioEngine.connect(audioPitchEffect, to: audioDelayEffect, format: receivedAudio.audioFile.processingFormat)
        audioEngine.connect(audioDelayEffect, to: audioReverbEffect, format: receivedAudio.audioFile.processingFormat)
        audioEngine.connect(audioReverbEffect, to: audioEngine.outputNode, format: receivedAudio.audioFile.processingFormat)
//        audioEngine.connect(audioPitchEffect, to: audioEngine.mainMixerNode, format: receivedAudio.audioFile.processingFormat)
        
        audioPlayer.scheduleFile(receivedAudio.audioFile, atTime: nil, completionHandler: nil)
        
        audioEngine.startAndReturnError(nil)
        
        println("play rate: \(rate) overlap: \(overlap) pitch: \(pitch) reverb: \(reverb)")
        audioPlayer.play()
    }

}
