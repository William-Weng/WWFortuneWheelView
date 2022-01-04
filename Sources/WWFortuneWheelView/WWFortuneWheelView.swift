//
//  WWFortuneWheelView.swift
//  WWFortuneWheelView
//
//  Created by William.Weng on 2022/01/01.
//

import Foundation
import UIKit

@IBDesignable
open class WWFortuneWheelView: UIView {
    
    typealias RotationParameter = (radian: CGFloat, deltaRadian: CGFloat, transform: CGAffineTransform)
    
    @IBInspectable public var count: Int = 4
    @IBInspectable public var buttonSize: CGSize = CGSize(width: 36, height: 36)
    @IBInspectable public var buttonPoint: CGPoint = CGPoint(x: 0, y: 0)
    @IBInspectable public var fontSize: CGFloat = 12.0
    @IBInspectable public var wheelImage: UIImage = UIImage()
    @IBInspectable public var isVerticalDisplay: Bool = false

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var wheelView: UIView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    public weak var myDelegate: WWFortuneWheelViewDelegate?
    public var bullseyeButtons: [UIButton] = []
    
    private let animationDuration: TimeInterval = 0.5
    
    private var currentIndex = 0
    private var initialRotationParameter: RotationParameter = (.zero, .zero, .identity)
    private var bullseyeButtonTransforms: [CGAffineTransform] = []
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        initViewFromXib()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initViewFromXib()
    }
    
    override public func draw(_ rect: CGRect) {
        bullseyeButtonsCountSetting(with: count, buttonSize: buttonSize, buttonPoint: buttonPoint, fontSize: fontSize, wheelImage: wheelImage, isVerticalDisplay: isVerticalDisplay)
        #if TARGET_INTERFACE_BUILDER
        #endif
    }
    
    /// [預覽用](https://stackoverflow.com/questions/46723683/ib-designables-failed-to-render-and-update-auto-layout-status)
    override public func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        contentView.prepareForInterfaceBuilder()
    }
}

// MARK: Override UIResponder / UITouch
public extension WWFortuneWheelView {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) { recordInitialRotationParameter(touches, with: event) }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) { rotateWheel(touches, with: event, isVerticalDisplay: isVerticalDisplay) }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) { fixRotationWheel(touches, with: event, isVerticalDisplay: isVerticalDisplay) }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) { touchesEnded(touches, with: event) }
}

// MARK: UIResponder / UITouch
private extension WWFortuneWheelView {
    
    /// [記錄一開始的數值](https://stackoverflow.com/questions/45402639/pinch-pan-and-rotate-text-simultaneously-like-snapchat-swift-3)
    /// - Parameters:
    ///   - touches: [Set<UITouch>](https://blog.csdn.net/totogo2010/article/details/8615940)
    ///   - event: [UIEvent?](https://www.jianshu.com/p/dbb05bdccf18)
    func recordInitialRotationParameter(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touche = touches.first else { return }
        
        initialRotationParameter = rotationParameterMaker(with: touche, rotationView: wheelView)
        bullseyeButtonTransforms = wheelButtonsStartTransformsMaker(bullseyeButtons)
        
        let rotatingAngle = convertRotatingAngle(with: initialRotationParameter)
        
        myDelegate?.willRotate(self, unitAngle: unitAngleMaker(with: count), startAngle: rotatingAngle)
    }
    
    /// 旋轉底圖
    /// - Parameters:
    ///   - touches: Set<UITouch>
    ///   - event: UIEvent?
    func rotateWheel(_ touches: Set<UITouch>, with event: UIEvent?, isVerticalDisplay: Bool) {
        
        guard let touche = touches.first else { return }
        
        let parameter = rotationParameterMaker(with: touche, rotationView: wheelView)
        let nextIndex = indexMaker(with: count, radian: parameter.radian)
        let deltaRadian = parameter.deltaRadian - initialRotationParameter.deltaRadian
        let rotatingAngle = convertRotatingAngle(with: parameter)
        
        rotateWheelView(with: deltaRadian, isVerticalDisplay: isVerticalDisplay)
        myDelegate?.rotating(self, from: currentIndex, to: nextIndex, angle: rotatingAngle)
    }
    
