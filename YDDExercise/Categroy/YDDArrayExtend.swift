//
//  YDDArrayExtend.swift
//  YDDExercise
//
//  Created by ydd on 2021/3/12.
//  Copyright © 2021 ydd. All rights reserved.
//

import Foundation

enum ArrayOrderType {
    /// 无序， 降序， 升序
    case disOrder, desc, aesc
}

extension Array where Element: Comparable {
    mutating func bublleSort(desc isDesc: Bool = false) {
        let count = self.count
        for i in 0..<(count - 1) {
            for j in 0..<(count - i - 1) {
                if isDesc {
                    if self[j] < self[j + 1] {
                        (self[j], self[j + 1]) = (self[j + 1], self[j])
                    }
                } else {
                    if self[j] > self[j + 1] {
                        (self[j], self[j + 1]) = (self[j + 1], self[j])
                    }
                }
            }
        }
    }
    
    mutating func selectSort(desc isDesc: Bool = false) {
        let count = self.count
        for i in 0..<(count - 1) {
            for j in (i + 1)..<count {
                if isDesc {
                    if self[i] < self[j] {
                        (self[i], self[j]) = (self[j], self[i])
                    }
                } else {
                    if self[i] > self[j] {
                        (self[i], self[j]) = (self[j], self[i])
                    }
                }
            }
        }
    }
    
    mutating func fastSort(desc isDesc: Bool = false) {
        
        func fastSort(low: Int, high: Int) {
            guard low < high else {
                return
            }
            var i = low + 1, j = low
            let key = self[low]
            
            while i <= high {
                if isDesc {
                    if self[i] > key {
                        j += 1
                        (self[i], self[j]) = (self[j], self[i])
                    }
                } else {
                    if self[i] < key {
                        j += 1
                        (self[i], self[j]) = (self[j], self[i])
                    }
                }
                i += 1
            }
            (self[low], self[j]) = (self[j], self[low])
            
            fastSort(low: j + 1, high: high)
            fastSort(low: low, high: j - 1)
        }
        fastSort(low: 0, high: self.count - 1)
    }
    
    mutating func checkSort() -> ArrayOrderType {
        let count = self.count
        var desc = true, aesc = true
        for i in 0..<(count - 1) {
            if desc && self[i] < self[i+1] {
                desc = false
            }
            if aesc && self[i] > self[i+1] {
                aesc = false
            }
            
            if !desc && !aesc {
                break
            }
        }
        if desc {
            return .desc
        }
        if aesc {
            return .aesc
        }
        return .disOrder
    }
    
    /// 二分法查找有序数组
    mutating func selected(obj: Element) -> Int {
        
        let count = self.count - 1
        if count < 0 {
            return -1
        }
        
        let order = checkSort()
        
        if order == .disOrder {
            return -1
        }
        
        if order == .aesc {
            if obj < self[0] || obj > self[count] {
                return -1
            }
        } else {
            if obj > self[0] || obj < self[count] {
                return -1
            }
        }
        
        
        func selecte(left: Int, right: Int) -> Int {
            let sum = left + right
            
            if sum > count {
                return -1
            }
            
            var mid = 0
            if sum % 2 == 0 {
                mid = sum / 2
            } else {
                mid = (sum + 1) / 2
            }
            
            if obj == self[mid] {
                return mid
            }
            
            if mid == right {
                if obj == self[left] {
                    return left
                }
                return -1
            }
            
            if obj > self[mid] {
                if order == .desc {
                    return selecte(left: left, right: mid - 1)
                }
                return selecte(left: mid + 1, right: sum)
            }
            
            if order == .desc {
                return selecte(left: mid + 1, right: sum)
            }
            return selecte(left: left, right: mid - 1)
        }
        
        return selecte(left: 0, right: count)
    }
    
    /// 降序数组二分大查找
    mutating func aescSelected(obj: Element) -> Int {
    
        var min = 0, max = self.count - 1, mid = 0
        
        while min <= max {
            mid = (mid + max) / 2
            if obj > self[mid] {
                min = mid + 1
            } else if obj < self[mid] {
                max = mid - 1
            } else {
                return mid
            }
        }
        return -1
    }
    
    /// 合并升序序数组
    mutating func merge(otherArr arr: Array<Element>, order type: ArrayOrderType = .aesc) -> Array<Element> {
        
        var r = Array<Element>()
        
        let aCount = self.count, bCount = arr.count
        
        var a = 0, b = 0
        
        while a < aCount && b < bCount {
            if type == .aesc {
                if self[a] < arr[b] {
                    r.append(self[a])
                    a += 1
                } else {
                    r.append(arr[b])
                    b += 1
                }
            } else {
                if self[a] > arr[b] {
                    r.append(self[a])
                    a += 1
                } else {
                    r.append(arr[b])
                    b += 1
                }
            }
        }
        
        if a < aCount {
            r += self[a..<aCount]
        }
        
        if b < bCount {
            r += arr[b..<bCount]
        }
        return r
    }
    
    /// 数组去重
    mutating func disRepeatDic() -> Array<Element> {

        var arr = Array<Element>()
        let count = self.count
        for i in 0..<count {
            let v = self[i]
            if !arr.contains(v) {
                arr.append(v)
            }
        }
        return arr
    }
    
    
}
