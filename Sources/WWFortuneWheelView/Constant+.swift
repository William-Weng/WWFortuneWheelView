//
//  Constant.swift
//  WWFortuneWheelView
//
//  Created by William.Weng on 2022/1/3.
//

import UIKit

// MARK: - Utility (單例)
final class Constant: NSObject {}

// MARK: - typealias
extension Constant {
    
    /// [錨點的位置](https://kittenyang.com/anchorpoint/)
    enum AnchorPointPosition {
        
        case leftTop
        case left
        case leftBottom
        case centerTop
        case center
        case centerBottom
        case rightTop
        case right
        case rightBottom
        
        /// 產生數值
        /// - Returns: CGPoint
        func value() -> CGPoint {
            switch self {
            case .leftTop: return CGPoint(x: 0.0, y: 0.0)
            case .left: return CGPoint(x: 0.0, y: 0.5)
            case .leftBottom: return CGPoint(x: 0.0, y: 1.0)
            case .centerTop: return CGPoint(x: 0.5, y: 0.0)
            case .center: return CGPoint(x: 0.5, y: 0.5)
            case .centerBottom: return CGPoint(x: 0.5, y: 1.0)
            case .rightTop: return CGPoint(x: 1.0, y: 0.0)
            case .right: return CGPoint(x: 1.0, y: 0.5)
            case .rightBottom: return CGPoint(x: 1.0, y: 1.0)
            }
        }
    }
}
