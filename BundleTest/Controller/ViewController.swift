//
//  ViewController.swift
//  BundleTest
//
//  Created by jianli chen on 2018/9/26.
//  Copyright © 2018年 jianli chen. All rights reserved.
//

import UIKit
import Lottie
import YYCategories
import DeviceKit
import FileKit
import Kingfisher
import SnapKit

class ViewController: UIViewController {
    
    private let _textFieldInput = TMPriceTextField()
    
    private let _playBtn = UIButton()
    private let _playBtn2 = UIButton()
    private let _imageView = UIImageView()
    
    private(set) lazy var unfollowLottieView: LOTAnimationView = {
        if let bundlePath = Bundle.main.path(forResource: "unlike", ofType: "bundle"), let bundle = Bundle(path: bundlePath) {
            // Success
            print("1 \(bundlePath)")
            if let dataPath = bundle.path(forResource: "data", ofType: "json") {
                let dataURL = URL(fileURLWithPath: dataPath)
                if let data = try? Data(contentsOf: dataURL) {
                    if let dataJson = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyHashable] {
                        return LOTAnimationView(json: dataJson, bundle: bundle)
                    }
                }
            }
        }
        // Error
        return LOTAnimationView(name: "")
    }()
    
    private(set) lazy var followLottieView: LOTAnimationView = {
        if let bundlePath = Bundle.main.path(forResource: "like", ofType: "bundle"), let bundle = Bundle(path: bundlePath) {
            // Success
            print("2 \(bundlePath)")
            if let dataPath = bundle.path(forResource: "data", ofType: "json") {
                let dataURL = URL(fileURLWithPath: dataPath)
                if let data = try? Data(contentsOf: dataURL) {
                    if let dataJson = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyHashable] {
                        return LOTAnimationView(json: dataJson, bundle: bundle)
                    }
                }
            }
        }
        // Error
        return LOTAnimationView(name: "")
    }()
    
