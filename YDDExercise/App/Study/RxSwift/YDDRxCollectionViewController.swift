//
//  YDDRxCollectionViewController.swift
//  YDDExercise
//
//  Created by ydd on 2021/3/5.
//  Copyright © 2021 ydd. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class YDDRxCollectionCell: UICollectionViewCell {
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.font = textFont(fontSize: 16)
        label.textAlignment = .center
        label.backgroundColor = .gray
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.label)
        
        self.label.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


class YDDRxCollectionViewController: YDDBaseViewController {

    let disposeBag = DisposeBag()
    
    lazy var items: Array<String> = {
       let arr = ["Swift", "Object-C", "Python", "C++", "JaveSprice"]
        return arr
    }()
    
    lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.backgroundColor = .white
        collection.register(YDDRxCollectionCell.self, forCellWithReuseIdentifier: YDDRxCollectionCell.description())
        collection.rx.setDelegate(self).disposed(by: disposeBag)
        return collection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navBarView.leftBlock = {[weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        addCollectionView()
        bindCollectionView()
        
    }
    
    private func addCollectionView() {
        self.view.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(self.navBarView.snp_bottom)
            make.left.right.bottom.equalTo(0)
        }
    }
    
    private func bindCollectionView() {
        let item = Observable.just(self.items, scheduler: MainScheduler.instance).map({$0})
        
        item.bind(to: collectionView.rx.items(cellIdentifier: YDDRxCollectionCell.description(), cellType: YDDRxCollectionCell.self)) {index, elment, cell in
            cell.label.text = elment
        }.disposed(by: disposeBag)
        
        collectionView.rx.modelSelected(String.self).subscribe(onNext: { index in
            SwiftLog("did selected : \(index)")
        }).disposed(by: disposeBag)
        
        
        
        
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

extension YDDRxCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w = (SwiftScreenWidth - 5 * 10) / 4
        return CGSize(width: w , height: w * 1.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
}

