//
//  YDDRxBinderVC.swift
//  YDDExercise
//
//  Created by ydd on 2021/3/3.
//  Copyright © 2021 ydd. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift


class YDDRxBinderModel: NSObject {
    
    var content: BehaviorRelay<String> = BehaviorRelay<String>(value: "456")
    
    
    
    
}

class YDDRxBinderVC: YDDBaseViewController {

    let disposeBag = DisposeBag()
    
    lazy var fontSizeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    lazy var bindLabel: UITextField = {
        let label = UITextField()
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    lazy var binderModel: YDDRxBinderModel = {
        let model = YDDRxBinderModel()
       
        return model
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = .white
        self.navBarView.leftBlock = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        self.navBarView.title = "binder 绑定"
        
        testBinderFontSize()
        
        testBinder()
        
    }
    
    private func testBinderFontSize() {
        self.view.addSubview(self.fontSizeLabel)
        self.fontSizeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.navBarView.snp_bottom).offset(20)
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(30)
        }
        
        
        
        let obser = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
        obser.map { (a) -> CGFloat in
            return CGFloat(a % 30 + 1)
        }.bind(to: self.fontSizeLabel.fontSize).disposed(by: disposeBag)
        
        obser.map({ "current fontSize : \($0 % 30 + 1)" }).subscribe(onNext: { [weak self] a in
            self?.fontSizeLabel.text = a
        }).disposed(by: disposeBag)
     
        /// map可以作为数据类型转换跳板
        
    }
    
    
    func testBinder()  {
        
        self.view.addSubview(self.bindLabel)
        
        self.bindLabel.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.width.equalTo(100)
            make.height.equalTo(50)
            make.top.equalTo(200)
        }
        
        let btn = UIButton(type: .system)
        self.view.addSubview(btn)
        btn.setTitle("点击", for: .normal)
        var change = false
        btn.rx.tap.subscribe(onNext:{ [weak self] in
            guard let self = self else {
                return
            }
            change = !change
            if change {
                self.bindLabel.text = "123"
                SwiftLog("当前model 的值 ： \(self.binderModel.content.value)")
            } else {
                self.binderModel.content = BehaviorRelay<String>(value: "456")
            }
        }).disposed(by: disposeBag)
        
        btn.snp.makeConstraints { (make) in
            make.left.equalTo(140)
            make.width.equalTo(50)
            make.height.equalTo(50)
            make.top.equalTo(200)
        }

        
        self.binderModel.content.asObservable().bind(to: self.bindLabel.rx.text).disposed(by: disposeBag)
        self.bindLabel.rx.text.orEmpty.bind(to: self.binderModel.content).disposed(by: disposeBag)
        
        let label = UILabel()
        label.textColor = .blue
        self.view.addSubview(label)
        
        label.snp.makeConstraints { (make) in
            make.left.equalTo(140)
            make.width.equalTo(50)
            make.height.equalTo(50)
            make.top.equalTo(250)
        }
        
        self.binderModel.content.asObservable().bind(to: label.rx.text).disposed(by: disposeBag)
        
    }
    

    deinit {
        SwiftLog("dealloc")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

/// 自定义绑定属性， fontSize改变时自动修改字体大小
extension UILabel {
    public var fontSize: Binder<CGFloat> {
        return Binder(self) { label, size in
            label.font = textFont(fontSize: size)
        }
    }
}