//    private(set) lazy var advanceLookLottieView: LOTAnimationView = {
//        if let bundlePath = Bundle.main.path(forResource: "advance_look_jump_init", ofType: "bundle"), let bundle = Bundle(path: bundlePath) {
//            // Success
//            print("2 \(bundlePath)")
//            if let dataPath = bundle.path(forResource: "data", ofType: "json") {
//                let dataURL = URL(fileURLWithPath: dataPath)
//                if let data = try? Data(contentsOf: dataURL) {
//                    if let dataJson = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyHashable] {
//                        return LOTAnimationView(json: dataJson, bundle: bundle)
//                    }
//                }
//            }
//        }
//        // Error
//        return LOTAnimationView(name: "")
//    }()
    
    private(set) lazy var vipFlag: LOTAnimationView = {
        if let bundlePath = Bundle.main.path(forResource: "vip", ofType: "bundle"), let bundle = Bundle(path: bundlePath) {
            // Success
            print("2 \(bundlePath)")
            if let dataPath = bundle.path(forResource: "data", ofType: "json") {
                let dataURL = URL(fileURLWithPath: dataPath)
                if let data = try? Data(contentsOf: dataURL) {
                    if let dataJson = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyHashable] {
                        return LOTAnimationView(json: dataJson, bundle: bundle)
                    }
                }
            }
        }
        // Error
        return LOTAnimationView(name: "")
    }()
    
    private(set) lazy var animationView: LOTAnimationView? = {
        return VCUIUtils.createLottieAnimateView(with: "intro_page_guide_lot2")
    }()
    
    private let followButton = VCFollowButton(style: .darkRed)
    private let advanceLookButton = VCAdvanceLookButton(frame: CGRect.zero)
    
    @IBOutlet weak var waveLineLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var waveLineTrailingConstraint: NSLayoutConstraint!
    
    private let simpleTextView = VCSimpleTextView()
    private let dynamicContraintTestView = TMDynamicConstriantTestView()
    private let edgeLabel = TMEdgeInsetLabel()
    
    fileprivate lazy var _collectionView: UICollectionView = { [unowned self] in
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.scrollDirection = .horizontal
        if #available(iOS 10, *) {
            layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        } else {
            layout.estimatedItemSize = CGSize.init(width: 80, height: 30)
        }
        let c = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        c.contentInset = .zero
        c.delegate = self
        c.dataSource = self
        c.backgroundColor = UIColor.gray
        c.register(TMAutomaticSizeCollectionViewCell.self, forCellWithReuseIdentifier: TMAutomaticSizeCollectionViewCell.identifier)
        return c
    }()
    
    class TMAutomaticSizeCollectionViewCell: UICollectionViewCell {
        static let identifier = "TMAutomaticSizeCollectionViewCell"
        
        let label = UILabel()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            didInitialize()
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            didInitialize()
        }
        
        private func didInitialize() {
            contentView.addSubview(label)
             let cellWidth: CGFloat = CGFloat.greatestFiniteMagnitude// screenWidth - 16.0 * 2 - 18.0 * 2 - 1.0
            label.preferredMaxLayoutWidth = cellWidth
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = UIFont.systemMediumFont(13)
            label.textColor = UIColor.colorFF6680
            label.lineBreakMode = .byTruncatingTail
            contentView.addSubview(label)
//            contentView.backgroundColor = UIColor.colorWithHexRGBA(0xF4F4F4)
            contentView.layer.cornerRadius = 10
            contentView.layer.borderColor = UIColor.colorFF6680.cgColor
            contentView.layer.borderWidth = 1.0
            contentView.clipsToBounds = true
            
            label.snp.makeConstraints {
                $0.left.equalToSuperview().offset(8)
                $0.right.equalToSuperview().offset(-8)
                $0.top.equalToSuperview().offset(4)
                $0.bottom.equalToSuperview().offset(-4)
                $0.width.lessThanOrEqualTo(cellWidth)
            }
        }
    }
    
    private var collectionViewDataSource: [String] = [
        "就是垃圾大垃圾袋啦",
        "斯柯达肯定；澳康达；卡； ",
        "看；萨克打开到；阿看得开；啊",
        "拍2I拍I拍",
        "大萨达；卡；打卡",
        "大萨达；澳康达；卡的看；澳康达；艾克；的卡萨；肯定；澳康达卡可是；澳康达卡；开口道；卡萨丁；卡；可达",
        "打卡；打卡；打卡；打卡；卡萨丁；卡； ",
        "了2配3；1孔；看；可；1孔；12看；看",
    ]
    
    static var appVersion: String {
        print("get app version")
        return Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    }
    
    // ELTabMenu
    
    @objc fileprivate func onReceivedTestNotification(_ notification: Notification) {
        __devlog("Thread >> \(Thread.current.name)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(_collectionView)
        _collectionView.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(60)
            make.right.equalTo(-10)
            make.height.equalTo(30)
        }
        _collectionView.reloadData()
        
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 100.0
        imageView.contentMode = .scaleAspectFill
        imageView.frame = CGRect(x: 10, y: 100, width: 200, height: 200)
        imageView.image = UIImage(named: "image_002")
        view.addSubview(imageView)
        
        let name = "🔥👆1😂1231哈哈"
        let c = name.coverOauthNickName()
        __devlog("c is \(c)")
        
        let font = UIFont.systemMediumFont(30)
        let range = NSMakeRange(0, name.utf16Length())
        let labelContent = NSMutableAttributedString(string: name)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        //            attributeString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle
        labelContent.addAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.red,
                                    NSAttributedString.Key.font: font,
                                    NSAttributedString.Key.paragraphStyle: paragraphStyle], range: range)
        let lable = UILabel()
        self.view.addSubview(lable)
        lable.frame = CGRect(x: 10, y: 320, width: 260, height: 40)
        lable.attributedText = labelContent
        
        DispatchQueue.global().async { [weak self] in
            guard let SELF = self else { return }
            addNCObserver(SELF, #selector(SELF.onReceivedTestNotification(_:)), "TEST_NOTIFICATION")
        }
        
//        ViewController.appVersion
//        ViewController.appVersion
//        ViewController.appVersion
        
//        let device = Device()
//        print(device)
//
//        _imageView.frame = CGRect(x: 100, y: 20, width: 180, height: 72)
//        _imageView.contentMode = .center
//        view.addSubview(_imageView)
//
////        if let bundlePath = Bundle.main.path(forResource: "unfollow", ofType: "bundle"), let bundle = Bundle(path: bundlePath) {
////            if let dataPath = bundle.path(forResource: "img_0", ofType: "png") {
////                _imageView.image = UIImage(contentsOfFile: dataPath)
////            }
////        }
//
////        let wh: CGFloat = 68.0
////        let offset: CGFloat = 1.5
//        if let unlikeImageView = view.viewWithTag(1002) {
////            unfollowLottieView.size = CGSize(width: wh, height: wh)
////            unfollowLottieView.bottom = unlikeImageView.bottom + offset
////            unfollowLottieView.centerX = unlikeImageView.centerX + 1.0
////            unfollowLottieView.contentMode = .scaleAspectFill
//            view.addSubview(unfollowLottieView)
//        }
//
//        if let likeImageView = view.viewWithTag(1001) {
////            followLottieView.size = CGSize(width: wh, height: wh)
////            followLottieView.bottom = likeImageView.bottom + offset
////            followLottieView.centerX = likeImageView.centerX + 1.0
////            followLottieView.contentMode = .scaleAspectFill
//            view.addSubview(followLottieView)
//        }
//
//        vipFlag.loopAnimation = true
//        view.addSubview(vipFlag)
//        vipFlag.frame = CGRect(x: 10, y: 100, width: 55, height: 16)
//
//        _playBtn.backgroundColor = .green
//        _playBtn.frame = CGRect(x: 100, y: 200, width: 180, height: 44)
//        _playBtn.addTarget(self, action: #selector(onPlayBtnTapped), for: .touchUpInside)
//        view.addSubview(_playBtn)
//
//        _playBtn2.backgroundColor = .blue
//        _playBtn2.frame = CGRect(x: 100, y: 360, width: 180, height: 44)
//        _playBtn2.addTarget(self, action: #selector(onPlayBtn2Tapped), for: .touchUpInside)
//        view.addSubview(_playBtn2)
//
//        followLottieView.animationProgress = 1
//        unfollowLottieView.animationProgress = 1
        
//        let followButton = VCFollowButton(style: .darkRed)
//        let frame = CGRect(x: 0, y: 107, width: 60, height: 24)
//        followButton.frame = frame
//        followButton.isScaleDownEffectEnable = true
//        view.addSubview(followButton)
        
//        advanceLookButton.frame = CGRect(x: 10, y: 140, width: 66, height: 33)
//        view.addSubview(advanceLookButton)
        
//        let decimalHandler = NSDecimalNumberHandler(roundingMode: NSDecimalNumber.RoundingMode.down, scale: 1, raiseOnExactness: false,
//                                                    raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)
//        let ouncesDecimal = NSDecimalNumber(value: 21.11)
//        let roundedOunces = ouncesDecimal.rounding(accordingToBehavior: decimalHandler)
//        print(NSString(format: "%@", roundedOunces))
        
//        simpleTextView.backgroundColor = .yellow
//        view.addSubview(simpleTextView)
//        simpleTextView.snp.makeConstraints { (make) in
//            make.leading.trailing.equalToSuperview()
//            make.top.equalTo(100)
//            make.height.equalTo(50)
//        }
//
//        dynamicContraintTestView.backgroundColor = .gray
//        view.addSubview(dynamicContraintTestView)
//        dynamicContraintTestView.snp.makeConstraints { (make) in
//            make.leading.trailing.equalToSuperview()
//            make.top.equalTo(200)
//            make.height.equalTo(50)
//        }
//
//        view.addSubview(edgeLabel)
//        edgeLabel.snp.makeConstraints { (make) in
//            make.leading.equalTo(10)
//            make.top.equalTo(300)
//        }
//        edgeLabel.numberOfLines = 0
//        edgeLabel.backgroundColor = UIColor.gray
//        edgeLabel.text = "全款\n预定"
//        edgeLabel.textInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
//        let textFiled = UITextField()
        _textFieldInput.textColor = UIColor.mainColor
        _textFieldInput.font = UIFont.systemRegularFont(14)
        _textFieldInput.backgroundColor = .gray
        
        view.addSubview(_textFieldInput)
        _textFieldInput.frame = CGRect(x: 50, y: 150, width: 200, height: 40)
//
//        let contentView = UIView()
//        contentView.frame = CGRect(x: 20, y: 200, width: 200, height: 60)
//        contentView.backgroundColor = .gray
//
        let text1 = UILabel()
        text1.layer.borderWidth = 1.0
        text1.layer.borderColor = UIColor.gray.cgColor
        text1.numberOfLines = 0
        
        let text2 = UILabel()
        text2.layer.borderWidth = 1.0
        text2.layer.borderColor = UIColor.darkGray.cgColor
        text2.numberOfLines = 0
//
//        view.addSubview(contentView)
        view.addSubview(text1)
        view.addSubview(text2)
//        contentView.addSubview(text2)
//
        text1.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalTo(50)
        }
