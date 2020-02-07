//
//  VCAccountDestroyViewController.swift
//  BundleTest
//
//  Created by jianli chen on 2019/11/18.
//  Copyright © 2019 jianli chen. All rights reserved.
//

import Foundation

class VCAccountDestroyViewController: VCBaseViewController {
    
    // MARK: - View
    private let _scrollView: UIScrollView = UIScrollView()
    private let _contentView: UIView = UIView()
    
    // 当前账号
    private let _accountLabel = UILabel()
    // 联系方式
    private let _contactTextField = UITextField()
    // 预约时间
    private let _timeTextField = UITextField()
    // 注销流程描述
    private let _descLabel = UILabel()
    // 确认提交
    private let _confirmButton = UIButton()
    
    // MARK: - Data
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "账号注销"
        _setupUI()
    }
    
//    @available(iOS 11.0, *)
//    override func viewSafeAreaInsetsDidChange() {
//        super.viewSafeAreaInsetsDidChange()
//        _descLabel.snp.remakeConstraints { (make) in
//            make.top.equalTo(_timeTextField.snp.bottom).offset(16)
//            make.leading.equalTo(16)
//            make.trailing.equalTo(-16)
//            make.bottom.equalTo(-76 - viewSafeAreaInsets.bottom)
//        }
//
//        _confirmButton.snp.remakeConstraints { (make) in
//            make.leading.equalTo(16)
//            make.trailing.equalTo(-16)
//            make.bottom.equalTo(-16 - viewSafeAreaInsets.bottom)
//            make.height.equalTo(44)
//        }
//    }
    
    private func _setupUI() {
        view.backgroundColor = .white
        view.clipsToBounds = true
        _scrollView.clipsToBounds = true
        _contentView.clipsToBounds = true
        _scrollView.backgroundColor = .white
         view.addSubview(_scrollView)
        _scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        _contentView.backgroundColor = .white
        _scrollView.addSubview(_contentView)
        _contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.width.equalTo(view.width)
        }
        
        _accountLabel.numberOfLines = 0
        _accountLabel.font = UIFont.systemRegularFont(14)
        _accountLabel.textColor = UIColor.colorWithHexRGBA(0x101010)
        _contentView.addSubview(_accountLabel)
        _accountLabel.snp.makeConstraints { (make) in
            make.top.equalTo(16)
            make.leading.equalTo(16)
            make.trailing.equalTo(-16)
        }
        
        _contactTextField.font = UIFont.systemRegularFont(12)
        _contactTextField.textColor = UIColor.colorWithHexRGBA(0xFE5C75)
        _contactTextField.backgroundColor = UIColor.colorWithHexRGBA(0xFE5C75).withAlphaComponent(0.18)
        _contentView.addSubview(_contactTextField)
        _contactTextField.snp.makeConstraints { (make) in
            make.top.equalTo(_accountLabel.snp.bottom).offset(16)
            make.leading.equalTo(16)
            make.trailing.equalTo(-16)
            make.height.equalTo(40)
        }
        
        _timeTextField.font = UIFont.systemRegularFont(12)
        _timeTextField.textColor = UIColor.colorWithHexRGBA(0xFE5C75)
        _timeTextField.backgroundColor = UIColor.colorWithHexRGBA(0xFE5C75).withAlphaComponent(0.18)
        _contentView.addSubview(_timeTextField)
        _timeTextField.snp.makeConstraints { (make) in
            make.top.equalTo(_contactTextField.snp.bottom).offset(16)
            make.leading.equalTo(16)
            make.trailing.equalTo(-16)
            make.height.equalTo(40)
        }
        
        _descLabel.numberOfLines = 0
        _descLabel.font = UIFont.systemRegularFont(14)
        _descLabel.textColor = UIColor.colorWithHexRGBA(0x101010)
        _contentView.addSubview(_descLabel)
        _descLabel.snp.makeConstraints { (make) in
            make.top.equalTo(_timeTextField.snp.bottom).offset(16)
            make.leading.equalTo(16)
            make.trailing.equalTo(-16)
            make.bottom.equalTo(-76)
        }
        
        _confirmButton.backgroundColor = UIColor.colorWithHexRGBA(0xFE5C75)
        _confirmButton.layer.cornerRadius = 22
        _confirmButton.layer.masksToBounds = true
        _confirmButton.isScaleDownEffectEnable = true
        view.addSubview(_confirmButton)
        _confirmButton.snp.makeConstraints { (make) in
            make.leading.equalTo(16)
            make.trailing.equalTo(-16)
            make.bottom.equalTo(-16)
            make.height.equalTo(44)
        }
        
        let tipText1 = "微博动漫非常重视您的账户信息以及账户中的虚拟资产，请填写您能够方便、及时沟通的联系方式以及时间段，我们会尽快联系您~"
        let tipText2 = """
        * 账号注销流程：
        微博动漫客户端账号注销流程如下：
        1、用户提出账号注销申请。
        2、微博动漫运营工作人员核实。
        3、经过用户确认，正式注销账号。
        """
        let tipText3 = """
        * 账号注销用户需知：
        为了保证您的账户权益，请务必在提交注销申请前，确认
        以下关键信息：
        1、账号无付费购买墨币记录。
        2、账号在3个月内没变更过密码及修改登录手机号码。
        3、账号在经过用户和微博动漫工作人员确定注销后将无法找回，账号数据将被清空且无法登录。
        4、点击提交视为您已阅读过用户须知和注销流程。
        """
        let tipText = """
        \(tipText1)
        
        
        \(tipText2)
        
        
        \(tipText3)
        """
        
        let attr0: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: UIFont.systemRegularFont(12),
            NSAttributedString.Key.foregroundColor: UIColor.colorWithHexRGBA(0xFE5C75)
        ]
        _accountLabel.text = "当前登录账号：188****9069"
        _contactTextField.attributedPlaceholder = NSAttributedString(string: "联系方式 （ 电话、qq、邮箱  如多个方式 请用空格区分 ）", attributes: attr0)
        _timeTextField.attributedPlaceholder = NSAttributedString(string: "预约沟通时间", attributes: attr0)
        _confirmButton.setTitle("提交", for: .normal)
        
        let attr1: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: UIFont.systemRegularFont(12),
            NSAttributedString.Key.foregroundColor: UIColor.colorWithHexRGBA(0x999999)
        ]
        let attr2: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: UIFont.systemBoldFont(13),
            NSAttributedString.Key.foregroundColor: UIColor.colorWithHexRGBA(0x101010)
        ]
        let attrText = NSMutableAttributedString(string: tipText, attributes: attr2)
        let range = (tipText as NSString).range(of: tipText1)
        attrText.addAttributes(attr1, range: range)
        _descLabel.attributedText = attrText
        
        _confirmButton.addBlock(for: .touchUpInside) { [weak self] (_) in
            let controller = VCNativeMineViewController()
            self?.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
}
