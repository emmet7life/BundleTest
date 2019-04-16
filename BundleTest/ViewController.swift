//
//  ViewController.swift
//  BundleTest
//
//  Created by jianli chen on 2018/9/26.
//  Copyright © 2018年 jianli chen. All rights reserved.
//

import UIKit
import Lottie
import YYCategories

class ViewController: UIViewController {
    
    private let _playBtn = UIButton()
    private let _playBtn2 = UIButton()
    private let _imageView = UIImageView()
    
    private(set) lazy var unfollowLottieView: LOTAnimationView = {
        if let bundlePath = Bundle.main.path(forResource: "unlike", ofType: "bundle"), let bundle = Bundle(path: bundlePath) {
            // Success
            print("1 \(bundlePath)")
            if let dataPath = bundle.path(forResource: "data", ofType: "json") {
                let dataURL = URL(fileURLWithPath: dataPath)
                if let data = try? Data(contentsOf: dataURL) {
                    if let dataJson = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyHashable] {
                        return LOTAnimationView(json: dataJson, bundle: bundle)
                    }
                }
            }
        }
        // Error
        return LOTAnimationView(name: "")
    }()
    
    private(set) lazy var followLottieView: LOTAnimationView = {
        if let bundlePath = Bundle.main.path(forResource: "like", ofType: "bundle"), let bundle = Bundle(path: bundlePath) {
            // Success
            print("2 \(bundlePath)")
            if let dataPath = bundle.path(forResource: "data", ofType: "json") {
                let dataURL = URL(fileURLWithPath: dataPath)
                if let data = try? Data(contentsOf: dataURL) {
                    if let dataJson = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyHashable] {
                        return LOTAnimationView(json: dataJson, bundle: bundle)
                    }
                }
            }
        }
        // Error
        return LOTAnimationView(name: "")
    }()
    
//    private(set) lazy var advanceLookLottieView: LOTAnimationView = {
//        if let bundlePath = Bundle.main.path(forResource: "advance_look_jump_init", ofType: "bundle"), let bundle = Bundle(path: bundlePath) {
//            // Success
//            print("2 \(bundlePath)")
//            if let dataPath = bundle.path(forResource: "data", ofType: "json") {
//                let dataURL = URL(fileURLWithPath: dataPath)
//                if let data = try? Data(contentsOf: dataURL) {
//                    if let dataJson = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyHashable] {
//                        return LOTAnimationView(json: dataJson, bundle: bundle)
//                    }
//                }
//            }
//        }
//        // Error
//        return LOTAnimationView(name: "")
//    }()
    
    private let followButton = VCFollowButton(style: .darkRed)
    private let advanceLookButton = VCAdvanceLookButton(frame: CGRect.zero)
    
    @IBOutlet weak var waveLineLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var waveLineTrailingConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        _imageView.frame = CGRect(x: 100, y: 20, width: 180, height: 72)
        _imageView.contentMode = .center
        view.addSubview(_imageView)
        
//        if let bundlePath = Bundle.main.path(forResource: "unfollow", ofType: "bundle"), let bundle = Bundle(path: bundlePath) {
//            if let dataPath = bundle.path(forResource: "img_0", ofType: "png") {
//                _imageView.image = UIImage(contentsOfFile: dataPath)
//            }
//        }
        
