//
//  YDDRxTransformingVC.swift
//  YDDExercise
//
//  Created by ydd on 2021/3/4.
//  Copyright © 2021 ydd. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

/// RxSwift 操作符（高阶函数）

class YDDRxTransformingVC: YDDBaseViewController {

    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navBarView.leftBlock = {[weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        self.navBarView.title = "RxSwift 操作符（高阶函数）"
        
        
        testBuffer()
        
        testWindow()
        
        testMap()
        
        testFlatMap()
        
        testFlatMapLatest()
        
        testConcatMap()
        
        testScan()
        
        testGroupBy()
        
        testFilter()
        
        testDistinctUntilChanged()
        
        testSingle()
        
        testElementAt()
        
        testIgnoreElements()
        
        testTake()
        
        testTakeLast()
        
        testSkip()
        
        testSample()
        
        testDebounce()
    }
    
    /**
     buffer : 缓存信号，当信号数量满足缓存数是出发订阅闭包，当缓存信号数量不足时，等到定时时间间隔出发订阅闭包，
        参数1：定时时间间隔，
        参数2：缓存信号数，缓存达到缓存数时立即执行订阅闭包，小于缓存数或没有缓存信号时等到定时时间触发订阅闭包
        参数3：订阅闭包调用线程
     */
    private func testBuffer() {
        let subject = PublishSubject<String>()
        SwiftLog("buffer : start")
        subject.buffer(timeSpan: .seconds(1), count: 2, scheduler: MainScheduler.instance).subscribe(onNext: { (event) in
            SwiftLog("buffer : event:  \(event)")
            if event.count == 0 {
                subject.onCompleted()
            }
        }).disposed(by: disposeBag)
        
        subject.onNext("信号1")
        subject.onNext("信号2")
        subject.onNext("信号3")
        subject.onNext("信号4")
        subject.onNext("信号5")
        SwiftLog("buffer : 信号发送完毕")
    }
    
    /**
     window： 与buffer功能类似， buffer是将缓存信号打包成数组发出， window是将缓存信号打包成Observable发出，
     */
    private func testWindow() {
        
        let subject = PublishSubject<String>()
        subject.window(timeSpan: .seconds(1), count: 2, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] obser in
                guard let self = self else {
                    return
                }
                SwiftLog("window : obser : \(obser)")
            
                obser.asObservable().subscribe(onNext: {text in
                    SwiftLog("window : text : \(text)")
                }).disposed(by: self.disposeBag)
                
            }).disposed(by: disposeBag)
        
        subject.onNext("信号1")
        subject.onNext("信号2")
        subject.onNext("信号3")
        
