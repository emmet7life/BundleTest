//
//  String+Extension.swift
//  Swift-iOS-Demo
//
//  Created by jianli chen on 2018/5/30.
//  Copyright © 2018年 jianli chen. All rights reserved.
//

import Foundation

extension String {
    
    // 对象方法
    func fileSize() -> UInt64  {
        var size: UInt64 = 0
        let fileManager = FileManager.default
        var isDir: ObjCBool = false
        let isExists = fileManager.fileExists(atPath: self, isDirectory: &isDir)
        // 判断文件存在
        if isExists {
            // 是否为文件夹
            if isDir.boolValue {
                // 迭代器 存放文件夹下的所有文件名
                let enumerator = fileManager.enumerator(atPath: self)
                for subPath in enumerator! {
                    // 获得全路径
                    let fullPath = self.appending("/\(subPath)")
                    do {
                        let attr = try fileManager.attributesOfItem(atPath: fullPath)
                        size += attr[FileAttributeKey.size] as! UInt64
                    } catch  {
                        print("error :\(error)")
                    }
                }
            } else {    // 单文件
                do {
                    let attr = try fileManager.attributesOfItem(atPath: self)
                    size += attr[FileAttributeKey.size] as! UInt64
                    
                } catch  {
                    print("error :\(error)")
                }
            }
        }
        return size
    }
    
    /// 生成32位 md5 的加密串
//    var md5String: String {
//        let cString = self.cString(using: String.Encoding.utf8)
//        let length = CUnsignedInt(
//            self.lengthOfBytes(using: String.Encoding.utf8)
//        )
//        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(
//            capacity: Int(CC_MD5_DIGEST_LENGTH)
//        )
//
//        CC_MD5(cString!, length, result)
//
//        return String(format:
//            "%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
//                      result[0], result[1], result[2], result[3],
//                      result[4], result[5], result[6], result[7],
//                      result[8], result[9], result[10], result[11],
//                      result[12], result[13], result[14], result[15])
//    }
}
