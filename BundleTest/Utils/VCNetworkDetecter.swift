//
//  NetworkDetecter.swift
//  Swift-2018
//
//  Created by jianli chen on 2018/12/13.
//  Copyright © 2018年 jianli chen. All rights reserved.
//

import Foundation
import CoreTelephony

class VCNetworkDetecter {
    
    static var shared = VCNetworkDetecter()
    
    private var _cellularData: CTCellularData? = nil
    private var _isAddedListener = false
    
    private init() {}
    
    func addNetworkChangedListener() {
        guard !_isAddedListener else { return }
        _isAddedListener = true
        let cellularData = CTCellularData()
        cellularData.cellularDataRestrictionDidUpdateNotifier = { state in
            // state -> CTCellularDataRestrictedState
            print("VCNetworkDetecter state is >>> \(state)")
            switch state {
            case .notRestricted:// 不受限，监听网络情况
                break
            case .restricted:// 受限，用户未允许APP联网
                break
            case .restrictedStateUnknown:// 未知，可能是不受限，但是网络不通的情况！
                break
            }
        }
        _cellularData = cellularData
    }
    
    func removeNetworkChangedListener() {
        guard _isAddedListener else { return }
        if let listener = _cellularData {
            listener.cellularDataRestrictionDidUpdateNotifier = nil
            _cellularData = nil
        }
        _isAddedListener = false
    }
    
}
