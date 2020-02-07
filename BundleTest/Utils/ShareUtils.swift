//
//  ShareUtils.swift
//  BundleTest
//
//  Created by jianli chen on 2019/10/16.
//  Copyright © 2019 jianli chen. All rights reserved.
//

import Foundation

struct ShareUtils {
    
    /// 生成二维码
    ///
    /// - Parameters:
    ///   - message: 需要编码到二维码图片中的数据
    ///   - logoImage: logo 图
    /// - Returns: 二维码图片，生成异常返回 nil
    static func generateQRCodeImage(message: String, logoImage: UIImage? = nil) -> UIImage? {
        let msgData = message.data(using: .utf8, allowLossyConversion: false)
        
        // 1. 生成二维码
        guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        qrFilter.setDefaults()
        qrFilter.setValue(msgData, forKey: "inputMessage")
        //设置二维码的纠错水平，越高纠错水平越高，可以污损的范围越大
        /*
         * L: 7%
         * M: 15%
         * Q: 25%
         * H: 30%
         */
        qrFilter.setValue("H", forKey: "inputCorrectionLevel")
        
        guard var outputImage = qrFilter.outputImage else { return nil }
        
        // 二维码一共有40个尺寸。官方叫版本Version。Version 1是21 x 21的矩阵，Version 2是 25 x 25的矩阵，Version 3是29的尺寸，每增加一个version，就会增加4的尺寸，公式是：(V-1)4 + 21（V是版本号） 最高Version 40，(40-1)4+21 = 177，所以最高是177 x 177 的正方形。
        
        // let version = ((outputImage.extent.size.width - 21) / 4.0 + 1)
        // print("version: \(version)")
        
        // 初始生成的图都比较小（23*23/35*35/47*47，推测二维码白边占1个点）
        // 2. 缩放处理
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        outputImage = outputImage.transformed(by: transform)
        
        // 3. 颜色滤镜
        if let colorFilter = CIFilter(name: "CIFalseColor") {
            colorFilter.setDefaults()
            colorFilter.setValue(outputImage, forKey: "inputImage")
            
            // 前景色
            colorFilter.setValue(CIColor(color: UIColor.black), forKey: "inputColor0")
            // 背景色
            colorFilter.setValue(CIColor(color: UIColor.white), forKey: "inputColor1")
            
            if let ciImage = colorFilter.outputImage {
                outputImage = ciImage
            }
        }
        
        var image = UIImage(ciImage: outputImage)
        
        if let logo = logoImage {
            image = insertIconImage(qrimage: image, logo: logo)
        }
        
        return image
    }
    
    /// 在二维码图片中心画 logo
    ///
    /// - Parameters:
    ///   - qrimage: 二维码原图
    ///   - logo: logo 图，宽度是二维码的20%
    /// - Returns: 带 logo 的图，如果绘制失败，则返回二维码原图
    private static func insertIconImage(qrimage: UIImage, logo: UIImage) -> UIImage {
        
        UIGraphicsBeginImageContext(qrimage.size)
        
        let rect = CGRect(origin: .zero, size: qrimage.size)
        qrimage.draw(in: rect)
        
        let w = rect.width * 0.2
        let x = (rect.width - w) * 0.5
        let y = (rect.height - w) * 0.5
        logo.draw(in: CGRect(x: x, y: y, width: w, height: w))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image ?? qrimage
    }
}
