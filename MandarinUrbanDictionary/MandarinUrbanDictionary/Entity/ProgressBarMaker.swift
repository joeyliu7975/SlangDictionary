//
//  ProgressBarMaker.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 12/19/20.
//

import UIKit

class ProgressBarMaker {
    
    let circularPath: UIBezierPath
    
    init(circularPath: UIBezierPath = .init(arcCenter: .zero, radius: 100, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)) {
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
    
    func setupProgressBar(position: CGPoint, on view: UIView) {
            
        trackLayer.path = circularPath.cgPath
        
        trackLayer.position = position
        
        view.layer.addSublayer(trackLayer)
        
        shapeLayer.path = circularPath.cgPath
        
        shapeLayer.position = position
        
        shapeLayer.transform = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1)
        
        view.layer.addSublayer(shapeLayer)
    }
    
    func startDrawing(keyPath: String, value: CGFloat, duration: CFTimeInterval, fillMode: CAMediaTimingFillMode, isRemoveOnCompletion: Bool, progressBarKey key: String) {

        let basicAnimation = CABasicAnimation(keyPath: keyPath)

        basicAnimation.toValue = value

        basicAnimation.duration = duration

        basicAnimation.fillMode = fillMode

        basicAnimation.isRemovedOnCompletion = isRemoveOnCompletion

        shapeLayer.add(basicAnimation, forKey: key)
    }
    
    func resetProgressBar() {
        trackLayer.removeFromSuperlayer()
        
        shapeLayer.removeFromSuperlayer()
    }
}
