//
//  YDDTableViewViewController.swift
//  YDDExercise
//
//  Created by ydd on 2021/4/14.
//  Copyright © 2021 ydd. All rights reserved.
//

import UIKit

class YDDTableViewViewController: YDDBaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    lazy var list: Array<String> = {
        let arr = Array<String>()
        return arr
    }()
    
    var displayLink: CADisplayLink?
    var page = 0
    let num = 2
    
    
    
    lazy var arr: Array<String> = {
        var arr = [String]()
        for i in 0..<10000 {
            arr.append(String(i))
        }
        return arr
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60
        tableView.separatorColor = .clear
        
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        
        return tableView
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.addNavigation()
        
        addTableView()
    }
    
    private func addNavigation() {
        self.navBarView.leftBlock = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        self.navBarView.rightBtn.setTitle("+", for: .normal)
        
        
        
       
        self.navBarView.rightBlock = { [weak self] in
            guard let self = self else {
                return
            }
            self.startTimer()
        }
    }
    
    private func stopTimer() {
        if let link = self.displayLink {
            link.invalidate()
            self.displayLink = nil
        }
    }
    
    private func startTimer() {
        
        stopTimer()
        page = 0
        
        self.list.removeAll()
        self.tableView.reloadData()
        
        self.displayLink = CADisplayLink(target: self, selector: #selector(timerAction))
        
        self.displayLink?.frameInterval = 30
        
        self.displayLink?.add(to: RunLoop.main, forMode: .default)
    }
    
    @objc func timerAction() {
        let range: Range = (page * num)..<((page * num) + num)
        
        if range.contains(10000) {
            stopTimer()
            return
        }
        
        self.list.append(contentsOf: self.arr[range])
        
        SwiftLog("list : \(self.list)")
        
        var paths = [IndexPath]()
        
        for i in range {
            paths.append(IndexPath(row: i, section: 0))
        }
        
        self.updateTableRow(paths)
//        self.tableView.reloadData()
        if let lastPath = paths.last {
            self.tableView.scrollToRow(at: lastPath, at: .bottom, animated: true)
        }
        page += 1
    }
    
    private func updateTableRow(_ paths: [IndexPath]) {
        
        /**
         beginUpdates 和 endUpdates 方法的作用是，
         将这两条语句之间的对 tableView 的 insert/delete 操作聚合起来，然后同时更新 UI。如果不加多次insert/delete一起操作会导致崩溃
         */
        self.tableView.beginUpdates()
        
        self.tableView.insertRows(at: paths, with: .bottom)
        
        self.tableView.endUpdates()
    }
    
    
    private func addTableView() {
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(0)
            make.top.equalTo(self.navBarView.snp.bottom)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = self.list[indexPath.row]
        return cell
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
