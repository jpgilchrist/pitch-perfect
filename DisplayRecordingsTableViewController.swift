//
//  DisplayRecordingsTableViewController.swift
//  Pitch Perfect
//
//  Created by James Gilchrist on 3/19/15.
//  Copyright (c) 2015 James Gilchrist. All rights reserved.
//

import UIKit

class DisplayRecordingsTableViewController: UITableViewController {
    
    let fileManager = NSFileManager.defaultManager()
    var recordings = [RecordedAudio]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let directory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        for fileName in fileManager.contentsOfDirectoryAtPath(directory, error: nil) as [String] {
            println("recording: \(fileName)")
            
            recordings.append(RecordedAudio(title: fileName, path: NSURL.fileURLWithPathComponents([directory, fileName])!))
        }
        
        println("recordings \(recordings)")

        self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recordings.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RecordedAudioCell", forIndexPath: indexPath) as UITableViewCell
        
        cell.textLabel?.text = recordings[indexPath.item].title
        cell.textLabel?.textColor = UIColor(red: 26/255, green: 56/255, blue: 92/255, alpha: 1.0)
        cell.textLabel?.font = UIFont(name: "Heiti SC", size: 17.0)

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("Show Player", sender: recordings[indexPath.item])
    }


    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        switch editingStyle {
        case .Delete:
            fileManager.removeItemAtURL(recordings[indexPath.item].filePathURL, error: nil)
            recordings.removeAtIndex(indexPath.item)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        default:
            println("unsupported editingStyle \(editingStyle)")
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


}
