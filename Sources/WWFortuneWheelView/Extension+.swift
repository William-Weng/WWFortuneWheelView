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

// MARK: - CGFloat (class function)
extension CGFloat {
    
    /// 180° => π
    func _radian() -> CGFloat { return (self / 180.0) * CGFloat.pi }
    
    /// π => 180°
    func _angle() -> CGFloat { return self * (180.0 / CGFloat.pi) }
}

extension Double {
    
    /// 180° => π
    func _radian() -> Double { return (self / 180.0) * Double.pi }
    
    /// π => 180°
    func _angle() -> Double { return self * (180.0 / Double.pi) }
}

// MARK: - CGPoint (static function)
extension CGPoint {
    
    /// [產生錨點的設定值](https://kittenyang.com/anchorpoint/)
    /// - Parameter position: AnchorPointPosition
    /// - Returns: CGPoint
    static func _anchorPoint(at position: Constant.AnchorPointPosition) -> CGPoint {
        return position.value()
    }
}

