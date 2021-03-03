//
//  YDDRxObservable.swift
//  YDDExercise
//
//  Created by ydd on 2021/3/1.
//  Copyright © 2021 ydd. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum RxError: Error {
    case unkown
    case code(_ code: Int)
    
    func content() -> Int {
        
        switch self {
        case let .code(v):
            return v
        default:
            return 404
        }
    }
}

class YDDRxObservable: YDDBaseViewController {
    
    var disposeBag = DisposeBag()
    
    lazy var binLabel: UILabel = {
        let label = UILabel.init()
        label.font = textFont(fontSize: 14)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    lazy var subLabel: UILabel = {
        let label = UILabel.init()
        label.font = textFont(fontSize: 14)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    lazy var obserLabel: UILabel = {
        let label = UILabel.init()
        label.font = textFont(fontSize: 14)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    lazy var binderLabel: UILabel = {
        let label = UILabel.init()
        label.font = textFont(fontSize: 14)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        baseUse()
        
        testObervable()
        
        testCreateObervableSequence()
        
        testBin()
        
        anyObserver()
        
        testBinder()
        
        
        testStartWidth()
        
        testMerge()
        
        testZip()
        
        testCombineLatest()
        
        testSwitchLatest()
        
        testMap()
        
        
        
    }
    
    deinit {
        print("YDDRxObservable dealloc")
    }
    
    /// 基本用法
    private func baseUse() {
        /**
         1.创建信号
         2.订阅信号
         3.发送信号
         */
       
        /// 1.创建信号
        _ = Observable<String>.create({ (obserber) -> Disposable in
            /// 3.发送信号
            obserber.onNext("发送信号")
            
            /// Disposables 控制订阅者生命周期，调用  dispose() 结束订阅
            return Disposables.create()
            /// 2. 订阅信号
        }).subscribe(onNext: { (str) in
            SwiftLog("Observale 收到信号 str : \(str)")
        }, onDisposed: {
            SwiftLog("Observale base 信号 被释放")
        })
        
    }
    
    private func testObervable() {
        
        /// 发送onError或者onCompleted信号之后，内部会调用dispose()  结束订阅，之后的信号将不再接受
        _ = Observable<String>.create({ (obserber) -> Disposable in
            
            obserber.onNext("发送信号")
            obserber.onNext("再次发送信号")
            obserber.onError(RxError.code(1))
            obserber.onNext("已发送错误信号")
            obserber.onCompleted()
            obserber.onNext("已发送完成信号")
    
            return Disposables.create()
        }).subscribe(onNext: { (text) in
            SwiftLog("Observale onNext : 接收到新信号 \(text)")
        }, onError: { (error) in
            
            guard let err = error as? RxError else {
                return
            }

            SwiftLog("Observale onError : 接收到错误信号 \(err.content())")
        }, onCompleted: {
            SwiftLog("Observale onCompleted : 信号完成")
        }, onDisposed: {
            SwiftLog("Observale 订阅被释放")
        })
        
    }
    
    /// 创建Obervable序列
    private func testCreateObervableSequence() {
        /// Obervable序列，当所有初始化传入信号执行完后执行completed类结束订阅
        ///1.  just 传入一个默参数来初始化 Obervable 序列
        let justObervable = Observable<Int>.just(2)
        justObervable.subscribe { (a) in
            SwiftLog("Observable just 序列 \(a)")
            
        }.disposed(by: disposeBag)
        
        ///2.  of传入多个同一类型参数初始化 Observable序列
        let ofObervable = Observable<Int>.of(1, 2, 3)
        ofObervable.subscribe { (a) in
            SwiftLog("Observable of 序列 \(a)")
        }.disposed(by: disposeBag)

        ///3. from 传入一个数组初始化 Observable序列
        let fromOber = Observable<Int>.from([1, 2, 3])
        fromOber.subscribe { (a) in
            SwiftLog("Observable from 序列 \(a)")
        }.disposed(by: disposeBag)
        
        ///4. empty 创建一个空 Observable序列， 直接执行 completed结束订阅
        let emptyOber = Observable<Any>.empty()
        emptyOber.subscribe(onNext :{ (a) in
            SwiftLog("Observable empty 序列 \(a)")
        }, onDisposed: {
            SwiftLog("Observable empty 序列 终止")
        }).disposed(by: disposeBag)

        ///5. never 创建个永远不会执行的Observable，在页面释放时通过disposeBag来终止订阅
        let neverObser = Observable<Any>.never()
        neverObser.subscribe(onNext: { (a) in
            /// 不会执行
            SwiftLog("Observable never 序列 \(a)")
        }, onDisposed: {
            SwiftLog("Observable never 序列 终止")
        }).disposed(by: disposeBag)
        
        ///6. error 创建一个只会发送执行 onError的Observable
        let errorObser = Observable<RxError>.error(RxError.code(200))
        errorObser.subscribe { (a) in
            /// 不会触发
            SwiftLog("Observable error 序列 a : \(a)")
        } onError: { (err) in
            guard let rxError = err as? RxError else {
                return
            }
            SwiftLog("Observable error 序列 error : \(rxError.content())")
        }.disposed(by: disposeBag)

        ///7. range 创建个从5起始长度为8的Observable序列
        Observable<Int>.range(start: 5, count: 8).subscribe { (a) in
            SwiftLog("Observable range 序列 a : \(a.element ?? 0)")
        }.disposed(by: disposeBag)

        ///8. repeatElement创建一个重复发送信号的Observable序列，默认是当前线程，主线程会卡UI, SerialDispatchQueueScheduler gcd串行队列
        let repeatObser = Observable<Int>.repeatElement(1, scheduler: SerialDispatchQueueScheduler(internalSerialQueueName: "Rx.Serial.Queue"))
        let repeatDispose = repeatObser.subscribe { (a) in
            SwiftLog("Observable repeatElement 序列 a : \(a), curThread : \(Thread.current)")
        } onDisposed: {
            SwiftLog("Observable repeatElement 序列 终止")
        }
        /// 1秒后终止repeatObser 序列
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            repeatDispose.dispose()
        }
        
        /// 9. generate 从初始值开始，筛选满足条件的信号执行订阅闭包，然后数据执行信号处理，循环再条件判断直至条件不符合执行completed结束订阅
        Observable<Int>.generate(initialState: 2, condition: { (a) -> Bool in
            SwiftLog("Observable generate 序列 筛选条件")
            return a < 10
        }, scheduler: MainScheduler.instance) { (a) -> Int in
            SwiftLog("Observable generate 序列 数据处理")
            return a + 1
        }.subscribe { (a) in
            SwiftLog("Observable generate 序列 \(a)")
        }.disposed(by: disposeBag)
        
        /// 10.deferred 通过block延迟创建Observable， 在订阅的时候才创建Observable
        var bigNum = false
        let factory = Observable<Int>.deferred { () -> Observable<Int> in
            
            if bigNum {
                return Observable.of(8, 9, 10)
            }
            return Observable.of(1, 2, 3)
        }
        
        factory.subscribe { (a) in
            
            
            SwiftLog("Observable deferred 序列 sam \(a)")
        }.disposed(by: disposeBag)
        
        bigNum = true
        factory.subscribe { (a) in
            
            SwiftLog("Observable deferred 序列 big \(a)")
            
        }.disposed(by: disposeBag)
        
        /// 11.timer 定时执行订阅， dueTime: 延时开始，0立即开始，period：定时间隔
        SwiftLog("Observable timer : 开始")
        Observable<Int>.timer(.seconds(5), period: .seconds(6), scheduler: MainScheduler.instance).subscribe(onNext: { a in
            SwiftLog("Observable timer :  \(a)")
        }).disposed(by: disposeBag)
        
        /// 12. do 在subscribe 订阅之前监听信号状态
        let _ = Observable<Int>.of(1, 2).do { (a) in
            SwiftLog("Observable do :  \(a)")
        } afterNext: { (a) in
            SwiftLog("Observable do afterNext :  \(a)")
        } onError: { (err) in
            SwiftLog("Observable do onError :  \(err)")
        } afterError: { (err) in
            SwiftLog("Observable do afterError :  \(err)")
        } onCompleted: {
            SwiftLog("Observable do onCompleted")
        } afterCompleted: {
            SwiftLog("Observable do afterCompleted")
        } onSubscribe: {
            SwiftLog("Observable do onSubscribe")
        } onSubscribed: {
            SwiftLog("Observable do onSubscribed")
        } onDispose: {
            SwiftLog("Observable do onDispose")
        }.subscribe { (a) in
            SwiftLog("Observable do sub \(a)")
        } onError: { (error) in
            SwiftLog("Observable do sub onError \(error)")
        } onCompleted: {
            SwiftLog("Observable do sub onCompleted")
        } onDisposed: {
            SwiftLog("Observable do sub onDisposed")
        }.disposed(by: disposeBag)


        
    }
    
    private func testBin() {
        
        let obser = Observable<Int>.interval(.seconds(2), scheduler: MainScheduler.instance)
            .map { (a) -> (String , Int) in
                return ("当前索引数 ： \(a)", a)
            }
        var disposa: Disposable? = nil
        disposa = obser.subscribe(onNext: { [weak self] a in
                self?.subLabel.text = a.0
                if a.1 > 10 {
                    disposa?.dispose()
                }
            })
        disposa?.disposed(by: disposeBag)
        
        var binDisposa: Disposable? = nil
        binDisposa = obser.bind(onNext: { [weak self] (a) in
            self?.binLabel.text = a.0
            if a.1 > 10 {
                binDisposa?.dispose()
            }
        })
        
        
        binDisposa?.disposed(by: disposeBag)
        
        
    }
    
    private func anyObserver() {
        
        /// AnyObserver 作为subscribe参数， 先订阅后发信号
        let obs = AnyObserver<String> { (event) in
            switch event {
            case .next(let str):
                SwiftLog("AnyObserver next : \(str)")
            case .error(let err):
                SwiftLog("AnyObserver error : \(err)")
            case .completed:
                SwiftLog("AnyObserver completed")
            }
        }
        let _ = Observable<String>.of("a", "b").subscribe(obs).disposed(by: disposeBag)
        
        
        var timerDispods: Disposable? = nil
        
        let obsTimer = AnyObserver<Int> {[weak self] event in
            switch event {
            case .next(let a):
                if a > 20 {
                    self?.obserLabel.text = "AnyObserver 观察值完成"
                    timerDispods?.dispose()
                    break
                }
                
                self?.obserLabel.text = "AnyObserver 观察值：\(a)"
            default:
                SwiftLog("AnyObserver def")
                
                break
            }
        }
        /// 使用 bind(to)绑定观察者
        let timer = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
        timerDispods = timer.bind(to: obsTimer)
        timerDispods?.disposed(by: disposeBag)
        
    }
    
    private func testBinder() {
        
        
        let binder: Binder<String> = Binder.init(self.binderLabel, scheduler: MainScheduler.instance) { (label, text) in
            label.text = text
        }
        
        Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance).map { (a) -> String in
            return "binder 绑定观察者：\(a)"
        }.bind(to: binder).disposed(by: disposeBag)
        
    }
    
    
    
    /// 组合操作符
    private func testStartWidth() {
        
        /// startWith 在观察者发送信号之前发出信号，startWith后发先至
        
        let obs = Observable.of("1", "2", "3")
            .startWith("a")
            .startWith("b")
            .startWith("c", "d")
        
        SwiftLog("组合操作符： startWith : 添加订阅")
        obs.subscribe(onNext: { (text) in
            SwiftLog("组合操作符： startWith \(text)")
        }, onDisposed: {
            SwiftLog("组合操作符： startWith : 释放订阅")
        }).disposed(by: disposeBag)
    }
    
    private func testMerge() {
        
        let sub1 = PublishSubject<String>()
        let sub2 = PublishSubject<String>()
        
        Observable.of(sub1, sub2)
            .merge()
            .subscribe(onNext: { (text) in
                SwiftLog("组合操作符： merge : \(text)")
            }).disposed(by: disposeBag)
        sub1.onNext("sub1 a")
        sub1.onNext("sub1 b")
        sub2.onNext("sub2 c")
        sub2.onNext("sub2 d")
        
        /// merge() 将sub1和sub2两个被观察者组合在一起订阅一个事件，任何一个发送信号都会触发订阅事件
        
    }
    
    
    private func testZip() {
        let zip1 = PublishSubject<String>()
        let zip2 = PublishSubject<Int>()
        
        Observable.zip(zip1, zip2) { (stringElement, intElement) in
            "\(stringElement) \(intElement)"
        }.subscribe(onNext: {
            SwiftLog("组合操作符 zip ： \($0)")
        })
        .disposed(by: disposeBag)
        
        zip1.onNext("zip1 a")
        zip2.onNext(1)
        
        zip1.onNext("zip1 b")
        zip2.onNext(2)
        
        zip2.onNext(4)
        
        zip1.onNext("zip1 c")
        zip1.onNext("zip1 d")
        zip2.onNext(3)
        
        /// zip 操作符与merge相反，zip将两个订阅者打包组合在一起，只有当两个订阅者都发出信号才会触发订阅闭包
        /// zip不会覆盖信号，所有信号都会存储并不覆盖，等待另一个信号发送后一起触发订阅闭包
    }
    
    private func testCombineLatest() {
        let combine1 = PublishSubject<String>()
        let combine2 = PublishSubject<Int>()
        
        Observable.combineLatest(combine1, combine2) { (stringElement, intElement) in
            "\(stringElement) \(intElement)"
        }.subscribe(onNext: {
            SwiftLog("组合操作符 combineLatest ： \($0)")
        })
        .disposed(by: disposeBag)
        
        combine1.onNext("combine1 a")
        combine2.onNext(1)
        
        combine1.onNext("combine1 b")
        
        combine1.onNext("combine1 c")
        combine2.onNext(2)
        
        /// combineLatest 组合两个订阅者，只要两个订阅这都有发送信号则触发订阅闭包，每次触发都只会拿到每个订阅者最后发送的信号
    }
    
    private func testSwitchLatest() {
        let sub1 = BehaviorSubject(value: "Y")
        let sub2 = BehaviorSubject(value: "D")
        
        let sub = BehaviorSubject(value: sub1)
        
        sub.asObservable()
            .switchLatest()
            .subscribe(onNext: {
                print("组合操作符 switch : \($0)")
            })
            .disposed(by: disposeBag)
        
        sub1.onNext(" 1")
        sub1.onNext("2")
        sub2.onNext("a")
        sub2.onNext("b")
        sub.onNext(sub2)
        
        sub2.onNext("c")
        sub1.onNext("3")
        sub2.onNext("d")
         
        /// switchLatest 切换订阅者，如上例中将sub1切换为sub2， 切换后sub1不会再触发订阅闭包
    }
    /// 映射操作符
    private func testMap() {
        /// 遍历观察序列，对观察序列操作之后在返回新的序列
        let obj = Observable.of(1, 2, 3)
        obj.map { (number) -> Int in
            return number + 2
        }.subscribe { n in
            let v = n.element ?? 0
            SwiftLog("映射操作符 map: \(n) v: \(v)")
        }.disposed(by: disposeBag)
        

        /// 遍历数组
        let from = Observable.from([1, 2, 3])
        from.map { (n) -> Int in
            return n - 1
        }.subscribe { n in
            SwiftLog("映射操作符 map from : \(n)")
        }.disposed(by: disposeBag)

        
        
        
    }
    
    private func testFlatMap() {
        
    }
    
    
    private func setupUI() {
        self.navBarView.title = "Observale"
        self.navBarView.leftBlock = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        self.view.addSubview(self.binLabel)
        self.binLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.navBarView.snp_bottom).offset(20)
            make.left.right.equalTo(20)
            make.height.equalTo(40)
        }
        
        self.view.addSubview(self.subLabel)
        self.subLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.binLabel.snp_bottom).offset(20)
            make.left.right.equalTo(20)
            make.height.equalTo(40)
        }
        
        self.view.addSubview(self.obserLabel)
        self.obserLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.subLabel.snp_bottom).offset(20)
            make.left.right.equalTo(20)
            make.height.equalTo(40)
        }
        
        self.view.addSubview(self.binderLabel)
        self.binderLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.obserLabel.snp_bottom).offset(20)
            make.left.right.equalTo(20)
            make.height.equalTo(40)
        }
    }
    
    
}
