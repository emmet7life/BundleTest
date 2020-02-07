//
//  ViewController4.swift
//  BundleTest
//
//  Created by jianli chen on 2019/4/23.
//  Copyright © 2019 jianli chen. All rights reserved.
//

import UIKit
import Lottie
import Kingfisher

class ViewController4: UIViewController {
    
    enum VCFeedLOTType: Int {
        case feed1 = 1
        case feed2 = 2
        case feed3 = 3
        case feed4 = 4
        case feed5 = 5
        case feedX = 6
        
        var lotViewSize: CGSize {
            switch self {
            case .feed1: return CGSize(width: 168, height: 168)
            case .feed2: return CGSize(width: 375, height: 168)
            case .feed3: return CGSize(width: 375, height: 168)
            case .feed4: return CGSize(width: 375, height: 168)
            case .feed5: return CGSize(width: 375, height: 168)
            case .feedX: return CGSize(width: 375, height: 375)
            }
        }
        
        var jsonName: String {
            return "data_\(rawValue)"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let label = UILabel()
//        label.numberOfLines = 0
//        label.contentMode = .center
//        label.textAlignment = .center
////        label.frame = view.bounds
////        view.addSubview(label)
//
//        let attributes1 = [
//            NSAttributedString.Key.foregroundColor: UIColor.colorWithHexRGBA(0x999999),
//            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12.0)
//        ]
//
//        let attributes2 = [
//            NSAttributedString.Key.foregroundColor: UIColor.colorWithHexRGBA(0xF75D79),
//            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12.0)
//        ]
//
//        let bigText = """
//                投喂值投喂值投喂值投喂值投喂值投喂值投喂值投喂值投喂值投喂值
//                投喂值投喂值投喂值投喂值投喂值投喂值投喂值投喂值投喂值投喂值
//                投喂值投喂值投喂值投喂值投喂值投喂值投喂值投喂值投喂值投喂值
//                投喂值投喂值投喂值投喂值投喂值投喂值投喂值投喂值投喂值投喂值
//                投喂值投喂值投喂值投喂值投喂值投喂值投喂值投喂值投喂值投喂值
//                投喂值投喂值投喂值投喂值投喂值投喂值投喂值投喂值投喂值投喂值
//                投喂值投喂值投喂值投喂值投喂值投喂值投喂值投喂值投喂值投喂值
//                投喂值投喂值投喂值投喂值投喂值投喂值投喂值投喂值投喂值投喂值
//                投喂值投喂值投喂值投喂值投喂值投喂值投喂值投喂值投喂值投喂值
//                投喂值投喂值投喂值投喂值投喂值投喂值投喂值投喂值投喂值投喂值
//                投喂值投喂值投喂值投喂值投喂值投喂值投喂值投喂值投喂值投喂值
//                投喂值投喂值投喂值投喂值投喂值投喂值投喂值投喂值投喂值投喂值
//                投喂值投喂值投喂值投喂值投喂值投喂值投喂值投喂值投喂值投喂值
//                投喂值投喂值投喂值投喂值投喂值投喂值投喂值投喂值投喂值投喂值
//                投喂值投喂值投喂值投喂值投喂值投喂值投喂值投喂值投喂值投喂值
//                投喂值投喂值投喂值投喂值投喂值投喂值投喂值投喂值投喂值投喂值
//                投喂值投喂值投喂值投喂值投喂值投喂值投喂值投喂值投喂值投喂值
//                投喂值投喂值投喂值投喂值投喂值投喂值投喂值投喂值投喂值投喂值
//                投喂值投喂值投喂值投喂值投喂值投喂值投喂值投喂值投喂值投喂值
//                投喂值投喂值投喂值投喂值投喂值投喂值投喂值投喂值投喂值投喂值
//        """
//
//        let lastComicFeedValue: String? = "99999999"
//        let feedValue1 = "129021"
//        let feedValue1Text = "+\(feedValue1)"
//        var text = bigText + feedValue1Text
//        let attr = NSMutableAttributedString(string: text, attributes: attributes1)
//        attr.addAttributes(attributes2, range: (text as NSString).range(of: feedValue1Text))
//        if let feedValue2 = lastComicFeedValue {
//            let feedValue2Text = feedValue2.numberFormat(float: 2, append: "") + "投喂值"
//            let appendText = "\n还差"+feedValue2Text+"，超越上一名"
//            text += appendText
//            attr.append(NSAttributedString(string: appendText, attributes: attributes1))
//            attr.addAttributes(attributes2, range: (text as NSString).range(of: feedValue2Text))
//        }
//        label.attributedText = attr
//
//        let size = label.sizeThatFits(CGSize(width: 200, height: CGFloat.greatestFiniteMagnitude))
//
//        let scrollView = UIScrollView()
//        if size.height < 300 {
//            scrollView.size = size
//        } else {
//            scrollView.size = CGSize(width: size.width, height: 300)
//        }
//        scrollView.backgroundColor = .gray
//        scrollView.center = view.center
//
//        scrollView.addSubview(label)
////        label.snp.makeConstraints { (make) in
////            make.edges.equalToSuperview()
////        }
//        label.size = size
//        scrollView.contentSize = size
//
//        view.addSubview(scrollView)
    }
    
