//
//  GameViewController.swift
//  FatsoRun
//
//  Created by Trygve Sanne Hardersen on 27/02/15.
//  Copyright (c) 2015 HypoBytes Ltd. All rights reserved.
//

import UIKit
import SpriteKit
import MessageUI

extension SKNode {
    class func unarchiveFromFile(file : NSString) -> SKNode? {
        if let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks") {
            var sceneData = NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe, error: nil)!
            var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
            
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as GameScene
            archiver.finishDecoding()
            return scene
        } else {
            return nil
        }
    }
}

class GameViewController: UIViewController, MFMailComposeViewControllerDelegate, GameSceneDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene {
            // Configure the view.
            let skView = self.view as SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            
            scene.gameSceneDelegate = self
            
            skView.presentScene(scene)
        }
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
        } else {
            return Int(UIInterfaceOrientationMask.All.rawValue)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func inviteUser() {
        var composer = MFMailComposeViewController()
        composer.mailComposeDelegate = self
        composer.setSubject("Try Fatso Run")
        composer.setMessageBody("Flurry: http://bit.ly/1Aoxab6\nTapstream: http://taps.fatsorun.com/beta-invite", isHTML: false)
        
        self.presentViewController(composer, animated: true, completion: nil)
    }
    
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        if (result.value == MFMailComposeResultSent.value) {
            // track this event using all trackers
            // flurry
            Flurry.logEvent("invite");
            // google analytics
            let tracker = GAI.sharedInstance().defaultTracker
            let event = GAIDictionaryBuilder.createEventWithCategory("invite", action: nil, label: nil, value: nil).build()
            GAI.sharedInstance().defaultTracker.send(event)
            // taptream
            let e = TSEvent.eventWithName("invite", oneTimeOnly: false) as TSEvent
            TSTapstream.instance().fireEvent(e)
        }
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}
