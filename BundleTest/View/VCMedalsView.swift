//
//  VCMedalsView.swift
//  Swift-2018
//
//  Created by jianli chen on 2018/12/5.
//  Copyright © 2018年 jianli chen. All rights reserved.
//

import UIKit
import SwiftyJSON
import Kingfisher

// 数据源构造协议
protocol VCJSONDataModel {
    // 构造方法
    init?(_ json: JSON)
    // 数据是否有效
    var isValid: Bool { get }
}

// 勋章信息
struct VCMedalInfo: VCJSONDataModel {
    
    init?(_ json: JSON) {
        guard json != JSON.null else { return nil }
        id = json["medal_id"].stringValue
        icon = json["medal_icon"].stringValue
    }
    
    init(id: String, icon: String) {
        self.id = id
        self.icon = icon
    }
    
    var id: String      // 勋章ID
    var icon: String    // 勋章图标URL
    
    var isValid: Bool {
        return !icon.isEmpty
    }
}

// MARK: - 勋章容器 组件
class VCMedalsView: UIView {
    
    /// MARK: - 勋章ICON请求状态
    typealias MedalIconRequestState = (isRequesting: Bool, isSuccess: Bool, request: RetrieveImageTask?)
    
    // MARK: - 容器配置
    struct MedalsViewOption {
        var medalViewSize: CGSize                       // 勋章大小
        var medalViewOffset: CGFloat = 6.0              // 勋章之间的间隔
        var medalViewContentMode: UIView.ContentMode     // 勋章ImageView的contentMode
    }
    
    // MARK: - 内部属性
    private(set) var sourceMedals: [VCMedalInfo] = []   // 所有勋章源
    private var finalVisibleMedals: [VCMedalInfo] = []  // 最终可显示的勋章
    private var requestedMedals: [VCMedalInfo] = []     // 请求成功了的勋章
    
    private var reqStates: [String: MedalIconRequestState] = [:]    // 勋章请求状态
    
    // MARK: - 配置 & 默认配置
    private static let defaultMedalOption = MedalsViewOption(medalViewSize: CGSize(width: 43, height: 24), medalViewOffset: 6.0, medalViewContentMode: .scaleAspectFit)
    private(set) var medalOption: MedalsViewOption = VCMedalsView.defaultMedalOption
    
    // MARK: - 构建 & 内容方法
    init(option: MedalsViewOption = VCMedalsView.defaultMedalOption) {
        super.init(frame: CGRect.zero)
        medalOption = option
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func _handleRequestComplete(with image: UIImage?, error: NSError?, medalInfo: VCMedalInfo) {
        if var state = reqStates[medalInfo.id] {
            let isSuccess = image != nil && error == nil
            state.isRequesting = false
            state.isSuccess = isSuccess
            state.request = nil
            reqStates.updateValue(state, forKey: medalInfo.id)
            if isSuccess {// 成功请求的勋章
                requestedMedals.append(medalInfo)
            }
            let isAllRequestCompleted = (reqStates.filter { !$0.value.isRequesting }).count == sourceMedals.count
            if isAllRequestCompleted {
                // 最终显示的是那些已经请求成功了的勋章
                finalVisibleMedals.removeAll()
                finalVisibleMedals = sourceMedals.filter { medal in
                    return requestedMedals.contains {
                        $0.id == medal.id
                    }
                }
                layoutFinalVisibleMedals()
            }
        }
        
    }
    
    private func layoutFinalVisibleMedals() {
        let offsetX: CGFloat = medalOption.medalViewOffset
        var originX: CGFloat = 0.0
        for medal in finalVisibleMedals {
            let medalView = _createMedalView()
            medalView.frame.origin = CGPoint(x: originX, y: 0)
            addSubview(medalView)
            medalView.kf.setImage(with: URL(string: medal.icon)!)
            originX += medalView.frame.size.width + offsetX
        }
    }
    
    private func _createMedalView() -> UIImageView {
        let medalView = UIImageView()
        medalView.contentMode = medalOption.medalViewContentMode
        medalView.frame.size = medalOption.medalViewSize
        return medalView
    }
    
    // MARK: - 开放API
    
    // 设置勋章源
    func setSourceMedals(with sourceMedals: [VCMedalInfo] = []) {
        self.sourceMedals.removeAll()
        self.sourceMedals = sourceMedals.filter { !$0.icon.isEmpty && URL(string: $0.icon) != nil }
        
        for subview in subviews {
            subview.removeFromSuperview()
        }
        
        for state in reqStates {
            state.value.request?.cancel()
        }
        
        reqStates.removeAll()
        finalVisibleMedals.removeAll()
        requestedMedals.removeAll()
        
        for source in sourceMedals {
            
            let task: RetrieveImageTask = KingfisherManager.shared.retrieveImage(with: URL(string: source.icon)!,
                                                                                 options: nil,
                                                                                 progressBlock: nil)
            { [weak self] (image, error, cacheType, url) in
                self?._handleRequestComplete(with: image, error: error, medalInfo: source)
            }
            reqStates.updateValue((true, false, task), forKey: source.id)
        }
    }
}
