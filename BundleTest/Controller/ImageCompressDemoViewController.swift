//
//  ImageCompressDemoViewController.swift
//  Swift-iOS-Demo
//
//  Created by jianli chen on 2018/5/30.
//  Copyright © 2018年 jianli chen. All rights reserved.
//

import UIKit
import Accelerate
import Kingfisher
import Dispatch

extension UIImageView {
    func setProfileImage(with url: URL, _ optionsInfo: KingfisherOptionsInfo?) {
       // Image will always cached as PNG format to preserve alpha channel for round rect.
       _ = kf.setImage(with: url, options: optionsInfo)
    }
}

class ImageCompressDemoViewController: UIViewController {

    private var _tempFlag: Int = 0
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var compressButton: UIButton!
    @IBOutlet weak var slider1: UISlider!
    @IBOutlet weak var slider2: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        slider1.minimumValue = 0.0
        slider1.maximumValue = 10.0
        
        slider2.minimumValue = 0.0
        slider2.maximumValue = 1.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func onSlider1ValueChanged(_ sender: Any) {
        if let WX = UIImage(named: "WX") {
            let blurredImage = WX.kf.blurred(withRadius: CGFloat(slider1.value))
            imageView.image = blurredImage.kf.overlaying(with: UIColor.black, fraction: CGFloat(slider2.value))
        }
    }
    
    @IBAction func onSlider2ValueChanged(_ sender: Any) {
        if let WX = UIImage(named: "WX") {
            let blurredImage = WX.kf.blurred(withRadius: CGFloat(slider1.value))
            imageView.image = blurredImage.kf.overlaying(with: UIColor.black, fraction: CGFloat(slider2.value))
        }
    }
    
