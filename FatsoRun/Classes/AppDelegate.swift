//
//  AppDelegate.swift
//  FatsoRun
//
//  Created by Trygve Sanne Hardersen on 27/02/15.
//  Copyright (c) 2015 HypoBytes Ltd. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        let apiKeysPath = NSBundle.mainBundle().pathForResource(FatsoRun.APIKeysFileName, ofType: FatsoRun.APIKeysFileType)
        let apiKeys = NSDictionary(contentsOfFile: apiKeysPath!)

        // setup Flurry
        let flurryAPIKey = apiKeys?.objectForKey(FatsoRun.FlurryAPIKey)
            as String
        Flurry.setDebugLogEnabled(true)
        Flurry.setCrashReportingEnabled(true);
        //Flurry.startSession(FatsoRun.loadAPIKey(FatsoRun.FlurryAPIKey))
        Flurry.startSession(flurryAPIKey)
        
        // setup Google Analytics
        let googleAnalyticsAccount = apiKeys?.objectForKey(FatsoRun.GoogleAnalyticsAccount)
            as String
        GAI.sharedInstance().trackUncaughtExceptions = true
        GAI.sharedInstance().dispatchInterval = 10
        GAI.sharedInstance().logger.logLevel = GAILogLevel.Verbose
        GAI.sharedInstance().trackerWithTrackingId(googleAnalyticsAccount)
        GAI.sharedInstance().defaultTracker.allowIDFACollection = true;
        
        
        // setup Tapstream
        let tapstreamAccount = apiKeys?.objectForKey(FatsoRun.TapstreamAccount) as String
        let tapstramSecret = apiKeys?.objectForKey(FatsoRun.TapstreamSecret) as String
        let tsConfig = TSConfig.configWithDefaults() as TSConfig
        TSTapstream.createWithAccountName(tapstreamAccount, developerSecret: tapstramSecret, config: tsConfig)
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