//        let wh: CGFloat = 68.0
//        let offset: CGFloat = 1.5
        if let unlikeImageView = view.viewWithTag(1002) {
//            unfollowLottieView.size = CGSize(width: wh, height: wh)
//            unfollowLottieView.bottom = unlikeImageView.bottom + offset
//            unfollowLottieView.centerX = unlikeImageView.centerX + 1.0
//            unfollowLottieView.contentMode = .scaleAspectFill
            view.addSubview(unfollowLottieView)
        }
        
        if let likeImageView = view.viewWithTag(1001) {
//            followLottieView.size = CGSize(width: wh, height: wh)
//            followLottieView.bottom = likeImageView.bottom + offset
//            followLottieView.centerX = likeImageView.centerX + 1.0
//            followLottieView.contentMode = .scaleAspectFill
            view.addSubview(followLottieView)
        }
        
        _playBtn.backgroundColor = .green
        _playBtn.frame = CGRect(x: 100, y: 200, width: 180, height: 44)
        _playBtn.addTarget(self, action: #selector(onPlayBtnTapped), for: .touchUpInside)
        view.addSubview(_playBtn)
        
        _playBtn2.backgroundColor = .blue
        _playBtn2.frame = CGRect(x: 100, y: 360, width: 180, height: 44)
        _playBtn2.addTarget(self, action: #selector(onPlayBtn2Tapped), for: .touchUpInside)
        view.addSubview(_playBtn2)
        
        followLottieView.animationProgress = 1
        unfollowLottieView.animationProgress = 1
        
//        let followButton = VCFollowButton(style: .darkRed)
//        let frame = CGRect(x: 0, y: 107, width: 60, height: 24)
//        followButton.frame = frame
//        followButton.isScaleDownEffectEnable = true
//        view.addSubview(followButton)
        
//        advanceLookButton.frame = CGRect(x: 10, y: 140, width: 66, height: 33)
//        view.addSubview(advanceLookButton)
        
//        let decimalHandler = NSDecimalNumberHandler(roundingMode: NSDecimalNumber.RoundingMode.down, scale: 1, raiseOnExactness: false,
//                                                    raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)
//        let ouncesDecimal = NSDecimalNumber(value: 21.11)
//        let roundedOunces = ouncesDecimal.rounding(accordingToBehavior: decimalHandler)
//        print(NSString(format: "%@", roundedOunces))
    }
    
    @IBAction @objc func onPlayBtnTapped(_ sender: Any) {
//        followButton.startLoading(false, animated: true, isJudgeAnimating: true)
//        advanceLookButton.start(animated: true, isJudgeAnimating: true)
        
        unfollowLottieView.play { [weak self] (isFinished) in
            self?.unfollowLottieView.animationProgress = 1.0
        }
        
        //        unfollowLottieView.animationProgress = 1
        //        _updatePraiseImage(with: _flag, true)
        //        _flag = !_flag
    }
    
    @IBAction func onStopBtnTapped(_ sender: Any) {
//        followButton.stopLoadingWithSuccess()
//        advanceLookButton.stop()
    }
    
    @IBAction func onSliderValueChanged(_ sender: Any) {
//        if let slider = sender as? UISlider {
//            followButton.unfollowLottieView.animationProgress = CGFloat(slider.value)
//            advanceLookButton.neonLightLottieView.animationProgress = CGFloat(slider.value)
//        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let wh: CGFloat = 64.5
        let offset: CGFloat = -2.5
        if let unlikeImageView = view.viewWithTag(1002) {
            unfollowLottieView.size = CGSize(width: wh, height: wh)
            unfollowLottieView.bottom = unlikeImageView.bottom + offset
            unfollowLottieView.centerX = unlikeImageView.centerX + 0.5
        }
        
        if let likeImageView = view.viewWithTag(1001) {
            followLottieView.size = CGSize(width: wh, height: wh)
            followLottieView.bottom = likeImageView.bottom + offset
            followLottieView.centerX = likeImageView.centerX + 0.5
        }
        
        let padding = CGFloat(adjustPadding(with: Float(view.width)))
        if waveLineLeadingConstraint.constant != padding {
            waveLineLeadingConstraint.constant = padding
            waveLineTrailingConstraint.constant = padding
        }
    }

//    @objc fileprivate func onPlayBtnTapped() {
//
//    }

    @objc fileprivate func onPlayBtn2Tapped() {
        followLottieView.play { [weak self] (isFinished) in
            self?.followLottieView.animationProgress = 1.0
        }
//        followLottieView.animationProgress = 1
//        _updatePraiseImage(with: _flag, true)
//        _flag = !_flag
        
//        let controller = VCPostAlterViewController.controller(sourceCount: 9, parentVc: self)
//        present(controller, animated: true, completion: nil)
    }
    
    private var _flag = false
    private var _isAnimatingToInvisible = false
    private var _isAnimatingToVisible = false
    
    private func _updatePraiseImage(with isLike: Bool, _ animated: Bool = false) {
        let zanView = view.viewWithTag(1002)!
        if isLike {
            guard animated else {
                if !_isAnimatingToVisible {
                    zanView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                }
                return
            }
            guard !_isAnimatingToVisible else { return }
            _isAnimatingToVisible = true
            zanView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            UIView.animate(withDuration: 0.36,
                           delay: 0.0,
                           options: .beginFromCurrentState,
                           animations: {
                            zanView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            }, completion: nil)
            
            UIView.animate(withDuration: 0.36,
                           delay: 0.30,
                           options: .beginFromCurrentState,
                           animations: {
                            zanView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }, completion: { [weak self] (_) in
                self?._isAnimatingToVisible = false
            })
        } else {
            guard animated else {
                if !_isAnimatingToInvisible {
                    zanView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
                }
                return
            }
            guard !_isAnimatingToInvisible else { return }
            _isAnimatingToInvisible = true
            zanView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            UIView.animate(withDuration: 0.36,
                           delay: 0.0,
                           options: .beginFromCurrentState,
                           animations: {
                            zanView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            }, completion: { [weak self] (_) in
                self?._isAnimatingToInvisible = false
            })
        }
    }

    func adjustPadding(with width: Float, padding: Float = 8.0) -> Float {
        
        func _format(value: Float) -> Float {
            let decimalHandler = NSDecimalNumberHandler(roundingMode: NSDecimalNumber.RoundingMode.down, scale: 1, raiseOnExactness: false,
                                                        raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)
            let ouncesDecimal = NSDecimalNumber(value: value)
            let roundedOunces = ouncesDecimal.rounding(accordingToBehavior: decimalHandler)
            return roundedOunces.floatValue
        }
        
        func _count(padding: Float) -> Float {
            return (width - (padding * 2) - 2) / 16
        }
        
        var _padding: Float = padding
        for index in 0 ..< 10 {
            let count = _count(padding: _padding)
            let format = _format(value: count)
            if ceilf(format) == floor(format) {
                print("format[\(index)] is \(format), break")
                break
            }
            print("format[\(index)] is \(format)")
            _padding += 0.5
        }
        
        return _padding
    }
}