    @IBAction func onCompressBtnTapped(_ sender: Any) {
        
//        let profileImageSize = CGSize(width: 44, height: 44)
//        let imageProcessor = RoundCornerImageProcessor(cornerRadius: profileImageSize.width / 2, targetSize: profileImageSize)
//        let optionsInfo: KingfisherOptionsInfo = [.cacheSerializer(FormatIndicatedCacheSerializer.png), .backgroundDecode, .scaleFactor(UIScreen.main.scale)]
        
//        let url = URL(string: "http://h.hiphotos.baidu.com/image/pic/item/342ac65c103853434cc02dda9f13b07eca80883a.jpg")!
//        imageView.setProfileImage(with: url, optionsInfo)
        
//        imageView.kf.setImage(with: url, placeholder: nil, options: []) { (image, error, cacheType, url) in
//            print("\(image) || \(error) || \(cacheType) || \(url)")
//        }
        
//        if let WX = UIImage(named: "WX") {
//            let crop = min(WX.size.width, WX.size.height)
//            let size = CGSize(width: crop, height: crop)
//            let resizeWX = WX.kf.crop(to: size, anchorOn: CGPoint(x: 0.5, y: 0.5))
//            let cropedSize: CGFloat = 80.0
//            let resizedImage = resizeWX.kf.image(withRoundRadius: cropedSize / 2, fit: CGSize(width: cropedSize, height: cropedSize), roundingCorners: .all, backgroundColor: UIColor.black)
//            imageView.image =
//            let blurredImage = WX.kf.blurred(withRadius: 3.5)
//            imageView.image = blurredImage.kf.overlaying(with: UIColor.black, fraction: 0.8)
//            imageView.image = WX.kf.scaled(to: 2.0)
//        }
        
//        if let path = Bundle.main.path(forResource: "IMG_0169", ofType: "JPG"), let image = UIImage(contentsOfFile: path) {
////        if let path = Bundle.main.path(forResource: "6fb8efb7gy1fqcj2kaowij23v92ky7wn", ofType: "jpg"), let image = UIImage(contentsOfFile: path) {
//            //
//
////            let fileManager = FileManager.default
//
//            print("original image memory size is \(image.memerySize) | \(path.fileSize())")
//
//            guard image.size.width != 0 && image.size.height != 0 else { return }
//
////            let maxWidth: CGFloat = 3000
////            let newSize = CGSize(width: maxWidth, height: maxWidth * image.size.height / image.size.width)
////            print("original image newSize is \(newSize)")
////            guard let newImage = UIImage.resizeImage(image: image, newSize: newSize) else { return }
////            print("newImage image memory size is \(newImage.memerySize)")
////            guard let imageData = UIImageJPEGRepresentation(newImage, 0.25) else { return }
////            print("\(CGFloat(imageData.count) / CGFloat(1024.0) / CGFloat(1024.0))")
//
////            let compressedImage = UIImage(data: imageData)! // UIImage.compressImage(image, toByte: 2 * 1024 * 1024)
////            print("compressedImage image memory size is \(compressedImage.memerySize)")
//
//            let ratio = image.size.width / image.size.height
//            let width: CGFloat = 375.0 * UIScreen.main.scale
//            let height = width / ratio
//            if _tempFlag % 2 == 0 {
//                guard let thumbnail = UIImage.thumbnailImage(image: image, size: CGSize(width: width, height: height)) else { return }
//                let data1 = UIImage.compress2Data(thumbnail, limitBytes: 2 * 1024 * 1024)
//                try? data1.write(to: URL(fileURLWithPath: "/Users/chenjianli/Desktop/2.JPG"))
//            } else {
//                autoreleasepool { () -> Void in
//                    guard let data = UIImage.compress(image, limitBytes: 2 * 1024 * 1024, maxSize: CGSize(width: width, height: width / ratio)) else { return }
//                    try? data.write(to: URL(fileURLWithPath: "/Users/chenjianli/Desktop/1.JPG"))
//                }
//            }
//            _tempFlag += 1
//
//
//
//
////            if let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first {
////
////                let diskCachePath = cachePath + "/compress"
////                if !fileManager.fileExists(atPath: diskCachePath) {
////                    do {
////                        try fileManager.createDirectory(atPath: diskCachePath, withIntermediateDirectories: true, attributes: nil)
////                    } catch _ {}
////                }
////
////                let filePath = diskCachePath + "/1.jpg"
////                try? data.write(to: URL(fileURLWithPath: filePath))
//////                fileManager.createFile(atPath: filePath, contents: UIImageJPEGRepresentation(compressedImage, 1.0), attributes: nil)
////            }
//        }
        
//        semaphoreTest()
        
//        for _ in 0 ..< 3 {
//            let queue1 = DispatchQueue.global(qos: .background)
//            queue1.async { [unowned self] in
//                self.threadSafe(self.count)
//            }
//            queue1.async { [unowned self] in
//                self.threadSafe(self.count)
//            }
//
//            let queue2 = DispatchQueue.global(qos: .utility)
//            queue2.async { [unowned self] in
//                self.threadSafe(self.count)
//            }
//            queue2.async { [unowned self] in
//                self.threadSafe(self.count)
//            }
//
//            let queue3 = DispatchQueue.global(qos: .default)
//            queue3.async { [unowned self] in
//                self.threadSafe(self.count)
//            }
//            queue3.async { [unowned self] in
//                self.threadSafe(self.count)
//            }
//        }
//        print("1111\(Date())")
//        perform(#selector(test), with: self, afterDelay: 3, inModes: [RunLoopMode.defaultRunLoopMode])
        
//        print("start")
//        DispatchQueue.main.safeSync {
//            print("I am execute. \(Thread.current)")
//            Thread.sleep(forTimeInterval: 3)
//        }
//        print("end")
    }
    
    @objc fileprivate func test() {
        print("2222\(Date())")
    }
    
    func executeTask(_ taskTime: TimeInterval, result: @escaping () -> Void) {
        DispatchQueue.global().async {
            Thread.sleep(forTimeInterval: taskTime)
            result()
        }
    }
    
    func semaphoreTest() {
        let semaphore = DispatchSemaphore(value: 0)
        
        executeTask(5) {
            print("execute task complete")
            semaphore.signal()
            print("end")
        }
        
        let waitResult = semaphore.wait(timeout: DispatchTime(secondsFromNow: 2))
        switch waitResult {
        case .success:
            print("success")
        case .timedOut:
            print("timedOut")
        }
        print("continue \(semaphore)")
    }
    
    var count: Int = 0
    
    func threadSafe(_ obj: Any) {
        
//        synchronized(obj) {
//            count += 1
//            print("\(count) >> \(Thread.current)")
//            Thread.sleep(forTimeInterval: 2)
//        }
        
        exeInMultipleThreadSafety { [weak self] in
            guard let wSelf = self else { return }
            wSelf.count += 1
            print("\(wSelf.count) >> \(Thread.current)")
            Thread.sleep(forTimeInterval: 2)
        }
        
    }
}