//
        text2.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalTo(text1.snp.bottom).offset(10)
        }
        
        let attr = createAttributedString()
//        let size = attr.bound(for: CGFloat.greatestFiniteMagnitude)
//        text1.frame = CGRect(x: 10, y: 50, width: size.width, height: size.height)
        text1.backgroundColor = .white
        text1.attributedText = attr
//        text1.sizeToFit()
//        text1.origin = CGPoint(x: 10, y: 50)
        print("DEBUG >> text1 is \(text1.frame)")
        
        let attr2 = createAttributedString(true)
//        let size2 = attr2.bound(for: CGFloat.greatestFiniteMagnitude)
//        text2.frame = CGRect(x: 10, y: 50, width: size2.width, height: size2.height)
        text2.backgroundColor = .white
        text2.attributedText = attr2
//        text2.sizeToFit()
//        text2.origin = CGPoint(x: 10, y: 150)
        print("DEBUG >> text2 is \(text2.frame)")
        
//        let tabMenu = ELTabMenu(frame: CGRect(origin: CGPoint(x: 0, y: 50), size: CGSize(width: view.width, height: 66)))
//        tabMenu.options.normalColor = .subColor
//        tabMenu.options.selectedTextFont = UIFont.systemMediumFont(18)
//        tabMenu.options.normalTextFont = UIFont.systemMediumFont(18)
//        tabMenu.options.selectedColor = UIColor.colorFF6680
//        tabMenu.options.edgeNeedMargin = false
//        tabMenu.options.padding = 8.0
//        tabMenu.options.scrollBarAlpha = 1.0
//        tabMenu.options.scrollBarHeight = 3.0
//        tabMenu.options.scrollBarWidthPercent = 0.46
//        tabMenu.options.margin = 0.0
//        tabMenu.options.numberOfLines = 0
//        tabMenu.options.debug = true
//        tabMenu.delegate = self
//        tabMenu.options.fixedItemSize = CGSize(width: 100, height: 66)
//        tabMenu.options.dynamicCreateAttributedStringBlock = { [weak self] (title, tabIndex, currentTabIndex, isCurrentTabSelected) -> NSAttributedString? in
//            return self?.createAttributedString(isCurrentTabSelected)
//        }
//        tabMenu.isExclusiveTouch = true
//        tabMenu.clipsToBounds = true
//        tabMenu.layer.borderColor = UIColor.gray.cgColor
//        tabMenu.layer.borderWidth = 1.0
//        tabMenu.backgroundColor = .white
//        var attrs = [NSAttributedString]()
//        for _ in 0 ..< 12 {
//            attrs.append(createAttributedString())
//        }
//        tabMenu.tabTitles = attrs
//        view.addSubview(tabMenu)
//        self.tabMenu = tabMenu
        
