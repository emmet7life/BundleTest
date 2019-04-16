//
//  VCPostAlterViewController.swift
//  WeiboDongman
//
//  Created by 秦兴华 on 2018/5/11.
//  Copyright © 2018年 Gookee. All rights reserved.
//

import UIKit
import Lottie
import SnapKit

///发帖成功的回调
typealias VCUploadFinishCallback = (() -> ())

/// 弹框样式类型
///
/// - image: 上传图片
/// - voice: 上传语音
enum VCPostAlertType {
    case image, voice
    
    var uploadingText: String {
        switch self {
        case .image:
            return "图片正在上传中…"
        case .voice:
            return "语音正在上传中…"
        }
    }
    
    var uploadSucceedText: String {
        switch self {
        case .image:
            return "图片上传成功"
        case .voice:
            return "语音上传成功"
        }
    }
    
    var uploadFailedText: String {
        switch self {
        case .image:
            return "上传失败了..."
        case .voice:
            return "上传失败了..."
        }
    }
    
    var animateImagePrefix: String {
        switch self {
        case .image:
            return "img_"
        case .voice:
            return "voice_"
        }
    }
    
    var uploadErrorImage: UIImage {
        var img = ""
        switch self {
        case .image:
            img = "img_upload_error"
        case .voice:
            img = "voice_upload_error"
        }
        return UIImage(contentsOfFile: Bundle.main.path(forResource: img, ofType: "png")!) ?? UIImage()
    }
   
}

/// 发帖页 - 上传资源进度的弹框
class VCPostAlterViewController: UIViewController {
    
    // MARK: - View
    @IBOutlet weak var topContainerView: UIView!
    @IBOutlet weak var topImageView: UIImageView!
    @IBOutlet weak var closeAlertBtn: UIButton!
    @IBOutlet weak var tipLabel: UILabel!
    
    @IBOutlet weak var progressBarBgView: UIImageView!
    @IBOutlet weak var progressBarGrayProgressView: UIImageView!
    @IBOutlet weak var progressBarRedProgressView: UIImageView!
    
    @IBOutlet weak var cancelPostBtn: UIButton!
    @IBOutlet weak var continuePostBtn: UIButton!
    
    // Lottie View
    private lazy var uploadPicLottieView: LOTAnimationView! = {
        return self.createLottieAnimateView(with: "upload_pic")
    }()
    private lazy var uploadVoiceLottieView: LOTAnimationView! = {
        return self.createLottieAnimateView(with: "upload_voice")
    }()
    
    // MARK: - Constraint
    @IBOutlet weak var progressBarBgViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var progressBarGrayProgressViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var progressBarRedProgressViewWidthConstraint: NSLayoutConstraint!
    
    // MARK: - Data
    fileprivate var sourceCount = 0
    fileprivate var voiceCount = 0
    fileprivate var lastUploadInex = 0
    fileprivate var uploadType: VCPostAlertType = .voice
    fileprivate var canRetry = true// 判断对话框不终止发布之后,是否马上启动续传
    fileprivate var uploadCallback: VCUploadFinishCallback?// 每次上传图片播放完动画后的回调
    fileprivate let _presentTransition = VCAlertsControllerAnimatedTransition()// 动画transition
    
    fileprivate var parentVC: UIViewController?
    
    func createLottieAnimateView(with bundleName: String) -> LOTAnimationView? {
        if let bundle = Bundle.vc_customBundle(with: bundleName) {
            if let dataPath = bundle.path(forResource: "data", ofType: "json") {
                let dataURL = URL(fileURLWithPath: dataPath)
                if let data = try? Data(contentsOf: dataURL) {
                    if let dataJson = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyHashable] {
                        return LOTAnimationView(json: dataJson, bundle: bundle)
                    }
                }
            }
        }
        return nil
    }
    
    // 终止上传的确认对话框
