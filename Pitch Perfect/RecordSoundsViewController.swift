//
//  ViewController.swift
//  Pitch Perfect
//
//  Created by James Gilchrist on 3/7/15.
//  Copyright (c) 2015 James Gilchrist. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    var session = AVAudioSession.sharedInstance()
    
    @IBOutlet weak var startRecordingButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    @IBOutlet weak var libraryBarButton: UIBarButtonItem!
    
    @IBOutlet weak var recordingStatusLabel: UILabel!
    
    // watching this to auto set associated variables in one location
    var recordingStatus: Bool = false {
        didSet {
            if recordingStatus {
                recordingStatusLabel.text = "Recording in progress."
            } else {
                recordingStatusLabel.text = "Tap to record."
            }
            stopRecordingButton.hidden = !self.recordingStatus
            startRecordingButton.enabled = !self.recordingStatus
            libraryBarButton.enabled = !self.recordingStatus
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        recordingStatus = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func startRecording(sender: UIButton) {
        if !recordingStatus {
            recordingStatus = true
            
            let directoryPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
            let recordingInfo = RecordingInfo(pathToDirectory: directoryPath);
            
            session.setCategory(AVAudioSessionCategoryRecord, error: nil)
            
            audioRecorder = AVAudioRecorder(URL: recordingInfo.uniqueFileURL!, settings: nil, error: nil)
            audioRecorder.delegate = self
            audioRecorder.meteringEnabled = true
            audioRecorder.prepareToRecord()
            audioRecorder.record()
        }
    }
    
    @IBAction func stopRecording(sender: UIButton) {
        if recordingStatus {
            recordingStatus = false
            audioRecorder.stop()
            var session = AVAudioSession.sharedInstance()
            session.setActive(false, error: nil)
        }
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if flag {
            //toggle session category to playback so it works on the play view
            session.setCategory(AVAudioSessionCategoryPlayback, error: nil)
            
            recordedAudio = RecordedAudio(title: recorder.url.lastPathComponent!, path: recorder.url);
            
            performSegueWithIdentifier("Show Player", sender: recordedAudio)

        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
        case "Show Player":
            let dvc = segue.destinationViewController as PlaySoundsViewController
            dvc.receivedAudio = sender as RecordedAudio
        default:
            println("unsupported segque \(segue.identifier)")
        }
    }
    
    struct RecordingInfo {
        private var pathToDirectory: String
        
        var dateFormat = "ddMMyyyy-HHmmss"
        
        init(pathToDirectory: String) {
            self.pathToDirectory = pathToDirectory;
        }
        
        var uniqueFileURL : NSURL? {
            get {
                let currentDateTime = NSDate()
                
                let formatter = NSDateFormatter()
                formatter.dateFormat = dateFormat
                
                let uniqueName = formatter.stringFromDate(currentDateTime)+".wav"

                return NSURL.fileURLWithPathComponents([pathToDirectory, uniqueName])
            }
        }
        
        
    }
}

