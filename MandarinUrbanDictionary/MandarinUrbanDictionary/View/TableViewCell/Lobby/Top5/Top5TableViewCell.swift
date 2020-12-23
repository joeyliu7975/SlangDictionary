//
//  Top5TableViewCell.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 12/12/20.
//

import UIKit
import FSPagerView

protocol Top5TableViewDelegate: class {
    
    func didSelectWord<T: Codable>(_ word: T)
    
}

class Top5TableViewCell: UITableViewCell {
    
    static let reusableIdentifier = String(describing: Top5TableViewCell.self)

    @IBOutlet weak var cardView: CardView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    weak var delegate: Top5TableViewDelegate?
    
    private var topFive = [Word]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    let rankList: [RankColor] = [
        .top,
        .second,
        .third,
        .fourth,
        .fifth
    ]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setup()
        
        setupPagerView()
    }
    
    func setTopFiveWord(_ words: [Word]) {
        topFive = words
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension Top5TableViewCell {
    
    func setup() {
        self.backgroundColor = .homepageDarkBlue
        
        self.selectedBackgroundView = UIView()
        
        collectionView.setCorner(radius: 10)
    }
    
    func setupPagerView() {
        
        collectionView.registerCell(TopFiveCollectionViewCell.reusableIdentifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

extension Top5TableViewCell: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let isIndexValid = topFive.indices.contains(indexPath.row)
        
        switch isIndexValid {
        case true:
            
            let word = topFive[indexPath.row]
            
            delegate?.didSelectWord(word)
        case false:
            break
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
        
        let cell: TopFiveCollectionViewCell = collectionView.makeCell(indexPath: indexPath)
            
            let rank = rankList[indexPath.row]
            
        cell.titleLabel.text = topFive[indexPath.row].title
            
        cell.rankBoardView.backgroundColor = rank.makeColor()
            
            switch rank {
            case .top:
                
                cell.makeCrown()
                
            default:
                
                break
                
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

extension Top5TableViewCell {
    enum RankColor: String {
        case top = "#6DC0F8"
        case second = "#8ACCF9"
        case third = "#98D2FA"
        case fourth = "#A7D9FB"
        case fifth = "#B5E0FB"
        
        func makeColor() -> UIColor {
            return UIColor.hexStringToUIColor(hex: self.rawValue)
        }
    }
}