//    fileprivate lazy var cancelPostAlter: VCAlertsViewController = {
//        let confirm = VCAlertBtnConfig(text: "确定", font: UIFont.systemLightFont(15), textColor: UIColor.colorFF4D6A)
//        let cancel = VCAlertBtnConfig(text: "取消", font: UIFont.systemLightFont(15), textColor: UIColor.subColor)
//        let alert = VCAlertsViewController.alert(buttonConfigs: [cancel,confirm], controlBlock: {[unowned self](button, index) in
//            self.cancelPostAlterAction(index!)
//        })
//        let title = NSAttributedString(string: "主人您确定要终止发布吗? QAQ", attributes: [
//            NSAttributedStringKey.font: UIFont.systemRegularFont(14),
//            NSAttributedStringKey.foregroundColor: UIColor.subColor
//            ])
//        alert.alertText = "主人您确定要终止发布吗? QAQ"
//        alert.attribtedText = title
//        return alert
//    }()
    
    // MARK: - Constructor
    static func controller(sourceCount: Int, parentVc: UIViewController?) -> VCPostAlterViewController {
        let vc = UIStoryboard(name: "Post", bundle: nil).instantiateViewController(withIdentifier: "postAlertVC") as! VCPostAlterViewController
        vc.modalPresentationStyle = .overFullScreen
        vc.transitioningDelegate = vc
        vc.sourceCount = sourceCount
        vc.parentVC = parentVc
        return vc
    }
    
    static func controller(uploadType: VCPostAlertType, sourceCount: Int, parentVc: UIViewController?) -> VCPostAlterViewController {
         let vc = UIStoryboard(name: "Post", bundle: nil).instantiateViewController(withIdentifier: "postAlertVC") as! VCPostAlterViewController
        vc.modalPresentationStyle = .overFullScreen
        vc.transitioningDelegate = vc
        vc.sourceCount = sourceCount
        vc.uploadType = uploadType
        vc.parentVC = parentVc
        return vc
    }
    
    // MARK: - Init & Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCorner(view, cornerRadius: 16.0)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.36)
        
        let size = CGSize(width: 295, height: 150)
        
        uploadPicLottieView.loopAnimation = true
        topContainerView.addSubview(uploadPicLottieView)
        uploadPicLottieView.snp.makeConstraints { (make) in
            make.centerX.bottom.equalToSuperview()
            make.size.equalTo(size)
        }
        
        uploadVoiceLottieView.loopAnimation = true
        topContainerView.addSubview(uploadVoiceLottieView)
        uploadVoiceLottieView.snp.makeConstraints { (make) in
            make.centerX.bottom.equalToSuperview()
            make.size.equalTo(size)
        }
        
        uploadPicLottieView.isHidden = true
        uploadVoiceLottieView.isHidden = true
        
        _resetViewToInitState()
    }
    
    /// 重置UI为初始状态
    fileprivate func _resetViewToInitState() {
        lastUploadInex = 0
        tipLabel.text = "\(uploadType.uploadingText)0/\(sourceCount)"
        
        switch uploadType {
        case .image:
            uploadVoiceLottieView.isHidden = true
            uploadPicLottieView.isHidden = false
            uploadVoiceLottieView.stop()
            uploadPicLottieView.play()
            
        case .voice:
            uploadVoiceLottieView.isHidden = false
            uploadPicLottieView.isHidden = true
            uploadVoiceLottieView.play()
            uploadPicLottieView.stop()
        }
        
        progressBarGrayProgressViewWidthConstraint.constant = 8.0
        progressBarRedProgressViewWidthConstraint.constant = 16.0
        
        // 进度条显示成红色的图
        _showRedProgressView()
        let progress: CGFloat = CGFloat(lastUploadInex) / CGFloat(sourceCount)
        let constant: CGFloat = min(170.0, max(16.0, 170.0 * progress))
        progressBarRedProgressViewWidthConstraint.constant = constant
        
        // 显示“取消发布/重新上传”
        _hiddenBtns(with: false)
    }
    
    
    @IBOutlet weak var slider: UISlider!
    
    @IBAction func onSliderValueChanged(_ sender: Any) {
        print("onSliderValueChanged \(slider.value) | \(Int(slider.value))")
        progressStart(Int(slider.value), callback: nil)
    }
    
    /// 更改上传类型样式
    ///
    /// - Parameters:
    ///   - type: 新样式
    ///   - sourceCount: 总数据条数
    func changeUpLoadType(_ type: VCPostAlertType, sourceCount: Int) {
        uploadType = type
        self.sourceCount = sourceCount
        _resetViewToInitState()
    }
    
    /// 上传前的动画，播放完以后执行 callback
    func startAnimateWithBlock(_ callback: @escaping ()->()) {
//        animateView.isHidden = false
//        animateProgressContainer.isHidden = true
//        starPreOrAferAnimate(isPre: true)
//        delay(Double(addAnimateData(isPre: true).count) * 0.1) {[weak self] in
//            guard let wSelf = self else { return }
//            wSelf.animateView.isHidden = true
//            wSelf.animateProgressContainer.isHidden = false
            callback()
//        }
    }
    
    /// 开始动画
    func progressStart(_ haveUploadCount: Int, isError: Bool?=false, callback: VCUploadFinishCallback?) {
        
        // 记录、保存
        lastUploadInex = haveUploadCount
        uploadCallback = callback
        
        // 异常、错误
        if let error = isError, error {
            uploadError()
            return
        }
        
        if haveUploadCount > sourceCount { return }
        
        // 进度条显示成红色的图
        _showRedProgressView()
        let progress: CGFloat = CGFloat(haveUploadCount) / CGFloat(sourceCount)
        let constant: CGFloat = min(170.0, max(16.0, 170.0 * progress))
        
        // 更改文本
        let uploadingProgressText = "\(haveUploadCount)/\(sourceCount)"
        let isAllUploaded = haveUploadCount == sourceCount
        self.tipLabel.text = isAllUploaded ? "\(uploadType.uploadSucceedText)\(uploadingProgressText)" : "\(uploadType.uploadingText)\(uploadingProgressText)"

        // 执行进度动画
        UIView.animate(withDuration: 0.5, animations: {[unowned self] in
            self.progressBarRedProgressViewWidthConstraint.constant = constant
            self.view.layoutIfNeeded()
        }) { (_) in
            if isAllUploaded {
//                delay(1.0, callFunc: {
                    self.uploadCallback?()
//                })
            } else {
                self.uploadCallback?()
            }
        }
    }
    
    // 显示红色进度条
    fileprivate func _showRedProgressView() {
        if progressBarRedProgressView.isHidden {
            progressBarRedProgressView.isHidden = false
        }
        if !progressBarGrayProgressView.isHidden {
            progressBarGrayProgressView.isHidden = true
        }
    }
    
    // 显示灰色进度条
    fileprivate func _showGrayProgressView() {
        if !progressBarRedProgressView.isHidden {
            progressBarRedProgressView.isHidden = true
        }
        if progressBarGrayProgressView.isHidden {
            progressBarGrayProgressView.isHidden = false
        }
    }
    
    // 上传过程发生错误
    fileprivate func uploadError() {
        
        // 停掉Lottie动画并隐藏
        uploadVoiceLottieView.stop()
        uploadPicLottieView.stop()
        uploadVoiceLottieView.isHidden = true
        uploadPicLottieView.isHidden = true
        
        // 显示错误女孩图
        topImageView.isHidden = false
        switch uploadType {
        case .image:
            topImageView.image = UIImage(named: "ic_post_pic_error")
        case .voice:
            topImageView.image = UIImage(named: "ic_post_voice_error")
        }
        
        // 进度条显示成灰色的图
        _showGrayProgressView()
        let progress: CGFloat = CGFloat(lastUploadInex) / CGFloat(sourceCount)
        let constant: CGFloat = min(160.0, max(8.0, 160.0 * progress))
        progressBarGrayProgressViewWidthConstraint.constant = constant

        // 显示“取消发布/重新上传”
        _hiddenBtns(with: false)

        // 更改文本
        tipLabel.text = "\(uploadType.uploadFailedText)\(lastUploadInex)/\(sourceCount)"
    }
    
    fileprivate func setCorner(_ view: UIView, cornerRadius: CGFloat) {
        view.layer.masksToBounds = true
        view.layer.cornerRadius = cornerRadius
    }
    
    @IBAction func closeBtnClick(_ sender: UIButton) {
//        (parentVC as! VCPostViewController).isPauseUpLoad = true
//        present(cancelPostAlter, animated: true, completion: nil)
        canRetry = true
        closeAlertBtn.isUserInteractionEnabled = false
    }
    
    @IBAction func cancelUpLoadClick(_ sender: UIButton) {
//        present(cancelPostAlter, animated: true, completion: nil)
        canRetry = false
    }
    
    @IBAction func reUploadBtnClick(_ sender: UIButton) {
        
        // 隐藏“取消发布、重新上传”
        _hiddenBtns(with: true)
        tipLabel.text = "\(uploadType.uploadingText)\(lastUploadInex)/\(sourceCount)"
        
        // 隐藏错误女孩图
        topImageView.isHidden = true
        
        // 进度条显示成红色的图
        _showRedProgressView()
        let progress: CGFloat = CGFloat(lastUploadInex) / CGFloat(sourceCount)
        let constant: CGFloat = min(170.0, max(16.0, 170.0 * progress))
        progressBarRedProgressViewWidthConstraint.constant = constant
        
        // 重新上传
//        (parentVC as! VCPostViewController).retryUpLoadResource()
    }
    
    @IBAction func onUploadPicError(_ sender: Any) {
        uploadError()
    }
    
    @IBAction func onUploadVoiceError(_ sender: Any) {
        uploadError()
    }
    @IBAction func onSwitchUploadTypeTapped(_ sender: Any) {
        switch uploadType {
        case .image:
            changeUpLoadType(.voice, sourceCount: 9)
        default:
            changeUpLoadType(.image, sourceCount: 9)
        }
    }
    
    fileprivate func _hiddenBtns(with isHidden: Bool = true) {
        cancelPostBtn.isHidden = isHidden
        continuePostBtn.isHidden = isHidden
    }
    
    fileprivate func cancelPostAlterAction(_ index: Int) {
        closeAlertBtn.isUserInteractionEnabled = true
//        cancelPostAlter.dismiss(animated: true, completion: nil)
        if index == 1 {
            // 确定终止
            dismiss()
        } else {
            // 继续上传
            if canRetry {
                reUploadBtnClick(UIButton())
            }
            // 放开父页面终止上传的控制
//            (parentVC as! VCPostViewController).isPauseUpLoad = false
        }
    }
    
    fileprivate func dismiss() {
        dismiss(animated: true, completion: nil)
//        (parentVC as! VCPostViewController).removeAfterCancelPost()
    }
    
    deinit {
//        __devlog("Post_alert_deinit")
    }
}

