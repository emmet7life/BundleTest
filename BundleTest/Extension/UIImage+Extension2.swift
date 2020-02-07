//
//  UIImage+Extension.swift
//  Swift-iOS-Demo
//
//  Created by jianli chen on 2018/5/30.
//  Copyright © 2018年 jianli chen. All rights reserved.
//

import UIKit
import Accelerate

let kLimitMinImageWidth: CGFloat = 375
let kLimitMinImageHeight: CGFloat = 375
let kLimitMaxImageWidth: CGFloat = 3000
let kLimitMaxImageHeight: CGFloat = 9000

extension UIImage {
    
//    var hasAlphaChannel: Bool {
//        guard let cgImage = self.cgImage else { return false }
//        let alphaInfo = cgImage.alphaInfo
//        return !(alphaInfo == .none || alphaInfo == .noneSkipLast || alphaInfo == .noneSkipFirst)
//    }
    
    // 图片占用的内存大小，单位byte
    var memerySize: Int {
        guard let cgImage = self.cgImage else { return 0 }
        return cgImage.height * cgImage.bytesPerRow
    }
    
    static func resizeImage(image: UIImage, newSize: CGSize) -> UIImage? {
        UIGraphicsBeginImageContext(newSize)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    static func thumbnailImage(image: UIImage, size: CGSize) -> UIImage? {
        let compressSize = UIImage.compressedSize(with: image.size, maxSize: size)
        let data = compress2Data(image, limitBytes: 10 * 1024 * 1024)
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else { return nil }
        let options = [
            kCGImageSourceThumbnailMaxPixelSize: max(compressSize.width, compressSize.height),
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceCreateThumbnailFromImageAlways: true
        ] as CFDictionary
        let imageReference = CGImageSourceCreateThumbnailAtIndex(source, 0, options)!
        let thumb = UIImage(cgImage: imageReference)
        return thumb
    }
    
    // Compress
    static func compress2Data(_ comressImage: UIImage,
                              limitBytes maxBytesLength: Int) -> Data {
        var max: CGFloat = 1
        var min: CGFloat = 0
        var compression: CGFloat = 1
        var compressedData: Data! = nil
        for _ in 0 ..< 6 {
            compression = (max + min) / 2
            compressedData = comressImage.jpegData(compressionQuality: compression)!
            if CGFloat(compressedData.count) < CGFloat(maxBytesLength) * 0.9 {
                min = compression
            } else if compressedData.count > maxBytesLength {
                max = compression
            } else {
                break
            }
        }
        return compressedData
    }
    
    static func compress(_ image: UIImage,
                         limitBytes maxBytesLength: Int,
                         minSize: CGSize = CGSize(width: kLimitMinImageWidth, height: kLimitMinImageHeight),
                         maxSize: CGSize = CGSize(width: kLimitMaxImageWidth, height: kLimitMaxImageHeight)) -> Data? {
        let newSize = UIImage.compressedSize(with: image.size, minSize: minSize, maxSize: maxSize)
        guard newSize != image.size else {
            return image.compress2Data(with: maxBytesLength)
        }
        guard let newImage = image.resize(with: UIImage.ResizeMode.kCoreGraphics,
                                          limitBytes: maxBytesLength,
                                          minSize: minSize,
                                          maxSize: maxSize) else { return nil }
        return newImage.compress2Data(with: maxBytesLength)
    }
    
}

extension UIImage {
    
    // Compress Size
    static func compressedSize(with size: CGSize,
                               minSize: CGSize = CGSize(width: kLimitMinImageWidth, height: kLimitMinImageHeight),
                               maxSize: CGSize = CGSize(width: kLimitMaxImageWidth, height: kLimitMaxImageHeight)) -> CGSize {
        let radio = size.height / size.width
        var _w = min(size.width, maxSize.width)
        var _h = _w * radio
        _h = min(_h, maxSize.height)
        _w = _h / radio
        if _w < minSize.width || _h < minSize.height {
            let width = radio > 1.0 ? min(minSize.width, size.width) : min(minSize.height, size.height) / radio
            let height = width * radio
            return CGSize(width: width, height: height)
        }
        return CGSize(width: _w, height: _h)
    }
    
    // Compress Image
    func compress2Data(with maxBytesLength: Int) -> Data? {
        var max: CGFloat = 1
        var min: CGFloat = 0
        var compression: CGFloat = 1
        var compressedData: Data? = nil
        for _ in 0 ..< 6 {
            compression = (max + min) / 2
            if let _compressedData = self.jpegData(compressionQuality: compression) {
                compressedData = _compressedData
                
                if CGFloat(_compressedData.count) < CGFloat(maxBytesLength) * 0.9 {
                    min = compression
                } else if _compressedData.count > maxBytesLength {
                    max = compression
                } else {
                    break
                }
            } else {
                break
            }
        }
        return compressedData
    }
    
}

// 提前创建，单例共享
let sharedCIContextGPU = CIContext(options: [CIContextOption.useSoftwareRenderer: false]) // Use GPU
let sharedCIContextSoftware = CIContext(options: [CIContextOption.useSoftwareRenderer: true]) // Use CPU，涉及到CPU和GPU之间的数据交换操作，性能不佳

extension UIImage {
    
    // kCoreGraphics 性能最佳，消耗内存少，而且占用CPU也少，速度快
    // kCoreImage 有问题，无法使用
    // kUIKit、kImageIO 速度一般，压缩过程消耗内存且消耗CPU
    // kVImage 缩放一般不用该方式
    enum ResizeMode {
        case kUIKit             // "UIKit"
        case kCoreGraphics      // "Core Graphics"
        case kImageIO           // "Image IO"
        case kCoreImage(Bool)   // "Core Image GPU" or "Core Image Software", true -> GPU, false -> Software(CPU)
        case kVImage            // "Accelerate VImage"
    }
    
