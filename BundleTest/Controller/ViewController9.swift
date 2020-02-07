//
//  ViewController9.swift
//  BundleTest
//
//  Created by jianli chen on 2019/6/24.
//  Copyright © 2019 jianli chen. All rights reserved.
//

import UIKit
import MXParallaxHeader

class ViewController9: VCBaseViewController {

    @IBOutlet weak var scrollView: MXScrollView!
    @IBOutlet weak var topFloatView: UIView!
    @IBOutlet weak var topFloatViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var topFloatTipLabel: UILabel!
    
    private let topFloatViewBottomLineLayer: CALayer = CALayer()
    
    fileprivate let collectionView = UICollectionView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: UIScreen.main.bounds.width, height: 64.0 + 32.0 * 2)), collectionViewLayout: UICollectionViewFlowLayout())
    fileprivate let pageController = VCPageContainerViewController()
    
    private var currentSelectedIndex: Int = 0
    
    override var isNavigationBarTransparent: Bool {
        return true
    }
    
    class Person {
        
        var name: String
        
        lazy var personalizedGreeting: String = {
            //[unowned self] in
            return "Hello, \(self.name)!"
        }()
        
        init(name: String) {
            print("person init")
            self.name = name
        }
        
        deinit {
            print("person deinit")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "榜单"
        
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
            collectionView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
        collectionView.backgroundColor = .white
        collectionView.register(IdentifierCell3.self, forCellWithReuseIdentifier: IdentifierCell3.identifier)
        collectionView.contentInset = UIEdgeInsets(top: kNavBarHeight, left: 16.0, bottom: 0, right: 16.0)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        scrollView.parallaxHeader.view = collectionView
        scrollView.parallaxHeader.contentView.clipsToBounds = false
        scrollView.bounces = false
        scrollView.parallaxHeader.mode = .bottom
        
        scrollView.parallaxHeader.height = kHeaderHeight
        scrollView.parallaxHeader.minimumHeight = kStickyHeaderHeight
        
        scrollView.parallaxHeader.addObserver(self, forKeyPath: "progress", options: .new, context: nil)
        
        topFloatViewBottomLineLayer.backgroundColor = UIColor.gray.cgColor
        topFloatView.layer.addSublayer(topFloatViewBottomLineLayer)
        
        scrollView.delegate = self
        scrollView.canCancelContentTouches = true
        scrollView.panGestureRecognizer.cancelsTouchesInView = true
        
        // 添加Page
        addChild(pageController)
        pageController.view.frame = CGRect(x: 0, y: 0, width: view.width, height: 0)
        pageController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        pageController.willMove(toParent: self)
        scrollView.addSubview(pageController.view)
        pageController.didMove(toParent: self)
        pageController.delegate = self
        pageController.scrollView.clipsToBounds = false
        
        createPageControllerContent()
        
        topFloatTipLabel.text = topList[currentSelectedIndex]
        
        //...
        let person = Person(name: "name")
        print(person.personalizedGreeting)
        //..
    }
    
    deinit {
        scrollView.parallaxHeader.removeObserver(self, forKeyPath: "progress")
    }
    
    @available(iOS 11.0, *)
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        
        let minimumHeight = kStickyHeaderHeight
        let height = kHeaderHeight
        
        if scrollView.parallaxHeader.minimumHeight != minimumHeight {
            scrollView.parallaxHeader.minimumHeight = minimumHeight
        }
        
        if scrollView.parallaxHeader.height != height {
            scrollView.parallaxHeader.height = height
        }
        
        collectionView.contentInset = UIEdgeInsets(top: kNavBarHeight, left: 16.0, bottom: 0, right: 16.0)
        collectionView.reloadData()
        
        view.layoutIfNeeded()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        var frame = view.bounds
        frame.size.height -= viewSafeAreaInsets.bottom + scrollView.parallaxHeader.minimumHeight
        scrollView.contentSize = frame.size
        
        pageController.view.frame = frame
        pageController.scrollView.contentSize.height = frame.height
        view.layoutIfNeeded()
    }
    
    fileprivate let kMenuHeight: CGFloat = 34.0 * 2
    
    fileprivate var kNavBarHeight: CGFloat {
        return kHeaderMinimumHeight + viewSafeAreaInsetsAddtionTop
    }
    
    fileprivate var kStickyHeaderHeight: CGFloat {
        return kNavBarHeight
    }
    
    fileprivate var kHeaderHeight: CGFloat {
        return kNavBarHeight + kMenuHeight
    }
    
    fileprivate let topList: [String] = ["新作榜", "催更榜", "投喂榜", "飙升榜", "综合榜", "畅销榜", "收藏榜", "互动榜", "恋爱榜", "热度榜"]
    
    private func createPageControllerContent() {
        var viewControllers = [UIViewController]()
        let colors = [UIColor.yellow, UIColor.purple, UIColor.green, UIColor.darkGray, UIColor.white]
        
        var preColorIndex: Int = 0
        
        for title in topList {
            
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 30.0)
            label.textColor = UIColor.black
            label.textAlignment = .center
            label.text = title
            
            // 保证随机出来的颜色与上一个Controller使用的颜色不一样
            var randomColorIndex = Int(arc4random_uniform(UInt32(colors.count)))
            while randomColorIndex == preColorIndex {
                randomColorIndex = Int(arc4random_uniform(UInt32(colors.count)))
            }
            
            let controller = VCTopListViewController()
            controller.view.backgroundColor = colors[randomColorIndex]
            controller.view.addSubview(label)
            label.center = controller.view.center
            viewControllers.append(controller)
            
            preColorIndex = randomColorIndex
            
        }
        
        pageController.viewControllers = viewControllers
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        guard !scrollView.parallaxHeader.progress.isNaN else {
            return
        }
        
        var parallaxProgress: CGFloat = -1.0
        if let progress = Double(String(format: "%.6f", self.scrollView.parallaxHeader.progress)) {
            parallaxProgress = CGFloat(progress)
        }
        
        if parallaxProgress >= 1.0 {
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
            let alpha: CGFloat = 1.0 - parallaxProgress
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

extension ViewController9: VCPageContainerDelegate {
    
    func onPageContainerCurrentPageChanged(_ pageIndex: Int) {
        
    }
    
    func onPageContainerViewEndScroll(_ scrollView: UIScrollView) {
        
    }
    
    func onPageContainerViewDidScroll(_ scrollView: UIScrollView) {
        let contentWidth = scrollView.contentSize.width
        let contentOffsetX: CGFloat = scrollView.contentOffset.x
        let progress: Int = Int(((contentOffsetX + scrollView.width * 0.5) / contentWidth) * 10)
        if currentSelectedIndex != progress {
            currentSelectedIndex = progress
            collectionView.reloadData()
            topFloatTipLabel.text = topList[currentSelectedIndex]
        }
    }
    
}

extension ViewController9: MXScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
}

