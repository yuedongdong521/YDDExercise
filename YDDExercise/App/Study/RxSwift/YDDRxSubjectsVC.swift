//
//  YDDRxSubjectsVC.swift
//  YDDExercise
//
//  Created by ydd on 2021/3/4.
//  Copyright © 2021 ydd. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
///

class YDDRxSubjectsVC: YDDBaseViewController {

    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navBarView.leftBlock = {[weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        self.navBarView.title = "Subject 订阅者"
        
        testPublishSubject()
        
        testBehaviorSubject()
        
        testReplaySubject()
        
        testBehaviorRelay()
        

    }
    
    /**
     PublishSubject,
     特性：1. 不需要初始值就能创创建，
          2.订阅者只能收到从订阅开始后发出的信号，不能收到订阅之前发出的信号
          3.多次订阅后，所有发送信号之前的订阅都会收到信号，
          4.发送completed和error信号之后，所有订阅终止，不会在接收信号，也无法重新订阅，如果重新订阅会立即收到completed/error和订阅终止信号
     */
    private func testPublishSubject() {
        let publishSubject = PublishSubject<String>()
        
        publishSubject.onNext("订阅前发出信号")
        
        SwiftLog("PublishSubject ************** 一次订阅 ***************")
        publishSubject.subscribe { (text) in
            SwiftLog("PublishSubject : \(text)")
        } onError: { (error) in
            SwiftLog("PublishSubject : \(error)")
        } onCompleted: {
            SwiftLog("PublishSubject : completed")
        } onDisposed: {
            SwiftLog("PublishSubject : 终止订阅")
        }.disposed(by: disposeBag)
        
        publishSubject.onNext("订阅后发出信号")
        
//        publishSubject.onCompleted()
//
//        publishSubject.onNext("订阅完成后发出信号")
        
        SwiftLog("PublishSubject ************** 二次订阅 ***************")
        
        publishSubject.subscribe { (text) in
            SwiftLog("PublishSubject 2 : \(text)")
        } onError: { (error) in
            SwiftLog("PublishSubject 2: \(error)")
        } onCompleted: {
            SwiftLog("PublishSubject 2: completed")
        } onDisposed: {
            SwiftLog("PublishSubject 2: 终止订阅")
        }.disposed(by: disposeBag)
        
        publishSubject.onNext("二次订阅之后发送信号")
        
        publishSubject.onCompleted()
        publishSubject.onNext("订阅完成后发送信号")
    }
    
    /**
      BehaviorSubject
      特性：  1.需要一个初始值来初始化，初始值将会作为第一个信号
            2.订阅之后将会收到订阅之前最后发送的一个信号
            3.其余特性和PublishSubject一致
     */
    private func testBehaviorSubject() {
        let behaviorSubject = BehaviorSubject<String>(value: "init")
        
        behaviorSubject.onNext("订阅前发送信号")
        
        SwiftLog("BehaviorSubject ************** 一次订阅 ***************")
        behaviorSubject.subscribe { (text) in
            SwiftLog("BehaviorSubject 1 : \(text)")
        } onError: { (error) in
            SwiftLog("BehaviorSubject 1 : error : \(error)")
        } onCompleted: {
            SwiftLog("BehaviorSubject 1 : onCompleted")
        } onDisposed: {
            SwiftLog("BehaviorSubject 1 : 终止订阅")
        }.disposed(by: disposeBag)
        
        behaviorSubject.onNext("订阅之后发送信号")
        
//        behaviorSubject.onCompleted()
//        behaviorSubject.onNext("订阅完成后发送信号")
        
        SwiftLog("BehaviorSubject ************** 二次订阅 ***************")
        behaviorSubject.subscribe { (text) in
            SwiftLog("BehaviorSubject 2 : \(text)")
        } onError: { (error) in
            SwiftLog("BehaviorSubject 2 : error : \(error)")
        } onCompleted: {
            SwiftLog("BehaviorSubject 2 : onCompleted")
        } onDisposed: {
            SwiftLog("BehaviorSubject 2 : 终止订阅")
        }.disposed(by: disposeBag)
        
        behaviorSubject.onNext("二次订阅后发送信号")
        behaviorSubject.onCompleted()
        behaviorSubject.onNext("二次订阅完成后发送信号")
    }
    /**
     ReplaySubject
      特性： 1. 初始化需要出入一个bufferSize参数，bufferSize值表示信号缓存个数，ReplaySubject会缓存最近的几个信号，
             在订阅的时候会直接执行已缓存的信号
           2.终止订阅后二次订阅也会受到之前缓存的信号回调同事也回收终止订阅相关信号
     */
    private func testReplaySubject() {
        let replaySubject = ReplaySubject<String>.create(bufferSize: 2)
        
        replaySubject.onNext("信号1")
        replaySubject.onNext("信号2")
        replaySubject.onNext("信号3")
        
        SwiftLog("BehaviorSubject ************** 一次订阅 ***************")
        replaySubject.subscribe { (text) in
            SwiftLog("ReplaySubject 1: \(text)")
        } onError: { (error) in
            SwiftLog("ReplaySubject 1: \(error)")
        } onCompleted: {
            SwiftLog("ReplaySubject 1: completed")
        } onDisposed: {
            SwiftLog("ReplaySubject 1: 终止订阅")
        }.disposed(by: disposeBag)
        
        replaySubject.onNext("信号4")
        
        replaySubject.onNext("信号5")
//
//        replaySubject.onCompleted()

        SwiftLog("BehaviorSubject ************** 二次订阅 ***************")
        replaySubject.subscribe { (text) in
            SwiftLog("ReplaySubject 2: \(text)")
        } onError: { (error) in
            SwiftLog("ReplaySubject 2: \(error)")
        } onCompleted: {
            SwiftLog("ReplaySubject 2: completed")
        } onDisposed: {
            SwiftLog("ReplaySubject 2: 终止订阅")
        }.disposed(by: disposeBag)
        
        
        replaySubject.onNext("信号6")
        
    }
    
    /// Variable 在RxSwift 5之后被弃用
   
    /**
      BehaviorRelay : BehaviorRelay是对BehaviorSubject的封装
      特性：BehaviorRelay不能被onCompleted和onError终止订阅
     */
    private func testBehaviorRelay() {
        let behaviorRelay = BehaviorRelay<String>(value: "init")
        behaviorRelay.subscribe { (text) in
            SwiftLog("BehaviorRelay : \(text)")
        } onError: { (error) in
            SwiftLog("BehaviorRelay : error \(error)")
        } onCompleted: {
            SwiftLog("BehaviorRelay : completed")
        } onDisposed: {
            SwiftLog("BehaviorRelay : 终止订阅")
        }.disposed(by: disposeBag)
        
        behaviorRelay.accept("信号1")
        behaviorRelay.accept("信号2")
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
