//
//  CategoryViewController.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 11/27/20.
//

import UIKit

enum Category: CaseIterable {
    case all
    case engineer
    case job
    case school
    case pickUpLine
    case restaurant
    case game
    case gym
    case relationship
}

class CategoryViewController: UIViewController {

    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var containerView: UIView!
    
    let categoryList = Category.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
        setupCollectionView()
    }

    func setup() {
        containerView.setCorner(radius: 20.0)
        
        categoryCollectionView.registerCell(String(describing: CategoryCollectionViewCell.self))
    }
    
    func setupCollectionView() {
        categoryCollectionView.registerCell(String(describing: CategoryCollectionViewCell.self))
        
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
    }
}

extension CategoryViewController: UICollectionViewDelegate {
    
}

extension CategoryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CategoryCollectionViewCell.self), for: indexPath)
        
        guard let categoryCell = cell as? CategoryCollectionViewCell else { return cell }
        
        categoryCell.renderUI(title: "Hello", image: "featherPen")
        
        return categoryCell
    }
}

extension CategoryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width:CGFloat = categoryCollectionView.bounds.width
        let height:CGFloat = categoryCollectionView.bounds.height
        
        return CGSize(width: width / 3, height: height / 3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}