extension ViewController9: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: IdentifierCell3.identifier, for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.isSelected = indexPath.item == currentSelectedIndex
        if let labelCell = cell as? IdentifierCell3 {
            labelCell.textLabel.text = topList[indexPath.item]
            labelCell.reloadUI()
        }
    }
}

extension ViewController9: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let minimumInteritemSpacing = self.collectionView(collectionView, layout: collectionViewLayout, minimumInteritemSpacingForSectionAt: 0)
        let width: CGFloat = view.frame.size.width - collectionView.contentInset.left - collectionView.contentInset.right
        let itemWidth: CGFloat = (width - minimumInteritemSpacing * 4) / 5.0 - 1.0
        return CGSize(width: itemWidth, height: 34.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return UIScreen.isPhoneDown5Plus ? 16.0 : 22.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }

}

class IdentifierCell3: UICollectionViewCell {
    
    static let identifier = "IdentifierCell3_identifier"
    let textLabel = UILabel()
    private let color1: UIColor = UIColor.colorWithHexRGBA(0xF75d79)
    private let color2: UIColor = UIColor.colorWithHexRGBA(0xB3B3B3)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    private func initialize() {
        textLabel.textAlignment = .left
        textLabel.font = UIFont.systemRegularFont(15.0)
        textLabel.textColor = UIColor.colorWithHexRGBA(0x666666)
        contentView.addSubview(textLabel)
        textLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func reloadUI() {
        if isSelected {
            textLabel.textColor = color1
        } else {
            textLabel.textColor = color2
        }
    }
}
