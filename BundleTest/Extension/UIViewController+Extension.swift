//
//  UIViewController+Extension.swift
//  VComicApp
//
//  Created by 杨权 on 2017/7/12.
//  Copyright © 2017年 Gookee. All rights reserved.
//

import UIKit
import YYCategories

// 基础视图控制器的默认配置
let kDefaultPreferredStatusBarStyle: UIStatusBarStyle = .default
let kDefaultPrefersStatusBarHidden: Bool = false
let kDefaultShouldAutorotate: Bool = true
let kDefaultSupportedInterfaceOrientations: UIInterfaceOrientationMask = .portrait
let kDefaultPreferredInterfaceOrientationForPresentation: UIInterfaceOrientation = .portrait

private var kUIViewControllerBindingTrackTagKey: Void?

/// 控制器中触发数据请求的方式
///
/// - `default`: 默认是上拉或下拉
/// - emptyLoad: 界面为空时
/// - artificial: 代码逻辑手动触发
enum VCPageDataRequestType: Int {
    case `default`
    case emptyLoad
    case artificial
}

/// 界面数据请求协议
protocol VCViewControllerRequestContentProtocol {
    
    // 下拉次数
    var pulldownCount: Int { get set }
    // 上拉次数
    var pullupCount: Int { get set }
    
    /// 界面内容是否为空
    var isContentEmpty: Bool { get set }
    
    /// 界面数据请求
    ///
    /// - Parameters:
    ///   - isRefresh: 是否是刷新操作
    ///   - type: 请求发起的类型
    func requestContent(_ isRefresh: Bool, type: VCPageDataRequestType)
}

extension UIImage {
    
    // 导航栏透明背景图
    static let transparentImage: UIImage = UIImage()
    // 默认导航栏背景图
    static let defaultNavigationBarImage: UIImage? = UIImage(color: UIColor(white: 1, alpha: 0.98)) ?? UIImage(named: "nav_bg")
    // 默认导航栏shadowImage背景图
    static let defaultShadowImage: UIImage = UIImage.shadowImageFromColor(.sepLineColor)
}

@objc extension UIViewController {
    
    // 初始化导航栏样式
    func initializeNavigationBarStyle() {
        guard !isAsChildControllerEmbedInParentController else { return }
        if isNavigationBarTransparent {
            edgesForExtendedLayout = .top
            transparentNavigationBar()
        } else {
            edgesForExtendedLayout = UIRectEdge()
            let defaultBackgroundImage = defaultNavBarBackgroundImage
            navigationBar?.isTranslucent = translucent && defaultBackgroundImage == UIImage.transparentImage
            navigationBar?.setBackgroundImage(defaultBackgroundImage, for: .default)
            navigationBar?.shadowImage = UIImage.defaultShadowImage
        }
    }
    
    // 设置导航栏为透明样式
    func transparentNavigationBar() {
        navigationBar?.isTranslucent = true
        navigationBar?.setBackgroundImage(UIImage.transparentImage, for: .default)
        navigationBar?.shadowImage = UIImage.transparentImage
    }
    
    // 更新导航栏isTranslucent属性(viewWillAppear调用)
    func updateNavigationBarIsTranslucent() {
        guard !isAsChildControllerEmbedInParentController else { return }
        navigationBar?.isTranslucent = translucent
    }
    
    // 默认导航栏背景图
    var defaultNavBarBackgroundImage: UIImage {
        if isNavigationBarTransparent {
            return UIImage.transparentImage
        }
        return UIImage.defaultNavigationBarImage  ?? UIImage.transparentImage
    }
    
    // 导航栏isTranslucent属性值
    var translucent: Bool {
        return isNavigationBarTransparent
    }
    
    // 导航栏是否设置成透明样式
    var isNavigationBarTransparent : Bool {
        return false
    }
    
    // 导航栏
    var navigationBar: UINavigationBar? {
        return navigationController?.navigationBar
    }
    
    // 如果作为子Controller，则放弃配置导航栏样式等
    var isAsChildControllerEmbedInParentController: Bool {
        return false
    }
    
    // 是否禁用导航栏的左滑手势
    var isForbidInteractivePopGesture: Bool {
        return false
    }
    
    @discardableResult
    func popController(animated: Bool) -> UIViewController? {
        return navigationController?.popViewController(animated: animated)
    }
    
    @discardableResult
    func configNavBackButton(_ isBlackStyle: Bool = true) -> UIButton {
        return configNavBackButtonByNamed(image: isBlackStyle ? "ic_arrow_back_black_1" : "ic_arrow_back_white_1")
    }
    
