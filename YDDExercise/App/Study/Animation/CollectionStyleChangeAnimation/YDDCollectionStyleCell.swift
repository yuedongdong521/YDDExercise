//
//  YDDCollectionStyleCell.swift
//  YDDExercise
//
//  Created by ydd on 2021/1/4.
//  Copyright © 2021 ydd. All rights reserved.
//

import Foundation

class YDDCollectionStyleCell: UICollectionViewCell {
    
    lazy var icon : UIImageView = {
        let imageView = UIImageView.init()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var name : UILabel = {
        let label = UILabel.init()
        label.textAlignment = .left
        label.font = textMediumFont(fontSize: 14)
        label.textColor = UIColor.black
        return label
    }()
    
    lazy var sex : UILabel = {
        let label = UILabel.init()
        label.textAlignment = .left
        label.font = textMediumFont(fontSize: 14)
        label.textColor = UIColor.black
        return label
    }()
    
    lazy var birthday : UILabel = {
        let label = UILabel.init()
        label.textAlignment = .left
        label.font = textMediumFont(fontSize: 14)
        label.textColor = UIColor.black
        return label
    }()
    
    lazy var occupation : UILabel = {
        let label = UILabel.init()
        label.textAlignment = .left
        label.font = textMediumFont(fontSize: 14)
        label.textColor = UIColor.black
        return label
    }()
    
    var isGirdStype : Bool? {
        didSet {
            if let isGirdStype = isGirdStype {
                updateStyle(isGirdStype)
            }
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.icon)
        self.addSubview(self.name)
        self.addSubview(self.sex)
        self.addSubview(self.birthday)
        self.addSubview(self.occupation)
        self.isGirdStype = true
        updateStyle(true)
        
       
        NotificationCenter.default.addObserver(self, selector: #selector(observerStyle(_:)), name: NSNotification.Name.init(rawValue: CellStyleKey), object: nil)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        
    }
    
    @objc func observerStyle(_ notify: NSNotification) {
        guard let style = notify.object as? Bool else { return }
        self.isGirdStype = style
    }
    
    override func layoutSubviews() {
        UIView.animate(withDuration: 0.3) {
            super.layoutSubviews()
        } completion: { (finish) in
            
        }
    }
    
    
    func update(_ model:YDDCollectionStyleModel) {
    
        self.icon.sd_setImage(with: URL.init(string: model.icon), placeholderImage: UIImage(named: "defaultIcon"), options:SDWebImageOptions(rawValue: 0), context: nil)
        
        self.name.text = model.name
        self.sex.text = model.sex
        self.birthday.text = model.birthday
        self.occupation.text = model.occupation
        
    }
    
    private func updateStyle(_ isGird:Bool) {
        if !isGird {
            let iconW = self.width() * 0.5
            let left = iconW + 10;
            self.icon.mas_remakeConstraints { (make) in
                make?.top.mas_equalTo()(0)
                make?.left.mas_equalTo()(0)
                make?.width.mas_equalTo()(iconW)
                make?.bottom.mas_equalTo()(0)
            }
            
            self.name.mas_remakeConstraints { (make) in
                make?.top.mas_equalTo()(10)
                make?.left.mas_equalTo()(left)
                make?.right.mas_equalTo()(-10)
                make?.height.mas_equalTo()(20)
            }
            
            self.sex.mas_remakeConstraints { (make) in
                make?.top.mas_equalTo()(self.name.mas_bottom)?.offset()(10)
                make?.left.mas_equalTo()(left)
                make?.right.mas_equalTo()(-10)
                make?.height.mas_equalTo()(20)
            }
            
            self.birthday.mas_remakeConstraints { (make) in
                make?.top.mas_equalTo()(self.sex.mas_bottom)?.offset()(10)
                make?.left.mas_equalTo()(left)
                make?.right.mas_equalTo()(-10)
                make?.height.mas_equalTo()(20)
            }
            
            self.occupation.mas_remakeConstraints { (make) in
                make?.top.mas_equalTo()(self.birthday.mas_bottom)?.offset()(10)
                make?.left.mas_equalTo()(left)
                make?.right.mas_equalTo()(-10)
                make?.height.mas_equalTo()(20)
            }
            
        } else {
            
            self.icon.mas_remakeConstraints { (make) in
                make?.edges.mas_equalTo()(UIEdgeInsets.zero)
            }
            
            self.name.mas_remakeConstraints { (make) in
                make?.top.mas_equalTo()(10)
                make?.left.mas_equalTo()(10)
                make?.right.mas_equalTo()(-10)
                make?.height.mas_equalTo()(20)
            }
            
            self.sex.mas_remakeConstraints { (make) in
                make?.top.mas_equalTo()(self.name.mas_bottom)?.offset()(10)
                make?.left.mas_equalTo()(10)
                make?.right.mas_equalTo()(-10)
                make?.height.mas_equalTo()(20)
            }
            
            self.birthday.mas_remakeConstraints { (make) in
                make?.top.mas_equalTo()(self.sex.mas_bottom)?.offset()(10)
                make?.left.mas_equalTo()(10)
                make?.right.mas_equalTo()(-10)
                make?.height.mas_equalTo()(20)
            }
            
            self.occupation.mas_remakeConstraints { (make) in
                make?.top.mas_equalTo()(self.birthday.mas_bottom)?.offset()(10)
                make?.left.mas_equalTo()(10)
                make?.right.mas_equalTo()(-10)
                make?.height.mas_equalTo()(20)
            }
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
