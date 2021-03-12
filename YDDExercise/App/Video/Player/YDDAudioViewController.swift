//
//  YDDAudioViewController.swift
//  YDDExercise
//
//  Created by ydd on 2021/3/11.
//  Copyright © 2021 ydd. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class YDDAudioViewController: YDDBaseViewController {

    let disposeBag = DisposeBag()
    
    lazy var player: YDDAudioLocalPlayer = {
        let player = YDDAudioLocalPlayer()
        return player
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navBarView.leftBlock = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    
        addLocalAudioPlayer()
        
        addServicePlayer()
        
        
        
       
        
    }
    
    

    func addServicePlayer() {
        let btn = UIButton(type: .system)
        self.view.addSubview(btn)
        btn.setTitle("stop", for: .normal)
        btn.rx.tap.subscribe(onNext: { [weak btn] in
            
            guard let btn = btn else {
                return
            }
            if btn.currentTitle == "play" {
                btn.setTitle("stop", for: .normal)
            } else {
                btn.setTitle("play", for: .normal)
                playerAudioServices(name: "11582.caf")
              
            }
        }).disposed(by: disposeBag)
        
        btn.snp.makeConstraints { (make) in
            make.top.equalTo(self.navBarView.snp.bottom).offset(20)
            make.left.equalTo(120)
            make.width.equalTo(80)
            make.height.equalTo(40)
        }
    }
    
    func addLocalAudioPlayer() {
        let btn = UIButton(type: .system)
        self.view.addSubview(btn)
        btn.setTitle("stop", for: .normal)
        btn.rx.tap.subscribe(onNext: { [weak btn, weak self] in
            guard let btn = btn else {
                return
            }
            if btn.currentTitle == "play" {
                btn.setTitle("stop", for: .normal)
                self?.stop()
            } else {
                btn.setTitle("play", for: .normal)
                self?.play()
            }
        }).disposed(by: disposeBag)
        
        btn.snp.makeConstraints { (make) in
            make.top.equalTo(self.navBarView.snp.bottom).offset(20)
            make.left.equalTo(20)
            make.size.equalTo(CGSize(width: 80, height: 40))
        }
    }
    
    
    func play() {
//        _ = self.player.player(local: "http://downsc.chinaz.net/Files/DownLoad/sound1/201906/11582.mp3")
        
        let path = Bundle.main.path(forResource: "11582", ofType: "mp3")
        _ = self.player.player(local: path!)
        
    }
    
    func stop() {
        self.player.destory()
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
