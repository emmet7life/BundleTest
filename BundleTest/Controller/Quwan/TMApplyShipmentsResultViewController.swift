//
//  TMApplyShipmentsResultViewController.swift
//  BundleTest
//
//  Created by jianli chen on 2019/9/9.
//  Copyright © 2019 jianli chen. All rights reserved.
//
import UIKit

extension Array {
    // 防止数组越界
    subscript(index: Int, safe: Bool) -> Element? {
        if safe {
            if index >= 0, self.count > index {
                return self[index]
            } else {
                return nil
            }
        } else {
            return self[index]
        }
    }
}

// 发货成功 · 提示 · 视图控制器
// 转卖成功 · 提示 · 视图控制器
class TMApplyShipmentsResultViewController: VCBaseViewController {
    
    struct TMResultViewControllerParams {
        var title: String?
        var tipText: String?
        var tipImage: String?
        
        var leftBtnText: String?
        var centerBtnText: String?
        var rightBtnText: String?
        
        var leftBtnActionBlock: ((UIViewController) -> Void)? = nil
        var centerBtnActionBlock: ((UIViewController) -> Void)? = nil
        var rightBtnActionBlock: ((UIViewController) -> Void)? = nil
        
        static func diliverSuccessParams() -> TMResultViewControllerParams {
            return TMResultViewControllerParams(title: "确认发货",
                                                tipText: "申请发货成功",
                                                tipImage: "tm_empty_prompt_success",
                                                leftBtnText: "返回首页",
                                                centerBtnText: nil,
                                                rightBtnText: nil,
                                                leftBtnActionBlock: { (controller) in
                                                    print("leftBtnActionBlock")
            },
                                                centerBtnActionBlock: { (controller) in
                                                    print("centerBtnActionBlock")
            },
                                                rightBtnActionBlock: { (controller) in
                                                    print("rightBtnActionBlock")
            })
        }
    }
    
    class func viewController(with params: TMResultViewControllerParams) -> UIViewController {
        let controller = TMApplyShipmentsResultViewController()
        controller.params = params
        return controller
    }
    
    private var params: TMResultViewControllerParams?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = params?.title
        
//        navigationItem.hidesBackButton = true
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    private func setupUI() {
        let imageView = UIImageView(image: UIImage(named: params?.tipImage ?? ""))
        
        let label = UILabel()
        label.font = UIFont.systemMediumFont(15)
        label.textColor = UIColor.mainColor
        label.text = params?.tipText
        
        view.addSubview(imageView)
        view.addSubview(label)
        
        imageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(54)
            $0.centerX.equalToSuperview()
        }
        
        label.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(imageView.snp.bottom).offset(16)
            $0.width.lessThanOrEqualToSuperview().offset(-36)
        }
        
        let button1 = UIButton(type: .system)
        button1.layer.borderColor = UIColor.colorFF6680.cgColor
        button1.layer.borderWidth = 1
        button1.layer.cornerRadius = 17.5
        button1.setTitleColor(UIColor.colorFF6680, for: .normal)
        button1.titleLabel?.font = UIFont.systemMediumFont(15)
        
        let button2 = UIButton(type: .system)
        button2.layer.borderColor = UIColor.colorFF6680.cgColor
        button2.layer.borderWidth = 1
        button2.layer.cornerRadius = 17.5
        button2.setTitle(params?.centerBtnText, for: .normal)
        button2.setTitleColor(UIColor.colorFF6680, for: .normal)
        button2.titleLabel?.font = UIFont.systemMediumFont(15)
        
        let button3 = UIButton(type: .system)
        button3.layer.borderColor = UIColor.colorFF6680.cgColor
        button3.layer.borderWidth = 1
        button3.layer.cornerRadius = 17.5
        button3.setTitle(params?.rightBtnText, for: .normal)
        button3.setTitleColor(UIColor.colorFF6680, for: .normal)
        button3.titleLabel?.font = UIFont.systemMediumFont(15)
        
        let space = screenWidth < 375 ? 5 : 16
        
        let txtList = [params?.leftBtnText, params?.centerBtnText, params?.rightBtnText].compactMap { (text) -> String? in
            if let txt = text, !txt.isEmpty {
                return txt
            }
            return nil
        }
        
        button1.setTitle(txtList[0, true], for: .normal)
        button2.setTitle(txtList[1, true], for: .normal)
        button3.setTitle(txtList[2, true], for: .normal)
        
        let count = txtList.count
        if count == 0 {
            // 默认，返回首页
            view.addSubview(button1)
            
            button1.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.top.equalTo(label.snp.bottom).offset(UIScreen.isPhoneDown5Plus ? 68 : 98)
                $0.size.equalTo(CGSize(width: 100, height: 35))
            }
            
            button1.addBlock(for: .touchUpInside) { [unowned self] (_) in
                
            }
        } else if count == 1 {
            view.addSubview(button1)
            
            button1.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.top.equalTo(label.snp.bottom).offset(UIScreen.isPhoneDown5Plus ? 68 : 98)
                $0.size.equalTo(CGSize(width: 100, height: 35))
            }
            
            button1.addBlock(for: .touchUpInside) { [unowned self] (_) in
                self.params?.centerBtnActionBlock?(self)
            }
        } else if count == 2 {
            view.addSubview(button1)
            view.addSubview(button2)
            
            button1.snp.makeConstraints {
                $0.centerX.equalToSuperview().offset(-55)
                $0.top.equalTo(label.snp.bottom).offset(UIScreen.isPhoneDown5Plus ? 68 : 98)
                $0.size.equalTo(CGSize(width: 100, height: 35))
            }
            
            button2.snp.makeConstraints {
                $0.centerX.equalToSuperview().offset(55)
                $0.centerY.size.equalTo(button1)
            }
            
            button1.addBlock(for: .touchUpInside) { [unowned self] (_) in
                self.params?.leftBtnActionBlock?(self)
            }
            
            button2.addBlock(for: .touchUpInside) { [unowned self] (_) in
                self.params?.rightBtnActionBlock?(self)
            }
        } else if count == 3 {
            view.addSubview(button1)
            view.addSubview(button2)
            view.addSubview(button3)
            
            button2.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.top.equalTo(label.snp.bottom).offset(UIScreen.isPhoneDown5Plus ? 68 : 98)
                $0.size.equalTo(CGSize(width: 100, height: 35))
            }
            
            button1.snp.makeConstraints {
                $0.centerY.size.equalTo(button2)
                $0.right.equalTo(button2.snp.left).offset(-space)
            }
            
            button3.snp.makeConstraints {
                $0.centerY.size.equalTo(button2)
                $0.left.equalTo(button2.snp.right).offset(space)
            }
            
            button1.addBlock(for: .touchUpInside) { [unowned self] (_) in
                self.params?.leftBtnActionBlock?(self)
            }
            
            button2.addBlock(for: .touchUpInside) { [unowned self] (_) in
                self.params?.centerBtnActionBlock?(self)
            }
            
            button3.addBlock(for: .touchUpInside) { [unowned self] (_) in
                self.params?.rightBtnActionBlock?(self)
            }
        }
    }
}