        subject.onCompleted()
        
    }
    
    /**
     map : 对信号处理完成后返回一个新的信号
     */
    private func testMap() {
        Observable<Int>.of(1, 2, 3).map({10 - $0}).subscribe(onNext:{SwiftLog("map : \($0)")}).disposed(by: disposeBag)
    }
    
    /**
     flatMap: 当信号是一个observable时使用flatMap对observabel做降维操作，直接得到值
     */
    private func testFlatMap() {
        /// 例1 ：
        let publish = PublishSubject<String>()
        publish.window(timeSpan: .seconds(1), count: 2, scheduler: MainScheduler.instance).flatMap({$0}).subscribe(onNext: {text in
            SwiftLog("flatMap : text \(text)")
        }).disposed(by: disposeBag)
        
        publish.onNext("信号1")
        publish.onNext("信号2")
        publish.onNext("信号3")
        
        /// 例2
        let subject1 = BehaviorSubject<String>(value: "subject1")
        let subject2 = BehaviorSubject<String>(value: "subject2")
        
        let sub = BehaviorSubject(value: subject1)
        sub.asObservable().flatMap({$0}).subscribe(onNext: { text in
            SwiftLog("flatMap BehaviorRelay : \(text)")
        }).disposed(by: disposeBag)
        
        subject1.onNext("subject1 信号1")
        subject1.onNext("subject1 信号2")
        subject2.onNext("subject2 信号3")
        SwiftLog("flatMap BehaviorRelay 切换 subject2 ")
        sub.onNext(subject2)
        
        subject1.onNext("subject1 信号4")
        subject2.onNext("subject2 信号5")
        
    }
    
    /**
     flatMapLatest : 与flatMap类似，区别在于flatMapLatest只接受最新的信号，当切换为subject2后，subject1信号不再接受
     */
    private func testFlatMapLatest() {
        
        let subject1 = BehaviorSubject<String>(value: "subject1")
        let subject2 = BehaviorSubject<String>(value: "subject2")
        
        let sub = BehaviorSubject(value: subject1)
        
        sub.asObservable().flatMapLatest({$0}).subscribe(onNext: {text in
            SwiftLog("flatMapLatest : \(text)")
        }).disposed(by: disposeBag)
        
        subject1.onNext("sub1 信号1")
        subject2.onNext("sub2 信号1")
        SwiftLog("flatMapLatest 切换sub2")
        sub.onNext(subject2)
        
        subject1.onNext("sub1 信号2")
        subject2.onNext("sub2 信号2")
    }
    
    /**
     concatMap 与map类似，区别在于 只有当前一个observable完成才会继续执行新的observable
     */
    private func testConcatMap() {
        let subject1 = BehaviorSubject<String>(value: "sub1")
        let subject2 = BehaviorSubject<String>(value: "sub2")
        
        let sub = BehaviorSubject(value: subject1)
        
        sub.asObservable().concatMap({$0}).subscribe(onNext: { SwiftLog("concatMap : \($0)")}).disposed(by: disposeBag)
        subject1.onNext("1")
        subject2.onNext("a")
        
        sub.onNext(subject2)
        
        subject1.onNext("2")
        subject2.onNext("b")
        
        subject1.onCompleted()
    }
    /**
     scan : 先给一个初始值，然后处理信号和这个初始值并返回结果，拿到结果后将结果作为下次处理信号所需的值，
          下例中实现 2 + 1 + 2 + 3
     */
    private func testScan() {
        Observable<Int>.of(1, 2, 3).scan(2) { (a, b) -> Int in
            /// a第一次循环是初始值，返回值作为下次循环a的值
            SwiftLog("scan a = \(a), b = \(b)")
            return a + b
        }.subscribe(onNext: {a in
            SwiftLog("scan onNext : \(a)")
        }).disposed(by: disposeBag)
    }
    /// groupBy 将一个序列按条件分成两组序列
    private func testGroupBy() {
        Observable<Int>.of(1, 2, 3, 4).groupBy { (a) -> String in
            return a % 2 == 0 ? "偶数" : "奇数"
        }.subscribe({ [weak self] evnet in
            guard let self = self else {
                return
            }
            
            SwiftLog("groupBy : event \(evnet)")
            
            switch evnet {
            case .next(let group):
                group.asObservable().subscribe({event in
                    
                    SwiftLog("groupBy : key : \(group.key), value : \(event.element ?? 0)")
                    
                }).disposed(by: self.disposeBag)
            default:
                SwiftLog("groupBy : default ")
            }
        }).disposed(by: disposeBag)
    }
    /// filter过滤
    private func testFilter() {
        Observable<Int>.of(1, 2, 3, 4).filter({$0 % 2 == 0}).subscribe(onNext:{SwiftLog("filter : 偶数 : \($0)")}).disposed(by: disposeBag)
    }
    /// distinctUntilChanged 去重
    private func testDistinctUntilChanged() {
        Observable<Int>.of(1, 2, 2, 3, 3, 4).distinctUntilChanged().subscribe(onNext:{SwiftLog("distinctUntilChanged : 去重: \($0)")}).disposed(by: disposeBag)
    }
    
    /// single ：只执行一次满足需求的信号后订阅终止，如果没有满足条件的信号则执行error终止订阅
    private func testSingle() {
    
        Observable<Int>.of(1, 2, 3, 2).single({$0 == 2}).subscribe(onNext: {SwiftLog("single : \($0)")}, onError: {SwiftLog("single : error \($0)")}, onCompleted: {SwiftLog("single 完成")}, onDisposed: {SwiftLog("single 终止")}).disposed(by: disposeBag)
        
        Observable<Int>.of(1, 2, 3).single({$0 == 0}).subscribe(onNext: {SwiftLog("single1 : \($0)")}, onError: {SwiftLog("single1 : error \($0)")}, onCompleted: {SwiftLog("single1 完成")}, onDisposed: {SwiftLog("single1 终止")}).disposed(by: disposeBag)
    }
    /// 输出指定位置的信号，位置超出则error 终止
    private func testElementAt() {
        Observable<Int>.of(3, 2, 1).element(at: 3).subscribe(onNext: { a in
            SwiftLog("ElementAt : \(a)")
        }, onError: {SwiftLog("ElementAt error : \($0)")}, onCompleted: {SwiftLog("ElementAt completed")}, onDisposed: {SwiftLog("ElementAt 终止")}).disposed(by: disposeBag)
    }
    
    /// ignoreElements, 忽略所有信号，在所有信号执行完成之后执行订阅闭包，如果不关心信号，只关心书否完成则可以使用此操作符
    private func testIgnoreElements() {
        Observable<Int>.of(1, 2, 3).ignoreElements().subscribe(onNext: {SwiftLog("ignoreElements next \($0)")}, onError: {SwiftLog("ignoreElements error \($0)")}, onCompleted: {SwiftLog("ignoreElements completed")}, onDisposed: {SwiftLog("ignoreElements 终止")}).disposed(by: disposeBag)
    }
    
    /// take 指定执行信号序列中的前几个，执行完后调用completed完成并终止订阅
    private func testTake() {
        Observable<Int>.of(1, 2, 3).take(2).subscribe { (a) in
            SwiftLog("take a : \(a)")
        }.disposed(by: disposeBag)
    }
    /// takeLast 指定执行信号序列中的后几个信号，执行完后调用completed完成并终止订阅
    private func testTakeLast() {
        Observable<Int>.of(1, 2, 3).takeLast(2).subscribe { (a) in
            SwiftLog("takeLast a : \(a)")
        }.disposed(by: disposeBag)
    }
    
    /// skip 跳过前几个信号序列开始执行
    private func testSkip() {
        /// 跳过前两个信号
        Observable<Int>.of(1, 2, 3).skip(2).subscribe { (a) in
            SwiftLog("skip a : \(a)")
        }.disposed(by: disposeBag)
    }
    
    /// Sample : 除了源监听（source）外还有另一个订阅者（notifier），当监听的notifier发送信号时源监听会触发最新的信号，两个notifier之间没有新信号时notifier不会发送信号，订阅闭包不会调用
    private func testSample() {
        let source = PublishSubject<Int>()
        let notifier = PublishSubject<String>()
        
        source.sample(notifier)
            .subscribe(onNext: { a in
                SwiftLog("sample : \(a)")
            }).disposed(by: disposeBag)
        SwiftLog("sample source 1")
        source.onNext(1)
        SwiftLog("sample source 2")
        source.onNext(2)
        SwiftLog("sample notifier A")
        notifier.onNext("A")
        SwiftLog("sample notifier B")
        notifier.onNext("B")
    }
    /// Debounce : 过滤高频操作，指定相邻两个信号发送时间间隔，小于这个时间两个信号都不触发订阅闭包，大于这个时间才会响应
    private func testDebounce() {
        //定义好每个事件里的值以及发送的时间
        let times = [
            [ "value": 1, "time": 0.1 ],
            [ "value": 2, "time": 1.1 ],
            [ "value": 3, "time": 1.2 ],
            [ "value": 4, "time": 1.4 ],
            [ "value": 5, "time": 2.1 ],
            [ "value": 6, "time": 3.1 ]
        ]
        
        //生成对应的 Observable 序列并订阅
        Observable.from(times).flatMap({ item in
            return Observable.of(Int(item["value"]!))
                .delaySubscription( .milliseconds(Int(CGFloat(item["time"]!) * 1000)), scheduler: MainScheduler.instance)
        }).debounce(.milliseconds(500), scheduler: MainScheduler.instance)
        .subscribe({SwiftLog("Debounce : \($0)")}).disposed(by: disposeBag)
        
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
