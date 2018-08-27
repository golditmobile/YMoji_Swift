//
//  MessagesViewController.swift
//  YMojiMessage
//
//  Created by C on 9/8/17.
//  Copyright © 2017 C. All rights reserved.
//

import UIKit
import Messages
import AVFoundation

class MessagesViewController: MSMessagesAppViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, YMojiCollectionViewLayoutDelegate {
    
    var stickerCount = 17
    var stickerArray: NSMutableArray = NSMutableArray()
    
    var stickerCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadYMojies()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Conversation Handling
    
    override func willBecomeActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the inactive to active state.
        // This will happen when the extension is about to present UI.
        
        // Use this method to configure the extension and restore previously stored state.
    }
    
    override func didResignActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the active to inactive state.
        // This will happen when the user dissmises the extension, changes to a different
        // conversation or quits Messages.
        
        // Use this method to release shared resources, save user data, invalidate timers,
        // and store enough state information to restore your extension to its current state
        // in case it is terminated later.
    }
   
    override func didReceive(_ message: MSMessage, conversation: MSConversation) {
        // Called when a message arrives that was generated by another instance of this
        // extension on a remote device.
        
        // Use this method to trigger UI updates in response to the message.
    }
    
    override func didStartSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user taps the send button.
    }
    
    override func didCancelSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user deletes the message without sending it.
    
        // Use this to clean up state related to the deleted message.
    }
    
    override func willTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // Called before the extension transitions to a new presentation style.
    
        // Use this method to prepare for the change in presentation style.
    }
    
    override func didTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // Called after the extension transitions to a new presentation style.
    
        // Use this method to finalize any behaviors associated with the change in presentation style.
        stickerCollectionView.frame = self.view.frame

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        createCollectionViews()
    }

    // MARK: -
    // MARK: - Init Interface
    
    func loadYMojies() {
        
        for item in 0...stickerCount {
            stickerArray.add("minion\(item)")
        }
    }
    
    func createCollectionViews() {
        
        stickerCollectionView = createYourMojiCollectionView(CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height), tag: 0)
        self.view.addSubview(stickerCollectionView)
        stickerCollectionView.reloadData()
        
    }
    
    func createYourMojiCollectionView(_ rect: CGRect, tag: Int) -> UICollectionView {
        
        let pinsCollectionViewLayout: YMojiCollectionViewLayout = YMojiCollectionViewLayout()
        pinsCollectionViewLayout.cellPadding = 5
        pinsCollectionViewLayout.delegate = self
        pinsCollectionViewLayout.numberOfColumns = 3
        
        let collectionView: UICollectionView = UICollectionView(frame: rect, collectionViewLayout: pinsCollectionViewLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.white
        collectionView.tag = tag
        collectionView.contentInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        
        let nibName = UINib(nibName: "StickerCollectionViewCell", bundle: Bundle.main)
        collectionView.register(nibName, forCellWithReuseIdentifier: "StickerCollectionViewCell")
        
        return collectionView
    }

    
    // MARK: -
    // MARK: - Emoji CollectionView DataSoruce & Delegate
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 0 {
            return stickerArray.count
        }
        return 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let stickerCell = collectionView.dequeueReusableCell(withReuseIdentifier: "StickerCollectionViewCell", for: indexPath) as! StickerCollectionViewCell
        let fileName = stickerArray.object(at: (indexPath as NSIndexPath).row) as! String
        do {
            if fileName == "minion5" || fileName == "minion9" || fileName == "minion14" {
                let sourceUrl = URL(fileURLWithPath: Bundle.main.path(forResource: fileName, ofType: "gif")!)
                try stickerCell.stickerView.sticker = MSSticker(contentsOfFileURL: sourceUrl, localizedDescription: "")
            } else {
                let sourceUrl = URL(fileURLWithPath: Bundle.main.path(forResource: fileName, ofType: "png")!)
                try stickerCell.stickerView.sticker = MSSticker(contentsOfFileURL: sourceUrl, localizedDescription: "")
            }
        } catch {
            
        }
        
        return stickerCell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath, withWidth width: CGFloat) -> CGFloat {
        
        var ratio: CGFloat = 1.0
        var imageWidth: CGFloat = 0.0
        var imageHeight: CGFloat = 0.0
        
        var image: UIImage = UIImage()
        let fileName = stickerArray.object(at: (indexPath as NSIndexPath).row) as! String
        
        if fileName == "minion5" || fileName == "minion9" || fileName == "minion14" {
            
            image = UIImage.animatedImage(withAnimatedGIFURL: URL(fileURLWithPath: Bundle.main.path(forResource: fileName, ofType: "gif")!))
        } else {
            
            image = UIImage(named: fileName)!
        }
        
        imageWidth = CGFloat(image.size.width)
        imageHeight = CGFloat(image.size.height)
        
        ratio = imageHeight / imageWidth
        let size = CGSize(width: 100, height: 100 * ratio)
        let boundingRect = CGRect(x: 0, y: 0, width: width, height: CGFloat(MAXFLOAT))
        let rect = AVMakeRect(aspectRatio: size, insideRect: boundingRect)
        
        return rect.height
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }

}