    @discardableResult
    func configNavBackButtonByNamed(image name: String = "ic_arrow_back_black_1") -> UIButton {
        var button: UIButton!
        if #available(iOS 11.0, *) {
            let fixedWidth: CGFloat = 4.0
            let fixedBarButtonItem = createFixedBarButtonItem(fixedWidth)
            button = createBarButtonItemCustomButton(offset: fixedWidth, isLeft: true)
            navigationItem.leftBarButtonItems = [fixedBarButtonItem, UIBarButtonItem(customView: WrapperView(underlyingView: button))]
        } else {
            button = UIButton(type: .custom)
            button.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
            navigationItem.leftBarButtonItems = [createFixedBarButtonItem(-16), UIBarButtonItem(customView: button)]
        }
        
        button.addTarget(self, action: #selector(onNavBackAction), for: .touchUpInside)
        button.setImage(UIImage(named: name)?.withRenderingMode(.alwaysOriginal), for: UIControl.State())
        button.titleLabel?.lineBreakMode = .byTruncatingTail
        button.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        return button
    }
    
    @discardableResult
    func configNavRightTextButton(_ text: String, textColor: UIColor = .mainColor) -> UIButton {
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 0, y: 0, width: 60, height: 44)
        button.contentHorizontalAlignment = .right
        button.addTarget(self, action: #selector(onNavRightButtonAction), for: .touchUpInside)
        button.setTitle(text, for: UIControl.State())
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.setTitleColor(textColor, for: UIControl.State())
        
        navigationItem.rightBarButtonItems = [createFixedBarButtonItem(-6), UIBarButtonItem(customView: button)]
        
        return button
    }
    
    // redrawColor 用指定颜色重绘图片
    @discardableResult
    func configNavRightIconButton(_ imgName: String,redrawColor: UIColor? = nil) -> UIButton {
        var button: UIButton!
        if #available(iOS 11.0, *) {
            let fixedWidth: CGFloat = 4.0
            let fixedBarButtonItem = createFixedBarButtonItem(fixedWidth)
            button = createBarButtonItemCustomButton(offset: fixedWidth, isLeft: false)
            navigationItem.rightBarButtonItems = [fixedBarButtonItem, UIBarButtonItem(customView: WrapperView(underlyingView: button))]
        } else {
            button = UIButton(type: .system)
            button.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
            navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: button)]
        }
        button.addTarget(self, action: #selector(onNavRightButtonAction), for: .touchUpInside)
        let needImage = UIImage(named: imgName)
        if let redrawColor = redrawColor{
            let redrawImage = needImage?.redrawWithTintColor(redrawColor)?.withRenderingMode(.alwaysOriginal)
            button.setImage(redrawImage, for: UIControl.State())
            return button
        }
        button.setImage(needImage?.withRenderingMode(.alwaysOriginal), for: UIControl.State())
        return button
    }
    
    @discardableResult
    func configNavRightButtons(with views: [UIView] = [], imageNames: [String] = [], layoutFrames: [CGRect]? = nil) -> [UIButton] {
        
        func getLayoutFrame(_ index: Int) -> CGRect {
            if let frames = layoutFrames, index >= 0 && index < frames.count {
                return frames[index]
            }
            return CGRect(origin: .zero, size: CGSize(width: 44.0, height: 44.0))
        }
        
        var enumerateIndex: Int = 0
        
        let fixedWidth: CGFloat = 4.0
        let fixedBarButtonItem = createFixedBarButtonItem(fixedWidth)
        
        // 总按钮数组
        var buttons = [UIButton]()
        
        // 1. 先装载自定义View
        for view in views {
            var button = UIButton(type: .system)
            let frame = getLayoutFrame(enumerateIndex)
            if #available(iOS 11.0, *) {
                button = createBarButtonItemCustomButton(offset: fixedWidth, isLeft: false)
                view.frame = frame
            } else {
                // 11以下值设置size
                view.size = frame.size
                view.origin = .zero
            }
            button.size = frame.size
            
            button.addSubview(view)
            buttons.append(button)
            
            enumerateIndex += 1
        }
        
        // 2. 再装载普通图片按钮
        for imageName in imageNames {
            var button = UIButton(type: .system)
            if #available(iOS 11.0, *) {
                button = createBarButtonItemCustomButton(offset: fixedWidth, isLeft: false)
            }
            let frame = getLayoutFrame(enumerateIndex)
            button.size = frame.size
            
            button.setImage(UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal), for: UIControl.State())
            buttons.append(button)
            
            enumerateIndex += 1
        }
        
        enumerateIndex = (views.count + imageNames.count) - 1
        
        var rightItems: [UIBarButtonItem] = []
        if #available(iOS 11.0, *) {
            rightItems.append(fixedBarButtonItem)
            for button in buttons.reversed().enumerated() {
                let frame = getLayoutFrame(enumerateIndex)
                rightItems.append(UIBarButtonItem(customView: WrapperView(underlyingView: button.element, minimumSize: frame.size)))
                
                enumerateIndex -= 1
            }
        } else {
            rightItems.append(createFixedBarButtonItem(-16))
            for button in buttons.reversed().enumerated() {
                rightItems.append(UIBarButtonItem(customView: button.element))
                if button.offset > 0 {
                    rightItems.append(createFixedBarButtonItem(1.0))
                }
            }
        }
        
        navigationItem.rightBarButtonItems = rightItems
        return buttons
    }
    
    fileprivate func createFixedBarButtonItem(_ width: CGFloat) -> UIBarButtonItem {
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        barButtonItem.width = width
        return barButtonItem
    }
    
    @objc func onNavBackAction(_ button: UIButton?) {
        popController(animated: true)
    }
    
    @objc func onNavRightButtonAction(_ button: UIButton?) {
        
    }
    
    /// 统计界面使用率，用来区分界面
    var trackTag: String? {
        get {
            return objc_getAssociatedObject(self, &kUIViewControllerBindingTrackTagKey) as? String
        }
        set {
            objc_setAssociatedObject(self, &kUIViewControllerBindingTrackTagKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    // MARK: - 3.0.0新增统计相关
    var pageName: String {
        return title ?? className()
    }
    
    var attachInfo: [String: Any]? {
        return nil
    }
}

// iOS 11.0 extension
extension UIViewController {
    
    var viewSafeAreaInsets: UIEdgeInsets {
        if #available(iOS 11.0, *) {
            return view.safeAreaInsets
        }
        return UIEdgeInsets.zero
    }
    
    // 仅适用于导航栏和状态栏处于可见状态使用
    var viewSafeAreaInsetsAddtionTop: CGFloat {
        return max(0, viewSafeAreaInsets.top - 64.0)// 44.0 + 20.0 导航栏加状态栏
    }
    
    func createBarButtonItemCustomButton(offset: CGFloat = 0, isLeft: Bool = true, frame: CGRect = CGRect(x: 0, y: 0, width: 44, height: 44)) -> UIButton {
        let button = VCBarButtonItemCustomButton(frame: frame)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 0)
        if isLeft {
            button.alignmentRectInsetsOverride = UIEdgeInsets(top: 0, left: offset, bottom: 0, right: -offset)
        } else {
            button.alignmentRectInsetsOverride = UIEdgeInsets(top: 0, left: -offset, bottom: 0, right: offset)
        }
        return button
    }
}

