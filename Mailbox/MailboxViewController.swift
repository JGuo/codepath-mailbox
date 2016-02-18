//
//  MailboxViewController.swift
//  Mailbox
//
//  Created by Jisi Guo on 2/16/16.
//  Copyright © 2016 Jisi Guo. All rights reserved.
//

import UIKit

class MailboxViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var feedScrollView: UIScrollView!
    @IBOutlet weak var feedImage: UIImageView!
    @IBOutlet var panGestureRecognizer: UIPanGestureRecognizer!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var message: UIImageView!
    @IBOutlet weak var snoozeImage: UIImageView!
    @IBOutlet weak var listImage: UIImageView!
    
    @IBOutlet weak var snoozeIcon: UIImageView!
    @IBOutlet weak var listIcon: UIImageView!
    @IBOutlet weak var archiveIcon: UIImageView!
    @IBOutlet weak var deleteIcon: UIImageView!
    
    
    var messageOriginalCenter: CGPoint!
    var messageOffset: CGFloat!
    var messageLeft: CGPoint!
    var messageRight: CGPoint!
    
    var feedOffset: CGFloat!
    var feedUp: CGPoint!
    
    var snoozeIconAlpha: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        feedScrollView.contentSize = CGSize(width: 320, height: 1357)
        feedScrollView.delegate = self
        
        // The onCustomPan: method will be defined in Step 3 below.
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "onCustomPan:")
        
        // Attach it to a view of your choice. If it's a UIImageView, remember to enable user interaction
        message.addGestureRecognizer(panGestureRecognizer)

        // Do any additional setup after loading the view.
        messageOffset = 320
        messageLeft = CGPoint(x: message.center.x - messageOffset ,y: message.center.y)
        messageRight = CGPoint(x: message.center.x + messageOffset ,y: message.center.y)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func snoozeTap(sender: UITapGestureRecognizer) {
        print("snooze tap")
        listIcon.hidden = true
        snoozeIcon.hidden = true
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.snoozeImage.alpha = 0
            self.messageView.frame.size.height = 0
            self.feedImage.transform = CGAffineTransformMakeTranslation(0, -86)
        })
    }
    
    @IBAction func listTap(sender: UITapGestureRecognizer) {
        print("list tap")
        listIcon.hidden = true
        snoozeIcon.hidden = true
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.listImage.alpha = 0
            self.messageView.frame.size.height = 0
            self.feedImage.transform = CGAffineTransformMakeTranslation(0, -86)
        })
    }
    
    func onCustomPan(panGestureRecognizer: UIPanGestureRecognizer) {
        
        // Absolute (x,y) coordinates in parent view
        let point = panGestureRecognizer.locationInView(view)
        
        // Relative change in (x,y) coordinates from where gesture began.
        let translation = panGestureRecognizer.translationInView(view)
        let velocity = panGestureRecognizer.velocityInView(view)
        
        
        if panGestureRecognizer.state == UIGestureRecognizerState.Began {
            print("Gesture began at: \(point)")
            messageOriginalCenter = message.center
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Changed {
            message.center = CGPoint(x: messageOriginalCenter.x + translation.x, y: messageOriginalCenter.y)
            if translation.x > 60 {
                messageView.backgroundColor = UIColor(red:0.439,  green:0.851,  blue:0.384, alpha:1)
                archiveIcon.center = CGPoint(x: messageOriginalCenter.x + translation.x - 190, y: messageOriginalCenter.y)
                deleteIcon.alpha = 0
                archiveIcon.alpha = 1
                if translation.x > 260 {
                    messageView.backgroundColor = UIColor(red:0.922,  green:0.329,  blue:0.200, alpha:1)
                    deleteIcon.center = CGPoint(x: messageOriginalCenter.x + translation.x - 190, y: messageOriginalCenter.y)
                    deleteIcon.alpha = 1
                    archiveIcon.alpha = 0
                }
            } else if translation.x < -60 {
                messageView.backgroundColor = UIColor(red:0.980,  green:0.827,  blue:0.200, alpha:1)
                snoozeIcon.center = CGPoint(x: messageOriginalCenter.x + translation.x + 190, y: messageOriginalCenter.y)
                listIcon.alpha = 0
                snoozeIcon.alpha = 1
                if translation.x < -260{
                    messageView.backgroundColor = UIColor(red:0.847,  green:0.651,  blue:0.459, alpha:1)
                    listIcon.alpha = 1
                    snoozeIcon.alpha = 0
                    listIcon.center = CGPoint(x: messageOriginalCenter.x + translation.x + 190, y: messageOriginalCenter.y)
                }
            } else {
                messageView.backgroundColor = UIColor(red:0.890,  green:0.890,  blue:0.890, alpha:1)
                if translation.x < 0 {
                    snoozeIconAlpha = convertValue(translation.x, r1Min:0 , r1Max: -60, r2Min: 0, r2Max: 1)
                    snoozeIcon.alpha = snoozeIconAlpha
                } else if translation.x > 0 {
                    archiveIcon.alpha = convertValue(translation.x, r1Min:0 , r1Max: 60, r2Min: 0, r2Max: 1)
                }
            }
            print("Gesture changed at: \(point)")
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Ended {
            print("Gesture ended at: \(point)")
            if translation.x > 260 {
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    print("DELETE Gesture ended at: \(point)")
                    self.message.center = self.messageRight
                    self.deleteIcon.center = CGPoint(x: self.message.center.x - 190 ,y: self.message.center.y)
                })
                delay(0.3, closure: { () -> () in
                    UIView.animateWithDuration(0.3, animations: { () -> Void in
                        self.messageView.frame.size.height = 0
                        self.feedImage.transform = CGAffineTransformMakeTranslation(0, -86)
                    })
                })
            } else if translation.x > 60 {
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    print("ARCHIVE Gesture ended at: \(point)")
                    self.message.center = self.messageRight
                    self.archiveIcon.center = CGPoint(x: self.message.center.x - 190 ,y: self.message.center.y)
                })
                delay(0.3, closure: { () -> () in
                    UIView.animateWithDuration(0.3, animations: { () -> Void in
                        self.messageView.frame.size.height = 0
                        self.feedImage.transform = CGAffineTransformMakeTranslation(0, -86)
                    })
                })
            } else if translation.x < -260 {
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    print("LIST Gesture ended at: \(point)")
                    self.message.center = self.messageLeft
                    self.listImage.alpha = 1
                })
            } else if translation.x < -60 {
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    print("SNOOZE Gesture ended at: \(point)")
                    self.message.center = self.messageLeft
                    self.snoozeImage.alpha = 1
                })
            } else {
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    print("NOTHING Gesture ended at: \(point)")
                    self.message.center = self.messageOriginalCenter
                })
            }

        }
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
