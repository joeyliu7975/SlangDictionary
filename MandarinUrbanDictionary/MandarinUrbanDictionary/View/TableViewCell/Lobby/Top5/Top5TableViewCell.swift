//
//  Top5TableViewCell.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 12/12/20.
//

import UIKit
import FSPagerView

protocol Top5TableViewDelegate: class {
    func didSelectWord<T:Codable>(_ word: T)
}

class Top5TableViewCell: UITableViewCell {
    
    static let reusableIdentifier = String(describing: Top5TableViewCell.self)

    @IBOutlet weak var cardView: CardView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    weak var delegate: Top5TableViewDelegate?
    
    var topFive = [Word]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setup()
        
        setupPagerView()
    }
    
    func setup() {
        self.backgroundColor = .homepageDarkBlue
        
        self.selectedBackgroundView = UIView()
        
        collectionView.setCorner(radius: 10)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupPagerView() {
        
        collectionView.registerCell(TopFiveCollectionViewCell.reusableIdentifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

extension Top5TableViewCell:  UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            
        if (topFive.count - 1) >= indexPath.row {
            let word = topFive[indexPath.row]
            
            delegate?.didSelectWord(word)
        }
    }
}

extension Top5TableViewCell: UICollectionViewDataSource {
   
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topFive.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopFiveCollectionViewCell.reusableIdentifier, for: indexPath)
        
        if let topFiveCell = cell as? TopFiveCollectionViewCell {
            
            if indexPath.row == 0 {
                topFiveCell.makeCrown()
            }
            
            topFiveCell.titleLabel.text = topFive[indexPath.row].title
            
            cell = topFiveCell
        }
        
        return cell
    }
}

extension Top5TableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let height = (cardView.frame.height * 0.75) / 6
        
        let width = cardView.frame.width
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
