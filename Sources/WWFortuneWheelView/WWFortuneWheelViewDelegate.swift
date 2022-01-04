//
//  WWFortuneWheelViewDelegate.swift
//  WWFortuneWheelView
//
//  Created by William.Weng on 2022/01/01.
//

import UIKit

public protocol WWFortuneWheelViewDelegate: AnyObject {
    
    func willRotate(_ wheelView: WWFortuneWheelView, unitAngle: CGFloat, startAngle: CGFloat)
    func rotating(_ wheelView: WWFortuneWheelView, from startIndex: Int, to endIndex: Int, angle: CGFloat)
    func autoRotated(_ wheelView: WWFortuneWheelView, from startIndex: Int, to endIndex: Int, duration: TimeInterval)
    func didRotated(_ wheelView: WWFortuneWheelView, at index: Int, angle: CGFloat)
}
