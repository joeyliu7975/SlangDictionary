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
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchButton: SearchButton!
    @IBOutlet weak var writeNewWordButtonView: NewPostButtonView!
    
    var viewModel = HomePageViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
        setupNavigationController()
        setupCollectionView()
    }
    
    @IBAction func clickSearch(_ sender: UIButton) {
        let searchViewController = SearchPageViewController()
        
        let navController = UINavigationController(rootViewController: searchViewController)
        
        navController.modalPresentationStyle = .fullScreen
        
        navController.modalTransitionStyle = .crossDissolve
        
        present(navController, animated: true)
    }
    
    @objc func showSideMenu() {
        print("show")
    }
}

private extension HomePageViewController {
    func setup() {
        view.backgroundColor = UIColor.homepageDarkBlue
        
        logoImageView.image = UIImage.homeLogo
    }
    
    func setupNavigationController() {
        guard let navigationController = self.navigationController else { return }
        
        navigationController.navigationBar.backgroundColor = UIColor.homepageDarkBlue
        
        navigationController.navigationBar.tintColor = UIColor.homepageLightBlue
        
        navigationController.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController.navigationBar.shadowImage = UIImage()
        
        let sideMenuButton = UIBarButtonItem(image: UIImage.list, style: .plain, target: self, action: #selector(showSideMenu))
        
        self.navigationItem.leftBarButtonItem = sideMenuButton
    }
    
    func setupCollectionView() {
        collectionView.registerCell(MostViewedWordCollectionViewCell.identifierName)
        collectionView.delegate = self
        collectionView.dataSource = self
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
        
        let collectionViewContent = viewModel.collectionViewContents[indexPath.row]
        
       cell = collectionView.dequeueReusableCell(withReuseIdentifier: MostViewedWordCollectionViewCell.identifierName, for: indexPath)
        
        if let mostViewedCell = cell as? MostViewedWordCollectionViewCell {
            mostViewedCell.renderImage(name: collectionViewContent)
            cell = mostViewedCell
        }
        
        return cell
    }
}

extension HomePageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width
        let height = collectionView.frame.height
        
        return CGSize(width: width, height: height)
    }
}