    /// [Touch完成後，修正輪子的角度 => 記錄Index](https://www.appcoda.com.tw/view-animation-in-swift/)
    /// - Parameters:
    ///   - touches: [Set<UITouch>](https://medium.com/彼得潘的-swift-ios-app-開發問題解答集/ios-app-動畫建議使用-uiviewpropertyanimator-別再用-uiview-animate-a868c579abb5)
    ///   - event: UIEvent?
    func fixRotationWheel(_ touches: Set<UITouch>, with event: UIEvent?, isVerticalDisplay: Bool) {
        
        guard let touche = touches.first else { return }
        
        let parameter = rotationParameterMaker(with: touche, rotationView: wheelView)
        let nextIndex = indexMaker(with: count, radian: parameter.radian)
        let nextAngle = Double(currentIndex - nextIndex) * unitAngleMaker(with: count)
                
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: animationDuration, delay: .zero, options: [.curveEaseIn]) {
            self.rotateWheelView(with: nextAngle._radian(), isVerticalDisplay: self.isVerticalDisplay)
            self.myDelegate?.autoRotated(self, from: self.currentIndex, to: nextIndex, duration: self.animationDuration)
        } completion: { postion in
            let angle = Double(nextIndex) * self.unitAngleMaker(with: self.count)
            self.currentIndex = nextIndex
            self.myDelegate?.didRotated(self, at: nextIndex, angle: angle)
        }
    }
}

// MARK: - 小工具
private extension WWFortuneWheelView {
    
    /// 讀取Nib畫面 => 加到View上面
    func initViewFromXib() {
        
        let bundle = Bundle.module
        let name = String(describing: Self.self)
        
        bundle.loadNibNamed(name, owner: self, options: nil)
        contentView.frame = bounds
        
        addSubview(contentView)
    }
    
    /// 滾輪相關設定
    /// - Parameters:
    ///   - count: 滾輪上的按鍵數量
    ///   - buttonSize: 按鍵大小
    ///   - fontSize: 文字大小
    ///   - isVerticalDisplay: 滾輪按鍵是否要跟著轉？
    ///   - buttonPoint: 按鍵的位置
    ///   - wheelImage: 滾輪的底圖
    func bullseyeButtonsCountSetting(with count: Int, buttonSize: CGSize = CGSize(width: 36, height: 36), buttonPoint: CGPoint = .zero, fontSize: CGFloat = 12.0, wheelImage: UIImage, isVerticalDisplay: Bool = true) {
        
        self.count = count
        self.buttonSize = buttonSize
        self.buttonPoint = buttonPoint
        self.isVerticalDisplay = isVerticalDisplay
        self.wheelImage = wheelImage
        self.fontSize = fontSize
        self.backgroundImageView.image = self.wheelImage
        
        let bullseyeButtons = (0...count - 1).map { index -> UIButton in
            
            let angle = angleMaker(with: count, for: index)
            let label = wheelLabelMaker(with: buttonSize.width, tag: index, angle: angle)
            let button = wheelButtonMaker(with: index, size: buttonSize, fontSize: fontSize, origin: buttonPoint, angle: angle, isVerticalDisplay: isVerticalDisplay)
            
            label.addSubview(button)
            wheelView.addSubview(label)
            
            return button
        }
        
        self.bullseyeButtons = bullseyeButtons
    }
    
    /// [產生滾輸桿子的Label => 錨點 + 旋轉 + 能被點到 + 背景透明](https://stackoverflow.com/questions/10181255/drag-rotation-using-uipangesturerecognizer-touch-getting-off-track)
    /// - Parameters:
    ///   - size: CGSize
    ///   - tag: Int
    ///   - angle: CGFloat
    /// - Returns: UILabel
    func wheelLabelMaker(with width: CGFloat, tag: Int, angle: CGFloat) -> UILabel {
        
        let size = CGSize(width: width, height: wheelLabelRadius())
        let label = labelMaker(with: size, tag: tag)
        
        label.layer.anchorPoint = CGPoint._anchorPoint(at: .centerBottom)
        label.transform = CGAffineTransform(rotationAngle: angle._radian())
        
        return label
    }
    
