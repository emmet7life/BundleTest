//
//  ViewController.swift
//  WeiboDongman790
//
//  Created by jianli chen on 2019/6/18.
//  Copyright © 2019 jianli chen. All rights reserved.
//

import UIKit

//let kHeaderMinimumHeight: CGFloat = 64.0

//extension UIViewController {
//
//    var viewSafeAreaInsets: UIEdgeInsets {
//        if #available(iOS 11.0, *) {
//            return view.safeAreaInsets
//        }
//        return UIEdgeInsets.zero
//    }
//
//    // 仅适用于导航栏和状态栏处于可见状态使用
//    var viewSafeAreaInsetsAddtionTop: CGFloat {
//        return max(0, viewSafeAreaInsets.top - 64.0)// 44.0 + 20.0 导航栏加状态栏
//    }
//
//}

class ViewController8: UIViewController {
    
    class func viewController(headMode mode: HeadMode) -> UIViewController {
        let controller = UIStoryboard(name: "790", bundle: nil).instantiateViewController(withIdentifier: "VC_CATE_PAGE") as! ViewController8
        controller.headMode = mode
        return controller
    }
    
    struct HeadMode: OptionSet {
        let rawValue: Int
        static let cates = HeadMode(rawValue: 1 << 0)
        static let end = HeadMode(rawValue: 1 << 1)
        static let pay = HeadMode(rawValue: 1 << 2)
        static let all: HeadMode = [.cates, .end, .pay]
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var topFloatView: UIView!
    @IBOutlet weak var sliderValLabel: UILabel!
    @IBOutlet weak var topFloatViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var topFloatTipLabel: UILabel!
    
    private let topFloatViewBottomLineLayer: CALayer = CALayer()
    
    var headers: [[String]] = [
        ["全部", "奇幻", "都市", "情感", "校园", "古风", "搞笑", "武侠", "言情", "热血", "古装", "国风", "欧美", "科技", "玄幻", "其他"],
        ["全部", "连载", "完结"],
        ["全部", "免费", "付费"]
    ]
    
    private(set) var headMode: HeadMode = .all
    
    var bookCount: Int = 11
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        title = "分类"
        
        configNavBackButton(true)
        configNavRightIconButton("ic_nav_search_1")
        
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .scrollableAxes
        } else {
            // Fallback on earlier versions
            automaticallyAdjustsScrollViewInsets = true
        }
        
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16.0, bottom: 0, right: 16.0)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        topFloatViewBottomLineLayer.backgroundColor = UIColor.gray.cgColor
        topFloatView.layer.addSublayer(topFloatViewBottomLineLayer)
        //        collectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
    }
    
    @IBAction func onSliderValueChanged(_ slider: UISlider) {
        topFloatView.backgroundColor = UIColor.white.withAlphaComponent(CGFloat(slider.value))
        sliderValLabel.text = String(slider.value)
    }
    
    fileprivate var kNavBarHeight: CGFloat {
        return kHeaderMinimumHeight + viewSafeAreaInsetsAddtionTop
    }
    
}

extension ViewController8: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return headers.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section < headers.count {
            return headers[section].count
        }
        return bookCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = indexPath.section
        if section < headers.count {
            return collectionView.dequeueReusableCell(withReuseIdentifier: VCCateItemCollectionCell.identifier, for: indexPath)
        }
        return collectionView.dequeueReusableCell(withReuseIdentifier: VCCateComicItemCollectionCell.identifier, for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let section = indexPath.section
        if section < headers.count {
            if let labelCell = cell as? VCCateItemCollectionCell {
                labelCell.label.text = headers[section][indexPath.item]
            }
        }
    }
}

extension ViewController8: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let section = indexPath.section
        let minimumInteritemSpacing = self.collectionView(collectionView, layout: collectionViewLayout, minimumInteritemSpacingForSectionAt: section)
        let width: CGFloat = view.frame.size.width - collectionView.contentInset.left - collectionView.contentInset.right
        if section < headers.count {
            let itemWidth: CGFloat = (width - minimumInteritemSpacing * 5) / 6.0 - 1.0
            return CGSize(width: itemWidth, height: 34.0)
        }
        let itemWidth: CGFloat = (width - minimumInteritemSpacing * 2) / 3.0 - 1.0
        let itemHeight: CGFloat = itemWidth * 143.0 / 107.0 + 60.0
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if section < headers.count {
            return UIScreen.isPhoneDown5Plus ? 16.0 : 22.0
        }
        return UIScreen.isPhoneDown5Plus ? 8.0 : 10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        if offset <= 0 {
            if topFloatTipLabel.alpha != 0 {
                let topFloatViewHeight: CGFloat = kNavBarHeight
                UIView.animate(withDuration: 0.36) { [weak self] in
                    guard let strongSelf = self else { return }
                    strongSelf.topFloatViewHeightConstraint.constant = topFloatViewHeight
                    strongSelf.view.layoutIfNeeded()
                }
                updateTopFloatViewBottomLineLayerHeight(topFloatViewHeight, height: 0)
                topFloatTipLabel.alpha = 0
                topFloatViewBottomLineLayer.frame.size.height = 0
            }
        } else {
            let topFloatViewHeight: CGFloat = kNavBarHeight + 34.0
            if topFloatViewHeightConstraint.constant != topFloatViewHeight {
                UIView.animate(withDuration: 0.36) { [weak self] in
                    guard let strongSelf = self else { return }
                    strongSelf.topFloatViewHeightConstraint.constant = topFloatViewHeight
                    strongSelf.view.layoutIfNeeded()
                }
                updateTopFloatViewBottomLineLayerHeight(topFloatViewHeight, height: 0.5)
            }
            let alpha: CGFloat = offset / 34.0
            topFloatTipLabel.alpha = alpha
            topFloatViewBottomLineLayer.opacity = Float(alpha)
        }
    }
    
    fileprivate func updateTopFloatViewBottomLineLayerHeight(_ topFloatViewHeight: CGFloat, height: CGFloat) {
        let lineLayerWidth = view.bounds.size.width
        let y = topFloatViewHeight - height
        topFloatViewBottomLineLayer.frame = CGRect(x: 0, y: y, width: lineLayerWidth, height: height)
    }
}


