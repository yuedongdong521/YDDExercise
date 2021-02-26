//
//  YDDRxSwiftVC.swift
//  YDDExercise
//
//  Created by ydd on 2021/2/26.
//  Copyright © 2021 ydd. All rights reserved.
//

import Foundation
import RxSwift
import SnapKit
import RxCocoa

let RxNotifyName = Notification.Name(rawValue: "RxNotifyNameKey")

class YDDRxSwiftVC: YDDBaseViewController {
    
    var disposeBag = DisposeBag()
    
    var button = UIButton()
    
    @objc dynamic var content = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        
        testRxButton()
        
        testRxTextFiled()
        
        testRxKVO()
    }
    
    /// button点击事件
    private func testRxButton() {
        let btn = UIButton(type: .system)
        btn.setTitle("Rx点击事件", for: .normal)
        btn.setTitle("点我干啥", for: .selected)
        self.view.addSubview(btn)
        btn.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.top.equalTo(self.navBarView.snp_bottom).offset(20)
            make.size.equalTo(CGSize(width: 80, height: 40))
        }
        
        self.button = btn
        
        self.button.rx.tap.subscribe(onNext:{ [weak self] in
            
            guard let button = self?.button else {
                return
            }
            button.isSelected = !button.isSelected
            SwiftLog("点击btn")
        
            NotificationCenter.default.post(name: RxNotifyName, object: "点击了button")
            
            
        }).disposed(by: disposeBag)
    }
    
    /// RxSwift textFiled输入内容监听，绑定
    private func testRxTextFiled() {
        
        let textFiled = UITextField()
        textFiled.placeholder = "说点啥吧..."
        self.view.addSubview(textFiled)
        
        textFiled.snp.makeConstraints { (make) in
            make.left.equalTo(110)
            make.top.equalTo(self.navBarView.snp_bottom).offset(20)
            make.size.equalTo(CGSize(width: 100, height: 40))
        }
        
        
        textFiled.rx.text.orEmpty.changed.subscribe(onNext: { [weak self] (str) in
            SwiftLog("textfiled str : \(str)")
            self?.content = str
            SwiftLog("content : \(self?.content ?? "")")
            
        }).disposed(by: disposeBag)
        
        textFiled.rx.text.bind(to: self.button.rx.title()).disposed(by: disposeBag)
    }
    /// KVO
    private func testRxKVO() {
        /// observeWeakly 监听的属性必须是 @objc dynamic 修饰的属性， 参数为类型名和属性名称
        self.rx.observeWeakly(String.self, "content").subscribe(onNext: { [weak self] (text) in
            
            print("text : \(text ?? "")" + " content : \(self?.content ?? "")")
        }).disposed(by: disposeBag)
    }
    
    private func testNotify() {
        NotificationCenter.default.rx.notification(RxNotifyName).subscribe(onNext: { [weak self] (notify) in
        
        }).disposed(by: disposeBag)

    }
    
    
    deinit {
        SwiftLog("YDDRxSwiftVC deallco")
    }
    
    private func setUI() {
        self.view.backgroundColor = UIColor.white
        setUpNav()
    }
    
    private func setUpNav() {
        self.navBarView.leftBlock = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
}