    var feedCount: Int = 0

    @IBAction func onPopTapped(_ sender: Any) {
//        let url = "https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=1258383479,2031990900&fm=200&gp=0.jpg"
//        let modOf6 = feedCount % 6 + 1
//        if let type = VCFeedLOTType(rawValue: modOf6)  {
//            showFeedLOT(with: url, lotType: type)
//        }
//        feedCount += 1
//
//        let modOf8 = feedCount % 8
//        let quotientOf8 = feedCount / 8
//        let count = CGFloat(quotientOf8 + (modOf8 != 0 ? 1 : 0))
//        print(count)
        
//        for _ in 0...100 {
//            let i = arc4random_uniform(8)
//            print(i)
//        }
    }
    
    fileprivate func showFeedLOT(with imageUrl: String, lotType: VCFeedLOTType) {
        guard let imageURL = URL(string: imageUrl) else { return }
        let filePath = KingfisherManager.shared.cache.cachePath(forKey: imageUrl)
        // if path exist ?
        if let index = filePath.lastIndex(of: "/") {
            let dirPath = String(filePath.prefix(upTo: filePath.index(after: index)))
            let fileName = String(filePath.suffix(from: filePath.index(after: index)))
            
            print("fileName \(fileName)")
            print("dirPath \(dirPath)")
            
            KingfisherManager.shared.retrieveImage(with: imageURL, options: nil, progressBlock: nil)
            { [weak self] (image, error, cacheType, url) in
                guard let strongSelf = self else { return }
                if let bundle = Bundle(path: dirPath) {
                    let lotView = strongSelf.createLOTAnimationView(with: bundle, jsonName:  lotType.jsonName, imageName: fileName)
                    lotView.size = lotType.lotViewSize
                    lotView.center = strongSelf.view.center
                    strongSelf.view.addSubview(lotView)
                    lotView.play(completion: { isFinished in
                        lotView.removeFromSuperview()
                    })
                }
            }
        }
    }
    
    fileprivate func createLOTAnimationView(with imageBundle: Bundle, jsonName: String, imageName: String) -> LOTAnimationView {
        if let bundlePath = Bundle.main.path(forResource: "feed", ofType: "bundle"), let bundle = Bundle(path: bundlePath) {
            // Success
            if let dataPath = bundle.path(forResource: jsonName, ofType: "json") {
                let dataURL = URL(fileURLWithPath: dataPath)
                if var data = try? Data(contentsOf: dataURL) {
                    if var string = String(data: data, encoding: String.Encoding.utf8) {
//                        print("1️⃣ \(string)")
                        string = string.replacingOccurrences(of: "img_0.png", with: imageName)
//                        print("2️⃣ \(string)")
                        if let convertToData = string.data(using: String.Encoding.utf8) {
                            data = convertToData
                        }
                    }
                    let dataJson = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
                    if let dataDict = dataJson as? [String: AnyHashable] {
                        return LOTAnimationView(json: dataDict, bundle: imageBundle)
                    }
                }
            }
        }
        // Error
        return LOTAnimationView(name: "")
    }
}
