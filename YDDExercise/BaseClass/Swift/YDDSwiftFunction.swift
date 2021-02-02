//
//  YDDSwiftFunction.swift
//  YDDExercise
//
//  Created by ydd on 2021/1/4.
//  Copyright © 2021 ydd. All rights reserved.
//

import Foundation

var SwiftScreenWidth: CGFloat {
    return UIScreen.main.bounds.size.width
}


var SwiftScreenHeight: CGFloat {
    return UIScreen.main.bounds.size.height
}

var SwiftIPhone: Bool {
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone
}

var SwiftIPhoneX: Bool {
    if !SwiftIPhone {
        return false
    }
    if #available(iOS 11.0, *) {
        guard let window = UIApplication.shared.delegate?.window, let unwrapedWindow = window else {
            return false
        }
        if unwrapedWindow.safeAreaInsets.left > 0 || unwrapedWindow.safeAreaInsets.bottom > 0 {
            print(unwrapedWindow.safeAreaInsets)
            return true
        }
    }
    return false
}

var SwiftNavHeight: CGFloat {
    return SwiftIPhoneX ? 88 : 64
}

var SwiftSafeBottom: CGFloat {
    return SwiftIPhoneX ? 34 : 0
}

extension UIView {
    func width() -> CGFloat {
        return self.bounds.size.width
    }
    func height() -> CGFloat {
        return self.bounds.size.height
    }
    
    func x() -> CGFloat {
        return self.frame.origin.x
    }
    
    func y() -> CGFloat {
        return self.frame.origin.y
    }
}

public func textFont(fontName name:String, fontSize size:CGFloat) -> UIFont {
    return UIFont(name: name, size: size) ?? UIFont.systemFont(ofSize: size)
}

public func textFont(fontSize size:CGFloat) -> UIFont {
    return textFont(fontName: "PingFangSC-Regular", fontSize: size)
}

public func textMediumFont(fontSize size:CGFloat) -> UIFont {
    return textFont(fontName: "PingFangSC-Medium", fontSize: size)
}

public func textThinFont(fontSize size:CGFloat) -> UIFont {
    return textFont(fontName: "PingFangSC-Thin", fontSize: size)
}

public func textLightFont(fontSize size:CGFloat) -> UIFont {
    return textFont(fontName: "PingFangSC-Light", fontSize: size)
}

public func textBoldFont(fontSize size:CGFloat) -> UIFont {
    return textFont(fontName: "PingFangSC-Semibold", fontSize: size)
}

public func textHelveticaBoldFont(fontSize size:CGFloat) -> UIFont {
    return textFont(fontName: "Helvetica-Bold", fontSize: size)
}

public func textArialBoldItalicMTFont(fontSize size:CGFloat) -> UIFont {
    return textFont(fontName: "Arial-BoldItalicMT", fontSize: size)
}

public func SwiftLog(_ logInfo: String, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
    
#if DEBUG
    let time = Date()

    let arr = file.components(separatedBy: "/")

    let fileName = arr.last ?? ""

    print("\(time): " + fileName + " " + function + " line \(line) : " + logInfo)
#endif
}
