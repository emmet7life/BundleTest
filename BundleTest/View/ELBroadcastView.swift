//
//  ELBroadcastView.swift
//  Swift-iOS-Demo
//
//  Created by jianli chen on 2018/5/9.
//  Copyright © 2018年 jianli chen. All rights reserved.
//

import UIKit

// MARK: - 默认的配置选项
// 单页显示几条数据
private let kDefaultBroadcastCountInOnePage: Int = 2
// 滚动间歇时间
private let kDefaultBroadcastAutoScrollDuration: TimeInterval = 3.0
// 是否自动缓存视图
private let kDefaultBroadcastAutoCacheView: Bool = false
// 滚动方向
private let kDefaultBroadcastScrollDirection: ELBroadcastViewDirection = .bottomToUp

// MARK: - 方向枚举
enum ELBroadcastViewDirection {
    case leftToRight
    case rightToLeft
    case upToBottom
    case bottomToUp
}

// MARK: - 配置视图的结构体
struct ELBroadcastViewOption {
    
    var broadcastCountInOnePage: Int = kDefaultBroadcastCountInOnePage
    var broadcastScrollDirection: ELBroadcastViewDirection = kDefaultBroadcastScrollDirection
    var broadcastAutoScrollDuration: TimeInterval = kDefaultBroadcastAutoScrollDuration
    var broadcastAutoCacheView: Bool = kDefaultBroadcastAutoCacheView
    
    init(_ countInPage: Int = kDefaultBroadcastCountInOnePage,
         direction: ELBroadcastViewDirection = kDefaultBroadcastScrollDirection,
         dutation: TimeInterval = kDefaultBroadcastAutoScrollDuration,
         isAutoCache: Bool = kDefaultBroadcastAutoCacheView) {
        broadcastCountInOnePage = countInPage
        broadcastScrollDirection = direction
        broadcastAutoScrollDuration = dutation
        broadcastAutoCacheView = isAutoCache
    }
}

// MARK: - 数据源协议
@objc protocol ELBroadcastViewDataSource: NSObjectProtocol {
    
    func elAutoScrollBroadcast(view: ELBroadcastView, viewForIndex index: Int) -> UIView
    var elAutoScrollBroadcastDataSourceCount: Int { get }
}

// 点击回调类型定义
typealias ELBroadcastCallback = () -> Void

// MARK: - 视图
class ELBroadcastView: UIView {
    
    // MARK: - Data & Option
    weak var dataSource: ELBroadcastViewDataSource?
    var options = ELBroadcastViewOption()
    var tappedBlock: ELBroadcastCallback?
    
