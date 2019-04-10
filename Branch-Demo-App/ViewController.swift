//
//  ViewController.swift
//  Branch-Demo-App
//
//  Created by Deepti Pandey on 8/10/18.
//  Copyright © 2018 Deepti Pandey. All rights reserved.
//

import UIKit
import Branch
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBOutlet weak var referFriend: UIButton!
    
    @IBAction func refereFreiewdn(_ sender: Any) {
        redeemCredits()
    }
    
    
    @IBOutlet weak var label: UILabel!
    @IBAction func showCredits(_ sender: Any) {
//        viewCredits()
//        createLink()
        shareLink()
    }
    func viewCredits(){
        Branch.getInstance().loadRewards { (changed, error) in
            if (error == nil) {
                let credits = Branch.getInstance().getCredits()
                print("credit: \(credits)")
                self.label.text = "you have \(credits) credits"

            }
        }
    }
    
    func redeemCredits() {
        Branch.getInstance().redeemRewards(5, callback: {(success, error) in
            if success {
                print("Redeemed 5 credits!")
            }
            else {
                print("Failed to redeem credits: \(error)")
            }
        })
    }
    
    func shareLink(){
        let branchUniversalObject: BranchUniversalObject = BranchUniversalObject(canonicalIdentifier: "monster/12345")
        branchUniversalObject.title = "Meet Mr. Squiggles"
        branchUniversalObject.contentDescription = "Your friend Josh has invited you to meet his awesome monster, Mr. Squiggles!"
        branchUniversalObject.imageUrl = "https://example.com/monster-pic-12345.png"
        branchUniversalObject.contentMetadata.customMetadata = ["custom":"123"]
        branchUniversalObject.contentMetadata.customMetadata = ["anything":"everything"]
        let linkProperties: BranchLinkProperties = BranchLinkProperties()
        linkProperties.feature = "share"
        linkProperties.channel = "facebook"
        let randomNum: UInt32 = arc4random()
//        linkProperties.alias = "watch?v=\(randomNum)"
//        linkProperties.addControlParam("$deeplink_path", withValue: "watch?\(randomNum)")
        branchUniversalObject.getShortUrl(with: linkProperties) { (url, error) in
            if (error == nil) {
                print("Got my Branch link to share: (url)")
                print("####")
                print(url ?? "")
            } else {
                print(String(format: "Branch error : %@", error! as CVarArg))
            }
        }
    }
    func createLink(){
        let buo = BranchUniversalObject.init(canonicalIdentifier:"5ad92ef6a3b01c03fa60289a")
        buo.title = "TODAY ON DAYS!"
        buo.contentDescription = "Dummy text"
        buo.publiclyIndex = true
        buo.locallyIndex = true
        buo.contentMetadata.customMetadata["type"] = "post"
        
        let lp: BranchLinkProperties = BranchLinkProperties()
        lp.channel = "twitter"
        lp.feature = "sharing"
        lp.campaign = "content 123 launch"
        lp.stage = "new user"
        lp.tags = ["one", "two", "three"]
    
        lp.addControlParam("$twitter_title", withValue:"twiiteer titel")
//            lp.addControlParam("$og_image_url", withValue:"https://www.fnordware.com/superpng/pngtest8rgba.png")
//            lp.addControlParam("$og_image_url", withValue:"http://d00lappcms.com:8001/uploads/1524182944804.png")
            lp.addControlParam("custom_data", withValue: "yes")
        
            lp.addControlParam("look_at", withValue: "this")
            lp.addControlParam("nav_to", withValue: "over here")
            lp.addControlParam("random", withValue: UUID.init().uuidString)
            
        buo.getShortUrl(with: lp) { (url, error) in
            print("####")
            print(url ?? "")
        }
    }
}