//        text1.attributedText = nil
//
//        text2.attributedText = NSAttributedString(string: "原价$100", attributes:
//            [
//                NSAttributedString.Key.font : UIFont.systemMediumFont(11),
//                NSAttributedString.Key.foregroundColor : UIColor.blue
//            ]
//        )
        
//        let menus = ["1", "2"]//, "3" , "4", "5", "6", "7", "8"
//        let menus2 = ["A", "B", "C", "D", "E", "F", "G", "H"]
//        var option = TMDropDownMenuView.TMDropDownMenuOption()
//        option.maxContentViewHeight = 260
//        let dropDownMenu = TMDropDownMenuView(menus: menus, option: option) { (menu, index) in
//            print("\(menu), \(index)")
//        }
//        dropDownMenu.layer.borderColor = UIColor.red.cgColor
//        dropDownMenu.layer.borderWidth = 1.0
//        dropDownMenu.frame = CGRect(x: 10, y: 100, width: view.width - 20, height: view.height - 100)
//        view.addSubview(dropDownMenu)
//
//        delay(0.25) {
//            dropDownMenu.show()
//        }
//
//        var open: Bool = false
//
//        let button = UIButton(type: .custom)
//        button.backgroundColor = .gray
//        button.setTitle("DropDown", for: .normal)
//        button.frame = CGRect(x: 10, y: 10, width: 100, height: 40)
//        button.addBlock(for: .touchUpInside) { (_) in
//            if open {
//                let index = Int(arc4random_uniform(UInt32(menus.count)))
//                dropDownMenu.exchangeMenus(menus, menuIndex: index)
//            } else {
//                let index = Int(arc4random_uniform(UInt32(menus2.count)))
//                dropDownMenu.exchangeMenus(menus2, menuIndex: index)
//            }
//            open = !open
//        }
//        view.addSubview(button)
        
//        animationView?.backgroundColor = .white
//        animationView?.animationSpeed = 1
//        animationView?.animationProgress = 0
//        animationView?.loopAnimation = false
//        animationView?.autoReverseAnimation = false
//        animationView?.contentMode = .scaleAspectFill
//        animationView?.layer.masksToBounds = true
//        animationView?.frame = CGRect(x: 20, y: 60, width: 200, height: 360)
//        if let _view = animationView {
//            self.view.addSubview(_view)
//        }
        
//        let s = "yunqiange16030242".md5String
//        print("DDDD s is \(s)")
    }
    
