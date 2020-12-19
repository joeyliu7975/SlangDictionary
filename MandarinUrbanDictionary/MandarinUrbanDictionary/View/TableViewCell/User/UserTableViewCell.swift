//
//  UserTableViewCell.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 12/18/20.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    
    static let reusableIdentifier = String(describing: UserTableViewCell.self)
    
    @IBOutlet weak var challengLabel: UILabel!
    
    @IBOutlet weak var progressionBarContainerView: UIView!
    
    let shapeLayer: CAShapeLayer = .init()
    
    let trackLayer: CAShapeLayer = .init()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        trackLayer.removeFromSuperlayer()
        
        shapeLayer.removeFromSuperlayer()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        drawDiscoveryTracker()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func renderUI(title: String) {
        
        challengLabel.text = title
        
    }

    @objc private func handleTap() {
        
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        
        basicAnimation.toValue = 0.5
        
        basicAnimation.duration = 2
        
        basicAnimation.fillMode = .forwards
        
        basicAnimation.isRemovedOnCompletion = false
        
        shapeLayer.add(basicAnimation, forKey: "urSoBasic")
    }
}

extension UserTableViewCell {

    func drawDiscoveryTracker() {
        
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 100, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        
        trackLayer.path = circularPath.cgPath
        
        trackLayer.strokeColor = UIColor.lightGray.cgColor
        
        trackLayer.lineWidth = 10
        
        trackLayer.fillColor = UIColor.clear.cgColor
        
        trackLayer.lineCap = .round
        
        trackLayer.position = contentView.center
                
        shapeLayer.path = circularPath.cgPath
        
        shapeLayer.strokeColor = UIColor.red.cgColor
        
        shapeLayer.lineWidth = 10
        
        shapeLayer.lineCap = .round
        
        shapeLayer.fillColor = UIColor.clear.cgColor
        
        shapeLayer.strokeEnd = 0
        
        shapeLayer.position = contentView.center
        
        shapeLayer.transform = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1)
        
        self.layer.addSublayer(trackLayer)
        
        self.layer.addSublayer(shapeLayer)
        
        progressionBarContainerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
}
