//
//  UserTableViewCell.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 12/18/20.
//

import UIKit

protocol UserTableViewCellDelegate: class {
    func startChallenge(_ cell: UITableViewCell)
}

class UserTableViewCell: UITableViewCell {
    
    static let reusableIdentifier = String(describing: UserTableViewCell.self)
    
    weak var delegate: UserTableViewCellDelegate?
    
    @IBOutlet weak var challengLabel: UILabel!
    
    @IBOutlet weak var progressionBarContainerView: UIView!

    let progressMaker: ProgressBarMaker = .init()
    
    private lazy var startLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 30))
        
        label.text = "Start"
        
        label.textColor = .black
        
        label.textAlignment = .center
        
        label.font = UIFont.boldSystemFont(ofSize: 24)
        
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(title: String, barColor: UIColor) {
        
        challengLabel.text = title
        
        progressMaker.setBarColor(barColor)
    }
    
    func renderChallengeLabel(_ stage: UserViewModel.Stage, percentage: Int) {
        
        switch stage {
        
        case .begin:
            
            progressionBarContainerView.isUserInteractionEnabled = true
            
            startLabel.text = "Start"
            
        case .process:
            
            progressionBarContainerView.isUserInteractionEnabled = false
                        
            DispatchQueue.main.async {
                
                self.progressMaker.startTimer(to: percentage)
                
                self.progressMaker.updateTimer = Timer.scheduledTimer(
                    timeInterval: 0.04,
                    target: self,
                    selector: #selector(self.updateLabel),
                    userInfo: nil,
                    repeats: true
                )
            }
            
        case .finish:
            
            progressionBarContainerView.isUserInteractionEnabled = false
            
            self.progressMaker.updateProgress(to: 1.0)
            
            startLabel.text = "Finished"
        }
        
    }

    @objc private func handleTap() {
        
        delegate?.startChallenge(self)
    }
    
    @objc func updateLabel() {
        
        self.progressMaker.processing(startLabel: &self.startLabel)
        
        if self.progressMaker.shouldStopTimer {
            
            self.progressMaker.resetTimer()
            
        }
    }
}

extension UserTableViewCell {

    func drawDiscoveryTracker() {
        
        self.layoutSubviews()
        
        progressMaker.setBarPosition(at: contentView.center, on: self)
        
        addLabel()
        
        progressionBarContainerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    func addLabel() {
        
        startLabel.center = contentView.center
        
        self.layer.addSublayer(startLabel.layer)
    }
    
    func updateChallengeLabel(percentage: String) {
        
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.1, delay: 0.0, options: .curveEaseIn) {
            
            self.startLabel.alpha = 0
            
        }
    }
}