//    private func createTabInfoAttibuteString(index: Int, isSelected: Bool) -> NSMutableAttributedString {
//        if let tabInfo = tabInfos[index, true], let area = tabInfo.ext as? TMSaleTimeArea {
//            let text = area.limitStartTimeFormartString + "\n" + tabInfo.tabName
//            let limitIndex = inLimitIndex ?? -100
//            let color = limitIndex == index ? UIColor.colorFF6680 : (isSelected ? UIColor.color333333 : UIColor.color666666)
//            let textFont = isSelected ? UIFont.pingFangSCBoldFont(15) : UIFont.pingFangSCMediumFont(15)
//            let timeFont = isSelected ? UIFont.pingFangSCBoldFont(14) : UIFont.pingFangSCMediumFont(14)
//            return NSMutableAttributedString.createAttributedString(text: text, font: textFont, color: color, targetText: area.limitStartTimeFormartString, targetColor: color, targetFont: timeFont, alignment: .center, lineSpacing: 5)
//        }
//        return NSMutableAttributedString()
//    }
    
    private let toastView = TMToastView()
    private var tabMenu: ELTabMenu?
    
    private func createAttributedString(_ isCurrentTabSelected: Bool = false) -> NSMutableAttributedString {
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.minimumLineHeight = 22
        paragraphStyle.maximumLineHeight = 22
        paragraphStyle.lineSpacing = 0.0
        paragraphStyle.paragraphSpacing = 0.0
        
        let attr = NSMutableAttributedString(string: "12:00", attributes:
            [
                NSAttributedString.Key.font : isCurrentTabSelected ? UIFont.pingFangSCBoldFont(14) : UIFont.pingFangSCMediumFont(14),
                NSAttributedString.Key.foregroundColor : isCurrentTabSelected ? UIColor.red : UIColor.mainColor,
                NSAttributedString.Key.paragraphStyle: paragraphStyle
            ]
        )
        attr.append(NSAttributedString(string: "\n", attributes:
            [
                NSAttributedString.Key.font : isCurrentTabSelected ? UIFont.pingFangSCBoldFont(13) : UIFont.pingFangSCMediumFont(13),
                NSAttributedString.Key.foregroundColor : isCurrentTabSelected ? UIColor.red : UIColor.mainColor,
                NSAttributedString.Key.paragraphStyle: paragraphStyle
            ]
        ))
        attr.append(NSAttributedString(string: "即将开始", attributes:
            [
                NSAttributedString.Key.font : UIFont.systemSemiboldFont(15),
                NSAttributedString.Key.foregroundColor : isCurrentTabSelected ? UIColor.red : UIColor.darkGray,
                NSAttributedString.Key.paragraphStyle: paragraphStyle
            ]
        ))
        return attr
    }
    
    var temp: Int = 0
    
    @IBAction @objc func onPlayBtnTapped(_ sender: Any) {
//        followButton.startLoading(false, animated: true, isJudgeAnimating: true)
//        advanceLookButton.start(animated: true, isJudgeAnimating: true)
        let t = temp % 9
        if t == 0 {
            let text = "T##String?T##String?T##String?T##String?T##String?T##String?T##String?T##String?"
            simpleTextView.setText(with: text, image: nil)
            dynamicContraintTestView.setData(text1: text, text2: "Text2", text3: "Text3", imageName: "topic_tag_ic")
        } else if t == 1 {
            let text = "T##String?T##String?T##String?T##String?T##String?T##String?T##String?T##String?"
            simpleTextView.setText(with: text, image: UIImage(named: "topic_tag_ic"))
            dynamicContraintTestView.setData(text1: nil, text2: text, text3: "Text3", imageName: "topic_tag_ic")
        } else if t == 2 {
            let text = "T##String?T##String?T##String?T##String?T##String?T##String?T##String?T##String?"
            simpleTextView.setText(with: text, imageName: "topic_tag_ic")
            dynamicContraintTestView.setData(text1: nil, text2: nil, text3: text, imageName: "topic_tag_ic")
        } else if t == 3 {
            simpleTextView.setAttributedText(with: NSAttributedString(string: "T##String?T##String?T##String?T##String?T##String?T##String?T##String?T##String",
                                                                      attributes: [
                                                                        NSAttributedString.Key.foregroundColor : UIColor.red,
                                                                        NSAttributedString.Key.font : UIFont.systemLightFont(18),
                ]), image: UIImage(named: "topic_tag_ic"))
            dynamicContraintTestView.setData(text1: nil, text2: nil, text3: nil, imageName: "topic_tag_ic")
        } else if t == 4 {
            simpleTextView.setAttributedText(with: NSAttributedString(string: "T##String?T##String?T##String?T##String?T##String?T##String?T##String?T##String",
                                                                      attributes: [
                                                                        NSAttributedString.Key.foregroundColor : UIColor.red,
                                                                        NSAttributedString.Key.font : UIFont.systemLightFont(18),
                                                                        ]), image: UIImage(named: "topic_tag_ic"))
            dynamicContraintTestView.setData(text1: "Text1", text2: nil, text3: "Text3", imageName: "topic_tag_ic")
        } else if t == 5 {
            simpleTextView.setAttributedText(with: NSAttributedString(string: "T##String?T##String?T##String?T##String?T##String?T##String?T##String?T##String",
                                                                      attributes: [
                                                                        NSAttributedString.Key.foregroundColor : UIColor.red,
                                                                        NSAttributedString.Key.font : UIFont.systemLightFont(18),
                                                                        ]), image: nil)
            dynamicContraintTestView.setData(text1: "Text1", text2: nil, text3: nil, imageName: "topic_tag_ic")
        } else if t == 6 {
            dynamicContraintTestView.setData(text1: nil, text2: "Text2", text3: nil, imageName: "topic_tag_ic")
        } else if t == 7 {
            dynamicContraintTestView.setData(text1: nil, text2: nil, text3: "Text3", imageName: "topic_tag_ic")
        } else if t == 8 {
            dynamicContraintTestView.setData(text1: nil, text2: "Text2", text3: "Text3", imageName: "topic_tag_ic")
        }
        
        temp += 1
        
        unfollowLottieView.play { [weak self] (isFinished) in
            self?.unfollowLottieView.animationProgress = 1.0
        }
        
        vipFlag.play()
        
        //        unfollowLottieView.animationProgress = 1
        //        _updatePraiseImage(with: _flag, true)
        //        _flag = !_flag
    }
    
    @IBAction func onStopBtnTapped(_ sender: Any) {
//        followButton.stopLoadingWithSuccess()
//        advanceLookButton.stop()
        
//        let controller = TMApplyShipmentsResultViewController.viewController(with: TMApplyShipmentsResultViewController.TMResultViewControllerParams.diliverSuccessParams())
//        navigationController?.pushViewController(controller, animated: true)
//        present(controller, animated: true, completion: nil)
//        test = !test
//
//        var option = TMToastView.Option()
////        option.marginEdge = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
//        option.paddingEdge = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
//        TMToastViewManager.shared.updateOption(option)
//
//        if test {
//            let text = """
//                确认购买提示已关闭
//        """
////            toastView.setText(text)
//            TMToastViewManager.shared.showToast(text)
//        } else {
//            let text = """
//                确认购买提示已关闭
//                确认购买提示已关闭确认购买提示已关闭
//                确认购买提示已关闭确认购买提示已关闭确认购买提示已关闭
//                确认购买提示已关闭确认购买提示已关闭确认购买提示已关闭确认购买提示已关闭
//                确认购买提示已关闭确认购买提示已关闭确认购买提示已关闭确认购买提示已关闭确认购买提示已关闭
//        """
////            toastView.setText(text)
//            TMToastViewManager.shared.showToast(text)
//        }
        
//        guard let context = UIGraphicsGetCurrentContext() else { return }
//        UIGraphicsBeginImageContextWithOptions(view.size, true, UIScreen.main.nativeScale)
//        view.layer.render(in: context)
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
        
//        let view = TMSharePosterView()
//        let image = view.contentView.snapshotImage()
//        do {
//            try image?.write(to: Path("/Users/chenjianli/Downloads/11.png"))
//        } catch (let e) {
//            print("e is \(e)")
//        }
        
//        DispatchQueue.global().async {
//            postNotification("TEST_NOTIFICATION")
//        }
    }
    
    private var test: Bool = false
    
    @IBAction func onSliderValueChanged(_ sender: Any) {
        if let slider = sender as? UISlider {
//            followButton.unfollowLottieView.animationProgress = CGFloat(slider.value)
//            advanceLookButton.neonLightLottieView.animationProgress = CGFloat(slider.value)
            
//            vipFlag.animationProgress = CGFloat(slider.value)
            animationView?.animationProgress = CGFloat(slider.value)
            __devlog("CGFloat(slider.value) is \(CGFloat(slider.value))")
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let wh: CGFloat = 64.5
        let offset: CGFloat = -2.5
        if let unlikeImageView = view.viewWithTag(1002) {
            unfollowLottieView.size = CGSize(width: wh, height: wh)
            unfollowLottieView.bottom = unlikeImageView.bottom + offset
            unfollowLottieView.centerX = unlikeImageView.centerX + 0.5
        }
        
        if let likeImageView = view.viewWithTag(1001) {
            followLottieView.size = CGSize(width: wh, height: wh)
            followLottieView.bottom = likeImageView.bottom + offset
            followLottieView.centerX = likeImageView.centerX + 0.5
        }
        
        let padding = CGFloat(adjustPadding(with: Float(view.width)))
        if waveLineLeadingConstraint.constant != padding {
            waveLineLeadingConstraint.constant = padding
            waveLineTrailingConstraint.constant = padding
        }
        
//        guard let window = UIApplication.shared.windows.first else { return }
//        window.addSubview(toastView)
//        window.bringSubviewToFront(toastView)
//        toastView.snp.remakeConstraints { (make) in
//            make.leading.trailing.top.equalToSuperview()
//            //make.height.equalTo(104)
//        }
//        var option = TMToastView.Option()
//        option.marginEdge = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
//        option.paddingEdge = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
//        toastView.updateOption(option)
//        let text = """
//                确认购买提示已关闭
//                确认购买提示已关闭确认购买提示已关闭
//                确认购买提示已关闭确认购买提示已关闭确认购买提示已关闭
//                确认购买提示已关闭确认购买提示已关闭确认购买提示已关闭确认购买提示已关闭
//                确认购买提示已关闭确认购买提示已关闭确认购买提示已关闭确认购买提示已关闭确认购买提示已关闭
//                确认购买提示已关闭
//                确认购买提示已关闭确认购买提示已关闭
//                确认购买提示已关闭确认购买提示已关闭确认购买提示已关闭
//                确认购买提示已关闭确认购买提示已关闭确认购买提示已关闭确认购买提示已关闭
//                确认购买提示已关闭确认购买提示已关闭确认购买提示已关闭确认购买提示已关闭确认购买提示已关闭
//        """
//        toastView.setText(text)
    }

//    @objc fileprivate func onPlayBtnTapped() {
//
//    }

    @objc fileprivate func onPlayBtn2Tapped() {
        followLottieView.play { [weak self] (isFinished) in
            self?.followLottieView.animationProgress = 1.0
        }
//        followLottieView.animationProgress = 1
//        _updatePraiseImage(with: _flag, true)
//        _flag = !_flag
        
//        let controller = VCPostAlterViewController.controller(sourceCount: 9, parentVc: self)
//        present(controller, animated: true, completion: nil)
    }
    
    private var _flag = false
    private var _isAnimatingToInvisible = false
    private var _isAnimatingToVisible = false
    
    private func _updatePraiseImage(with isLike: Bool, _ animated: Bool = false) {
        let zanView = view.viewWithTag(1002)!
        if isLike {
            guard animated else {
                if !_isAnimatingToVisible {
                    zanView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                }
                return
            }
            guard !_isAnimatingToVisible else { return }
            _isAnimatingToVisible = true
            zanView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            UIView.animate(withDuration: 0.36,
                           delay: 0.0,
                           options: .beginFromCurrentState,
                           animations: {
                            zanView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            }, completion: nil)
            
            UIView.animate(withDuration: 0.36,
                           delay: 0.30,
                           options: .beginFromCurrentState,
                           animations: {
                            zanView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }, completion: { [weak self] (_) in
                self?._isAnimatingToVisible = false
            })
        } else {
            guard animated else {
                if !_isAnimatingToInvisible {
                    zanView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
                }
                return
            }
            guard !_isAnimatingToInvisible else { return }
            _isAnimatingToInvisible = true
            zanView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            UIView.animate(withDuration: 0.36,
                           delay: 0.0,
                           options: .beginFromCurrentState,
                           animations: {
                            zanView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            }, completion: { [weak self] (_) in
                self?._isAnimatingToInvisible = false
            })
        }
    }

    func adjustPadding(with width: Float, padding: Float = 8.0) -> Float {
        
        func _format(value: Float) -> Float {
            let decimalHandler = NSDecimalNumberHandler(roundingMode: NSDecimalNumber.RoundingMode.down, scale: 1, raiseOnExactness: false,
                                                        raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)
            let ouncesDecimal = NSDecimalNumber(value: value)
            let roundedOunces = ouncesDecimal.rounding(accordingToBehavior: decimalHandler)
            return roundedOunces.floatValue
        }
        
        func _count(padding: Float) -> Float {
            return (width - (padding * 2) - 2) / 16
        }
        
        var _padding: Float = padding
        for index in 0 ..< 10 {
            let count = _count(padding: _padding)
            let format = _format(value: count)
            if ceilf(format) == floor(format) {
                print("format[\(index)] is \(format), break")
                break
            }
            print("format[\(index)] is \(format)")
            _padding += 0.5
        }
        
        return _padding
    }
}