class VCCateItemCollectionCell: UICollectionViewCell {
    
    static let identifier = "VCCateItemCollectionCell"
    
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if UIScreen.isPhoneDown5Plus {
            label.font = UIFont.systemFont(ofSize: 12.0)
        } else {
            label.font = UIFont.systemFont(ofSize: 15.0)
        }
    }
}

class VCCateComicItemCollectionCell: UICollectionViewCell {
    
    static let identifier = "VCCateComicItemCollectionCell"
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 4.0
    }
}

extension UIScreen {
    /// iphoneX 和 iphoneXs遵循相同的判断
    static let isPhoneX: Bool = {
        if UIDevice.current.userInterfaceIdiom == .phone {
            if let currentModel = UIScreen.main.currentMode {
                let iPhoneX = CGSize(width: 1125, height: 2436)
                return __CGSizeEqualToSize(currentModel.size, iPhoneX)
            }
        }
        return false
    }()
    
    // 6+
    static var isPhoneUp6Plus: Bool {
        return UIScreen.main.bounds.width >= 414
    }
    
    // 6
    static var isPhone6Plus: Bool {
        return UIScreen.main.bounds.width == 414 && UIScreen.main.bounds.height == 736
    }
    
    // 6
    static var isPhone6: Bool {
        return UIScreen.main.bounds.width == 375 && UIScreen.main.bounds.height == 667
    }
    
    // 320 3GS 4(s) 5c 5(s)
    static let isPhoneDown5Plus: Bool = {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return UIScreen.main.bounds.width < 375
        }
        return false
    }()
    
    static let isPhoneXr: Bool = {
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            if let currentModel = UIScreen.main.currentMode {
                let iPhoneXr = CGSize(width: 828, height: 1792)
                let iPhoneXr2 = CGSize(width: 750, height: 1624)
                return __CGSizeEqualToSize(currentModel.size, iPhoneXr) || __CGSizeEqualToSize(currentModel.size, iPhoneXr2)
            }
        }
        return false
    }()
    
    static let isPhoneXsMax: Bool = {
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            if let currentModel = UIScreen.main.currentMode {
                let iPhoneXsMax = CGSize(width: 1242, height: 2688)
                return __CGSizeEqualToSize(currentModel.size, iPhoneXsMax)
            }
        }
        return false
    }()
    
    
    static let isPhoneXSeries: Bool = { // 如果是齐刘海屏
        if UIScreen.isPhoneXr || UIScreen.isPhoneX || UIScreen.isPhoneXsMax {
            return true
        } else {
            // 判断“点”
            let wPoint = UIScreen.main.bounds.width
            let hPoint = UIScreen.main.bounds.height
            let isPhoneXPoint1 = wPoint == 812 || wPoint == 896
            let isPhoneXPoint2 = hPoint == 812 || hPoint == 896
            return isPhoneXPoint1 || isPhoneXPoint2
        }
    }()
    
    
    /// 此方法只支持竖屏状态下的获取，不支持 横竖屏旋转后 等动态获取方式
    static let naviBarHeight: CGFloat = {
        // iPhoneXs 与 isPhoneX 尺寸一致
        if UIScreen.isPhoneXSeries {
            return 88.0
        }
        return 64.0
    }()
    
    /// 此方法只支持竖屏状态下的获取，不支持 横竖屏旋转后 等动态获取方式
    static let statusBarHeight: CGFloat = {
        // iPhoneXs 与 isPhoneX 尺寸一致
        if UIScreen.isPhoneXSeries {
            return 44.0
        }
        return 20.0
    }()
    
    /// 此方法只支持竖屏状态下的获取，不支持 横竖屏旋转后 等动态获取方式
    static let tabBarHeight: CGFloat = {
        // iPhoneXs 与 isPhoneX 尺寸一致
        if UIScreen.isPhoneXSeries {
            return 83.0
        }
        return 49.0
    }()
    
    // 是否是横屏
    //    static let isHorizontal: Bool = {
    ////        __devlog("UIApplication.shared: \(UIApplication.shared.statusBarOrientation)")
    //        return UIApplication.shared.statusBarOrientation == .landscapeLeft || UIApplication.shared.statusBarOrientation == .landscapeRight
    //    }()
}
