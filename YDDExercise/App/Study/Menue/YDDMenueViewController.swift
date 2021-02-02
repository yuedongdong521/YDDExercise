//
//  YDDMenueViewController.swift
//  YDDExercise
//
//  Created by ydd on 2021/1/27.
//  Copyright © 2021 ydd. All rights reserved.
//

import UIKit

class YDDMenueViewController: YDDBaseViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate, YDDMenueDelegate {

    private let MenueHeight: CGFloat = 30
    
    private lazy var menueView: YDDMenueView = {
        let menue = YDDMenueView(frame: CGRect(x: 0, y: SwiftNavHeight, width: SwiftScreenWidth, height: MenueHeight))
        menue.delegate = self
        menue.animationStyle = .line
        return menue
    }()
    
    private lazy var contentView: UICollectionView = {
        let frame = CGRect(x: 0, y: SwiftNavHeight + MenueHeight, width: SwiftScreenWidth, height: SwiftScreenHeight - SwiftNavHeight - MenueHeight)
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = frame.size
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        let contentView = UICollectionView(frame: frame, collectionViewLayout: flowLayout)
        contentView.showsVerticalScrollIndicator = false
        contentView.showsHorizontalScrollIndicator = false
        contentView.dataSource = self
        contentView.delegate = self
        contentView.isPagingEnabled = true
        
        contentView.register(UICollectionViewCell.classForCoder(), forCellWithReuseIdentifier: UICollectionViewCell.description())
        
        return contentView
    }()
    
    lazy var vcList: Array<UIViewController> = {
        let list: Array<UIViewController> = []
        return list
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        initUI()
        
        configDefaultList()
    }
    
    private func initUI() {
        self.navBarView.leftBlock = {[weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        self.view.backgroundColor = .gray
        
        self.view.addSubview(self.menueView)
        self.view.addSubview(self.contentView)
    }
    
    private func configDefaultList() {
        var titles = Array<String>()
        for i in 0...4 {
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor(red: CGFloat(arc4random() % 256) / 255.0, green: CGFloat(arc4random() % 256) / 255.0, blue: CGFloat(arc4random() % 256)  / 255.0, alpha: 1)
            self.addChild(vc)
            self.vcList.append(vc)
            titles.append("\(i)")
        }
        
        self.menueView.menueTitles = titles
        self.contentView.reloadData()
        
    }

    /// UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.vcList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UICollectionViewCell.description(), for: indexPath)
        
        for subView in cell.contentView.subviews {
            subView.removeFromSuperview()
        }
        cell.contentView.addSubview(self.vcList[indexPath.item].view)
        return cell
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.menueView.updateScrollOffsetX(scrollView.contentOffset.x / scrollView.bounds.size.width)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x / scrollView.bounds.size.width)
        self.menueView.updateSelectedIndex(index)
    }
    
    func menue(_ view: YDDMenueView, _ selectedIndex: Int) {
        self.contentView.setContentOffset(CGPoint(x: CGFloat(selectedIndex) * self.contentView.bounds.size.width, y: 0), animated: true)
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