//
//  TMPriceTextField.swift
//  WeiboDongman
//
//  Created by jianli chen on 2019/9/12.
//  Copyright © 2019 Gookee. All rights reserved.
//

import Foundation

// 商品 · 价格 · 输入框 · UITextField
class TMPriceTextField: UITextField, UITextFieldDelegate {
    
    public var textFieldValueWillChangeHandle: (() -> Void)? = nil
    public var textFieldValueDidChangeHandle: (() -> Void)? = nil
    
    struct Option {
        var font: UIFont                            // 文本字体
        var textColor: UIColor                  // 文本字体颜色
        var borderColor: UIColor             // 边框样式 · 颜色
        var borderWidth: CGFloat            // 边框样式 · 宽度
        var cornerRadius: CGFloat           // 边框样式 · 圆角弧度
        var backgroundColor: UIColor     // 背景色
        var isForbidPasteboard: Bool       // 是否禁用复制黏贴功能
        var maxInputCount: UInt             // 最大允许可输入字符数(不包括小数点后的位数)
        var suffixDecimalPointCount: UInt// 小数点后的位数
        
        init() {
            font = UIFont.systemMediumFont(13)
            textColor = UIColor.mainColor
            borderColor = UIColor.colorWithHexRGBA(0xEEEEEE)
            borderWidth = 1.0
            cornerRadius = 4.0
            backgroundColor = UIColor.white
            isForbidPasteboard = true
            maxInputCount = 6// 最多允许输入6位
            suffixDecimalPointCount = 2// 小数点最多保留2位
        }
    }
    
