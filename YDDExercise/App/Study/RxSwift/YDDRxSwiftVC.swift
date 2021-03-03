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
    
    lazy var tapLabel: UILabel = {
        let label = UILabel.init()
        label.font = textFont(fontSize: 14)
        label.textAlignment = NSTextAlignment.center
        label.textColor = UIColor.black
        label.isUserInteractionEnabled = true
        return label
    }()
    
    @objc dynamic var content = ""
    
    var timer: RxSwift.Observable<Int>?
    var timeDisposable: Disposable?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        self.navigationController?.pushViewController(YDDRxObservable(), animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
  
        timeDisposable?.dispose()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        
        testRxButton()
        
        testRxTextFiled()
        
        testRxKVO()
        
        testNotify()
        
        testGesture()
        
        testRequest()
        
        testTimer()
        
        
    }
    
    /// button点击事件
    private func testRxButton() {
        
        self.button.rx.tap.subscribe(onNext:{ [weak self] in
            
            guard let button = self?.button else {
                return
            }
            button.isSelected = !button.isSelected
            SwiftLog("点击btn")
        
            NotificationCenter.default.post(name: RxNotifyName, object: "点击了button")
            
            self?.timeDisposable?.dispose()
            
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
            
            SwiftLog("text : \(text ?? "")" + " content : \(self?.content ?? "")")
        }).disposed(by: disposeBag)
    }
    
    private func testNotify() {
        NotificationCenter.default.rx.notification(RxNotifyName).subscribe(onNext: { [weak self] (notify) in
            self?.view.backgroundColor = UIColor(red: CGFloat(arc4random() % 10) / 10.0, green: CGFloat(arc4random() % 10) / 10.0, blue: CGFloat(arc4random() % 10) / 10.0, alpha: 1)
            SwiftLog("RxSwift 通知写法 ： \(notify)")
        
        }).disposed(by: disposeBag)

    }
    
    private func testGesture() {
        let tap = UITapGestureRecognizer()
        self.tapLabel.addGestureRecognizer(tap)
        tap.rx.event.subscribe { [weak self] (event) in
            print("点击label")
            self?.navigationController?.pushViewController(YDDRxObservable(), animated: true)
            
        }.disposed(by: disposeBag)
    }
    
    private func testRequest() {
        guard let url = URL(string: "http://baidu.com") else { return }
        URLSession.shared.rx.response(request: URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10))
            .subscribe(onNext: { (response, data) in
                SwiftLog("request success : \(data)")
            }, onError: { (error) in
                SwiftLog("request fial error : \(error)")
            }).disposed(by: disposeBag)
    }
    
    private func testTimer() {
        timer = Observable<Int>.interval(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
        
        guard let timer = timer else {
            return
        }
        
        timeDisposable = timer.subscribe(onNext: { (count) in
            SwiftLog("rx 定时器: \(count)")
        })
        timeDisposable?.disposed(by: disposeBag)
    }
    
    
    deinit {
        SwiftLog("YDDRxSwiftVC deallco")
    }
    
    private func setUI() {
        self.view.backgroundColor = UIColor.white
        setUpNav()
        
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
        
        self.view.addSubview(self.tapLabel)
        self.tapLabel.text = "Observable"
        self.tapLabel.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.top.equalTo(self.button.snp_bottom).offset(20)
            make.width.equalTo(80)
            make.height.equalTo(40)
        }
        
    }
    
    private func setUpNav() {
        self.navBarView.leftBlock = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
}
