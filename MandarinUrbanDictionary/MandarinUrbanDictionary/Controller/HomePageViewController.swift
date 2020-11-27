//
//  HomePageViewController.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 11/25/20.
//

import UIKit

class HomePageViewController: UIViewController {

    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var searchbar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var writeNewWordButtonView: NewPostButtonView!
    
    var viewModel = HomePageViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
        setupNavigationController()
        setupCollectionView()
    }
    
    private func setup() {
        view.backgroundColor = UIColor.lightGreen
        
        logoImageView.image = UIImage.homeLogo
        
        writeNewWordButtonView.setShadow(
            color: .black,
            offset: CGSize(width: 3, height: 3),
            opacity: 0.7,
            radius: 4.0
        )
        
        writeNewWordButtonView
            .writeButton
            .setCorner(
            radius: writeNewWordButtonView.frame.width / 2,
            maskToBounds: true
        )
    }
    
    private func setupNavigationController() {
        guard let navigationController = self.navigationController else { return }
        
        navigationController.navigationBar.backgroundColor = UIColor.lightGreen
        
        navigationController.navigationBar.tintColor = UIColor.barButtonRed
        
        navigationController.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController.navigationBar.shadowImage = UIImage()
        
        let sideMenuButton = UIBarButtonItem(image: UIImage.list, style: .plain, target: self, action: #selector(showSideMenu))
        
        self.navigationItem.leftBarButtonItem = sideMenuButton
    }
    
    private func setupCollectionView() {
        collectionView.registerCell(String(describing: MostViewedWordCollectionViewCell.self))
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    @objc func showSideMenu() {
        print("show")
    }
}

extension HomePageViewController: UICollectionViewDelegate {
    
}

extension HomePageViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.cellCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        
       cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: MostViewedWordCollectionViewCell.self), for: indexPath)
        // set cellViewModel for CollectionViewCell
        guard let mostViewedCell = cell as? MostViewedWordCollectionViewCell else { return cell }
        
        return mostViewedCell
    }
}

extension HomePageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width
        let height = collectionView.frame.height
        
        return CGSize(width: width - 60, height: height)
    }
}