    private(set) var option: Option = Option()
    
    func updateOption(_ option: Option) {
        self.option = option
        didInitialize()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        didInitialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        didInitialize()
    }
    
    convenience init() {
        self.init(frame: .zero)
        didInitialize()
    }
    
    private func didInitialize() {
        delegate = self
        keyboardType = .decimalPad
        leftView = UIView.init(frame: CGRect(x: 0, y: 0, width: 4, height: 0))
        leftViewMode = .always
        
        font = option.font
        textColor = option.textColor
        layer.borderColor = option.borderColor.cgColor
        layer.borderWidth = option.borderWidth
        layer.cornerRadius = option.cornerRadius
        backgroundColor = option.backgroundColor
        layer.masksToBounds = true
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        UIMenuController.shared.isMenuVisible = !option.isForbidPasteboard
        if option.isForbidPasteboard {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let orginalText = textField.text!
        if orginalText.contains(".") && string.contains(".") {
            return false
        }
        let mutableText: NSMutableString = orginalText.mutableCopy() as! NSMutableString
        mutableText.replaceCharacters(in: range, with: string)
        let combinedText = "\(mutableText)"
        let maxInputCount: Int
        if combinedText.contains(".") {
            let range = mutableText.range(of: ".")
            if range.location > Int(option.maxInputCount) {
                // 移动光标到最后
                perform(#selector(_moveSelectedTextRangeToEnd), afterDelay: 0.15)
                return false
            }
            // 组合生成后的内容包含小数点时，最多允许maxInputCount + 1位(小数点) + suffixDecimalPointCount
            maxInputCount = Int(option.maxInputCount + option.suffixDecimalPointCount + 1)
        } else {
            // 组合生成后的内容不包括小数点时，只能允许输入maxInputCount位数字
            maxInputCount = Int(option.maxInputCount)
        }
        let isOverflow = combinedText.isLengthOverflowInUTF16(with: maxInputCount)
        if isOverflow {
            // 超出了输入字符位数限制
            let clipCount = maxInputCount - orginalText.utf16Length()
            if clipCount > 0 {
                let clipedText = string.clipContent(with: clipCount)
                mutableText.replaceCharacters(in: range, with: clipedText)
                let replaceText = "\(mutableText)"
                textField.attributedText = generateMutableAttributedString(replaceText)
            }
        }
        textFieldDidEndEditing(textField)
        return !isOverflow
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        perform(#selector(_checkAndModifyInputTextIfNeeded), afterDelay: 0.15)
        textFieldValueWillChangeHandle?()
    }
    
    private func generateMutableAttributedString(_ text: String) -> NSMutableAttributedString {
        return NSMutableAttributedString(string: text, attributes:
            [
                NSAttributedString.Key.font: option.font,
                NSAttributedString.Key.foregroundColor: option.textColor
            ]
        )
    }
    
    // 检查并修正输入内容
    @objc fileprivate func _checkAndModifyInputTextIfNeeded() {
        textFieldValueDidChangeHandle?()
        var isMoveSelectedTextRangeToEnd = false
        let prevSelectedTextRange = selectedTextRange
        if var text = attributedText?.string {
            let mutableText: NSMutableString = text.mutableCopy() as! NSMutableString
            if mutableText.contains(".") {
                let range = mutableText.range(of: ".")
                if range.location == 0 {
                    // 点符号在第一位
                    if mutableText.length >= Int(option.suffixDecimalPointCount + 1) {
                        // 已经有其他非点符号的数字了
                        text = "0" + mutableText.substring(to: Int(option.suffixDecimalPointCount + 1))
                    } else if mutableText.length >= Int(option.suffixDecimalPointCount) {
                        text = "0" + "\(mutableText)"
                    } else {
                        // 首次输入
                        text = "0."
                    }
                    isMoveSelectedTextRangeToEnd = true
                } else if mutableText.length - range.location >= Int(option.suffixDecimalPointCount + 2) {
                    // 点字符后面的位数超过suffixDecimalPointCount位时，自动截取保留suffixDecimalPointCount位
                    let text1 = mutableText.substring(to: range.location)
                    let text2 = mutableText.substring(with: NSRange(location: range.location, length: Int(option.suffixDecimalPointCount + 1)))
                    text = text1 + text2
                    isMoveSelectedTextRangeToEnd = true
                }
            } else if mutableText.contains("0") {
                let range = mutableText.range(of: "0")
                if range.location == 0 {
                    // 0在第一位输入，除掉0，保持后面的字符
                    if mutableText.length > 1 {
                        text = mutableText.substring(from: 1)
                    }
                    isMoveSelectedTextRangeToEnd = true
                }
            }
            let attributedString = generateMutableAttributedString(text)
            self.attributedText = attributedString
            if let range = prevSelectedTextRange, !isMoveSelectedTextRangeToEnd {
                // 保存当前光标数据
                self.selectedTextRange = range
            } else {
                // 光标移动到尾部
                _moveSelectedTextRangeToEnd()
            }
        }
    }
    
    @objc fileprivate func _moveSelectedTextRangeToEnd() {
        let position = endOfDocument
        selectedTextRange = textRange(from: position, to: position)
    }
}


extension ViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewDataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TMAutomaticSizeCollectionViewCell.identifier, for: indexPath)
        if let textCell = cell as? TMAutomaticSizeCollectionViewCell {
            textCell.label.text = collectionViewDataSource[indexPath.item, true]
        }
        return cell
    }
}

extension ViewController: ELTabMenuDelegate {
    func switchToTab(_ tabMenu: ELTabMenu, preIndex: Int, newIndex: Int, disable: Bool) {
        tabMenu.scrollToTab(newIndex, animted: true, invokeDelegate: false)
    }
    
    func tabMenuScrollViewDelegate(_ tabMenu: ELTabMenu) -> UIScrollViewDelegate? {
        return self
    }
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let menu = tabMenu {
            let currentIndex = menu.currentIndex
            let subviews = scrollView.subviews.compactMap { subview -> UIView? in
                return subview is UIButton ? subview : nil
            }
            if let tabView = subviews[currentIndex, true] {
                let rect = tabView.convertRectToWindow()
                print("scrollViewDidScroll >> \(rect)")
            }
        }
    }
}
