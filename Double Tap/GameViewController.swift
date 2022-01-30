//
//  GameViewController.swift
//  Double Tap
//
//  Created by Sean Don Tait on 09/08/2016.
//  Copyright (c) 2016 SDT. All rights reserved.
//

import UIKit
import SpriteKit
import GoogleMobileAds

class GameViewController: UIViewController, GADBannerViewDelegate {
    
    var screenHeight: CGFloat = 0.0;
    
    var adBannerView: GADBannerView!
    var bannerDisplayed = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        screenHeight = self.view.frame.height;
        
        if let scene = GameScene(fileNamed:"GameScene") {
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = false
            skView.showsNodeCount = false
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            
            skView.presentScene(scene)
        }
        
        adBannerView = GADBannerView(adSize: kGADAdSizeSmartBannerLandscape, origin: CGPoint(x: 0, y: 0));
        
        adBannerView.delegate = self
        adBannerView.rootViewController = self
        adBannerView.adUnitID = "ca-app-pub-7713925081051899/6322349568";
        
        var reqAd = GADRequest()
        reqAd.testDevices = [kGADSimulatorID];
        adBannerView.loadRequest(reqAd)
        
        self.view.addSubview(adBannerView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func adViewDidReceiveAd(view: GADBannerView!) {
        bannerDisplayed = true
        relayoutViews()
    }
    
    func relayoutViews() {
        if (bannerDisplayed) {
            var bannerFrame = adBannerView!.frame
            bannerFrame.origin.x = 0
            bannerFrame.origin.y = screenHeight - bannerFrame.size.height
            
            adBannerView!.frame = bannerFrame
        }
    }
    
    
    
    
}
