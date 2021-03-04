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



class YDDRxBinderVC: YDDBaseViewController {

    let disposeBag = DisposeBag()
    
    lazy var fontSizeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        return label
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
