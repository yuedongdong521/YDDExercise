//
//  YDDMenueView.swift
//  YDDExercise
//
//  Created by ydd on 2021/1/27.
//  Copyright © 2021 ydd. All rights reserved.
//

import UIKit


enum YDDMenueAnimationStyle: Int {
    case normal = 0
    case line
}

@objc
protocol YDDMenueDelegate {
    func menue(_ view: YDDMenueView, _ selectedIndex: Int)
}

extension YDDMenueDelegate {
    func menue(_ view: YDDMenueView, _ selectedIndex: Int) {
        SwiftLog("warning 方法没有实现")
    }
}


private class YDDMenueCell: UICollectionViewCell {
    
    lazy var title: UILabel = {
        let label = UILabel.init()
        label.textAlignment = .center
        return label
    }()
    
    var didSelected: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(self.title)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.title.frame = self.bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func updateStatue(_ selected: Bool) {
        didSelected = selected
        if didSelected {
            self.title.textColor = UIColor(white: 1, alpha: 1)
            self.transform = CGAffineTransform.identity
        } else {
            self.title.textColor = UIColor(white: 1, alpha: 0.8)
            self.transform = CGAffineTransform.identity.scaledBy(x: 0.7, y: 0.7)
        }
    }
    
    func selectedAnimation(_ selected: Bool) {
        UIView.setAnimationsEnabled(true)
        UIView.animate(withDuration: 0.25) {
            self.updateStatue(selected)
        } completion: { (finished) in
            if !finished {
                self.updateStatue(selected)
            }
        }
    }
}


