//
//  OC&SwiftRuntime.swift
//  YDDExercise
//
//  Created by ydd on 2021/3/24.
//  Copyright © 2021 ydd. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

extension NSObject {
    static func swapStaticMethod(oldSel: Selector, newSel: Selector) -> Bool {
        let cls: AnyClass? = object_getClass(self)
        
        guard let originMethod = class_getInstanceMethod(cls, oldSel) else {
            return false
        }
        
        guard let newMethod = class_getInstanceMethod(cls, newSel)  else {
            return false
        }
        
        method_exchangeImplementations(originMethod, newMethod)
        
        return true
    }
    
    static func swapInstancelMethod(oldSel: Selector, newSel: Selector) -> Bool {
    
        guard let originalMethod = class_getInstanceMethod(self, oldSel) else {
            return false
        }
        
        guard let oldIMP = class_getMethodImplementation(self, oldSel) else {
            return false
        }
        
        guard let newMethod = class_getInstanceMethod(self, newSel) else {
            return false
        }
        
        guard let newIMP = class_getMethodImplementation(self, newSel) else {
            return false
        }
       
        let oldPointer = method_getTypeEncoding(originalMethod)
        
        class_addMethod(self, oldSel, oldIMP, oldPointer)
        
        let newPointer = method_getTypeEncoding(newMethod)
        
        class_addMethod(self, newSel, newIMP, newPointer)
    
        return true
    }
}



class SwiftRuntimeClass {
    
    var name = "Swift Runtime"
    
    var des = "纯swift类 runtime"
    
    @objc var objPro = "@objc修饰"
    
    func testFunction() {
        SwiftLog("纯swift 类 方法调用")
    }
    
    @objc func testSwiftObjFunction() {
        SwiftLog("纯swift类使用@objc修饰")
    }
    
    @objc static func testStaticFunction() {
        SwiftLog("纯swift类 类方法")
    }
}

class OCRuntimeClass: NSObject {
    
    var name = "oc runtime"
    
    var des = "swift中的oc类 runtime"
    
    @objc var objPro = "@objc修饰"
    
    func ocFunction()  {
        SwiftLog("swift 中的oc类 方法调用")
    }
    
    @objc func testOCObjFunction() {
        SwiftLog("swift继承oc类使用@objc修饰")
        
       
    }
}




class OCSwiftRuntimeVC: YDDBaseViewController  {
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        
        setupNavigation()
        
        let swiftBtn = UIButton(type: .system)
        swiftBtn.setTitle("Swift Runtime", for: .normal)
        self.view.addSubview(swiftBtn)
        
        swiftBtn.snp.makeConstraints { (make) in
            make.top.equalTo(self.navBarView.snp_bottom).offset(20)
            make.left.equalTo(20)
            make.width.equalTo(180)
            make.height.equalTo(40)
        }
        
        swiftBtn.rx.tap.subscribe(onNext:  { [weak self] in
            self?.showClassRuntime(cls: SwiftRuntimeClass.self)
        }).disposed(by: disposeBag)

        
        let ocBtn = UIButton(type: .system)
        ocBtn.setTitle("OC Runtime", for: .normal)
        self.view.addSubview(ocBtn)
        
        ocBtn.snp.makeConstraints { (make) in
            make.top.equalTo(swiftBtn.snp_bottom).offset(20)
            make.left.equalTo(20)
            make.width.equalTo(180)
            make.height.equalTo(40)
        }
        
        ocBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.showClassRuntime(cls: OCRuntimeClass.self)
        }).disposed(by: disposeBag)

        
    }
    
    private func setupNavigation() {
        self.navBarView.leftBlock = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    /**
     不管是纯swift类还是继承oc的swift类 只有@objc修饰的属性和方法才能通过runtime获得
     */
    func showClassRuntime(cls: AnyClass) {
        
        SwiftLog("获取方法列表开始")
        var methodNum: UInt32 = 0
        let methodList: UnsafeMutablePointer<objc_property_t>! = class_copyMethodList(cls, &methodNum)
        for index in 0..<numericCast(methodNum) {
            let method: Method = methodList[index]
            if let methodName: String = String(utf8String: property_getName(method)) {
                SwiftLog("方法名： " + methodName)
            }
        }
        SwiftLog("获取方法列表结束")
        
        free(methodList)
        
        SwiftLog("获取属性列表开始")
        var propertyNum: UInt32 = 0
        let propertyList: UnsafeMutablePointer<objc_property_t>! = class_copyPropertyList(cls, &propertyNum)
        for index in 0..<numericCast(propertyNum) {
            let property: objc_property_t = propertyList[index]
            if let proName: String = String(utf8String: property_getName(property)) {
                SwiftLog("属性名： " + proName)
            }
        }
        SwiftLog("获取属性列表结束")
        free(propertyList)
        
    }
    
    
    
}
