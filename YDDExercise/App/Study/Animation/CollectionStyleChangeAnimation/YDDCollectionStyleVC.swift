//
//  YDDCollectonStyleVC.swift
//  YDDExercise
//
//  Created by ydd on 2021/1/4.
//  Copyright © 2021 ydd. All rights reserved.
//

import Foundation
import UIKit

class YDDCollectionStyleVC: YDDBaseViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    lazy var listLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize(width: SwiftScreenWidth, height:300)
        layout.sectionInset = UIEdgeInsets.zero
        
        return layout
    }()
    
    lazy var gridLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize(width: (SwiftScreenWidth -  30) * 0.5, height: 300)
        layout.sectionInset = UIEdgeInsets.init(top: 0, left: 10, bottom: 0, right: 10)
        return layout
    }()

    lazy var collectionView :UICollectionView = {
        let collection = UICollectionView.init(frame: .zero, collectionViewLayout: self.listLayout)
        collection.backgroundColor = UIColor.white
        collection.delegate = self
        collection.dataSource = self
        collection.register(YDDCollectionStyleCell.self, forCellWithReuseIdentifier: "YDDCell")
        collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        return collection
    }()
    
    var isGirdStyle: Bool = false {
        didSet {
            changeLayoutStyle(isGirdStyle)
        }
    }
    
    var dataArr : Array<YDDCollectionStyleModel> = {
        return Array<YDDCollectionStyleModel>.init()
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configData()
        
        configNavigationBar()
        
        createUI()
    }
    
    private func configNavigationBar() {
        
        self.navBarView.title = "cell风格切换"
        self.navBarView.leftBlock = { [weak self] in
            guard let self = self else {
                return
            }
            self.navigationController?.popViewController(animated: true)
        }
        
        self.navBarView.rightBtn.setTitle("切换", for: .normal)
        self.navBarView.rightBlock = { [weak self] in
            if let self = self {
                self.isGirdStyle = !self.isGirdStyle
            }
        }
    }
    
    private func createUI() {
        
        self.view.addSubview(self.collectionView)
        self.collectionView.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(0)
            make?.right.mas_equalTo()(0)
            make?.bottom.mas_equalTo()(0)
            make?.top.mas_equalTo()(self.navBarView.mas_bottom)
        }
        
        self.collectionView.reloadData()
    }
    
    private func changeLayoutStyle(_ isGrid: Bool) {
        let layout = isGrid ? self.gridLayout : self.listLayout
        self.collectionView.setCollectionViewLayout(layout, animated: true) { (finish) in
           
        }
        
        NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: CellStyleKey), object: isGrid)
    }
    
    private func configData() {
        
        guard let path = Bundle.main.path(forResource: "HomeData", ofType: "json") else {
            return
        }
        
        let url = URL.init(fileURLWithPath: path)
        
       
        guard let data = try? Data.init(contentsOf: url) else {
            return
        }
        
        guard let result = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)  else {
            return
        }
        
        let dic = result as! Dictionary<String, Array<Any>>
        var mutArr = Array<YDDCollectionStyleModel>()
        for key in dic.keys {
            if let arr = dic[key] {
                for value in arr {
                    if let model = value as? Dictionary<String, Any> {
                        for k in model.keys {
                            if k == "iconUrl" {
                                if let icon = model[k] as? String {
                                    var model = YDDCollectionStyleModel()
                                    model.icon = icon;
                                    model.name = "浦江刘德华"
                                    model.sex = "男"
                                    model.birthday = "2021/01/04"
                                    model.occupation = "iOS工程师"
                                    mutArr.append(model)
                                }
                            }
                        }
                    }
                }
            }
        }
        self.dataArr = mutArr
        SwiftLog("\(mutArr)")
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "YDDCell", for: indexPath) as? YDDCollectionStyleCell else {
            return collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        }
        cell.update(self.dataArr[indexPath.item])
        cell.isGirdStype = self.isGirdStyle
        return cell
    }
    
    
}
