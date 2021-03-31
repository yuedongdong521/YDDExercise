//
//  YDDAlgorithmViewController.swift
//  YDDExercise
//
//  Created by ydd on 2021/3/12.
//  Copyright © 2021 ydd. All rights reserved.
//

import UIKit

class YDDAlgorithmViewController: YDDBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navBarView.leftBlock = {[weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        testString()
        
        testArr()
        
//        let arr = [3,2,1,5,6,4, 9, 8, 10, 7, 6]
        let arr = [2, 1]
        let k = findKthLargest2(arr, 2)
        print(k)
        
    }
    
    func testString() {
        let str = "0123456789"
        let a = str[2]
        let b = str[3..<6]
        
        let c = str[1, 7]
        print(" 字符串标签 a = \(a), b = \(b), c = \(c)")
        
        var o = "ydd"
        print("字符串 o : \(o.order())")
        
    }
    
    
    func testArr() {
        
        var a = 1, b = 2
        
        (a, b) = (b, a)
        
        SwiftLog("交换 a = \(a), b = \(b)")
        
        var arr1 = [1, 3, 2, 6, 8, 4, 5, 9, 7]
        arr1.bublleSort(desc: false)
        SwiftLog("冒泡 ： arr = \(arr1)")
        
        var arr2 = [1, 3, 2, 6, 8, 4, 5, 9, 7]
        arr2.selectSort(desc: false)
        SwiftLog("选择 ： arr = \(arr2)")
        
        var arr3 = [1, 3, 2, 6, 8, 4, 5, 9, 7]
        
        SwiftLog("arr3 原版： \(arr3.checkSort())")
        
        arr3.fastSort(desc: false)
        SwiftLog("快速 ： arr = \(arr3)")
        
        SwiftLog("arr3 排序后： \(arr3.checkSort())")
        
       
        SwiftLog("arr3 selected 3 : \(arr3.selected(obj: 3))")
        
        var arr4 = [1, 2]
        
        SwiftLog("arr4 selected 1 : \(arr4.selected(obj: 1))")
        
        var aArr = [1, 2, 3, 8]
        
        let bArr = [1, 4, 5, 6, 7, 8, 9]
        
        SwiftLog("merge arr : \(aArr.merge(otherArr: bArr))")
        
        var cArr = [3, 2, 1]
        let dArr = [7, 5, 4, 2]
        
        SwiftLog("merge2 arr : \(cArr.merge(otherArr: dArr, order: .desc))")
    }
    
    
    func findKthLargest(_ nums: [Int], _ k: Int) -> Int {
      
        let count = nums.count
        
        if k > count || k < 0 {
            return 0
        }
        
        if count == 1 {
            return nums[0]
        }
        var mutArr = nums
        
        for i in 0..<(count - 1) {
            for j in 0..<(count - i - 1) {
                if mutArr[j] > mutArr[j+1] {
                    (mutArr[j],mutArr[j+1]) = (mutArr[j+1], mutArr[j])
                }
            }
            if i == (k - 1) {
                print(mutArr)
                return mutArr[count - k]
            }
        }
        
        return mutArr[count - k]
    }
    
    
    func findKthLargest2(_ nums: [Int], _ k: Int) -> Int {
        
        let count = nums.count
        if k > count || k < 0 {
            return 0
        }
        var mutArr = Array<Int>()
        for i in 0..<count {
            let a = nums[i]
            let mutCount = mutArr.count
            if mutCount == 0 {
                mutArr.append(a)
            } else {
                let num = mutArr.count
                
                if num == k && a < mutArr[num - 1] {
                    continue
                }
                
                for i in 0..<num {
                    if a > mutArr[i] {
                        mutArr.insert(a, at: i)
                        break
                    }
                }
            }
                
            if mutArr.count < i + 1 {
                mutArr.append(a)
            }
            
            if mutArr.count > k {
                mutArr.removeLast()
            }
        }
        return mutArr[k - 1]
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
