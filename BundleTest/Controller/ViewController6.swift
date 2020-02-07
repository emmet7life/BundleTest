//
//  ViewController6.swift
//  BundleTest
//
//  Created by jianli chen on 2019/5/27.
//  Copyright © 2019 jianli chen. All rights reserved.
//

import UIKit
import MXParallaxHeader
import YYText

class ViewController6: UITableViewController {
    
//    let scrollView: MXScrollView = MXScrollView(frame: CGRect.zero)

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        scrollView

        // Do any additional setup after loading the view.
//        navigationController?.navigationBar.barTintColor = .blue
//        navigationController?.navigationBar.setBackgroundImage(UIImage(named: "alert_background"), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
            automaticallyAdjustsScrollViewInsets = false
        }
        
//        print("edgesForExtendedLayout  is \(UIRectEdge().rawValue)")
//        print("edgesForExtendedLayout  is \(UIRectEdge.all.rawValue)")
//        print("edgesForExtendedLayout  is \(UIRectEdge.top.rawValue)")
//        print("edgesForExtendedLayout  is \(UIRectEdge.left.rawValue)")
//        print("edgesForExtendedLayout  is \(UIRectEdge.bottom.rawValue)")
//        print("edgesForExtendedLayout  is \(UIRectEdge.right.rawValue)")
        
        edgesForExtendedLayout = UIRectEdge.top
//        edgesForExtendedLayout = UIRectEdge()//UIRectEdge()
//        extendedLayoutIncludesOpaqueBars = true
        
//        var array: [Any] = [1, true, 0]
//        array = array.compactMap { (any) -> String? in
////            if any is Int {
////                return "\(any)"
////            }
////            return nil
//            return "\(any)"
//        }
//        print("\(array)")
        
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 10, y: 100, width: 200, height: 44)
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.red.cgColor
//        button.contentMode = .left
        button.contentHorizontalAlignment = .left
        
        let followImageView = UIImageView(frame: CGRect(x: 18.0, y: 8.0, width: 28.0, height: 28.0))
        followImageView.image = UIImage(named: "未关注")
        button.addSubview(followImageView)
        
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 50, bottom: 0, right: 0)
        
        let attributes1 = [
            NSAttributedString.Key.foregroundColor: UIColor.colorWithHexRGBA(0x333333),
            NSAttributedString.Key.font: UIFont.systemMediumFont(15.0),
        ]
        
        let attributes2 = [
            NSAttributedString.Key.foregroundColor: UIColor.colorWithHexRGBA(0x999999),
            NSAttributedString.Key.font: UIFont.systemRegularFont(13.0),
        ]
        
        let text1 = "关注"
        let text2 = text1 + " (26.67万)"
        let attr = NSMutableAttributedString(string: text2, attributes: attributes2)
        attr.addAttributes(attributes1, range: (text2 as NSString).range(of: text1))
//        button.titleLabel?.attributedText = attr
        button.setAttributedTitle(attr, for: .normal)
        
        view.addSubview(button)
        
//        tableView.isHidden = true
        
        var uInt64: UInt64 = 100
        uInt64.decrease()
        print("uInt64 is \(uInt64)")
        uInt64.increase()
        print("uInt64 is \(uInt64)")
        uInt64.increase(UInt64.max)
        print("uInt64 is \(uInt64)")
        
