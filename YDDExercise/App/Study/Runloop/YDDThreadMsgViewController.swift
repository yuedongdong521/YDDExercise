//
//  YDDThreadMsgViewController.swift
//  YDDExercise
//
//  Created by ydd on 2021/3/26.
//  Copyright © 2021 ydd. All rights reserved.
//

import UIKit

let kMsgId = 101

class MyWorkClass: NSObject {
    
    var remotePort: NSMachPort?
    
    var myPort: NSMachPort = NSMachPort.init(machPort: 1)
    
    @objc func launchThreadWithPort(prot: NSMachPort) {
        autoreleasepool { [weak self]  in
            guard let self = self else {
                return
            }
            
            self.remotePort = prot
            Thread.current.name = "my work class"
            
            SwiftLog("launchThreadWithPort : cur Thread \(Thread.current)")
            
            RunLoop.current.add(self.myPort, forMode: .default)
            
            sendPortMessage()
            
            RunLoop.current.run()
            
        }
    }
    
    func sendPortMessage() {
        
        let arr = [1, 2]
        self.remotePort?.send(before: Date(), components: arr as? NSMutableArray, from: self.myPort, reserved: kMsgId)
        
    }
    
    
}

extension MyWorkClass: NSMachPortDelegate {
    func handleMachMessage(_ msg: UnsafeMutableRawPointer) {
        SwiftLog("MyWorkClass : \(msg)")
    }
}




class YDDThreadMsgViewController: YDDBaseViewController {

    lazy var myPory: NSMachPort = {
        let pory = NSMachPort(machPort: 0)
        pory.setDelegate(self)
        return pory
    }()
    
    var myWork: MyWorkClass = MyWorkClass()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navBarView.leftBlock = {[weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        threadMsg()
        
    }
    
    func threadMsg() {
        RunLoop.current.add(self.myPory, forMode: .common)
        
        Thread.detachNewThreadSelector(#selector(launchThreadWithPort:), toTarget: self, with: self.myPory)
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

extension YDDThreadMsgViewController: NSMachPortDelegate {
    
    func handleMachMessage(_ msg: UnsafeMutableRawPointer) {
        print(msg)
    }
    
}