    // MARK: - View
    fileprivate(set) lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        if #available(iOS 11, *) {
            view.contentInsetAdjustmentBehavior = .never
        }
        view.isUserInteractionEnabled = false
        view.isPagingEnabled = true
        view.bounces = false
        view.alwaysBounceHorizontal = false
        view.alwaysBounceVertical = false
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    
    fileprivate lazy var _currPageView: UIView = UIView()
    fileprivate lazy var _nextPageView: UIView = UIView()
    fileprivate lazy var _responseTapView: UIView = UIView()
    
    // MARK: - Inner Properties
    fileprivate var _isDidInitiate = false
    fileprivate var _pageIndex: Int = 0
    fileprivate var _isPause = true
    
    fileprivate var _cachedViews: [Int: UIView] = [:]
    
    fileprivate var viewWidth: CGFloat {
        return frame.size.width
    }
    
    fileprivate var viewHeight: CGFloat {
        return frame.size.height
    }
    
    // MARK: - Method
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        didInitiate()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if bounds != scrollView.frame {
            scrollView.frame = bounds
            _responseTapView.frame = bounds
            layoutSubviewsInitiate()
        }
    }
    
    deinit {
        removeAllSubviews(_currPageView)
        removeAllSubviews(_nextPageView)
        cleanCachedView()
    }
    
    /// 初始化
    private func didInitiate() {
        guard !_isDidInitiate else { return }
        _isDidInitiate = true
        scrollView.frame = bounds
        _responseTapView.frame = bounds
        scrollView.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        scrollView.delegate = self
        scrollView.contentSize = scrollViewContentSize
        addSubview(scrollView)
        addSubview(_responseTapView)
        scrollView.addSubview(_currPageView)
        scrollView.addSubview(_nextPageView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onBroadcastViewTapped))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        _responseTapView.addGestureRecognizer(tapGesture)
        
        layoutSubviewsInitiate()
    }
    
    /// 滚动视图的contentSize，跟方向和数据源总数有关系
    fileprivate var scrollViewContentSize: CGSize {
        switch options.broadcastScrollDirection {
        case .bottomToUp, .upToBottom:
            return CGSize(width: viewWidth, height: viewHeight * (isOverOnePage ? 2 : 1))
        case .leftToRight, .rightToLeft:
            return CGSize(width: viewWidth * (isOverOnePage ? 2 : 1), height: viewHeight)
        }
    }
    
    /// 初始化布局
    private func layoutSubviewsInitiate() {
        
        removeAllSubviews(_currPageView)
        removeAllSubviews(_nextPageView)
        
        _pageIndex = 0
        layoutCurrPage()
        
        if isOverOnePage {
            _pageIndex += 1
            layoutNextPage()
            
            startAutoScroll()
        } else {
            stopAutoScroll()
        }
    }
    
    /// 移除视图的所有子视图
    ///
    /// - Parameter view: 目标视图
    fileprivate func removeAllSubviews(_ view: UIView) {
        for subview in view.subviews {
            subview.removeFromSuperview()
        }
    }
    
    /// 清除已缓存视图
    func cleanCachedView() {
        _cachedViews.removeAll()
    }
    
    /// 重新加载(可能数据源发生变化了)
    func reloadData() {
        cleanCachedView()
        layoutSubviewsInitiate()
    }
    
    /// 数据源是否超过一屏
    fileprivate var isOverOnePage: Bool {
        return dataSourceCount > options.broadcastCountInOnePage
    }
    
    /// 数据源总数量
    fileprivate var dataSourceCount: Int {
        return dataSource?.elAutoScrollBroadcastDataSourceCount ?? 0
    }
    
    /// 布局上一页
    fileprivate func layoutCurrPage() {
        layoutPage(with: _pageIndex, pageView: _currPageView)
        _currPageView.frame = currPageFrame
    }
    
    /// 布局下一页
    fileprivate func layoutNextPage() {
        layoutPage(with: _pageIndex, pageView: _nextPageView)
        _nextPageView.frame = nextPageFrame
    }
    
    /// 布局页视图
    ///
    /// - Parameters:
    ///   - pageIndex: 页索引
    ///   - pageView: 布局的页视图
    fileprivate func layoutPage(with pageIndex: Int = 0, pageView: UIView) {
        
        guard dataSourceCount > 0 else { return }
        
        let totalCount = dataSourceCount
        let countInPage = options.broadcastCountInOnePage
        for index in 0 ..< min(countInPage, dataSourceCount) {
            let adjustIndex = (pageIndex * countInPage + index) % totalCount
            let cachedView: UIView? = _cachedViews[adjustIndex]
            if let pageIndexView = cachedView ?? dataSource?.elAutoScrollBroadcast(view: self, viewForIndex: adjustIndex) {
                pageIndexView.frame = pageIndexViewFrame(with: index)
                pageView.addSubview(pageIndexView)
                
                if options.broadcastAutoCacheView {
                    _cachedViews.updateValue(pageIndexView, forKey: adjustIndex)
                }
            }
        }
    }
    
    /// 页中的每一项视图的布局参数
    ///
    /// - Parameter index: 索引
    /// - Returns: 布局参数
    fileprivate func pageIndexViewFrame(with index: Int) -> CGRect {
        let countInPage: Int = options.broadcastCountInOnePage
        let _width = bounds.size.width
        let _height = bounds.size.height / CGFloat(max(1, countInPage))
        var offsetIndex = index % countInPage
        if options.broadcastScrollDirection == .upToBottom {
            offsetIndex = countInPage -  1 - offsetIndex
        }
        return CGRect(x: 0, y: CGFloat(offsetIndex) * _height, width: _width, height: _height)
    }
    
    /// 当前页的布局参数
    fileprivate var currPageFrame: CGRect {
        return CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight)
    }
    
    /// 下一页的布局参数
    fileprivate var nextPageFrame: CGRect {
        switch options.broadcastScrollDirection {
        case .bottomToUp:
            return CGRect(x: 0, y: viewHeight, width: viewWidth, height: viewHeight)
        case .upToBottom:
            return CGRect(x: 0, y: -viewHeight, width: viewWidth, height: viewHeight)
        case .leftToRight:
            return CGRect(x: viewWidth, y: 0, width: viewWidth * 2, height: viewHeight)
        case .rightToLeft:
            return CGRect(x: -viewWidth, y: 0, width: viewWidth, height: viewHeight)
        }
    }
    
    /// 开启自动滚动行为
    func startAutoScroll() {
        guard _isPause else { return }
        let totalCount = dataSourceCount
        let countInPage = options.broadcastCountInOnePage
        // 总数据条数大于每页显示的条数时才开启自动滚动
        guard totalCount > 0 && totalCount > countInPage else {
            return
        }
        
        _isPause = false
        self.perform(#selector(scrollToNextPage), with: self, afterDelay: options.broadcastAutoScrollDuration)
    }
    
    /// 结束自动滚动行为
    func stopAutoScroll() {
        _isPause = true
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(scrollToNextPage), object: nil)
    }
    
    /// 滚动到下一屏
    @objc fileprivate func scrollToNextPage() {
        guard !_isPause else {
            return
        }
        
        var offset = CGPoint.zero
        switch options.broadcastScrollDirection {
        case .bottomToUp:
            offset = CGPoint(x: 0, y: viewHeight)
        case .upToBottom:
            offset = CGPoint(x: 0, y: -viewHeight)
        case .leftToRight:
            offset = CGPoint(x: viewWidth, y: 0)
        case .rightToLeft:
            offset = CGPoint(x: -viewWidth, y: 0)
        }
        scrollView.setContentOffset(offset, animated: true)
    }
    
    /// 滚动到下一屏动画完成时的处理
    fileprivate func onScrollToNextPageComplete() {
        guard !_isPause else {
            return
        }
        
        let nextPageView = _nextPageView
        _nextPageView = _currPageView
        _currPageView = nextPageView
        
        _currPageView.frame = currPageFrame
        _nextPageView.frame = nextPageFrame
        
        scrollView.setContentOffset(.zero, animated: false)
        
        let totalCount: Int = dataSourceCount    // 总数据条数
        let countInPage: Int = options.broadcastCountInOnePage    // 每页显示多少条
        
        _pageIndex += 1// 页索引
        
        // 处理_pageIndex达到边界时的重置问题
        // 1. 总个数是偶数
        // 1.1 每页显示的个数如果是奇数，那么单轮循环次数便是总数据条数，然后再次重复循环下去
        // 1.2 每页显示的个数如果是偶数，还要判断会不会被countInPage整除
        // 1.2.1 会整除的话，就是达到totalCount / countInPage次后可再次循环
        // 1.2.2 不会整除的话，便是总数据条数，然后再次重复循环下去
        //
        // 2. 总个数是奇数
        // 2.1 单轮循环次数便是总数据条数，然后再次重复循环下去
        //
        // 特殊情况处理，如果是countInPage >= totalCount就只显示一页即可，不滚动
        
        // 总个数是偶数
        if totalCount % 2 == 0 {
            if countInPage % 2 != 0 {
                if _pageIndex >= totalCount {
                    _pageIndex = 0
                }
            } else {
                
                if totalCount % countInPage == 0 {
                    if _pageIndex >= totalCount / countInPage {
                        _pageIndex = 0
                    }
                } else {
                    if _pageIndex >= totalCount {
                        _pageIndex = 0
                    }
                }
            }
        } else {
            // 总个数是奇数
            if _pageIndex >= totalCount {
                _pageIndex = 0
            }
        }
        
        removeAllSubviews(_nextPageView)
        layoutPage(with: _pageIndex, pageView: _nextPageView)
        
        guard !_isPause else {
            return
        }
        self.perform(#selector(scrollToNextPage), with: self, afterDelay: options.broadcastAutoScrollDuration)
    }
    
    /// 处理点击事件响应
    @objc fileprivate func onBroadcastViewTapped() {
        tappedBlock?()
    }
    
}

// MARK: - UIScrollViewDelegate
extension ELBroadcastView: UIScrollViewDelegate {
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        onScrollToNextPageComplete()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        onScrollToNextPageComplete()
    }
    
}
