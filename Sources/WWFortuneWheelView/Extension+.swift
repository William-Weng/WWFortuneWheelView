//
//  Extension+.swift
//  WWFortuneWheelView
//
//  Created by William.Weng on 2022/01/01.
//

import UIKit

// MARK: - Collection (override class function)
extension Collection {

    /// [為Array加上安全取值特性 => nil](https://stackoverflow.com/questions/25329186/safe-bounds-checked-array-lookup-in-swift-through-optional-bindings)
    subscript(safe index: Index) -> Element? { return indices.contains(index) ? self[index] : nil }
}

// MARK: - Collection (class function)
extension Collection where Self.Element: UIControl {
        
    /// 是否可以被按
    /// - Parameter isUserInteractionEnabled: Bool
    func _isUserInteractionEnabled(_ isUserInteractionEnabled: Bool) {
        self.forEach { button in button.isUserInteractionEnabled = isUserInteractionEnabled }
    }
}


// MARK: - Double (class function)
extension Double {
    
    /// 180° => π
    func _radian() -> Double { return (self / 180.0) * Double.pi }
    
    /// π => 180°
    func _angle() -> Double { return self * (180.0 / Double.pi) }
}

// MARK: - CGFloat (class function)
extension CGFloat {
    
    /// 180° => π
    func _radian() -> CGFloat { return (self / 180.0) * CGFloat.pi }
    
    /// π => 180°
    func _angle() -> CGFloat { return self * (180.0 / CGFloat.pi) }
}

// MARK: - CGPoint (static function)
extension CGPoint {
    
    /// CGPoint的減法
    /// - Parameters:
    ///   - lhs: CGPoint
    ///   - rhs: CGPoint
    /// - Returns: CGPoint
    static func -(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
    
    /// [產生錨點的設定值](https://kittenyang.com/anchorpoint/)
    /// - Parameter position: AnchorPointPosition
    /// - Returns: CGPoint
    static func _anchorPoint(at position: Constant.AnchorPointPosition) -> CGPoint {
        return position.value()
    }
}

// MARK: - CGPoint (class function)
extension CGPoint {
    
    /// [半徑 - 圓點 (0, 0)](https://zh.wikipedia.org/wiki/勾股定理)
    func _radius() -> CGFloat {
        return sqrt(self.x * self.x + self.y * self.y)
    }
}

