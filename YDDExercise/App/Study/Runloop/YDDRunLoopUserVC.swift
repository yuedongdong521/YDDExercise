//
//  YDDRunLoopUserVC.swift
//  YDDExercise
//
//  Created by ydd on 2021/3/9.
//  Copyright © 2021 ydd. All rights reserved.
//

import UIKit
import Kingfisher

class YDDRunLoopUserVC: YDDBaseViewController {

    lazy var tableview: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: UITableViewCell.description())
        
        if #available(iOS 13.0, *) {
            tableView.automaticallyAdjustsScrollIndicatorInsets = false
        } else {
            // Fallback on earlier versions
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        return tableView
    }()
    
//    let callBlock:(Obser: CFRunLoopObserver) = {
//
//    }
//
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navBarView.leftBlock = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        self.view.addSubview(self.tableview)
        self.tableview.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets(top: SwiftNavHeight, left: 0, bottom: 0, right: 0))
        }
        
    }
    
    func addRunLoopObser() {
//        let curRunLoop = CFRunLoopGetCurrent()
//        let context = CFRunLoopObserverContext(version: 0, info: self.observationInfo) { (pointer) -> UnsafeRawPointer? in
//            return nil
//        } release: { (pointer) in
//            return
//        } copyDescription: { (pointer) -> Unmanaged<CFString>? in
//            return nil
//        }
        
//
//        CFRunLoopObserverCreate(kCFAllocatorDefault, <#T##activities: CFOptionFlags##CFOptionFlags#>, <#T##repeats: Bool##Bool#>, <#T##order: CFIndex##CFIndex#>, <#T##callout: CFRunLoopObserverCallBack!##CFRunLoopObserverCallBack!##(CFRunLoopObserver?, CFRunLoopActivity, UnsafeMutableRawPointer?) -> Void#>, <#T##context: UnsafeMutablePointer<CFRunLoopObserverContext>!##UnsafeMutablePointer<CFRunLoopObserverContext>!#>)

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


extension YDDRunLoopUserVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SwiftScreenWidth / 2;
    }
}

extension YDDRunLoopUserVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30000
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableview.dequeueReusableCell(withIdentifier: UITableViewCell.description()) else { return UITableViewCell()
        }
        
        cell.contentView.subviews.forEach({ $0.removeFromSuperview() })
        
        let size = (SwiftScreenWidth - 5 * 10) / 2
        
        for i in 0..<2 {
            let imageView = UIImageView(frame: CGRect(x: 10 + (size + 10) * CGFloat(i), y: 5, width: size, height: size))
            imageView.clipsToBounds = true
            cell.contentView.addSubview(imageView)
            
//            imageView.kf.setImage(with: URL(string: "http://pic1.win4000.com/pic/d/48/f2835946f9_250_350.jpg"), placeholder: Image(named: "defaultIcon"))
            if let path = Bundle.main.path(forResource: "BigImage", ofType: "jpg") {
                imageView.image = Image(contentsOfFile: path)
            }
        }
        
        return cell
    }
}
