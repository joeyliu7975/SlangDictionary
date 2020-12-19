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
    
    let progressMaker: ProgressBarMaker = .init()
    
    private lazy var startLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 60, height: 30))
        
        label.text = "Start"
        
        label.textColor = .black
        
        label.textAlignment = .center
        
        label.font = UIFont.boldSystemFont(ofSize: 24)
        
        return label
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()

        progressMaker.resetProgressBar()

    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func renderUI(title: String) {
        
        challengLabel.text = title
        
    }

    @objc private func handleTap() {
        
        progressMaker.startDrawing(keyPath: "strokeEnd", value: 0.5, duration: 2, fillMode: .forwards, isRemoveOnCompletion: false, progressBarKey: "urSoBasic")
        
        changeLabel()
    }
}

extension UserTableViewCell {

    func drawDiscoveryTracker() {
        
        self.layoutSubviews()
        
        progressMaker.setupProgressBar(position: contentView.center, on: self)
        
        addLabel()
        
        progressionBarContainerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    func addLabel() {
        
        startLabel.center = contentView.center
        
        self.layer.addSublayer(startLabel.layer)
    }
    
    func changeLabel() {
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.75, delay: 0.0, options: .curveEaseIn) {
            
            self.startLabel.alpha = 0
            
        } completion: { (_) in
            
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 1, delay: 0.8, options: .curveEaseOut) {
                
                self.startLabel.text = "50%"
                
                self.startLabel.alpha = 1
            }
        }
    }
}