//        setTabMenu()
        
        let str = "2019-06-06"
        if let day = str.formatterDate(dateFormat: "yyyy-MM-dd") {
            let format = day.formattedNewChapterTime()
            print("format is \(format)")
        }
        let str1 = "2019-06-05"
        if let day = str1.formatterDate(dateFormat: "yyyy-MM-dd") {
            let format = day.formattedNewChapterTime()
            print("format is \(format)")
        }
        let str2 = "2019-06-04"
        if let day = str2.formatterDate(dateFormat: "yyyy-MM-dd") {
            let format = day.formattedNewChapterTime()
            print("format is \(format)")
        }
        let str3 = "2019-06-03"
        if let day = str3.formatterDate(dateFormat: "yyyy-MM-dd") {
            let format = day.formattedNewChapterTime()
            print("format is \(format)")
        }
        let str4 = "2019-06-02"
        if let day = str4.formatterDate(dateFormat: "yyyy-MM-dd") {
            let format = day.formattedNewChapterTime()
            print("format is \(format)")
        }
        let str5 = "2019-06-01"
        if let day = str5.formatterDate(dateFormat: "yyyy-MM-dd") {
            let format = day.formattedNewChapterTime()
            print("format is \(format)")
        }
        let str6 = "2019-05-31"
        if let day = str6.formatterDate(dateFormat: "yyyy-MM-dd") {
            let format = day.formattedNewChapterTime()
            print("format is \(format)")
        }
        let str7 = "2019-05-30"
        if let day = str7.formatterDate(dateFormat: "yyyy-MM-dd") {
            let format = day.formattedNewChapterTime()
            print("format is \(format)")
        }
        let str8 = "2019-05-29"
        if let day = str8.formatterDate(dateFormat: "yyyy-MM-dd") {
            let format = day.formattedNewChapterTime()
            print("format is \(format)")
        }
        
        let button2 = UIButton(type: .custom)
        button2.setAttributedTitle(NSAttributedString(string: "关注（0)"), for: .normal)
        button2.setImage(UIImage(named: "未关注"), for: .normal)
        button2.sizeToFit()
        button2.layoutIfNeeded()
        view.addSubview(button2)
        
        button2.left = 20
        button2.top = 180
        
        button2.setTarget(self, action: #selector(onLikeTapped(_:)), for: .touchUpInside)
        
        let yyLabel = YYLabel()
        yyLabel.textVerticalAlignment = .center
        yyLabel.displaysAsynchronously = false
        yyLabel.ignoreCommonProperties = true
        yyLabel.fadeOnHighlight = false
        yyLabel.fadeOnAsynchronouslyDisplay = false
        yyLabel.clipsToBounds = false
//        yyLabel.backgroundColor = .gray
        yyLabel.frame = CGRect(x: 200, y: 300, width: 120, height: 10)
        view.addSubview(yyLabel)
        yyLabel.textLayout = "̶̶̶ۣۖิ̶玄̶ۣ5257".createYYTextLayout(fontSize: 9.0, lineBreakMode: .byTruncatingTail,
                                                               alignment: .center, paddingTop: 0.0, paddingBottom: 0.0,
                                                               maximumNumberOfRows: 1,
                                                               width: 120)
    }
    
    @objc fileprivate func onLikeTapped(_ sender: UIButton) {
        sender.setImage(UIImage(named: "已关注"), for: .normal)
        sender.imageView?.vc_spring()
    }
    

//    private func attributedString() -> NSMutableAttributedString {
//        let imageSize = CGSize(width: 24, height: 24)
//        var imageAttributedString = NSMutableAttributedString()
//        let radius: CGFloat = 22.0
//        let size: CGSize = CGSize(width: 44.0, height: 44.0)
//        if let image = UIImage(named: "害羞")?.kf.image(withRoundRadius: radius, fit: size) {
//            var blendImage = image
//            if let cornerImage = UIImage(named: "星星") {
//                // 头像和角标拼接 方便最后的图文混排
//                blendImage = UIImage.blendImages([image,cornerImage], withRects: [CGRect(origin: CGPoint.zero, size: size),
//                                                                                  CGRect(origin: CGPoint(x: radius + 13, y: radius + 13), size: cornerImage.size)])
//            }
//            imageAttributedString = NSMutableAttributedString.creatImageAttributedString(image: blendImage, imageRect: CGRect(origin: CGPoint(x: 0, y: -5), size: imageSize))
//        }
//        let nameAttributedString = NSMutableAttributedString.creatAttributedString(text: "  ", font: UIFont.systemFont(ofSize: 14), color: UIColor.mainColor)
//        nameAttributedString.insert(imageAttributedString, at: 0)
//        return nameAttributedString
//    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("\(navigationController?.navigationBar.isTranslucent)")
    }
    
    fileprivate lazy var _tabMenu: ELTabMenu = ELTabMenu(frame: CGRect(x: 0, y: 0, width: 125, height: 44))
    
    /// 设置顶部滑动菜单
    private func setTabMenu() {
//        _tabMenu.delegate = self
        var options = ELTabMenuOptions()
        
//        let backgroundView = UIView()
//        backgroundView.backgroundColor = UIColor.colorWithHexRGBA(0xFF4D6A)
//        backgroundView.layer.cornerRadius = _tabMenu.height * 0.5
//        backgroundView.layer.masksToBounds = true
        
        let scrollBarHeight: CGFloat = 28.0//_tabMenu.height - 2.0
        let scrollIndicatorView = UIView()
        scrollIndicatorView.backgroundColor = UIColor.colorWithHexRGBA(0xFF6680).withAlphaComponent(0.1)
        scrollIndicatorView.alpha = 1.0
        scrollIndicatorView.layer.cornerRadius = scrollBarHeight * 0.5
        scrollIndicatorView.layer.masksToBounds = true
        
        //        scrollIndicatorView.layer.borderColor = UIColor.yellow.cgColor
        //        scrollIndicatorView.layer.borderWidth = 1.5
        
        options.margin = 24
        options.padding = 8
        options.normalColor = UIColor.colorWithHexRGBA(0x333333)
        options.selectedColor = UIColor.colorWithHexRGBA(0xFF6680)
        
        options.normalTextFont = UIFont.systemMediumFont(16.0)
        options.selectedTextFont = UIFont.systemMediumFont(16.0)
        
//        options.backgroundView = backgroundView
        options.scrollIndicatorView = scrollIndicatorView
        
        options.scrollBarHeight = CGFloat(scrollBarHeight)
        options.scrollBarPositionOffset = -8.0
        //        options.scrollBarWidth = 66.0
        
        options.edgeNeedMargin = false
        
//        options.defaultItemIndex = 1
        options.isScrollBarAutoScrollWithOffsetChanged = true
        
        _tabMenu.options = options
        _tabMenu.isExclusiveTouch = true
        _tabMenu.tabTitles = ["最热", "最新"]
        
        navigationItem.titleView = _tabMenu
        if let _ = _tabMenu.superview, #available(iOS 11, *) {
            _tabMenu.snp.makeConstraints { (make) in
                make.width.equalTo(125)
                make.height.equalTo(44)
                make.center.equalToSuperview()
            }
        }
        
    }

}