    /// 計算出滾輸上的Button
    /// - Parameters:
    ///   - index: Int
    ///   - size: CGSize
    ///   - fontSize: CGFloat
    ///   - isVerticalDisplay: Bool
    ///   - angle: CGFloat
    ///   - origin: CGPoint
    /// - Returns: UIButton
    func wheelButtonMaker(with index: Int, size: CGSize, fontSize: CGFloat = 12.0, origin: CGPoint, angle: CGFloat, isVerticalDisplay: Bool) -> UIButton {
        
        let button = UIButton(frame: CGRect(origin: origin, size: size))
        
        button.tag = index
        button.setTitle("\(index)", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        
        if (isVerticalDisplay) { button.transform = button.transform.rotated(by: -angle._radian()) }
        
        return button
    }
    
    /// [產生Label](https://itisjoe.gitbooks.io/swiftgo/content/uikit/uilabel.html)
    /// - Parameters:
    ///   - size: [CGSize](https://medium.com/彼得潘的-swift-ios-app-開發教室/研究顯示文字的-uilabel-2987d7e9909f)
    ///   - tag: Int
    /// - Returns: UILabel
    func labelMaker(with size: CGSize, tag: Int) -> UILabel {
        
        let label = UILabel(frame: CGRect(origin: .zero, size: size))
        
        label.tag = tag
        label.text = tag.description
        label.textColor = .clear
        label.backgroundColor = .clear
        label.center = contentView.center
        label.textAlignment = .center
        label.isUserInteractionEnabled = true

        return label
    }
    
    /// 取得最適合的半徑
    /// - Returns: CGFloat
    func wheelLabelRadius() -> CGFloat {
        return min(contentView.bounds.height, contentView.bounds.width) / 2.0
    }

    /// [算出平均的角度 for index => 360°/數量](https://www.raywenderlich.com/2953-how-to-create-a-rotating-wheel-control-with-uikit)
    /// - Parameters:
    ///   - count: Int
    ///   - index: Int
    /// - Returns: Double
    func angleMaker(with count: Int, for index: Int) -> Double {
        return Double(index) * unitAngleMaker(with: count)
    }
    
    /// [算出平均的單位角度 => 360°/數量](https://www.raywenderlich.com/2953-how-to-create-a-rotating-wheel-control-with-uikit)
    /// - Parameter count: Int
    /// - Returns: Double
    func unitAngleMaker(with count: Int) -> Double {
        return 360.0 / Double(count)
    }
    
    /// [由角度去推算Index => ∵反轉 ∴加負號](https://www.jianshu.com/p/a041416056e4)
    /// - Parameter radian: [弧度](https://gan.wikipedia.org/wiki/弧度)
    /// - Returns: [Int](https://www.hangge.com/blog/cache/detail_708.html#:~:text=lroundf是一个全局函数，作用是将浮点数四舍五入转为整数。 1 var i %3D lroundf (23.50),上一篇 Swift - 让StoryBoard设计视图，程序运行时都使用横屏形式 下一篇 Swift - 使用xib添加新界面)
    func indexMaker(with count: Int, radian: CGFloat) -> Int {
        
        let averageAngle = -radian._angle() / unitAngleMaker(with: count)
        var index = lroundf(Float(averageAngle)) % count
        
        if (index < 0) { index += count }
        
        return index
    }
}

// MARK: - 小工具
private extension WWFortuneWheelView {
    
    /// [旋轉滾輪 - wheelView](https://www.raywenderlich.com/2953-how-to-create-a-rotating-wheel-control-with-uikit)
    /// - Parameters:
    ///   - radian: [CGFloat](https://medium.com/weeronline/swift-transforms-5981398b437d)
    ///   - isVerticalWord: Bool
    func rotateWheelView(with radian: CGFloat, isVerticalDisplay: Bool) {
        wheelView.transform = initialRotationParameter.transform.rotated(by: radian)
        if (isVerticalDisplay) { antiRotateButton(with: radian) }
    }
    
    /// 讓按鍵反轉，讓文字一直是垂直的
    func antiRotateButton(with radian: CGFloat) {
        
        for (index, button) in bullseyeButtons.enumerated() {
            guard let transform = bullseyeButtonTransforms[safe: index] else { return }
            button.transform = transform.rotated(by: -radian)
        }
    }
    
    /// 紀錄滾輪上按鈕的初始值
    /// - Parameter buttons: [UIButton]
    /// - Returns: [CGAffineTransform]
    func wheelButtonsStartTransformsMaker(_ buttons: [UIButton]) -> [CGAffineTransform] {
        
        var transforms: [CGAffineTransform] = []
        for button in buttons { transforms.append(button.transform) }
        
        return transforms
    }
    
    /// [計算旋轉View時所需的參數](https://medium.com/weeronline/swift-transforms-5981398b437d)
    /// - Parameters:
    ///   - touch: [UITouch](https://www.jianshu.com/p/dbb05bdccf18)
    ///   - wheelView: [UIView](https://www.jianshu.com/p/4285c26f1d2c)
    /// - Returns: [RotationParameter](https://www.jianshu.com/p/a041416056e4)
    func rotationParameterMaker(with touch: UITouch, rotationView: UIView) -> RotationParameter {
        
        let touchPoint = touch.location(in: self)
        let (dx, dy) = (touchPoint.x - rotationView.center.x, touchPoint.y - rotationView.center.y)
        
        let rotationParameter: RotationParameter = (
            radian: atan2(rotationView.transform.b, rotationView.transform.a),
            deltaRadian: atan2(dy, dx),
            transform: rotationView.transform
        )
        
        return rotationParameter
    }
    
    /// 旋轉角度轉換 => ∵ 實際上是反轉 ∴ 要變換成肉眼看到的角度
    /// - Parameter parameter: RotationParameter
    /// - Returns: CGFloat
    private func convertRotatingAngle(with parameter: RotationParameter) -> CGFloat {
        let rotatingAngle = (parameter.radian < 0) ? -parameter.radian._angle() : -parameter.radian._angle() + 360.0
        return rotatingAngle
    }
}
