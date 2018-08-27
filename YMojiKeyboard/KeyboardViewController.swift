//
//  KeyboardViewController.swift
//  YMojiKeyboard
//
//  Created by C on 9/7/17.
//  Copyright © 2017 C. All rights reserved.
//

import UIKit
import AVFoundation
import MobileCoreServices
import AudioToolbox

class KeyboardViewController: UIInputViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, YMojiKeyboardCollectionViewLayoutDelegate{
    
    var globalUserDefaults: UserDefaults = UserDefaults(suiteName: "group.emoji.ymoji")!
    var stickerCount = 17
    
    @IBOutlet var nextKeyboardButton: UIButton!
    
    var isDidLoadView: Bool = false
    var isSetupHeightConstraint: Bool = true
    
    var keyboardHeight: CGFloat = 0.0
    var keyboardWidth: CGFloat = 0.0
    
    var standardPaddingWidth = CGFloat(1.0)
    
    enum ScreenOrientationMode: Int {
        case portrait
        case landspace
    }
    
    var heightConstraint: NSLayoutConstraint!
    var currentScreenOrientation = ScreenOrientationMode.portrait
    var previousScreenOrientation = ScreenOrientationMode.portrait
    
    var selectedEmojiType: NSString = "video"
    
    enum BoardMode {
        case keyboard
        case standardboard
        case recentboard
    }
    var currentBoardMode = BoardMode.keyboard
    
    // --- KeyBoard ---
    
    var keyBoardView: UIView?
    var keyBoardViewRect: CGRect!
    
    // Predict Bar
    
    var predictBarHeight: CGFloat = 0.0
    var predictCollectionViewRect: CGRect!
    var predictCollectionView: UICollectionView?
    var buttonBrimojiRect: CGRect!
    var buttonBuyNewRect: CGRect!
    
    var buttonBrimoji: UIButton?
    var buttonBuyNew: UIButton?
    
    // KeyPad
    
    var keyPadViewRect: CGRect!
    var keyPadView: UIView?
    
    var topPadding: CGFloat = 0.0
    var keySpacing: CGFloat = 0.0
    var rowSpacing: CGFloat = 0.0
    
    var keyHeight: CGFloat = 0.0
    var keyWidth: CGFloat = 0.0
    
    var enKeyboardView: UIView?
    var numKeyboardView: UIView?
    var signKeyboardView: UIView?
    
    var shiftKey: UIButton?
    let shiftKeyWidth: CGFloat = 0.0
    var numberOfShiftTap = 0
    var isShiftKeySelected: Bool = true
    var shiftTimer: Timer?
    var isCapsLock: Bool = false
    var shiftPosArr = [0]
    
    var spaceKey: UIButton?
    var spaceKeyWidth: CGFloat = 0.0
    var isSpacePressed = false
    var isFullStopPressed = false
    var spaceTimer: Timer?
    
    var nextKeyWidth: CGFloat = 0.0
    var nextKey: UIButton?
    
    var emojiAltKeyWidth: CGFloat = 0.0
    var emojiAltKey: UIButton?
    
    var returnKeyWidth: CGFloat = 0.0
    var returnKey: UIButton?
    
    var is123KeySelected: Bool = false
    var isSignKeySelected: Bool = false
    
    var characterDeleteKey: UIButton?
    var delKeyTimer: Timer?
    var numberOfDeletedCharacter = 0
    
    var returnButton: UIButton?
    var numDeleteKey: UIButton?
    var signDeleteKey: UIButton?
    var numberAltKey: UIButton?
    var signAltKey_1: UIButton?
    var signAltKey_2: UIButton?
    
    var fullKeyButtons: Array<UIButton> = []
    var numKeyButtons: Array<UIButton> = []
    var signKeyButtons: Array<UIButton> = []
    
    let rowsABC = [["q", "w", "e", "r", "t", "y", "u", "i", "o", "p"],
                   ["a", "s", "d", "f", "g", "h", "j", "k", "l"],
                   ["z", "x", "c", "v", "b", "n", "m"]]
    let rows123 = [["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"],
                   ["-", "/", ":", ";", "(", ")", "$", "&", "@", "\""],
                   [".", ",", "?", "!", "'"]]
    let rowsSign = [["[", "]", "{", "}", "#", "%", "^", "*", "+", "="],
                    ["_", "\\", "|", "~", "<", ">", "€", "£", "¥", "•"],
                    [".", ",", "?", "!", "'"]]
    
    
    // --- EMoji Board ---
    
    var emojiBoardView: UIView?
    var emojiBoardViewRect: CGRect!
    
    // Video Player
    var videoPreviewBG: UIView?
    var videoPreviewMain: UIView?
    var videoPreviewBGRect: CGRect!
    var videoPreviewMainRect: CGRect!
    var videoPlayerLayerRect: CGRect!
    
    var videoPlayerItem: AVPlayerItem?
    var videoPlayer: AVPlayer?
    var videoPlayerLayer = AVPlayerLayer()
    
    //NavBar
    
    var navBarHeight: CGFloat = 0.0
    var buttonStickerRect: CGRect!
    var buttonSticker: UIButton?
    
    var buttonGifRect: CGRect!
    var buttonGif: UIButton?
    
    var buttonVideoRect: CGRect!
    var buttonVideo: UIButton?
    
    enum NavButtonStatus {
        case sticker
        case gif
        case video
    }
    var currentNavButtonStatus = NavButtonStatus.sticker
    
    //ToolBar
    
    var toolBarHeight: CGFloat = 0.0
    
    var otherKeyboardButton: UIButton?
    var keyboardButton: UIButton?
    var standardEmojiButton: UIButton?
    var recentEmojiButton: UIButton?
    var delelteEmojiButton: UIButton?
    
    var otherKeyboardButtonRect: CGRect!
    var keyboardButtonRect: CGRect!
    var standardEmojiButtonRect: CGRect!
    var recentEmojiButtonRect: CGRect!
    var delelteEmojiButtonRect: CGRect!
    
    //CollectionViews
    
    var emojiCollectionViewRect: CGRect!
    var emojiCollectionViewBoard: UIView?
    
    var standardStickerCollectionView: UICollectionView?
    var standardGifCollectionView: UICollectionView?
    var standardVideoCollectionView: UICollectionView?
    var recentStickerCollectionView: UICollectionView?
    var recentGifCollectionView: UICollectionView?
    var recentVideoCollectionView: UICollectionView?
    
    var numberOfRowsOfCollectionView = 2 // Portrait: 2 Landspace: 1
    var numberOfRowsOfPredictCollctionView = 1
    
    // Array Of Emojis
    
    var standardStickers: Array<String> = []
    var standardGifs: NSMutableArray = NSMutableArray()
    var standardVideos: NSMutableArray = NSMutableArray()
    var standardVideoThumbs: Array<UIImage> = []
    
    var recentStickers: Array<String> = []
    var recentGifs: NSMutableArray = NSMutableArray()
    var recentVideos: NSMutableArray = NSMutableArray()
    var recentVideoThumbs: Array<UIImage> = []
    
    
    // MARK: -
    // MARK: - Override Functions
    
    init() {
        super.init(nibName: nil, bundle:nil)
    }
    
    required init(coder aDecoder: NSCoder)  {
        super.init(coder: aDecoder)!
    }
    