class YDDMenueView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var space: CGFloat = 10
    
    var leftSpace: CGFloat = 10
    
    var rightSpace: CGFloat = 10
    
    var menueHeight: CGFloat = 30
    
    var menueFont: UIFont = textFont(fontSize: 16)
    
    var lineSize = CGSize(width: 10, height: 2)
    
    var animationStyle: YDDMenueAnimationStyle = .normal
    
    weak var delegate: YDDMenueDelegate?
    
    var menueTitles = Array<String>() {
        didSet {
            CATransaction.begin()
            self.collectionView.reloadData()
            CATransaction.setCompletionBlock {
                if self.lineView.frame.isEmpty {
                    self.updateLineFrame(self.curIndex, false, nil)
                }
            }
            CATransaction.commit()
            
        }
    }
        
    private var curIndex: Int = 0 {
        willSet {
            if let lastCell = getCell(curIndex) {
                lastCell.selectedAnimation(false)
            }
        }
        
        didSet {
            if let curCell = getCell(curIndex) {
                curCell.selectedAnimation(true)
            }
        }
    }
    

    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        
        flowLayout.scrollDirection = .horizontal
        let collection = UICollectionView.init(frame: .zero, collectionViewLayout: flowLayout)
        collection.showsHorizontalScrollIndicator = false
        collection.showsVerticalScrollIndicator = false
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = UIColor.clear
        collection.register(YDDMenueCell.classForCoder(), forCellWithReuseIdentifier: YDDMenueCell.description())
        
        return collection
    }()
    
    private lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.red
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.collectionView)
        self.collectionView.addSubview(self.lineView)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.collectionView.frame = self.bounds;
        
    }
    
    public func updateSelectedIndex(_ index: Int) {
        if index >= self.collectionView.numberOfItems(inSection: 0) {
            return
        }
        
        var selectedIndex = index
        if selectedIndex < 0 {
            selectedIndex = 0
        } else if selectedIndex >= self.menueTitles.count {
            selectedIndex = self.menueTitles.count - 1
        }
        
        self.curIndex = selectedIndex

        CATransaction.begin()
        self.collectionView.scrollToItem(at: IndexPath(item: selectedIndex, section: 0), at: UICollectionView.ScrollPosition.centeredHorizontally, animated: true)
        
        if let delegate = self.delegate {
            delegate.menue(self, self.curIndex)
        }
        
        CATransaction.setCompletionBlock {
            self.updateLineFrame(self.curIndex, false, nil)
        }
        CATransaction.commit()
        
    }
    
    public func updateScrollOffsetX(_ x: CGFloat) {
        var offsetX = x
        
        if offsetX < 0 {
            offsetX = 0
        } else if offsetX >= CGFloat(self.menueTitles.count) {
            offsetX = CGFloat(self.menueTitles.count - 1)
        }
        
        if CGFloat(self.curIndex) > offsetX {
            if CGFloat(self.curIndex) - offsetX >= 1 {
                self.curIndex -= 1
            }
            
            if self.curIndex < 0 {
                self.curIndex = 0;
                let lineFrame = getLineFrame(self.curIndex)
                self.lineView.frame = lineFrame;
                return
            }
            
            let curFrame = getCellFrame(self.curIndex)
            let newFrame = getCellFrame(Int(floor(offsetX)))
            
            let space = curFrame.midX - newFrame.midX
            var lineFrame = getLineFrame(curFrame)
            
            let roat = ceil(offsetX) - offsetX
            
            if animationStyle == .line {
                if roat <= 0.5 {
                    lineFrame.size.width += (space * roat * 2)
                    lineFrame.origin.x -= (space * roat * 2)
                } else {
                    lineFrame.origin.x -= space
                    lineFrame.size.width = (lineFrame.size.width + space) - (space * (roat - 0.5) * 2)
                }
            } else {
                lineFrame.origin.x -= space * roat
            }
            print("line x : \(lineFrame.origin.x)")
            self.lineView.frame = lineFrame
        } else if CGFloat(self.curIndex) < offsetX {
            if offsetX - CGFloat(self.curIndex) >= 1 {
                self.curIndex += 1
            }
            
            if self.curIndex >= self.menueTitles.count {
                self.curIndex = self.menueTitles.count - 1
                let lineFrame = self.getLineFrame(self.curIndex)
                self.lineView.frame = lineFrame
                return
            }
            
            let curFrame = getCellFrame(self.curIndex)
            let newFrame = getCellFrame(Int(ceil(offsetX)))
            let space = newFrame.midX - curFrame.midX
            var lineFrame = getLineFrame(curFrame)
            let roat =  offsetX - floor(offsetX)
            
            if animationStyle == .line {
                if roat <= 0.5 {
                    lineFrame.size.width += (space * roat * 2)
                } else {
                    lineFrame.size.width = (lineFrame.size.width + space) - (space * (roat - 0.5) * 2)
                    lineFrame.origin.x += (space * (roat - 0.5) * 2)
                }
            } else {
                lineFrame.origin.x += space * roat
            }
            
            self.lineView.frame = lineFrame
            print("line x : \(lineFrame.origin.x)")
        }
        
    }
    
    private func getCell(_ index: Int) -> YDDMenueCell? {
        if index >= self.collectionView.numberOfItems(inSection: 0) {
            return nil
        }
        return self.collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? YDDMenueCell
    }
    
    private func getCellFrame(_ index: Int) -> CGRect {
        if index >= self.collectionView.numberOfItems(inSection: 0) {
            return .zero
        }
        
        if let layout = self.collectionView.collectionViewLayout.layoutAttributesForItem(at: IndexPath(item: index, section: 0)) {
            return layout.frame
        }
        return .zero
    }
    
    private func getLineFrame(_ cellFrame: CGRect) -> CGRect {
        return CGRect(x: cellFrame.midX - self.lineSize.width * 0.5, y: cellFrame.height - self.lineSize.height, width: self.lineSize.width, height: self.lineSize.height)
    }
    
    private func getLineFrame(_ index: Int) -> CGRect {
        let cellFrame = getCellFrame(index)
        return getLineFrame(cellFrame)
    }
    
    private func updateLineFrame(_ index: Int, _ animation: Bool, _ completed: (()->Void)?) {
       
        let lineFrame = self.getLineFrame(index)
        if !animation {
            self.lineView.frame = lineFrame
            completed?()
        } else {
            
            UIView.animate(withDuration: 0.25) {
                self.lineView.frame = lineFrame
            } completion: { (finish) in
                if !finish {
                    self.lineView.frame = lineFrame
                }
                completed?()
            }
        }
    }
    
    
    
    /// UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        return UIEdgeInsets(top: 0, left: self.leftSpace, bottom: 0, right: self.rightSpace)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return self.space
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let title = self.menueTitles[indexPath.item]
     
        let att = NSAttributedString(string: title, attributes: [NSAttributedString.Key.font : self.menueFont])
        
        var w = att.boundingRect(with: CGSize(width: 1000, height: self.menueHeight), options: .usesLineFragmentOrigin, context: nil).size.width + 1
        if w < 30 {
            w = 30
        }
        
        return CGSize(width: w, height: self.menueHeight)
    }
    
    /// UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        return self.menueTitles.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: YDDMenueCell.description(), for: indexPath) as? YDDMenueCell else {
            return collectionView.dequeueReusableCell(withReuseIdentifier: YDDMenueCell.description(), for: indexPath)
        }
        
        cell.title.text = self.menueTitles[indexPath.item]
        cell.updateStatue(indexPath.item == self.curIndex)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.updateSelectedIndex(indexPath.item)
    }
    
}

