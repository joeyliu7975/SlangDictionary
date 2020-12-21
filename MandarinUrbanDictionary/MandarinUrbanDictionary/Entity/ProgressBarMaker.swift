//
//  ProgressBarMaker.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 12/19/20.
//

import UIKit

class ProgressBarMaker {
    
    let circularPath: UIBezierPath
    
     var updateTimer : Timer?
    
     var currentValue: CGFloat?
    
     var maxValue: CGFloat?
    
    init(circularPath: UIBezierPath = .init(
            arcCenter: .zero,
            radius: 100,
            startAngle: 0,
            endAngle: 2 * CGFloat.pi,
            clockwise: true
    )) {
        self.circularPath = circularPath
    }
    
    private lazy var trackLayer: CAShapeLayer = {
       
        let trackLayer = CAShapeLayer()

        trackLayer.strokeColor = UIColor.lightGray.cgColor
       
        trackLayer.lineWidth = 10
       
        trackLayer.fillColor = UIColor.clear.cgColor
       
        trackLayer.lineCap = .round
        
        return trackLayer
    }()
    
    private lazy var shapeLayer: CAShapeLayer = {
       
        let shapeLayer = CAShapeLayer()
        
        shapeLayer.strokeColor = UIColor.red.cgColor
        
        shapeLayer.lineWidth = 10
        
        shapeLayer.lineCap = .round
        
        shapeLayer.fillColor = UIColor.clear.cgColor
        
        shapeLayer.strokeEnd = 0
        
        return shapeLayer
    }()
    
    func setBarColor(_ color: UIColor) {
        
        shapeLayer.strokeColor = color.cgColor
        
    }
    
    func setBarPosition(at position: CGPoint, on view: UIView) {
            
        trackLayer.path = circularPath.cgPath
        
        trackLayer.position = position
        
        shapeLayer.path = circularPath.cgPath
        
        shapeLayer.position = position
        
        shapeLayer.transform = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1)
        
        view.layer.addSublayer(trackLayer)
        
        view.layer.addSublayer(shapeLayer)
    }
    
    func updateProgress(to value: CGFloat) {
        shapeLayer.strokeEnd = value
    }
    
    func resetProgressBar() {
        trackLayer.removeFromSuperlayer()
        
        shapeLayer.removeFromSuperlayer()
    }
}

// Timer and PercentageLabel

extension ProgressBarMaker {
    
    func resetTimer() {
        self.updateTimer?.invalidate()
        
        self.updateTimer = nil
        
        self.maxValue = nil
        
        self.currentValue = nil
    }
    
    func startTimer(to percentage: Int) {
        self.maxValue = CGFloat(percentage)
        
        self.currentValue = 0
        
        self.shapeLayer.strokeEnd = 0
    }
    
    func processing(startLabel: inout UILabel) {
        guard let currentValue = self.currentValue else { return }
        
        let valueForStrokeEnd = currentValue / 100
        
        self.shapeLayer.strokeEnd = valueForStrokeEnd
        
        startLabel.text = String(describing: Int(currentValue)) + "%"
        
        self.currentValue! += 1
    }
    
    var shouldStopTimer: Bool {
        guard
            let currentValue = self.currentValue,
            let maxValue = self.maxValue else { return true }
        
        return currentValue > maxValue 
    }
}
