//
//  YDDStringExtend.swift
//  YDDExercise
//
//  Created by ydd on 2021/3/11.
//  Copyright © 2021 ydd. All rights reserved.
//

import Foundation

extension String {
    
    subscript(index: Int) -> String {
        if index >= self.count || index < 0 {
            return ""
        }
        let i = self.index(self.startIndex, offsetBy: index)
        return String(self[i])
    }
    
    subscript(range: Range<Int>) -> String {
        guard let m = range.max(), m < self.count else {
            return ""
        }
        
        let start = self.index(self.startIndex, offsetBy: max(range.lowerBound, 0))
        let end = self.index(self.startIndex, offsetBy: min(range.upperBound, self.count))
        return String(self[start...end])
    }
    
    subscript(location: Int, lenght: Int) -> String {
        let m = lenght + location - 1
        if location < 0 || m >= self.count {
            return ""
        }
       
        let start = self.index(self.startIndex, offsetBy: location)
        let end = self.index(self.startIndex, offsetBy: m)
        return String(self[start...end])
    }
    
    mutating func order() -> String {
        var a = ""
        let count = self.count
        
        for i in 0..<count {
            a.insert(self[self.index(self.startIndex, offsetBy: i)], at: a.startIndex)
        }
        return a
    }
    
}