extension UInt64 {
    mutating func decrease(_ offset: UInt64 = 1) {
        if self >= offset {
            self -= offset
        } else {
            self = 0
        }
    }
    
    mutating func increase(_ offset: UInt64 = 1) {
        let maxOffset = UInt64.max - self
        if offset <= maxOffset {
            self += offset
        } else {
            self = UInt64.max
        }
    }
}

extension NSMutableAttributedString {
    /// 快捷的创建混排图片 把图片转换为AttributedString
    class func creatImageAttributedString(image: UIImage,
                                          imageRect: CGRect? = nil) -> NSMutableAttributedString {
        let attachMent = NSTextAttachment()
        attachMent.image = image
        if let imageRect = imageRect {
            attachMent.bounds = imageRect
        } else {
            attachMent.bounds = CGRect(origin: CGPoint.zero, size: image.size)
        }
        return NSMutableAttributedString(attributedString: NSAttributedString(attachment: attachMent))
    }
    
    /*
     targetText: 需要匹配的文字
     targetColor： 匹配文字显示的颜色
     
     */
    class func creatAttributedString(text: String, font: UIFont = UIFont.systemLightFont(14), color: UIColor = .black, targetText: String = "", targetColor: UIColor? = nil, alignment: NSTextAlignment = .center, lineSpacing: CGFloat = 0.5) -> NSMutableAttributedString {
        
        let attributedString = NSMutableAttributedString(string: text)
        if text.count <= 0 { return attributedString }
        
        attributedString.addAttributes([NSAttributedString.Key.foregroundColor: color, NSAttributedString.Key.font: font], range: NSMakeRange(0, text.count))
        
        let haveTarget = text.positionOf(sub: targetText)
        if haveTarget != -1, let targetColor = targetColor {
            attributedString.addAttributes([NSAttributedString.Key.foregroundColor: targetColor, NSAttributedString.Key.font: font], range: NSMakeRange(haveTarget,targetText.count))
        }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.alignment = alignment
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, text.count))
        
        return attributedString
    }
}

extension String {
    /*
     示例：let languages = "Java,Swift,Objective-C"
     let one = "Swift"
     let index = languages.positionOf(sub: one, backwards: false) // 5
     */
    /// sub 在 self 中出现的位置（如果backwards参数设置为true，则返回最后出现的位置）
    func positionOf(sub:String, backwards: Bool = false) -> Int {
        // 如果没有找到就返回-1
        var pos = -1
        if let range = range(of:sub, options: backwards ? .backwards : .literal ) {
            if !range.isEmpty {
                pos = self.distance(from:startIndex, to:range.lowerBound)
            }
        }
        return pos
    }
}
