//
//  YDDOffScreenViewController.swift
//  YDDExercise
//
//  Created by ydd on 2021/4/12.
//  Copyright © 2021 ydd. All rights reserved.
//

import UIKit

class YDDOffScreenViewController: YDDBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navBarView.leftBlock = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        testView()
        
    }
    
    func testView() {
        
        let view = UIView()
        view.frame = CGRect(x: 20, y: 100, width: 50, height: 50)
        view.backgroundColor = .green
        view.layer.cornerRadius = 10
//        view.layer.masksToBounds = true
        self.view.addSubview(view)
        
        let subView = UIView()
        subView.frame = CGRect(x: 20, y: 20, width: 20, height: 20)
        subView.backgroundColor = .red;
        view.addSubview(subView)
        
        /// 造成离屏渲染： 当设置view的layer.cornerRadius > 0并且 layer.masksToBounds = true， 同时view上面有subView时会造成离屏渲染。
        
        
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