    override func viewDidLayoutSubviews() {
        // Add custom view sizing constraints here
        
        if self.view.frame.size.width == 0 || self.view.frame.size.height == 0 {
            return
        }
        
        if isDidLoadView {
            if isSetupHeightConstraint {
                
                calculateKeyboardRects()
                
                if currentScreenOrientation != previousScreenOrientation {
                    previousScreenOrientation = currentScreenOrientation
                    
                    if currentBoardMode == BoardMode.keyboard {
                        drawKeyboard()
                    } else {
                        drawEmojiBoard()
                    }
                }
                
                isSetupHeightConstraint = false
            } else {
                setUpHeightConstraint()
                isSetupHeightConstraint = true
            }
        }
        
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Perform custom UI setup here
        self.nextKeyboardButton = UIButton(type: .system)
        
        self.nextKeyboardButton.setTitle(NSLocalizedString("Next Keyboard", comment: "Title for 'Next Keyboard' button"), for: UIControlState())
        self.nextKeyboardButton.sizeToFit()
        self.nextKeyboardButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.nextKeyboardButton.addTarget(self, action: #selector(UIInputViewController.advanceToNextInputMode), for: .touchUpInside)
        
        self.view.addSubview(self.nextKeyboardButton)
        self.view.backgroundColor = UIColor.white
        self.nextKeyboardButton.isHidden = true
        
        setUpHeightConstraint()
        calculateKeyboardRects()
        drawKeyboard()
        isDidLoadView = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
        NSLog("---------------------------- Memory Warning --------------------")
    }
    
    override func textWillChange(_ textInput: UITextInput?) {
        // The app is about to change the document's contents. Perform any preparation here.
    }
    
    override func textDidChange(_ textInput: UITextInput?) {
        // The app has just changed the document's contents, the document context has been updated.
    }
    
    var enableInputClicksWhenVisible: Bool {
        return true
    }
    
    
    // MARK: -
    // MARK: - Setup Keyboard Rects
    
    func setUpHeightConstraint() {
        
        if(UIScreen.main.bounds.size.width < UIScreen.main.bounds.size.height){
            //Keyboard is in Portrait
            
            if UIScreen.main.bounds.size.height == 736 {
                //iphone 6 plus
                keyboardHeight = UIScreen.main.bounds.height * 271 * 1.25 / (736 * 1.20)
            } else if UIScreen.main.bounds.size.height == 667 {
                //iphone 6
                keyboardHeight = UIScreen.main.bounds.height * 258 * 1.25 / (667  * 1.20)
            } else if UIScreen.main.bounds.size.height == 568 {
                //iphone 5
                keyboardHeight = UIScreen.main.bounds.height * 253 * 1.25 / (538  * 1.21)
            } else if UIScreen.main.bounds.size.height == 480 {
                //iphone 4s
                keyboardHeight = UIScreen.main.bounds.height * 253 * 1.25 / (480  * 1.20)
            } else {
                keyboardHeight = UIScreen.main.bounds.height * 264 * 1.25 / (1024  * 1.20)
            }
            
            keyboardWidth = UIScreen.main.bounds.width
            
            numberOfRowsOfCollectionView = 2
            navBarHeight = keyboardHeight * 0.14
            toolBarHeight = keyboardHeight * 0.15
            predictBarHeight = keyboardHeight * 0.25
            
            topPadding = 6
            keySpacing = 5
            rowSpacing = 8
            
            currentScreenOrientation = ScreenOrientationMode.portrait
        } else {
            //Keyboard is in Landscape
            keyboardHeight = UIScreen.main.bounds.height * 0.5 * 1.14
            keyboardWidth = UIScreen.main.bounds.width
            
            numberOfRowsOfCollectionView = 2
            
            navBarHeight = keyboardHeight * 0.15
            toolBarHeight = keyboardHeight * 0.17
            predictBarHeight = keyboardHeight * 0.27
            
            topPadding = 2
            keySpacing = 5
            rowSpacing = 5
            
            currentScreenOrientation = ScreenOrientationMode.landspace
        }
        
        if heightConstraint == nil {
            heightConstraint = NSLayoutConstraint(
                item: view,
                attribute: .height,
                relatedBy: .equal,
                toItem: nil,
                attribute: .notAnAttribute,
                multiplier: 1,
                constant: keyboardHeight
            )
            
            heightConstraint.priority = UILayoutPriority(999)
            
            self.view.addConstraint(heightConstraint)
        } else {
            heightConstraint.constant = keyboardHeight
        }
    }
    
    func calculateKeyboardRects() {
        
        // --- KeyBoard ---
        
        keyBoardViewRect = CGRect(
            x: 0,
            y: 0,
            width: keyboardWidth,
            height: keyboardHeight)
        
        // Predict Bar
        
        buttonBrimojiRect = CGRect(
            x: standardPaddingWidth * 2,
            y: 0,
            width: keyboardWidth * 0.2,
            height: predictBarHeight * 0.2)
        
        buttonBuyNewRect = CGRect(
            x: keyboardWidth * 0.65 - standardPaddingWidth * 2,
            y: 0,
            width: keyboardWidth * 0.35,
            height: predictBarHeight * 0.2)
        
        predictCollectionViewRect = CGRect(
            x: -standardPaddingWidth,
            y: 0,
            width: keyboardWidth + standardPaddingWidth * 2,
            height: predictBarHeight + keySpacing)
        
        // KeyPad
        
        keyPadViewRect = CGRect(
            x: 0,
            y: (predictBarHeight + keySpacing),
            width: keyboardWidth,
            height: (keyboardHeight - predictBarHeight - keySpacing * 2))
        
        // --- EMoji Board ---
        
        emojiBoardViewRect = CGRect(
            x: 0,
            y: 0,
            width: keyboardWidth,
            height: keyboardHeight)
        
        let navButtonWidth = keyboardWidth / 3.0
        let toolButtonWidth = keyboardWidth / 5.0
        let toolButtonPosition = (toolButtonWidth - toolBarHeight) / 2.0
        
        // Navigation Bar
        
        buttonStickerRect = CGRect(
            x: 0,
            y: 0,
            width: navButtonWidth,
            height: navBarHeight)
        
        buttonGifRect = CGRect(
            x: navButtonWidth * 1,
            y: 0,
            width: navButtonWidth,
            height: navBarHeight)
        
        buttonVideoRect = CGRect(
            x: navButtonWidth * 2,
            y: 0,
            width: navButtonWidth,
            height: navBarHeight)
        
        // Emoji CollectionView
        
        emojiCollectionViewRect = CGRect(
            x: 0,
            y: 0,
            width: keyboardWidth,
            height: (keyboardHeight - toolBarHeight))
        
        // Tool Bar Buttons
        
        otherKeyboardButtonRect = CGRect(
            x: toolButtonPosition,
            y: (keyboardHeight - toolBarHeight),
            width: toolBarHeight,
            height: toolBarHeight)
        
        keyboardButtonRect = CGRect(
            x: (toolButtonWidth + toolButtonPosition),
            y: (keyboardHeight - toolBarHeight),
            width: toolBarHeight,
            height: toolBarHeight)
        
        standardEmojiButtonRect = CGRect(
            x: (toolButtonWidth * 2 + toolButtonPosition),
            y: (keyboardHeight - toolBarHeight),
            width: toolBarHeight,
            height: toolBarHeight)
        
        recentEmojiButtonRect = CGRect(
            x: (toolButtonWidth * 3 + toolButtonPosition),
            y: (keyboardHeight - toolBarHeight),
            width: toolBarHeight,
            height: toolBarHeight)
        
        delelteEmojiButtonRect = CGRect(
            x: (toolButtonWidth * 4 + toolButtonPosition),
            y: (keyboardHeight - toolBarHeight),
            width: toolBarHeight,
            height: toolBarHeight)
        
        // Video Preview
        
        videoPreviewBGRect = CGRect(
            x: 0,
            y: 0,
            width: keyboardWidth,
            height: keyboardHeight)
        
        let videoPreviewWidth = keyboardWidth * 0.5 * 640 / 360
        let videoPreviewHeight = keyboardHeight * 0.5
        
        videoPreviewMainRect = CGRect(
            x: ((keyboardWidth - videoPreviewWidth) / 2),
            y: ((keyboardHeight - videoPreviewHeight) / 2),
            width: videoPreviewWidth,
            height: videoPreviewHeight)
        
        videoPlayerLayerRect = CGRect(
            x: 0,
            y: 0,
            width: videoPreviewWidth,
            height: videoPreviewHeight)
        
        
    }
    
    
    // MARK: -
    // MARK: - Draw Keyboards
    
    func drawKeyboard() {
        if keyboardHeight == 0.0 || keyboardWidth == 0.0 {
            return
        }
        
        if (keyBoardView == nil) {
            
            standardStickers = []
            
            for index in 0...stickerCount {
                let stickerStr = String(format: "minion%d",index)
                standardStickers.append(stickerStr)
            }
            
            keyBoardView = UIView(frame: keyBoardViewRect)
            keyBoardView!.backgroundColor = UIColor.white
            self.view.addSubview(keyBoardView!)
            
            drawPredictBar()
            drawKeyPad()
            
        } else {
            keyBoardView?.frame = keyBoardViewRect
            
            drawPredictBar()
            drawKeyPad()
            
        }
        
    }
    
    
    // MARK: -
    // MARK: - Draw Keyboard
    
    func drawPredictBar() -> Void {
        
        if (predictCollectionView == nil) {
            predictCollectionView = createCollectionView(predictCollectionViewRect, tag: 0)
            keyBoardView?.addSubview(predictCollectionView!)
            
            // Predict Stickers
            let predictCollectionViewLayout = predictCollectionView?.collectionViewLayout as! YMojiKeyboardCollectionViewLayout
            predictCollectionViewLayout.numberOfRows = numberOfRowsOfPredictCollctionView
            predictCollectionView?.frame = predictCollectionViewRect
            predictCollectionView?.reloadData()
            
        }
        else {
            predictCollectionView?.frame = predictCollectionViewRect
            predictCollectionView?.reloadData()
        }
        
    }
    
    func drawKeyPad() {
        
        if (keyPadView == nil) {
            keyPadView = UIView(frame: keyPadViewRect)
            keyPadView!.backgroundColor = UIColor.white
            keyBoardView?.addSubview(keyPadView!)
        } else {
            for view in keyPadView!.subviews {
                view.removeFromSuperview()
            }
            
            keyPadView?.frame = keyPadViewRect
        }
        
        addFullKeyButtons()
        
    }
    
    func addFullKeyButtons() {
        keyWidth = keyPadViewRect.width / 10.0 - keySpacing
        keyHeight = keyPadViewRect.height / 4.0 - rowSpacing * 0.85
        
        // En Keyboard View
        if enKeyboardView == nil {
            enKeyboardView = UIView(frame: CGRect(x: 0, y: 0, width: keyPadViewRect.width,
                                                  height: (topPadding + keyHeight * 3 + rowSpacing * 3)))
        }
        else {
            for view in enKeyboardView!.subviews {
                view.removeFromSuperview()
            }
            
            enKeyboardView?.frame = CGRect(x: 0, y: 0, width: keyPadViewRect.width,
                                           height: (topPadding + keyHeight * 3 + rowSpacing * 3))
        }
        
        self.enKeyboardView!.backgroundColor = UIColor.clear
        self.enKeyboardView?.isMultipleTouchEnabled = true
        keyPadView?.addSubview(enKeyboardView!)
        
        // Num Keyboard View
        if numKeyboardView == nil {
            numKeyboardView = UIView(frame: CGRect(x: 0, y: 0, width: keyPadViewRect.width,
                                                   height: (topPadding + keyHeight * 3 + rowSpacing * 3)))
        }
        else {
            for view in numKeyboardView!.subviews {
                view.removeFromSuperview()
            }
            
            numKeyboardView?.frame = CGRect(x: 0, y: 0, width: keyPadViewRect.width,
                                            height: (topPadding + keyHeight * 3 + rowSpacing * 3))
        }
        
        self.numKeyboardView!.backgroundColor = UIColor.clear
        self.numKeyboardView?.isMultipleTouchEnabled = true
        keyPadView?.addSubview(numKeyboardView!)
        
        // Sign Keyboard View
        if signKeyboardView == nil {
            signKeyboardView = UIView(frame: CGRect(x: 0, y: 0, width: keyPadViewRect.width,
                                                    height: (topPadding + keyHeight * 3 + rowSpacing * 3)))
        }
        else {
            for view in signKeyboardView!.subviews {
                view.removeFromSuperview()
            }
            
            signKeyboardView?.frame = CGRect(x: 0, y: 0, width: keyPadViewRect.width,
                                             height: (topPadding + keyHeight * 3 + rowSpacing * 3))
        }
        
        self.signKeyboardView!.backgroundColor = UIColor.clear
        self.signKeyboardView?.isMultipleTouchEnabled = true
        keyPadView?.addSubview(signKeyboardView!)
        
        if is123KeySelected {
            if isSignKeySelected {
                numKeyboardView?.isHidden = true
            } else {
                signKeyboardView?.isHidden = true
            }
            enKeyboardView?.isHidden = true
        }
        else {
            numKeyboardView?.isHidden = true
            signKeyboardView?.isHidden = true
        }
        
        //En Keys
        fullKeyButtons.removeAll()
        
        var y: CGFloat = topPadding
        for row in rowsABC {
            var x: CGFloat = ceil((keyPadViewRect.width - (CGFloat(row.count) - 1) * (keySpacing + keyWidth) - keyWidth) / 2.0)
            
            for label in row {
                
                let buttonRect = CGRect(x: x, y: y, width: keyWidth, height: keyHeight)
                let characterButton = UIButton(type: UIButtonType.custom)
                characterButton.frame = buttonRect
                characterButton.setTitle(label, for: UIControlState.normal)
                characterButton.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
                characterButton.backgroundColor = UIColor.white
                
                characterButton.layer.borderColor = UIColor.lightGray.cgColor
                characterButton.layer.borderWidth = 1.0
                characterButton.layer.cornerRadius = 3.0
                
                characterButton.isUserInteractionEnabled = false
                enKeyboardView?.addSubview(characterButton)
                fullKeyButtons.append(characterButton)
                
                x += keyWidth + keySpacing
            }
            
            y += keyHeight + rowSpacing
        }
        
        // Shift Key
        let thirdRowTopPadding: CGFloat = topPadding + (keyHeight + rowSpacing) * 2
        shiftKey = UIButton(type: .custom) as UIButton
        shiftKey!.frame = CGRect(x: keySpacing / 2.0, y: thirdRowTopPadding, width:(keyWidth * 1.5), height:keyHeight)
        shiftKey?.backgroundColor = UIColor.groupTableViewBackground
        
        shiftKey?.layer.borderColor = UIColor.lightGray.cgColor
        shiftKey?.layer.borderWidth = 1.0
        shiftKey?.layer.cornerRadius = 3.0
        
        if currentScreenOrientation == ScreenOrientationMode.portrait {
            shiftKey!.setBackgroundImage(UIImage(named: "ShiftKey_normal_Port.png"), for: .normal)
            shiftKey!.setBackgroundImage(UIImage(named: "ShiftKey_pressed_Port.png"), for: .selected)
        }
        else {
            shiftKey!.setBackgroundImage(UIImage(named: "ShiftKey_normal_Land.png"), for: .normal)
            shiftKey!.setBackgroundImage(UIImage(named: "ShiftKey_pressed_Land.png"), for: .selected)
        }
        
        shiftKey!.addTarget(self, action: #selector(self.shiftKeyPressed(_:)), for: .touchUpInside)
        isShiftKeySelected = true
        setShiftValue(true)
        enKeyboardView?.addSubview(shiftKey!)
        
        // Character Delete Key
        characterDeleteKey = UIButton(type: .custom) as UIButton
        characterDeleteKey!.frame = CGRect(x:(keyPadViewRect.width - (keyWidth * 1.5) - keySpacing / 2.0), y: thirdRowTopPadding, width:(keyWidth * 1.5), height:keyHeight)
        characterDeleteKey?.backgroundColor = UIColor.groupTableViewBackground
        
        characterDeleteKey?.layer.borderColor = UIColor.lightGray.cgColor
        characterDeleteKey?.layer.borderWidth = 1.0
        characterDeleteKey?.layer.cornerRadius = 3.0
        
        if currentScreenOrientation == ScreenOrientationMode.portrait {
            characterDeleteKey!.setBackgroundImage(UIImage(named: "DeleteKey_normal_Port.png"), for: .normal)
            characterDeleteKey!.setBackgroundImage(UIImage(named: "DeleteKey_pressed_Port.png"), for: .selected)
        }
        else {
            characterDeleteKey!.setBackgroundImage(UIImage(named: "DeleteKey_normal_Land.png"), for: .normal)
            characterDeleteKey!.setBackgroundImage(UIImage(named: "DeleteKey_pressed_Land.png"), for: .selected)
        }
        
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.longTap(_:)))
        characterDeleteKey!.addGestureRecognizer(longGesture)
        
        characterDeleteKey!.addTarget(self, action: #selector(self.deleteKeyPressed(_:)), for: .touchUpInside)
        
        self.enKeyboardView!.addSubview(characterDeleteKey!)
        
        // Num Keys
        numKeyButtons.removeAll()
        
        y = topPadding
        for row in rows123 {
            var x: CGFloat = ceil((keyPadViewRect.width - (CGFloat(row.count) - 1) * (keySpacing + keyWidth) - keyWidth) / 2.0)
            
            if row.count == 5 {
                x = ceil((keyPadViewRect.width - (CGFloat(row.count) - 1) * (keySpacing + keyWidth * 1.35) - keyWidth * 1.35) / 2.0)
                
                for label in row {
                    
                    let buttonRect = CGRect(x: x, y: y, width: keyWidth * 1.35, height: keyHeight)
                    let characterButton = UIButton(type: UIButtonType.custom)
                    characterButton.frame = buttonRect
                    characterButton.setTitle(label, for: UIControlState.normal)
                    characterButton.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
                    characterButton.backgroundColor = UIColor.white
                    
                    characterButton.layer.borderColor = UIColor.lightGray.cgColor
                    characterButton.layer.borderWidth = 1.0
                    characterButton.layer.cornerRadius = 3.0
                    
                    characterButton.isUserInteractionEnabled = false
                    self.numKeyboardView!.addSubview(characterButton)
                    numKeyButtons.append(characterButton)
                    
                    x += keyWidth * 1.35 + keySpacing
                }
                
            } else {
                for label in row {
                    
                    let buttonRect = CGRect(x: x, y: y, width: keyWidth, height: keyHeight)
                    let characterButton = UIButton(type: UIButtonType.custom)
                    characterButton.frame = buttonRect
                    characterButton.setTitle(label, for: UIControlState.normal)
                    characterButton.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
                    characterButton.backgroundColor = UIColor.white
                    
                    characterButton.layer.borderColor = UIColor.lightGray.cgColor
                    characterButton.layer.borderWidth = 1.0
                    characterButton.layer.cornerRadius = 3.0
                    
                    characterButton.isUserInteractionEnabled = false
                    self.numKeyboardView!.addSubview(characterButton)
                    numKeyButtons.append(characterButton)
                    
                    x += keyWidth + keySpacing
                }
                
            }
            
            y += keyHeight + rowSpacing
        }
        
        // Sign Alt Key 1
        signAltKey_1 = UIButton(type: .custom) as UIButton
        signAltKey_1!.frame = CGRect(x: keySpacing / 2.0, y: thirdRowTopPadding, width:(keyWidth * 1.5), height:keyHeight)
        
        signAltKey_1?.backgroundColor = UIColor.groupTableViewBackground
        
        signAltKey_1?.layer.borderColor = UIColor.lightGray.cgColor
        signAltKey_1?.layer.borderWidth = 1.0
        signAltKey_1?.layer.cornerRadius = 3.0
        
        signAltKey_1!.titleLabel?.font = UIFont(name: "Helvetica", size:keyHeight / 3)
        signAltKey_1!.setTitle("#+=", for: UIControlState())
        signAltKey_1!.setTitleColor(UIColor.black, for: UIControlState())
        signAltKey_1!.titleLabel?.textAlignment = .center
        signAltKey_1!.titleLabel?.sizeToFit()
        
        signAltKey_1!.addTarget(self, action: #selector(self.signKey1Pressed(_:)), for: .touchUpInside)
        self.numKeyboardView!.addSubview(signAltKey_1!)
        
        // Num Delete Key
        numDeleteKey = UIButton(type: .custom) as UIButton
        numDeleteKey!.frame = CGRect(x:(keyPadViewRect.width - (keyWidth * 1.5) - keySpacing / 2.0), y: thirdRowTopPadding,
                                     width:(keyWidth * 1.5), height:keyHeight)
        
        if currentScreenOrientation == ScreenOrientationMode.portrait {
            numDeleteKey!.setBackgroundImage(UIImage(named: "DeleteKey_normal_Port.png"), for: UIControlState())
            numDeleteKey!.setBackgroundImage(UIImage(named: "DeleteKey_pressed_Port.png"), for: .highlighted)
        }
        else {
            numDeleteKey!.setBackgroundImage(UIImage(named: "DeleteKey_normal_Land.png"), for: UIControlState())
            numDeleteKey!.setBackgroundImage(UIImage(named: "DeleteKey_pressed_Land.png"), for: .highlighted)
        }
        
        numDeleteKey?.backgroundColor = UIColor.groupTableViewBackground
        
        numDeleteKey?.layer.borderColor = UIColor.lightGray.cgColor
        numDeleteKey?.layer.borderWidth = 1.0
        numDeleteKey?.layer.cornerRadius = 3.0
        
        let longGesture1 = UILongPressGestureRecognizer(target: self, action: #selector(self.longTap(_:)))
        numDeleteKey!.addGestureRecognizer(longGesture1)
        
        numDeleteKey!.addTarget(self, action: #selector(self.deleteKeyPressed(_:)), for: .touchUpInside)
        
        self.numKeyboardView!.addSubview(numDeleteKey!)
        
        // Sign Keys
        signKeyButtons.removeAll()
        
        y = topPadding
        for row in rowsSign {
            var x: CGFloat = ceil((keyPadViewRect.width - (CGFloat(row.count) - 1) * (keySpacing + keyWidth) - keyWidth) / 2.0)
            
            if row.count == 5 {
                x = ceil((keyPadViewRect.width - (CGFloat(row.count) - 1) * (keySpacing + keyWidth * 1.35) - keyWidth * 1.35) / 2.0)
                
                for label in row {
                    
                    let buttonRect = CGRect(x: x, y: y, width: keyWidth * 1.35, height: keyHeight)
                    let characterButton = UIButton(type: UIButtonType.custom)
                    characterButton.frame = buttonRect
                    characterButton.setTitle(label, for: UIControlState.normal)
                    characterButton.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
                    characterButton.backgroundColor = UIColor.white
                    
                    characterButton.layer.borderColor = UIColor.lightGray.cgColor
                    characterButton.layer.borderWidth = 1.0
                    characterButton.layer.cornerRadius = 3.0
                    
                    characterButton.isUserInteractionEnabled = false
                    self.signKeyboardView!.addSubview(characterButton)
                    signKeyButtons.append(characterButton)
                    
                    x += keyWidth * 1.35 + keySpacing
                }
                
            } else {
                for label in row {
                    
                    let buttonRect = CGRect(x: x, y: y, width: keyWidth, height: keyHeight)
                    let characterButton = UIButton(type: UIButtonType.custom)
                    characterButton.frame = buttonRect
                    characterButton.setTitle(label, for: UIControlState.normal)
                    characterButton.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
                    characterButton.backgroundColor = UIColor.white
                    
                    characterButton.layer.borderColor = UIColor.lightGray.cgColor
                    characterButton.layer.borderWidth = 1.0
                    characterButton.layer.cornerRadius = 3.0
                    
                    characterButton.isUserInteractionEnabled = false
                    self.signKeyboardView!.addSubview(characterButton)
                    signKeyButtons.append(characterButton)
                    
                    x += keyWidth + keySpacing
                }
                
            }
            
            y += keyHeight + rowSpacing
        }
        
        // Sign Alt Key 2
        signAltKey_2 = UIButton(type: .custom) as UIButton
        signAltKey_2!.frame = CGRect(x: keySpacing / 2.0, y: thirdRowTopPadding, width:(keyWidth * 1.5), height:keyHeight)
        
        signAltKey_2?.backgroundColor = UIColor.groupTableViewBackground
        
        signAltKey_2?.layer.borderColor = UIColor.lightGray.cgColor
        signAltKey_2?.layer.borderWidth = 1.0
        signAltKey_2?.layer.cornerRadius = 3.0
        
        signAltKey_2!.titleLabel?.font = UIFont(name: "Helvetica", size:keyHeight / 3)
        signAltKey_2!.setTitle("123", for: UIControlState())
        signAltKey_2!.setTitleColor(UIColor.black, for: UIControlState())
        signAltKey_2!.titleLabel?.textAlignment = .center
        signAltKey_2!.titleLabel?.sizeToFit()
        
        signAltKey_2!.addTarget(self, action: #selector(self.signKey2Pressed(_:)), for: .touchUpInside)
        self.signKeyboardView!.addSubview(signAltKey_2!)
        
        // Sign Delete Key
        signDeleteKey = UIButton(type: .custom) as UIButton
        signDeleteKey!.frame = CGRect(x:(keyPadViewRect.width - (keyWidth * 1.5) - keySpacing / 2.0), y: thirdRowTopPadding,
                                      width:(keyWidth * 1.5), height:keyHeight)
        
        if currentScreenOrientation == ScreenOrientationMode.portrait {
            signDeleteKey!.setBackgroundImage(UIImage(named: "DeleteKey_normal_Port.png"), for: UIControlState())
            signDeleteKey!.setBackgroundImage(UIImage(named: "DeleteKey_pressed_Port.png"), for: .highlighted)
        }
        else {
            signDeleteKey!.setBackgroundImage(UIImage(named: "DeleteKey_normal_Land.png"), for: UIControlState())
            signDeleteKey!.setBackgroundImage(UIImage(named: "DeleteKey_pressed_Land.png"), for: .highlighted)
        }
        
        signDeleteKey?.backgroundColor = UIColor.groupTableViewBackground
        
        signDeleteKey?.layer.borderColor = UIColor.lightGray.cgColor
        signDeleteKey?.layer.borderWidth = 1.0
        signDeleteKey?.layer.cornerRadius = 3.0
        
        let longGesture2 = UILongPressGestureRecognizer(target: self, action: #selector(self.longTap(_:)))
        signDeleteKey!.addGestureRecognizer(longGesture2)
        
        signDeleteKey!.addTarget(self, action: #selector(self.deleteKeyPressed(_:)), for: .touchUpInside)
        
        self.signKeyboardView!.addSubview(signDeleteKey!)
        
        
        let bottomRowTopPadding = topPadding + keyHeight * 3 + rowSpacing * 3
        
        // .?123 Key
        let numberAltKeyWidth = keyWidth * 1.25
        numberAltKey = UIButton(type: .custom) as UIButton
        numberAltKey!.frame = CGRect(x: keySpacing / 2.0, y: bottomRowTopPadding, width:numberAltKeyWidth, height:keyHeight)
        numberAltKey?.backgroundColor = UIColor.groupTableViewBackground
        
        numberAltKey?.layer.borderColor = UIColor.lightGray.cgColor
        numberAltKey?.layer.borderWidth = 1.0
        numberAltKey?.layer.cornerRadius = 3.0
        
        numberAltKey!.titleLabel?.font = UIFont(name: "Helvetica", size:keyHeight / 3)
        numberAltKey!.setTitle("123", for: UIControlState())
        numberAltKey!.setTitleColor(UIColor.black, for: UIControlState())
        numberAltKey!.titleLabel?.textAlignment = .center
        numberAltKey!.titleLabel?.sizeToFit()
        numberAltKey!.addTarget(self, action: #selector(self.numKeyPressed(_:)), for: .touchUpInside)
        keyPadView?.addSubview(self.numberAltKey!)
        
        if is123KeySelected {
            numberAltKey!.setTitle("ABC", for: UIControlState())
        }
        
        // Next Key
        let nextKeyView = UIView(frame: CGRect(x: (keySpacing * 1.5 + numberAltKeyWidth), y: bottomRowTopPadding, width:numberAltKeyWidth, height:keyHeight))
        nextKeyView.backgroundColor = UIColor.groupTableViewBackground
        
        nextKeyView.layer.borderColor = UIColor.lightGray.cgColor
        nextKeyView.layer.borderWidth = 1.0
        nextKeyView.layer.cornerRadius = 3.0
        
        nextKey = UIButton(type: .custom) as UIButton
        nextKey!.frame = CGRect(x: 0, y: (keyHeight - numberAltKeyWidth) / 2, width:numberAltKeyWidth, height:numberAltKeyWidth)
        if numberAltKeyWidth > keyHeight {
            nextKey!.frame = CGRect(x: (numberAltKeyWidth - keyHeight) / 2, y: 0, width:keyHeight, height:keyHeight)
        }
        nextKey?.setBackgroundImage(UIImage(named: "OtherKeyboard_normal.png"), for: UIControlState())
        nextKey?.setBackgroundImage(UIImage(named: "OtherKeyboard_normal.png"), for: .highlighted)
        nextKey?.addTarget(self, action: #selector(UIInputViewController.advanceToNextInputMode), for: .touchUpInside)
        nextKeyView.addSubview(nextKey!)
        keyPadView?.addSubview(nextKeyView)
        
        // YourMoji Key
        let yourmojiKeyView = UIView(frame: CGRect(x: (keySpacing * 2.5 + numberAltKeyWidth * 2), y: bottomRowTopPadding, width:keyWidth, height:keyHeight))
        yourmojiKeyView.backgroundColor = UIColor.white
        
        yourmojiKeyView.layer.borderColor = UIColor.lightGray.cgColor
        yourmojiKeyView.layer.borderWidth = 1.0
        yourmojiKeyView.layer.cornerRadius = 3.0
        
        emojiAltKey = UIButton(type: .custom) as UIButton
        emojiAltKey!.frame = CGRect(x: 0, y: (keyHeight - keyWidth) / 2, width:keyWidth, height:keyWidth)
        if keyWidth > keyHeight {
            emojiAltKey!.frame = CGRect(x: (keyWidth - keyHeight) / 2, y: 0, width:keyHeight, height:keyHeight)
        }
        
        emojiAltKey?.setImage(UIImage(named: "ymoji_normal"), for: UIControlState())
        emojiAltKey?.setImage(UIImage(named: "ymoji_normal"), for: .highlighted)
        emojiAltKey?.addTarget(self, action: #selector(self.altEmojiButtonPressed(_:)), for: .touchUpInside)
        yourmojiKeyView.addSubview(emojiAltKey!)
        keyPadView?.addSubview(yourmojiKeyView)
        
        //Space Key
        
        let spaceWidth = (keyPadViewRect.width - keyWidth * 3.5 - keySpacing * 5) * 0.6
        spaceKey = UIButton(type: .custom) as UIButton
        spaceKey!.frame = CGRect(x: (keyWidth * 3.5 + keySpacing * 3.5), y: bottomRowTopPadding, width:spaceWidth, height:keyHeight)
        spaceKey?.backgroundColor = UIColor.white
        
        spaceKey?.layer.borderColor = UIColor.lightGray.cgColor
        spaceKey?.layer.borderWidth = 1.0
        spaceKey?.layer.cornerRadius = 3.0
        
        spaceKey!.titleLabel?.font = UIFont(name: "Helvetica", size:keyHeight / 2.3)
        spaceKey!.setTitle("space", for: UIControlState())
        spaceKey!.setTitleColor(UIColor.black, for: UIControlState())
        spaceKey!.titleLabel?.textAlignment = .center
        spaceKey!.titleLabel?.sizeToFit()
        spaceKey!.addTarget(self, action: #selector(self.spaceKeyPressed(_:)), for: .touchUpInside)
        keyPadView?.addSubview(spaceKey!)
        
        // Return Key
        returnButton = UIButton(type: .custom) as UIButton
        returnButton!.frame = CGRect(x: (keyWidth * 3.5 + keySpacing * 4.5 + spaceWidth), y: bottomRowTopPadding, width:spaceWidth * 2 / 3, height:keyHeight)
        
        returnButton?.backgroundColor = UIColor.groupTableViewBackground
        
        returnButton?.layer.borderColor = UIColor.lightGray.cgColor
        returnButton?.layer.borderWidth = 1.0
        returnButton?.layer.cornerRadius = 3.0
        
        returnButton!.titleLabel?.font = UIFont(name: "Helvetica", size:keyHeight / 2.3)
        returnButton!.setTitle("return", for: UIControlState())
        returnButton!.setTitleColor(UIColor.black, for: UIControlState())
        returnButton!.titleLabel?.textAlignment = .center
        returnButton!.titleLabel?.sizeToFit()
        returnButton!.addTarget(self, action: #selector(self.returnKeyPressed(_:)), for: .touchUpInside)
        keyPadView?.addSubview(returnButton!)
        
    }
    
    
    // MARK: -
    // MARK: - Keyboard Button Actions
    
    func brimojiButtonPressed(_ sender: UIButton) {
        
    }
    
    func buyNewButtonPressed(_ sender: UIButton) {
        
    }
    
    func shiftKeyPressed(_ sender: UIButton) {
        
        UIDevice.current.playInputClick()
        AudioServicesPlaySystemSound(1104)
        
        if numberOfShiftTap > 0 {
            isCapsLock = true
            setShiftValue(true)
            
            if currentScreenOrientation == ScreenOrientationMode.portrait {
                shiftKey!.setBackgroundImage(UIImage(named: "DoubleShiftKey_Port"), for: .normal)
                shiftKey!.setBackgroundImage(UIImage(named: "DoubleShiftKey_Port"), for: .selected)
                
            }
            else {
                shiftKey!.setBackgroundImage(UIImage(named: "DoubleShiftKey_Land"), for: .normal)
                shiftKey!.setBackgroundImage(UIImage(named: "DoubleShiftKey_Land"), for: .selected)
                
            }
            
        } else {
            numberOfShiftTap += 1
            
            isCapsLock = false
            setShiftValue(!shiftKey!.isSelected)
            
            if currentScreenOrientation == ScreenOrientationMode.portrait {
                shiftKey!.setBackgroundImage(UIImage(named: "ShiftKey_normal_Port.png"), for: .normal)
                shiftKey!.setBackgroundImage(UIImage(named: "ShiftKey_pressed_Port.png"), for: .selected)
            }
            else {
                shiftKey!.setBackgroundImage(UIImage(named: "ShiftKey_normal_Land.png"), for: .normal)
                shiftKey!.setBackgroundImage(UIImage(named: "ShiftKey_pressed_Land.png"), for: .selected)
            }
            
            shiftTimer?.invalidate()
            shiftTimer = nil
            shiftTimer = Timer.scheduledTimer(timeInterval: 1,
                                              target: self,
                                              selector: #selector(self.shiftTimeout),
                                              userInfo: nil,
                                              repeats: false)
            
            if isShiftKeySelected {
                shiftPosArr.append(0)
            }
            else if (shiftPosArr.count > 0) && (shiftPosArr[shiftPosArr.count - 1] == 0) {
                shiftPosArr.removeLast()
            }
            
            isSpacePressed = false
        }
        
    }
    
    func shiftTimeout() {
        shiftTimer?.invalidate()
        shiftTimer = nil
        numberOfShiftTap = 0
    }
    
    func setShiftValue(_ shiftVal: Bool) {
        if shiftKey?.isSelected != shiftVal {
            shiftKey?.isSelected = shiftVal
            for characterButton in fullKeyButtons {
                if shiftKey!.isSelected {
                    characterButton.setTitle(characterButton.titleLabel?.text?.uppercased(), for: UIControlState.normal)
                    isShiftKeySelected = true
                } else {
                    characterButton.setTitle(characterButton.titleLabel?.text?.lowercased(), for: UIControlState.normal)
                    isShiftKeySelected = false
                }
                
            }
            
        }
    }
    
    func deleteKeyPressed(_ sender: UIButton) {
        
        UIDevice.current.playInputClick()
        AudioServicesPlaySystemSound(1104)
        
        let isUpperCaseString: Bool = lastWordTyped!
        
        self.textDocumentProxy.deleteBackward()
        isSpacePressed = false
        
        if !self.textDocumentProxy.hasText || isUpperCaseString {
            setShiftValue(true)
        } else {
            setShiftValue(false)
        }
    }
    
    func longTap(_ sender : UIGestureRecognizer){
        if sender.state == .ended {
            //Do Whatever You want on End of Gesture
            delKeyTimer?.invalidate()
            numberOfDeletedCharacter = 0
        }
        else if sender.state == .began {
            //Do Whatever You want on Began of Gesture
            delKeyTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(handleDelKeyTimer(_:)), userInfo: nil, repeats: true)
        }
    }
    
    func handleDelKeyTimer(_ timer: Timer) {
        
        UIDevice.current.playInputClick()
        AudioServicesPlaySystemSound(1104)
        
        let isUpperCaseString: Bool = lastWordTyped!
        
        if numberOfDeletedCharacter > 10 {
            for _ in 0...numberOfDeletedCharacter {
                self.textDocumentProxy.deleteBackward()
            }
        } else {
            self.textDocumentProxy.deleteBackward()
            numberOfDeletedCharacter += 1
        }
        
        isSpacePressed = false
        
        if !self.textDocumentProxy.hasText || isUpperCaseString || isCapsLock {
            setShiftValue(true)
        } else {
            setShiftValue(false)
        }
    }
    
    var lastWordTyped: Bool? {
        if let documentContext = self.textDocumentProxy.documentContextBeforeInput {
            if documentContext.characters.count > 0 {
                let lastChar = documentContext.substring(from:documentContext.index(documentContext.endIndex, offsetBy: -1))
                if lastChar.lowercased() != lastChar {
                    return true
                } else {
                    return false
                }
                
            }
        }
        return false
    }
    
    func signKey1Pressed(_ sender: UIButton) {
        
        UIDevice.current.playInputClick()
        AudioServicesPlaySystemSound(1104)
        
        isSignKeySelected = true
        
        enKeyboardView?.isHidden = true
        numKeyboardView?.isHidden = true
        signKeyboardView?.isHidden = false
        
    }
    
    func signKey2Pressed(_ sender: UIButton) {
        
        UIDevice.current.playInputClick()
        AudioServicesPlaySystemSound(1104)
        
        isSignKeySelected = false
        
        enKeyboardView?.isHidden = true
        numKeyboardView?.isHidden = false
        signKeyboardView?.isHidden = true
        
    }
    
    func numKeyPressed(_ sender: UIButton) {
        
        UIDevice.current.playInputClick()
        AudioServicesPlaySystemSound(1104)
        
        is123KeySelected = !is123KeySelected
        
        if is123KeySelected {
            enKeyboardView?.isHidden = true
            numKeyboardView?.isHidden = false
            signKeyboardView?.isHidden = true
            numberAltKey!.setTitle("ABC", for: UIControlState())
        }
        else {
            enKeyboardView?.isHidden = false
            numKeyboardView?.isHidden = true
            signKeyboardView?.isHidden = true
            numberAltKey!.setTitle("123", for: UIControlState())
        }
    }
    
    func returnKeyPressed(_ sender: UIButton) {
        
        UIDevice.current.playInputClick()
        AudioServicesPlaySystemSound(1104)
        
        let proxy = self.textDocumentProxy as UITextDocumentProxy
        proxy.insertText("\n")
        shiftPosArr[shiftPosArr.count - 1] += 1
        if shiftKey!.isSelected {
            shiftPosArr.append(0)
        }
        setShiftValue(true)
        
        isSpacePressed = false
    }
    
    func altEmojiButtonPressed(_ sender: UIButton) {
        
        UIDevice.current.playInputClick()
        AudioServicesPlaySystemSound(1104)
        
        setBoardMode(BoardMode.standardboard)
        currentNavButtonStatus = NavButtonStatus.sticker
        drawEmojiBoard()
        
    }
    
    func spaceKeyPressed(_ sender: UIButton) {
        
        UIDevice.current.playInputClick()
        AudioServicesPlaySystemSound(1104)
        
        let proxy = self.textDocumentProxy as UITextDocumentProxy
        var str: String = " "
        
        if sender.titleLabel?.text == "space" {
            str = " "
        }
        
        var isDoubleTappedSpaceBtn = false
        
        if isSpacePressed && str == " " {
            proxy.deleteBackward()
            proxy.insertText(". ")
            isSpacePressed = false
            
            isDoubleTappedSpaceBtn = true
        }
        else {
            proxy.insertText(str )
            isSpacePressed = str == " "
            if isSpacePressed {
                spaceTimer?.invalidate()
                spaceTimer = Timer.scheduledTimer(timeInterval: 1,
                                                  target: self,
                                                  selector: #selector(self.spaceTimeout),
                                                  userInfo: nil,
                                                  repeats: false)
            }
            
        }
        
        shiftPosArr[shiftPosArr.count - 1] += 1
        if (isShiftKeySelected && !isCapsLock) {
            self.setShiftValue(false)
        }
        
        if sender.titleLabel?.text == "space" {
            if isFullStopPressed {
                isShiftKeySelected = true
                self.setShiftValue(true)
                isFullStopPressed = false
            }
            
        } else {
            isFullStopPressed = false
        }
        
        if isDoubleTappedSpaceBtn {
            isShiftKeySelected = true
            self.setShiftValue(true)
        }
        
        if (enKeyboardView?.isHidden)! {
            isShiftKeySelected = true
            self.setShiftValue(true)
            enKeyboardView?.isHidden = false
            numKeyboardView?.isHidden = true
            signKeyboardView?.isHidden = true
        }
        
        runReplaceLogic()
        
    }
    
    func spaceTimeout() {
        spaceTimer = nil
        isSpacePressed = false
    }
    
    func runReplaceLogic() {
        if let documentContext = self.textDocumentProxy.documentContextBeforeInput {
            
            var myNSString: NSString!
            var aChar: String!
            
            if documentContext.characters.count > 6 {
                let last7Chars = documentContext.substring(from:documentContext.index(documentContext.endIndex, offsetBy: -7))
                myNSString = last7Chars as NSString
                aChar = myNSString.substring(with: NSRange(location: 0, length: 1))
                
                if last7Chars.lowercased() == " youre " {
                    
                    for _ in 0...6 {
                        self.textDocumentProxy.deleteBackward()
                    }
                    
                    if aChar.lowercased() == aChar {
                        self.textDocumentProxy.insertText(" you're ")
                        return
                        
                    } else {
                        self.textDocumentProxy.insertText(" You're ")
                        return
                        
                    }
                    
                }
            }
            
            if documentContext.characters.count > 5 {
                let last6Chars = documentContext.substring(from:documentContext.index(documentContext.endIndex, offsetBy: -6))
                myNSString = last6Chars as NSString
                aChar = myNSString.substring(with: NSRange(location: 0, length: 1))
                
                if last6Chars.lowercased() == "youre " && documentContext.characters.count == 6 {
                    
                    for _ in 0...5 {
                        self.textDocumentProxy.deleteBackward()
                    }
                    self.textDocumentProxy.insertText("You're ")
                    return
                    
                } else if last6Chars.lowercased() == " wont " {
                    
                    for _ in 0...5 {
                        self.textDocumentProxy.deleteBackward()
                    }
                    
                    // detect Low or Upper of t
                    if aChar.lowercased() == aChar {
                        self.textDocumentProxy.insertText(" won't ")
                        return
                        
                    } else {
                        self.textDocumentProxy.insertText(" Won't ")
                        return
                        
                    }
                    
                } else if last6Chars.lowercased() == " cant " {
                    
                    for _ in 0...5 {
                        self.textDocumentProxy.deleteBackward()
                    }
                    
                    // detect Low or Upper of t
                    if aChar.lowercased() == aChar {
                        self.textDocumentProxy.insertText(" can't ")
                        return
                        
                    } else {
                        self.textDocumentProxy.insertText(" Can't ")
                        return
                        
                    }
                    
                } else if last6Chars.lowercased() == " hows " {
                    
                    for _ in 0...5 {
                        self.textDocumentProxy.deleteBackward()
                    }
                    
                    // detect Low or Upper of t
                    if aChar.lowercased() == aChar {
                        self.textDocumentProxy.insertText(" how's ")
                        return
                        
                    } else {
                        self.textDocumentProxy.insertText(" How's ")
                        return
                        
                    }
                    
                }
                
            }
            
            if documentContext.characters.count > 4 {
                let last5Chars = documentContext.substring(from:documentContext.index(documentContext.endIndex, offsetBy: -5))
                myNSString = last5Chars as NSString
                aChar = myNSString.substring(with: NSRange(location: 0, length: 1))
                
                if last5Chars.lowercased() == "wont " && documentContext.characters.count == 5 {
                    
                    for _ in 0...4 {
                        self.textDocumentProxy.deleteBackward()
                    }
                    self.textDocumentProxy.insertText("Won't ")
                    return
                    
                } else if last5Chars.lowercased() == "cant " && documentContext.characters.count == 5 {
                    
                    for _ in 0...4 {
                        self.textDocumentProxy.deleteBackward()
                    }
                    self.textDocumentProxy.insertText("Can't ")
                    return
                    
                } else if last5Chars.lowercased() == "hows " && documentContext.characters.count == 5 {
                    
                    for _ in 0...4 {
                        self.textDocumentProxy.deleteBackward()
                    }
                    self.textDocumentProxy.insertText("How's ")
                    return
                    
                }
                
            }
            
            if documentContext.characters.count > 3 {
                let last4Chars = documentContext.substring(from:documentContext.index(documentContext.endIndex, offsetBy: -4))
                myNSString = last4Chars as NSString
                aChar = myNSString.substring(with: NSRange(location: 0, length: 1))
                
                if last4Chars.lowercased() == " im " {
                    
                    for _ in 0...3 {
                        self.textDocumentProxy.deleteBackward()
                    }
                    
                    self.textDocumentProxy.insertText(" I'm ")
                    return
                    
                }
                
            }
            
            if documentContext.characters.count > 2 {
                let last3Chars = documentContext.substring(from:documentContext.index(documentContext.endIndex, offsetBy: -3))
                
                if last3Chars.lowercased() == " i " {
                    for _ in 0...2 {
                        self.textDocumentProxy.deleteBackward()
                    }
                    self.textDocumentProxy.insertText(" I ")
                    return
                    
                } else if (last3Chars.lowercased() == "im ") && documentContext.characters.count == 3 {
                    for _ in 0...2 {
                        self.textDocumentProxy.deleteBackward()
                    }
                    self.textDocumentProxy.insertText("I'm ")
                    return
                    
                }
                
            }
            
        }
        
    }
    
    
    func setBoardMode(_ selectedMode: BoardMode) {
        
        switch selectedMode {
        case BoardMode.standardboard:
            standardEmojiButton?.setBackgroundImage(UIImage(named: "ymoji_normal"), for: .normal)
            standardEmojiButton?.setBackgroundImage(UIImage(named: "ymoji_highlight"), for: .highlighted)
            recentEmojiButton?.setBackgroundImage(UIImage(named: "Recent_normal"), for: .normal)
            recentEmojiButton?.setBackgroundImage(UIImage(named: "Recent_pressed"), for: .highlighted)
            
            keyBoardView?.isHidden = true
            emojiBoardView?.isHidden = false
            break
        case BoardMode.recentboard:
            standardEmojiButton?.setBackgroundImage(UIImage(named: "ymoji_highlight"), for: .normal)
            standardEmojiButton?.setBackgroundImage(UIImage(named: "ymoji_normal"), for: .highlighted)
            recentEmojiButton?.setBackgroundImage(UIImage(named: "Recent_pressed"), for: .normal)
            recentEmojiButton?.setBackgroundImage(UIImage(named: "Recent_normal"), for: .highlighted)
            
            keyBoardView?.isHidden = true
            emojiBoardView?.isHidden = false
            break
        default:
            standardEmojiButton?.setBackgroundImage(UIImage(named: "ymoji_normal"), for: .normal)
            standardEmojiButton?.setBackgroundImage(UIImage(named: "ymoji_highlight"), for: .highlighted)
            recentEmojiButton?.setBackgroundImage(UIImage(named: "Recent_normal"), for: .normal)
            recentEmojiButton?.setBackgroundImage(UIImage(named: "Recent_pressed"), for: .highlighted)
            
            keyBoardView?.isHidden = false
            emojiBoardView?.isHidden = true
            break
        }
        
        currentBoardMode = selectedMode
        
    }
    
    // MARK: -
    // MARK: - Touch Event Delegate
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let location: CGPoint
        var searchFrame: CGRect
        var index = 0
        
        if !(enKeyboardView?.isHidden)! {
            let touchesSet=touches as NSSet
            let touch=touchesSet.anyObject() as? UITouch
            location = (touch?.location(in: enKeyboardView))!
            
            for b: UIButton in fullKeyButtons {
                searchFrame = CGRect(x: b.frame.origin.x - keySpacing / 2, y: b.frame.origin.y - rowSpacing / 2, width: b.frame.size.width + keySpacing, height: b.frame.size.height + rowSpacing)
                if index == 10 {
                    searchFrame = CGRect(x: b.frame.origin.x - keySpacing * 2, y: b.frame.origin.y - rowSpacing / 2, width: b.frame.size.width + keySpacing * 2.5, height: b.frame.size.height + rowSpacing)
                } else if index == 18 {
                    searchFrame = CGRect(x: b.frame.origin.x - keySpacing / 2, y: b.frame.origin.y - rowSpacing / 2, width: b.frame.size.width + keySpacing * 2.5, height: b.frame.size.height + rowSpacing)
                }
                
                if b.subviews.count > 1 {
                    b.subviews[1].removeFromSuperview()
                }
                if searchFrame.contains(location) {
                    addPopupToButton(uint(index), button: b)
                    UIDevice.current.playInputClick()
                }
                index += 1
                
            }
            
        } else if !(numKeyboardView?.isHidden)! {
            let touchesSet=touches as NSSet
            let touch=touchesSet.anyObject() as? UITouch
            location = (touch?.location(in: numKeyboardView))!
            
            for b: UIButton in numKeyButtons {
                searchFrame = CGRect(x: b.frame.origin.x - keySpacing / 2, y: b.frame.origin.y - rowSpacing / 2, width: b.frame.size.width + keySpacing, height: b.frame.size.height + rowSpacing)
                
                if b.subviews.count > 1 {
                    b.subviews[1].removeFromSuperview()
                }
                if searchFrame.contains(location) {
                    addPopupToButton(uint(index), button: b)
                    UIDevice.current.playInputClick()
                }
                index += 1
                
            }
            
        } else if !(signKeyboardView?.isHidden)! {
            let touchesSet=touches as NSSet
            let touch=touchesSet.anyObject() as? UITouch
            location = (touch?.location(in: signKeyboardView))!
            
            for b: UIButton in signKeyButtons {
                searchFrame = CGRect(x: b.frame.origin.x - keySpacing / 2, y: b.frame.origin.y - rowSpacing / 2, width: b.frame.size.width + keySpacing, height: b.frame.size.height + rowSpacing)
                if b.subviews.count > 1 {
                    b.subviews[1].removeFromSuperview()
                }
                if searchFrame.contains(location) {
                    addPopupToButton(uint(index), button: b)
                    UIDevice.current.playInputClick()
                }
                index += 1
                
            }
            
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let location: CGPoint
        var searchFrame: CGRect
        var index = 0
        
        if !(enKeyboardView?.isHidden)! {
            let touchesSet=touches as NSSet
            let touch=touchesSet.anyObject() as? UITouch
            location = (touch?.location(in: enKeyboardView))!
            
            for b: UIButton in fullKeyButtons {
                searchFrame = CGRect(x: b.frame.origin.x - keySpacing / 2, y: b.frame.origin.y - rowSpacing / 2, width: b.frame.size.width + keySpacing, height: b.frame.size.height + rowSpacing)
                if index == 10 {
                    searchFrame = CGRect(x: b.frame.origin.x - keySpacing * 2, y: b.frame.origin.y - rowSpacing / 2, width: b.frame.size.width + keySpacing * 2.5, height: b.frame.size.height + rowSpacing)
                } else if index == 18 {
                    searchFrame = CGRect(x: b.frame.origin.x - keySpacing / 2, y: b.frame.origin.y - rowSpacing / 2, width: b.frame.size.width + keySpacing * 2.5, height: b.frame.size.height + rowSpacing)
                }
                
                if b.subviews.count > 1 {
                    b.subviews[1].removeFromSuperview()
                }
                if searchFrame.contains(location) {
                    addPopupToButton(uint(index), button: b)
                }
                index += 1
                
            }
            
        } else if !(numKeyboardView?.isHidden)! {
            let touchesSet=touches as NSSet
            let touch=touchesSet.anyObject() as? UITouch
            location = (touch?.location(in: numKeyboardView))!
            
            for b: UIButton in numKeyButtons {
                searchFrame = CGRect(x: b.frame.origin.x - keySpacing / 2, y: b.frame.origin.y - rowSpacing / 2, width: b.frame.size.width + keySpacing, height: b.frame.size.height + rowSpacing)
                
                if b.subviews.count > 1 {
                    b.subviews[1].removeFromSuperview()
                }
                if searchFrame.contains(location) {
                    addPopupToButton(uint(index), button: b)
                }
                index += 1
                
            }
            
        } else if !(signKeyboardView?.isHidden)! {
            let touchesSet=touches as NSSet
            let touch=touchesSet.anyObject() as? UITouch
            location = (touch?.location(in: signKeyboardView))!
            
            for b: UIButton in signKeyButtons {
                searchFrame = CGRect(x: b.frame.origin.x - keySpacing / 2, y: b.frame.origin.y - rowSpacing / 2, width: b.frame.size.width + keySpacing, height: b.frame.size.height + rowSpacing)
                if b.subviews.count > 1 {
                    b.subviews[1].removeFromSuperview()
                }
                if searchFrame.contains(location) {
                    addPopupToButton(uint(index), button: b)
                }
                index += 1
                
            }
            
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let location: CGPoint
        var searchFrame: CGRect
        var index = 0
        
        if !(enKeyboardView?.isHidden)! {
            let touchesSet=touches as NSSet
            let touch=touchesSet.anyObject() as? UITouch
            location = (touch?.location(in: enKeyboardView))!
            
            for b: UIButton in fullKeyButtons {
                searchFrame = CGRect(x: b.frame.origin.x - keySpacing / 2, y: b.frame.origin.y - rowSpacing / 2, width: b.frame.size.width + keySpacing, height: b.frame.size.height + rowSpacing)
                if index == 10 {
                    searchFrame = CGRect(x: b.frame.origin.x - keySpacing * 2, y: b.frame.origin.y - rowSpacing / 2, width: b.frame.size.width + keySpacing * 2.5, height: b.frame.size.height + rowSpacing)
                } else if index == 18 {
                    searchFrame = CGRect(x: b.frame.origin.x - keySpacing / 2, y: b.frame.origin.y - rowSpacing / 2, width: b.frame.size.width + keySpacing * 2.5, height: b.frame.size.height + rowSpacing)
                }
                
                if b.subviews.count > 1 {
                    b.subviews[1].removeFromSuperview()
                }
                if searchFrame.contains(location) {
                    UIDevice.current.playInputClick()
                    insertTextFromButton(b)
                }
                index += 1
                
            }
            
        } else if !(numKeyboardView?.isHidden)! {
            let touchesSet=touches as NSSet
            let touch=touchesSet.anyObject() as? UITouch
            location = (touch?.location(in: numKeyboardView))!
            
            for b: UIButton in numKeyButtons {
                searchFrame = CGRect(x: b.frame.origin.x - keySpacing / 2, y: b.frame.origin.y - rowSpacing / 2, width: b.frame.size.width + keySpacing, height: b.frame.size.height + rowSpacing)
                
                if b.subviews.count > 1 {
                    b.subviews[1].removeFromSuperview()
                }
                if searchFrame.contains(location) {
                    insertTextFromButton(b)
                }
                index += 1
                
            }
            
        } else if !(signKeyboardView?.isHidden)! {
            let touchesSet=touches as NSSet
            let touch=touchesSet.anyObject() as? UITouch
            location = (touch?.location(in: signKeyboardView))!
            
            for b: UIButton in signKeyButtons {
                searchFrame = CGRect(x: b.frame.origin.x - keySpacing / 2, y: b.frame.origin.y - rowSpacing / 2, width: b.frame.size.width + keySpacing, height: b.frame.size.height + rowSpacing)
                if b.subviews.count > 1 {
                    b.subviews[1].removeFromSuperview()
                }
                if searchFrame.contains(location) {
                    insertTextFromButton(b)
                }
                index += 1
                
            }
            
        }
    }
    
    func addPopupToButton(_ index: uint, button: UIButton) {
        
        let keyPop: UIImageView;
        let text: UILabel = UILabel(frame: CGRect(x: 0, y: 5, width: keyWidth * 3.0, height: keyWidth * 1.7))
        text.font = UIFont(name: "Helvetica", size:35)
        
        if currentScreenOrientation == ScreenOrientationMode.portrait {
            
            if button == fullKeyButtons[0] || button == numKeyButtons[0] || button == numKeyButtons[10] || button == signKeyButtons[0] || button == signKeyButtons[10] {
                keyPop = UIImageView.init(image: keyPopImage.createiOS7KeytopImage(withKind: Int32(PKNumberPadViewImageRight)))
                keyPop.frame = CGRect(x: -(keyWidth * 0.6), y: -(keyHeight * 1.5), width: keyWidth * 3.0, height: keyHeight * 2.7)
            } else if button == fullKeyButtons[9] || button == numKeyButtons[9] || button == numKeyButtons[19] || button == signKeyButtons[9] || button == signKeyButtons[19] {
                keyPop = UIImageView.init(image: keyPopImage.createiOS7KeytopImage(withKind: Int32(PKNumberPadViewImageLeft)))
                keyPop.frame = CGRect(x: -(keyWidth * 1.4), y: -(keyHeight * 1.5), width: keyWidth * 3.0, height: keyHeight * 2.7)
            } else {
                keyPop = UIImageView.init(image: keyPopImage.createiOS7KeytopImage(withKind: Int32(PKNumberPadViewImageInner)))
                keyPop.frame = CGRect(x: -(keyWidth * 1.0), y: -(keyHeight * 1.5), width: keyWidth * 3.0, height: keyHeight * 2.7)
            }
            
        } else {
            
            text.frame = CGRect(x: 0, y: 5, width: keyWidth * 3.0, height: keyWidth * 0.7)
            text.font = UIFont(name: "Helvetica", size:25)
            
            if button == fullKeyButtons[0] || button == numKeyButtons[0] || button == numKeyButtons[10] || button == signKeyButtons[0] || button == signKeyButtons[10] {
                keyPop = UIImageView.init(image: keyPopImage.createiOS7KeytopImage(withKind: Int32(PKNumberPadViewImageRight)))
                keyPop.frame = CGRect(x: -(keyWidth * 0.6), y: -(keyHeight * 1.5), width: keyWidth * 3.0, height: keyHeight * 2.7)
            } else if button == fullKeyButtons[9] || button == numKeyButtons[9] || button == numKeyButtons[19] || button == signKeyButtons[9] || button == signKeyButtons[19] {
                keyPop = UIImageView.init(image: keyPopImage.createiOS7KeytopImage(withKind: Int32(PKNumberPadViewImageLeft)))
                keyPop.frame = CGRect(x: -(keyWidth * 1.4), y: -(keyHeight * 1.5), width: keyWidth * 3.0, height: keyHeight * 2.7)
            } else {
                keyPop = UIImageView.init(image: keyPopImage.createiOS7KeytopImage(withKind: Int32(PKNumberPadViewImageInner)))
                keyPop.frame = CGRect(x: -(keyWidth * 1.0), y: -(keyHeight * 1.5), width: keyWidth * 3.0, height: keyHeight * 2.7)
            }
            
        }
        
        text.textAlignment = .center
        text.backgroundColor = UIColor.clear
        text.adjustsFontSizeToFitWidth = true
        text.text = button.currentTitle
        
        keyPop.layer.shadowColor = UIColor(white: 0.1, alpha: 1.0).cgColor
        keyPop.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        keyPop.layer.shadowOpacity = 0.30
        keyPop.layer.shadowRadius = 3.0
        keyPop.clipsToBounds = false
        
        keyPop.addSubview(text)
        button.addSubview(keyPop)
        
    }
    
    func insertTextFromButton(_ button: UIButton) {
        
        AudioServicesPlaySystemSound(1104)
        
        let proxy = self.textDocumentProxy as UITextDocumentProxy
        
        if isCapsLock {
            proxy.insertText((button.currentTitle?.uppercased())!)
            isShiftKeySelected = true
            self.setShiftValue(true)
        } else if isShiftKeySelected {
            proxy.insertText((button.currentTitle?.uppercased())!)
            isShiftKeySelected = false
            self.setShiftValue(false)
        } else {
            proxy.insertText((button.currentTitle?.lowercased())!)
            self.setShiftValue(false)
        }
        
        isSpacePressed = false
        
        if button.currentTitle == "." {
            self.isFullStopPressed = true
        }
        
        if button.currentTitle == "." || button.currentTitle == "," {
            is123KeySelected = false
            self.enKeyboardView?.isHidden = false
            self.numKeyboardView?.isHidden = true
            self.signKeyboardView?.isHidden = true
            numberAltKey!.setTitle("123", for: UIControlState())
        }
        
    }
    
    
    // MARK: -
    // MARK: - Draw EmojiBoard
    
    func drawEmojiBoard() {
        if keyboardHeight == 0.0 || keyboardWidth == 0.0 {
            return
        }
        
        if (emojiBoardView == nil) {
            
            emojiBoardView = UIView(frame: emojiBoardViewRect)
            emojiBoardView!.backgroundColor = UIColor.white
            self.view.addSubview(emojiBoardView!)
            
        } else {
            
            emojiBoardView?.frame = emojiBoardViewRect
            
        }
        
        drawToolBar()
        drawCollectionViews()
        
    }
    
    func drawToolBar() -> Void {
        
        // Other Keyboard button
        if (otherKeyboardButton == nil) {
            otherKeyboardButton = UIButton(type: .custom) as UIButton
            otherKeyboardButton?.frame = otherKeyboardButtonRect
            otherKeyboardButton?.setBackgroundImage(UIImage(named: "OtherKeyboard_normal.png"), for: UIControlState())
            otherKeyboardButton?.setBackgroundImage(UIImage(named: "OtherKeyboard_pressed.png"), for: .highlighted)
            otherKeyboardButton?.addTarget(self, action: #selector(UIInputViewController.advanceToNextInputMode), for: .touchUpInside)
            emojiBoardView?.addSubview(otherKeyboardButton!)
        }
        else {
            otherKeyboardButton?.frame = otherKeyboardButtonRect
        }
        
        // Standard emojies button
        if (standardEmojiButton == nil) {
            standardEmojiButton = UIButton(type: .custom) as UIButton
            standardEmojiButton?.frame = standardEmojiButtonRect
            standardEmojiButton?.setBackgroundImage(UIImage(named: "ymoji_normal"), for: UIControlState())
            standardEmojiButton?.setBackgroundImage(UIImage(named: "ymoji_highlight"), for: .highlighted)
            standardEmojiButton?.addTarget(self, action: #selector(self.standardButtonPressed(_:)), for: .touchUpInside)
            emojiBoardView?.addSubview(standardEmojiButton!)
        }
        else {
            standardEmojiButton?.frame = standardEmojiButtonRect
        }
        
        // Recents button
        if (recentEmojiButton == nil) {
            recentEmojiButton = UIButton(type: .custom) as UIButton
            recentEmojiButton?.frame = recentEmojiButtonRect
            recentEmojiButton?.setBackgroundImage(UIImage(named: "Recent_normal.png"), for: UIControlState())
            recentEmojiButton?.setBackgroundImage(UIImage(named: "Recent_pressed.png"), for: .highlighted)
            recentEmojiButton?.addTarget(self, action: #selector(self.recentButtonPressed(_:)), for: .touchUpInside)
            emojiBoardView?.addSubview(recentEmojiButton!)
        }
        else {
            recentEmojiButton?.frame = recentEmojiButtonRect
        }
        
        // Full Keyboard button
        if (keyboardButton == nil) {
            keyboardButton = UIButton(type: .custom) as UIButton
            keyboardButton?.frame = keyboardButtonRect
            keyboardButton?.setBackgroundImage(UIImage(named: "Keyboard_normal.png"), for: UIControlState())
            keyboardButton?.setBackgroundImage(UIImage(named: "Keyboard_pressed.png"), for: .highlighted)
            keyboardButton?.addTarget(self, action: #selector(self.keyboardButtonPressed(_:)), for: .touchUpInside)
            emojiBoardView?.addSubview(keyboardButton!)
        }
        else {
            keyboardButton?.frame = keyboardButtonRect
        }
        
        // Delete button
        if (delelteEmojiButton == nil) {
            delelteEmojiButton = UIButton(type: .custom) as UIButton
            delelteEmojiButton?.frame = delelteEmojiButtonRect
            delelteEmojiButton?.setBackgroundImage(UIImage(named: "DeletePin_normal.png"), for: UIControlState())
            delelteEmojiButton?.setBackgroundImage(UIImage(named: "DeletePin_pressed.png"), for: .highlighted)
            
            let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.longTap(_:)))
            delelteEmojiButton!.addGestureRecognizer(longGesture)
            
            delelteEmojiButton?.addTarget(self, action: #selector(self.deleteKeyPressed(_:)), for: .touchUpInside)
            emojiBoardView?.addSubview(delelteEmojiButton!)
        }
        else {
            delelteEmojiButton?.frame = delelteEmojiButtonRect
        }
        
    }
    
    func drawCollectionViews() {
        
        loadRecentEmojies()
        
        if (emojiCollectionViewBoard == nil) {
            
            emojiCollectionViewBoard = UIView(frame: emojiCollectionViewRect)
            emojiCollectionViewBoard?.backgroundColor = UIColor.clear
            emojiBoardView?.addSubview(emojiCollectionViewBoard!)
            
        } else {
            emojiCollectionViewBoard?.frame = emojiCollectionViewRect
        }
        
        switch currentBoardMode {
        case BoardMode.standardboard:
            for view in emojiCollectionViewBoard!.subviews {
                if (view as! UICollectionView) != standardStickerCollectionView {
                    view.removeFromSuperview()
                }
            }
            
            recentStickerCollectionView = nil
            
            //standard sticker collectionview
            if (standardStickerCollectionView == nil) {
                standardStickerCollectionView = createCollectionView(CGRect(x: 0, y: 0, width: emojiCollectionViewRect.width, height: emojiCollectionViewRect.height), tag: 1)
                emojiCollectionViewBoard?.addSubview(standardStickerCollectionView!)
                standardStickerCollectionView?.reloadData()
            } else {
                standardStickerCollectionView?.frame = CGRect(x: 0, y: 0, width: emojiCollectionViewRect.width, height: emojiCollectionViewRect.height)
                standardStickerCollectionView?.reloadData()
            }
            break
        case BoardMode.recentboard:
            for view in emojiCollectionViewBoard!.subviews {
                if (view as! UICollectionView) != recentStickerCollectionView {
                    view.removeFromSuperview()
                }
            }
            standardStickerCollectionView = nil
            
            //recent sticker collectionview
            if (recentStickerCollectionView == nil) {
                recentStickerCollectionView = createCollectionView(CGRect(x: 0, y: 0, width: emojiCollectionViewRect.width, height: emojiCollectionViewRect.height), tag: 4)
                emojiCollectionViewBoard?.addSubview(recentStickerCollectionView!)
                recentStickerCollectionView?.reloadData()
            } else {
                recentStickerCollectionView?.frame = CGRect(x: 0, y: 0, width: emojiCollectionViewRect.width, height: emojiCollectionViewRect.height)
                recentStickerCollectionView?.reloadData()
            }
            break
        default:
            break
        }
        
    }
    
    func loadRecentEmojies() {
        
        if globalUserDefaults.array(forKey: "recentStickers") != nil {
            recentStickers = globalUserDefaults.array(forKey: "recentStickers") as! Array<String>
        }
        
    }
    
    func resizeImage(_ image: UIImage, newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: newWidth * 0.1, y: newHeight * 0.1, width: newWidth * 0.8, height: newHeight * 0.8))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    
    // MARK: -
    // MARK: - Emojiboard Button Actions
    
    func standardButtonPressed(_ sender: UIButton) {
        
        UIDevice.current.playInputClick()
        AudioServicesPlaySystemSound(1104)
        
        if currentBoardMode == BoardMode.standardboard {
            return
        }
        
        setBoardMode(BoardMode.standardboard)
        drawCollectionViews()
        
    }
    
    func recentButtonPressed(_ sender: UIButton) {
        
        UIDevice.current.playInputClick()
        AudioServicesPlaySystemSound(1104)
        
        if currentBoardMode == BoardMode.recentboard {
            return
        }
        
        setBoardMode(BoardMode.recentboard)
        drawCollectionViews()
        
    }
    
    func keyboardButtonPressed(_ sender: UIButton) {
        
        UIDevice.current.playInputClick()
        AudioServicesPlaySystemSound(1104)
        
        drawKeyboard()
        setBoardMode(BoardMode.keyboard)
        
    }
    
    
    func tapPreviewBackground(_ recognizer: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.3, delay: 0.1, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.videoPreviewBG!.alpha = 0
            
        }) { _ in
            self.videoPreviewBG!.isHidden = true
            self.videoPlayer?.pause()
            self.videoPlayerItem = nil
            
        }
        
    }
    
    func createCollectionView(_ rect: CGRect, tag: Int) -> UICollectionView {
        
        let pinsCollectionViewLayout: YMojiKeyboardCollectionViewLayout = YMojiKeyboardCollectionViewLayout()
        pinsCollectionViewLayout.cellPadding = 2
        pinsCollectionViewLayout.delegate = self
        pinsCollectionViewLayout.numberOfRows = numberOfRowsOfCollectionView
        
        if tag == 0 {
            pinsCollectionViewLayout.numberOfRows = numberOfRowsOfPredictCollctionView
        }
        pinsCollectionViewLayout.scrollDirection = .vertical
        
        let collectionView: UICollectionView = UICollectionView(frame: rect, collectionViewLayout: pinsCollectionViewLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.tag = tag
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        
        let nibName = UINib(nibName: "YMojiCollectionViewCell", bundle: Bundle.main)
        collectionView.register(nibName, forCellWithReuseIdentifier: "YMojiCollectionViewCell")
        
        return collectionView
    }
    
    // MARK: -
    // MARK: - CollectionView Delegate
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        var number = 0
        switch collectionView.tag {
        case 1:
            number = standardStickers.count
            break
        case 4:
            number = recentStickers.count
            break
        default:
            number = standardStickers.count
            break
        }
        
        return number
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "YMojiCollectionViewCell", for: indexPath) as! YMojiCollectionViewCell
        
        switch collectionView.tag {
        case 1:
            let fileName = standardStickers[(indexPath as NSIndexPath).item]
            if fileName == "minion5" || fileName == "minion9" || fileName == "minion14" {
                
                cell.containerImageView.image = UIImage.animatedImage(withAnimatedGIFURL: URL(fileURLWithPath: Bundle.main.path(forResource: fileName, ofType: "gif")!))
            } else {
                
                cell.containerImageView.image = UIImage(named: fileName)
            }
            cell.layoutIfNeeded()
            break
        case 4:
            let fileName = recentStickers[(indexPath as NSIndexPath).item]
            if fileName == "minion5" || fileName == "minion9" || fileName == "minion14" {
                
                cell.containerImageView.image = UIImage.animatedImage(withAnimatedGIFURL: URL(fileURLWithPath: Bundle.main.path(forResource: fileName, ofType: "gif")!))
            } else {
                
                cell.containerImageView.image = UIImage(named: fileName)
            }
            cell.layoutIfNeeded()
            break
        default:
            let fileName = standardStickers[(indexPath as NSIndexPath).item]
            if fileName == "minion5" || fileName == "minion9" || fileName == "minion14" {
                
                cell.containerImageView.image = UIImage.animatedImage(withAnimatedGIFURL: URL(fileURLWithPath: Bundle.main.path(forResource: fileName, ofType: "gif")!))
            } else {
                
                cell.containerImageView.image = UIImage(named: fileName)
            }
            cell.layoutIfNeeded()
            break
        }
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, widthForPhotoAtIndexPath indexPath: IndexPath, withHeight height: CGFloat) -> CGFloat {
        
        var ratio: CGFloat = 1.0
        var imageWidth: CGFloat = 0.0
        var imageHeight: CGFloat = 0.0
        
        switch collectionView.tag {
        case 1:
            var image:UIImage = UIImage()
            let fileName = standardStickers[(indexPath as NSIndexPath).item]
            
            if fileName == "minion5" || fileName == "minion9" || fileName == "minion14" {
                
                image = UIImage.animatedImage(withAnimatedGIFURL: URL(fileURLWithPath: Bundle.main.path(forResource: fileName, ofType: "gif")!))
            } else {
                
                image = UIImage(named: fileName)!
            }
            
            imageWidth = CGFloat(image.size.width)
            imageHeight = CGFloat(image.size.height)
            
            break
        case 4:
            var image:UIImage = UIImage()
            let fileName = recentStickers[(indexPath as NSIndexPath).item]
            
            if fileName == "minion5" || fileName == "minion9" || fileName == "minion14" {
                
                image = UIImage.animatedImage(withAnimatedGIFURL: URL(fileURLWithPath: Bundle.main.path(forResource: fileName, ofType: "gif")!))
            } else {
                
                image = UIImage(named: fileName)!
            }
            
            imageWidth = CGFloat(image.size.width)
            imageHeight = CGFloat(image.size.height)
            
            break
        default:
            var image:UIImage = UIImage()
            let fileName = standardStickers[(indexPath as NSIndexPath).item]
            
            if fileName == "minion5" || fileName == "minion9" || fileName == "minion14" {
                
                image = UIImage.animatedImage(withAnimatedGIFURL: URL(fileURLWithPath: Bundle.main.path(forResource: fileName, ofType: "gif")!))
            } else {
                
                image = UIImage(named: fileName)!
            }
            
            imageWidth = CGFloat(image.size.width)
            imageHeight = CGFloat(image.size.height)
            
            break
        }
        
        ratio = imageWidth / imageHeight
        let size = CGSize(width: 100 * ratio, height: 100)
        let boundingRect = CGRect(x: 0, y: 0, width: CGFloat(MAXFLOAT), height: height)
        let rect = AVMakeRect(aspectRatio: size, insideRect: boundingRect)
        
        return rect.width
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.centeredVertically, animated: true)
        let attributes = collectionView.layoutAttributesForItem(at: indexPath)!
        
        switch collectionView.tag {
        case 1:
            let fileName = standardStickers[(indexPath as NSIndexPath).item]
            
            if fileName == "minion5" || fileName == "minion9" || fileName == "minion14" {
                
                selectedEmojiType = "gif"
                let url = Bundle.main.url(forResource: fileName, withExtension: "gif")
                let urlData = try? Data(contentsOf: url!)
                UIPasteboard.general.setData(urlData!, forPasteboardType: "com.compuserve.gif")
            } else {
                
                selectedEmojiType = "sticker"
                let data = UIImagePNGRepresentation(resizeImage(UIImage(named: standardStickers[(indexPath as NSIndexPath).item])!, newWidth: 408))
                UIPasteboard.general.setData(data!, forPasteboardType: kUTTypePNG as String)
            }
            
            createCopiedLabelAndAnimation(collectionView, indexPath: indexPath, attributes: attributes)
            break
        case 4:
            let fileName = recentStickers[(indexPath as NSIndexPath).item]
            
            if fileName == "minion5" || fileName == "minion9" || fileName == "minion14" {
                
                selectedEmojiType = "gif"
                let url = Bundle.main.url(forResource: fileName, withExtension: "gif")
                let urlData = try? Data(contentsOf: url!)
                UIPasteboard.general.setData(urlData!, forPasteboardType: "com.compuserve.gif")
            } else {
                
                selectedEmojiType = "sticker"
                let data = UIImagePNGRepresentation(resizeImage(UIImage(named: standardStickers[(indexPath as NSIndexPath).item])!, newWidth: 408))
                UIPasteboard.general.setData(data!, forPasteboardType: kUTTypePNG as String)
            }
            
            createCopiedLabelAndAnimation(collectionView, indexPath: indexPath, attributes: attributes)
            break
        default:
            let fileName = standardStickers[(indexPath as NSIndexPath).item]
            
            if fileName == "minion5" || fileName == "minion9" || fileName == "minion14" {
                
                selectedEmojiType = "gif"
                let url = Bundle.main.url(forResource: fileName, withExtension: "gif")
                let urlData = try? Data(contentsOf: url!)
                UIPasteboard.general.setData(urlData!, forPasteboardType: "com.compuserve.gif")
            } else {
                
                selectedEmojiType = "sticker"
                let data = UIImagePNGRepresentation(resizeImage(UIImage(named: standardStickers[(indexPath as NSIndexPath).item])!, newWidth: 408))
                UIPasteboard.general.setData(data!, forPasteboardType: kUTTypePNG as String)
            }
            
            createCopiedLabelAndAnimation(collectionView, indexPath: indexPath, attributes: attributes)
            break
        }
        
    }
    
    func createCopiedLabelAndAnimation(_ collectionView: UICollectionView, indexPath: IndexPath, attributes: UICollectionViewLayoutAttributes) {
        
        if collectionView.tag != 4 {
            addToRecent(stickerName: standardStickers[(indexPath as NSIndexPath).item])
        }
        
        let copiedPinLabel: UILabel = UILabel()
        
        let cellRect: CGRect = attributes.frame;
        //        let extentionWidth: CGFloat = 120
        let copiedLabelHeight: CGFloat = 40
        let copiedLabelWidth: CGFloat = copiedLabelHeight * 5//cellRect.width + extentionWidth
        
        copiedPinLabel.frame = CGRect(x: (keyboardWidth - copiedLabelWidth) / 2, y: (keyboardHeight - copiedLabelHeight) / 2, width: copiedLabelWidth, height: copiedLabelHeight)
        copiedPinLabel.font = UIFont(name: "Helvetica", size:copiedLabelHeight / 3.0)
        copiedPinLabel.textAlignment = NSTextAlignment.center
        copiedPinLabel.text = "Copied. Ready to Paste."
        copiedPinLabel.textColor = UIColor.white
        copiedPinLabel.backgroundColor = UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 0.95)
        copiedPinLabel.layer.cornerRadius = copiedPinLabel.frame.height / 2.0;
        copiedPinLabel.layer.masksToBounds = true
        copiedPinLabel.tag = 3
        
        self.view.addSubview(copiedPinLabel)
        
        UILabel.animate(withDuration: 0.8, delay: 1.6, options: UIViewAnimationOptions.curveEaseIn, animations: {
            copiedPinLabel.alpha = 0
        }) { _ in
            copiedPinLabel.removeFromSuperview()
        }
        
        let copiedAnimationView: UIView = UIView()
        
        let extentionSize: CGFloat = 2
        let copiedAnimationViewWidth: CGFloat = cellRect.width + extentionSize
        let copiedAnimationViewHeight: CGFloat = cellRect.height + extentionSize
        let copiedAnimationViewMinX: CGFloat = cellRect.minX - (extentionSize / 2)
        let copiedAnimationViewMinY: CGFloat = cellRect.minY - (extentionSize / 2)
        
        copiedAnimationView.frame = CGRect(x: copiedAnimationViewMinX, y: copiedAnimationViewMinY, width: copiedAnimationViewWidth, height: copiedAnimationViewHeight)
        copiedAnimationView.backgroundColor = UIColor.red
        copiedAnimationView.alpha = 0.3
        copiedAnimationView.layer.cornerRadius = 8;
        copiedAnimationView.layer.masksToBounds = true
        
        collectionView.addSubview(copiedAnimationView)
        
        UIView.animate(withDuration: 0.3, delay: 0.1, options: UIViewAnimationOptions.curveEaseIn, animations: {
            copiedAnimationView.alpha = 0
        }) { _ in
            copiedAnimationView.removeFromSuperview()
        }
        
    }
    
    func addToRecent(stickerName: String) {
        
        var recentStickers: Array<String> = []
        if globalUserDefaults.array(forKey: "recentStickers") != nil {
            recentStickers = globalUserDefaults.array(forKey: "recentStickers") as! Array<String>
        }
        
        var newRecentStickers: Array<String> = []
        var isAlredyExist: Bool = false
        if recentStickers.count != 0 {
            for index in 0...(recentStickers.count - 1) {
                if stickerName.isEqual(recentStickers[index]) {
                    isAlredyExist = true
                }
                
            }
            
            if !isAlredyExist {
                newRecentStickers.append(stickerName)
            }
            
            for index in 0...(recentStickers.count - 1) {
                newRecentStickers.append(recentStickers[index])
            }
            
        } else {
            newRecentStickers.append(stickerName)
            
        }
        
        globalUserDefaults.set(newRecentStickers, forKey: "recentStickers")
        globalUserDefaults.synchronize()
        
    }
    
}