    func resize(with mode: ResizeMode,
                limitBytes maxBytesLength: Int,
                minSize: CGSize = CGSize(width: kLimitMinImageWidth, height: kLimitMinImageHeight),
                maxSize: CGSize = CGSize(width: kLimitMaxImageWidth, height: kLimitMaxImageHeight)) -> UIImage? {
        
        let compressedSize = UIImage.compressedSize(with: size, minSize: minSize, maxSize: maxSize)
        switch mode {
        case .kUIKit:
            let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
            UIGraphicsBeginImageContextWithOptions(compressedSize, !hasAlphaChannel(), scale)
            draw(in: CGRect(origin: .zero, size: compressedSize))
            let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return scaledImage
            
        case .kCoreGraphics:
            guard let cgImage = self.cgImage, let colorSpace = cgImage.colorSpace else { return nil }
            let width = Int(compressedSize.width)
            let height = Int(compressedSize.height)
            let bitsPerComponent = cgImage.bitsPerComponent
            let bytesPerRow = cgImage.bytesPerRow
            let bitmapInfo = cgImage.bitmapInfo
            guard let context = CGContext(data: nil,
                                          width: width,
                                          height: height,
                                          bitsPerComponent: bitsPerComponent,
                                          bytesPerRow: bytesPerRow,
                                          space: colorSpace,
                                          bitmapInfo: bitmapInfo.rawValue) else { return nil }
            context.interpolationQuality = .high
            context.draw(cgImage, in: CGRect(origin: .zero, size: CGSize(width: width, height: height)))
            guard let makedImage = context.makeImage() else { return nil }
            return UIImage(cgImage: makedImage)
            
        case .kImageIO:
            guard let data = compress2Data(with: maxBytesLength) else { return nil }
            guard let source = CGImageSourceCreateWithData(data as CFData, nil) else { return nil }
            let options = [
                kCGImageSourceThumbnailMaxPixelSize: max(compressedSize.width, compressedSize.height),
                kCGImageSourceCreateThumbnailWithTransform: true,
                kCGImageSourceCreateThumbnailFromImageAlways: true
                ] as CFDictionary
            let thumbImage = CGImageSourceCreateThumbnailAtIndex(source, 0, options).flatMap { (cgImage) -> UIImage? in
                return UIImage(cgImage: cgImage)
            }
            return thumbImage
            
        case .kCoreImage(let useGPU):
            guard let cgImage = self.cgImage else { return nil }
            guard let filter = CIFilter(name: "CILanczosScaleTransform") else { return nil }
            let inputScale = compressedSize.width / size.width
            filter.setValue(CIImage(cgImage: cgImage), forKey: kCIInputImageKey)
            filter.setValue(inputScale, forKey: kCIInputScaleKey)
            filter.setValue(1.0, forKey: kCIInputAspectRatioKey)
            guard let outputImage = filter.outputImage else { return nil }
            let extent = outputImage.extent
            guard let createdCGImage = (useGPU ? sharedCIContextGPU : sharedCIContextSoftware).createCGImage(outputImage, from: extent) else { return nil }
            return UIImage(cgImage: createdCGImage)
            
        case .kVImage:
            guard let cgImage = self.cgImage else { return nil }
            // create a source buffer
            var format = vImage_CGImageFormat(bitsPerComponent: 8,
                                              bitsPerPixel: 32, colorSpace: nil,
                                              bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.first.rawValue),
                                              version: 0,
                                              decode: nil,
                                              renderingIntent: CGColorRenderingIntent.defaultIntent)
            var sourceBuffer = vImage_Buffer()
            defer {
                sourceBuffer.data.deallocate()
            }
            var error = vImageBuffer_InitWithCGImage(&sourceBuffer, &format, nil, cgImage, numericCast(kvImageNoFlags))
            guard error == kvImageNoError else { return nil }
            
            // create a destination buffer
//            let scale = UIScreen.main.scale
//            let destWidth = Int(compressedSize.width * scale)
//            let destHeight = Int(compressedSize.height * scale)
            let destWidth = Int(compressedSize.width)
            let destHeight = Int(compressedSize.height)
            let bitsPerPixel = cgImage.bitsPerPixel / 8
            let bytesPerRow = destWidth * bitsPerPixel
            let data = UnsafeMutablePointer<UInt8>.allocate(capacity: destWidth * destHeight * bitsPerPixel)
            defer {
                data.deallocate()
            }
            var destBuffer = vImage_Buffer(data: data, height: vImagePixelCount(destHeight), width: vImagePixelCount(destWidth), rowBytes: bytesPerRow)
            
            // scale the image
            error = vImageScale_ARGB8888(&sourceBuffer, &destBuffer, nil, numericCast(kvImageHighQualityResampling))
            guard error == kvImageNoError else { return nil }
            
            // create a CGImage from vImage_Buffer
            guard let destCGImage = vImageCreateCGImageFromBuffer(&destBuffer, &format, nil, nil, numericCast(kvImageNoFlags), &error)?.takeRetainedValue() else { return nil }
            guard error == kvImageNoError else { return nil }
            
            // create a UIImage
            let scaledImage = UIImage.init(cgImage: destCGImage, scale: 0.0, orientation: imageOrientation)
            return scaledImage
        }
        
    }
    
}