class VCBarButtonItemCustomButton: UIButton {
    
    var alignmentRectInsetsOverride: UIEdgeInsets?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    fileprivate func setupUI() {
        translatesAutoresizingMaskIntoConstraints = false
        //        layer.borderColor = UIColor.yellow.cgColor
        //        layer.borderWidth = 0.5
    }
    
    override var alignmentRectInsets: UIEdgeInsets {
        return alignmentRectInsetsOverride ?? super.alignmentRectInsets
    }
}

@available(iOS 9.0, *)
class WrapperView: UIView {
    
    let minimumSize: CGSize
    let underlyingView: UIView
    init(underlyingView: UIView, minimumSize: CGSize = CGSize(width: 44.0, height: 44.0)) {
        self.underlyingView = underlyingView
        self.minimumSize = minimumSize
        super.init(frame: underlyingView.bounds)
        
        underlyingView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(underlyingView)
        
        NSLayoutConstraint.activate([
            underlyingView.leadingAnchor.constraint(equalTo: leadingAnchor),
            underlyingView.trailingAnchor.constraint(equalTo: trailingAnchor),
            underlyingView.topAnchor.constraint(equalTo: topAnchor),
            underlyingView.bottomAnchor.constraint(equalTo: bottomAnchor),
            heightAnchor.constraint(greaterThanOrEqualToConstant: minimumSize.height),
            widthAnchor.constraint(greaterThanOrEqualToConstant: minimumSize.width)
            ])
        
        //        layer.borderColor = UIColor.red.cgColor
        //        layer.borderWidth = 0.5
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UITabBarController {
    func setTabBarVisible(visible:Bool) {
        if (tabBarIsVisible() == visible) { return }
        let frame = self.tabBar.frame
        let height = frame.size.height
        let offsetY = (visible ? -height : height)
        
        self.tabBar.frame.offsetBy(dx:0, dy:offsetY)
        self.view.frame = CGRect(x:0,y:0,width: self.view.frame.width, height: self.view.frame.height + offsetY)
        self.view.setNeedsDisplay()
        self.view.layoutIfNeeded()
    }
    
    func tabBarIsVisible() ->Bool {
        return self.tabBar.frame.origin.y < UIScreen.main.bounds.height
    }
}

extension UIViewController {
    public func setViewCorner(view: UIView, cornerRadius: CGFloat) {
        view.layer.masksToBounds = true
        view.layer.cornerRadius = cornerRadius
    }
}
