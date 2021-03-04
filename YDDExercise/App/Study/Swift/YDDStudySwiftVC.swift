//
//  YDDStudySwiftVC.swift
//  YDDExercise
//
//  Created by ydd on 2021/3/2.
//  Copyright © 2021 ydd. All rights reserved.
//

import UIKit



class YDDStudySwiftVC: YDDBaseViewController {

    fileprivate lazy var dataArr: Array<String> = {
       return ["YDDRxSwiftVC", "YDDRxObservable", "YDDRxBinderVC", "YDDRxSubjectsVC", "YDDRxTransformingVC"]
    }()
    
    private lazy var tableView: UITableView = {
        let tabel = UITableView(frame: CGRect.zero, style: .plain)
        tabel.delegate = self
        tabel.dataSource = self
        
    
        if #available(iOS 13.0, *) {
            tabel.automaticallyAdjustsScrollIndicatorInsets = false
        } else {
            // Fallback on earlier versions
            tabel.estimatedRowHeight = 0
            tabel.estimatedSectionHeaderHeight = 0
            tabel.estimatedSectionFooterHeight = 0
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        tabel.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: UITableViewCell.description())
        return tabel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setUpUI()
        
        
        
    }
    
    deinit {
    }
    
    private func setUpUI() {
        
        self.navBarView.title = "Swift"
        self.navBarView.leftBlock = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }

        
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(0)
            make.top.equalTo(self.navBarView.snp_bottom)
        }
        
        self.tableView.reloadData()
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

extension YDDStudySwiftVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        SwiftLog("reload row : \(indexPath.row)")
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let name = self.dataArr[indexPath.row]
        
        guard let nameSpage = Bundle.main.infoDictionary?["CFBundleExecutable"] else {
            SwiftLog("获取命名空间错误")
            return
        }
        
        let tagertClass: AnyClass? = NSClassFromString((nameSpage as! String) + "." + name)
        
        guard let VC = tagertClass as? UIViewController.Type else {
            SwiftLog("没有得到VC类")
            return
        }
        self.navigationController?.pushViewController(VC.init(), animated: true)
    }
}

extension YDDStudySwiftVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.description(), for: indexPath)
        cell.textLabel?.text = self.dataArr[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }

}

