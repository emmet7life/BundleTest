//
//  UIImage+Extension.swift
//  BundleTest
//
//  Created by jianli chen on 2019/6/25.
//  Copyright © 2019 jianli chen. All rights reserved.
//

import Foundation

extension UIImage {
    
    // 专门为导航栏shadowImage配置的便捷方法，导航栏shadowImage要求为0.5个像素
    class func shadowImageFromColor(_ color: UIColor) -> UIImage {
        return imageFromColor(color, size: CGSize(width: 1, height: 0.5))
    }
    
    /// 生成一张纯色图片
    ///
    /// - Parameters:
    ///   - color: 图片颜色
    ///   - size: 图片大小，默认1*1
    /// - Returns: 图像
    class func imageFromColor(_ color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        UIGraphicsBeginImageContext(size);
        let context = UIGraphicsGetCurrentContext();
        context!.setFillColor(color.cgColor);
        context!.fill(CGRect(origin: CGPoint(x: 0, y: 0), size: size));
        let img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return img!;
    }
    
    /**
     生成一个纯色图片
     :param: color 图片的颜色
     */
    
    class func imageWithColor(_ color: UIColor, rect: CGRect = CGRect(x: 0, y: 0, width: 1, height: 1)) -> UIImage {//生成一个纯色图片
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? placeholderWhiteImage()
    }
    
    func redrawWithColor(_ color: UIColor, callBack: @escaping (_ image: UIImage?) ->()){//改变图片的着色值
        let size = self.size
        let spareTire = self
        DispatchQueue.global().async {
            UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
            color.setFill()
            let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            UIRectFill(rect)
            self.draw(in: rect, blendMode: .destinationIn, alpha: 1.0)
            
            UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            //回到主线程刷新UI
            DispatchQueue.main.async(execute: {
                if self.size.width != 0 {
                    callBack(self)
                } else {
                    __devlog("newImage: -- \(self) -- \(spareTire)")
                    callBack(spareTire.redrawWithTintColor(color))
                }
                
            })
        }
    }
    
    /// 用指定的颜色改变图片的着色值 needNewObj 是否需要另外创建 image 对象
    @discardableResult
    func redrawWithTintColor(_ color: UIColor, needNewObj: Bool = true) -> UIImage?{//改变图片的着色值
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        color.setFill()
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIRectFill(rect)
        draw(in: rect, blendMode: .destinationIn, alpha: 1.0)
        
        if needNewObj {
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return newImage
        } else {
            UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return self
        }
    }
    
    /**
     view生成一张图片
     */
    class func imageFromView(_ view: UIView)-> UIImage {
        UIGraphicsBeginImageContext(view.bounds.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? placeholderWhiteImage()
    }
    
    func createImage(cornerRadius: CGFloat = 0,
                     size: CGSize = CGSize.zero,
                     backgroundColor: UIColor = UIColor.clear,
                     inefficient: Bool = false, // 是否需要高效渲染(是否有锯齿,inefficient设置true会造成背景色不能为透明色，后期再查)
        callBack: @escaping (_ image: UIImage) ->()) {
        //在子线程中执行
        DispatchQueue.global().async {
            let rect = CGRect(origin: CGPoint.zero, size: size)
            //1. 开启上下文
            if inefficient {
                UIGraphicsBeginImageContextWithOptions(size, true, 0)
            } else {
                UIGraphicsBeginImageContext(size)
            }
            
            //2. 设置颜色
            backgroundColor.setFill()
            //3. 颜色填充
            UIRectFill(rect)
            //4. 图像绘制
            //切圆角
            let path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
            
            path.addClip()
            self.draw(in: rect)
            //5. 获取图片
            let image = UIGraphicsGetImageFromCurrentImageContext()
            //6 关闭上下文
            UIGraphicsEndImageContext()
            //回到主线程刷新UI
            DispatchQueue.main.async(execute: {
                callBack(image ?? UIImage())
            })
        }
    }
    
    /// 按照图片中间拉伸
    func resizeByCenterPoint() -> UIImage {
        let imageCenterY = size.height / 2
        let imageCenterX = size.width / 2
        return resizableImage(withCapInsets: UIEdgeInsets(top: imageCenterY, left: imageCenterX, bottom: imageCenterY, right: imageCenterX), resizingMode: .stretch)
    }
    
    // 创建圆角图片，最大圆角为 16 ，因为图片就那么大
    class func createCornerBgImage(_ corner: CGFloat = 4, drawColor: UIColor) -> UIImage {
        
        let initall = UIImage(named: "bg_corner_16")!
        // 正方形图片
        let squareImage = UIImage.imageWithColor(drawColor, rect: CGRect(origin: .zero, size: CGSize(width: corner * 2, height: corner * 2)))
        // 把正方形图片裁剪为圆形图片
        let circelImage = squareImage.circelImage()?.resizeByCenterPoint()
        return circelImage ?? initall
    }
    
    // 创建圆形图片 ps: 为了方便圆角图片不从设计那里要
    func circelImage() -> UIImage? {
        // 开始图形上下文，NO代表透明
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        // 获得图形上下文
        let ctx = UIGraphicsGetCurrentContext()
        // 设置一个范围
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        // 根据一个rect创建一个椭圆
        ctx?.addEllipse(in: rect)
        // 裁剪
        ctx?.clip()
        // 将原照片画到图形上下文
        draw(in: rect)
        // 从上下文上获取剪裁后的照片
        let newImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        // 关闭上下文
        UIGraphicsEndImageContext()
        return newImage
    }
    
    /**
     多张图片根据各自的frame混合成一张   必须确保images[0].size为最大
     */
    class func blendImages(_ images: [UIImage], withRects rects: [CGRect]) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(images[0].size, false, UIScreen.main.scale)
        
        for index in 0..<images.count {
            if index < rects.count {
                images[index].draw(in: rects[index])
            }
        }
        
        let resultingImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resultingImage!
    }
    
    // 如果上下文图片创建为空可以用这个白色图片站位，不至于崩溃
    static func placeholderWhiteImage() -> UIImage {
        return UIImage(named: "placeholder_white")!.resizeByCenterPoint()
    }
}