extension VCPostAlterViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        _presentTransition.present = true
        return _presentTransition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        _presentTransition.present = false
        return _presentTransition
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return GKComicPlayerPresentationController(presentedViewController: presented, presenting: presenting)
    }
}

// MARK: UIViewController Animated Transitioning
class VCAlertsControllerAnimatedTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    var present = false
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.18
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        guard let fromController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) else { return }
        guard let toController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else { return }
        guard let fromView = fromController.view else { return }
        guard let toView = toController.view else { return }
        let duration = transitionDuration(using: transitionContext)
        
        if present {
            // Present
            
            // presenting VC -> fromController
            // presented VC -> toController
            
            let frame = UIApplication.shared.keyWindow?.bounds ?? CGRect.zero
            toController.view.frame = frame
            toController.view.transform = CGAffineTransform(scaleX: 1.18, y: 1.18)
            toController.view.alpha = 0.36
            containerView.addSubview(toView)
            
            UIView.animate( withDuration: duration, delay: 0, options: .curveEaseIn, animations: {
                toController.view.transform = .identity
                toController.view.alpha = 1.0
            }, completion: { (finished) in
                transitionContext.completeTransition(true)
            })
            
        } else {
            // Dismiss
            
            // presented VC -> fromController
            // presenting VC -> toController
            
            toView.frame = UIApplication.shared.keyWindow?.bounds ?? CGRect.zero
            UIView.animate(withDuration: duration * 0.5, delay: 0, options: .curveEaseOut, animations: {
                fromView.alpha = 0.0
            }, completion: { (finished) in
                transitionContext.completeTransition(true)
            })
        }
    }
}

class GKComicPlayerPresentationController: UIPresentationController {
    
}

extension Bundle {
    
    static func vc_customBundle(with name: String) -> Bundle? {
        if let bundlePath = Bundle.main.path(forResource: name, ofType: "bundle"), let bundle = Bundle(path: bundlePath) {
            return bundle
        }
        return nil
    }
    
}
