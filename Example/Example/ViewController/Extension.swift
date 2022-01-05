//
//  Extension.swift
//  Example
//
//  Created by William.Weng on 2022/1/4.
//

import UIKit

// MARK: - Collection (override class function)
extension Collection {

    /// [為Array加上安全取值特性 => nil](https://stackoverflow.com/questions/25329186/safe-bounds-checked-array-lookup-in-swift-through-optional-bindings)
    subscript(safe index: Index) -> Element? { return indices.contains(index) ? self[index] : nil }
}

// MARK: - Collection (class function)
extension Collection where Self.Element: UIControl {
    
    /// 被選到的UIControl (單選)
    /// - Parameter index: Self.Index
    func _isSelected(at index: Self.Index) {
        
        guard let selectedButton = self[safe: index] else { return }
        
        self.forEach { button in button.isSelected = false }
        selectedButton.isSelected = true
    }
}

// MARK: - NSNumber (static function)
extension NSNumber {
    
    /// 轉換小數點有效位數 (四捨五入)
    /// - 123.456789._decimalPoint(2) => 123.46
    /// - Parameter decimal: 要轉換的小數位數
    /// - Returns: NSString
    static func _decimalPoint(number: NSNumber, decimal: UInt) -> NSString {
        
        let format = "%.\(decimal)f"
        let string = String(format: format, number.doubleValue)
        
        return (string as NSString)
    }
}

// MARK: - Double (class function)
extension Double {
    
    /// 轉換小數點有效位數 (四捨五入)
    /// - 123.456789._decimalPoint(2) => 123.46
    /// - Parameter decimal: 要轉換的小數位數
    /// - Returns: NSString
    func _decimalPoint(_ decimal: UInt) -> Double {
        return NSNumber._decimalPoint(number: NSNumber(value: self), decimal: decimal).doubleValue
    }
}

// MARK: - CGFloat (class function)
extension CGFloat {
    
    /// 轉換小數點有效位數 (四捨五入)
    /// - 123.456789._decimalPoint(2) => 123.46
    /// - Parameter decimal: 要轉換的小數位數
    /// - Returns: NSString
    func _decimalPoint(_ decimal: UInt) -> CGFloat {
        return CGFloat(Double(self)._decimalPoint(decimal))
    }
}
