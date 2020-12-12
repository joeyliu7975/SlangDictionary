//
//  HomePageViewController.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 11/25/20.
//

import UIKit
import FSPagerView

class HomePageViewController: UIViewController {

    @IBOutlet weak var searchButton: SearchButton!
    
    @IBOutlet weak var writeNewWordButtonView: NewPostButtonView!
    
    @IBOutlet weak var pagerView: FSPagerView!
        
    private let viewModel: HomePageViewModel = .init()
    
    weak var delegate: CenterViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
        setupNavigationController()
        
        setupPagerView()
        
        binding()
    }
    
    @IBAction func clickSearch(_ sender: UIButton) {
        
        let searchViewController = SearchPageViewController()
        
        let navController = UINavigationController(rootViewController: searchViewController)
        
        navController.modalPresentationStyle = .fullScreen
        
        navController.modalTransitionStyle = .crossDissolve
        
        present(navController, animated: true)
    }
    
    @objc func toggleSideMenu() {
        //Remove leftBarButtonItem when SidePanel show
        delegate?.toggleLeftPanel()
        viewModel.isVertical.toggle()
    }
}

private extension HomePageViewController {
    
    func setup() {
        
        view.backgroundColor = UIColor.homepageDarkBlue
        
        searchButton.setCorner(radius: 10.0)
        
        writeNewWordButtonView.delegate = self
        
        viewModel.fetchData(in: .user)
    }
    
    func setupNavigationController() {
        
        guard let navigationController = self.navigationController else { return }
        
        navigationItem.setBarAppearance(with: .homepageDarkBlue)
        
        navigationController.navigationBar.tintColor = UIColor.homepageLightBlue
        
        navigationController.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        
        navigationController.navigationBar.shadowImage = UIImage()
        
        let sideMenuButton = UIBarButtonItem(
            image: UIImage(named: ImageConstant.list),
            style: .plain,
            target: self,
            action: #selector(toggleSideMenu)
        )
        
        self.navigationItem.leftBarButtonItem = sideMenuButton
    }
    
    func setupPagerView() {
        
        pagerView.registerCell(MostViewedWordCollectionViewCell.identifierName)
        
        pagerView.transformer = FSPagerViewTransformer(type: .ferrisWheel)
        
        pagerView.delegate = self
        
        pagerView.dataSource = self
    }
    
    func binding() {
        
        viewModel.userViewModels.bind { [weak self] (_) in
            
            self?.pagerView.reloadData()
            
        }
    }
}

extension HomePageViewController: PostButtonDelegate {
    func clickButton(_ sender: UIButton) {
        
        delegate?.writeNewWord()
    
    }
}

extension HomePageViewController: FSPagerViewDelegate { }

extension HomePageViewController: FSPagerViewDataSource {
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        
        return viewModel.userViewModels.value.count
        
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        
        var cell = FSPagerViewCell()
        
        let image = viewModel.carouselList[index].getImage()
        
        let collectionViewContent = viewModel.userViewModels.value[index]
        
        cell = pagerView.dequeueReusableCell(withReuseIdentifier: MostViewedWordCollectionViewCell.identifierName, at: index)
        
        if let mostViewedCell = cell as? MostViewedWordCollectionViewCell {
            
            mostViewedCell.renderImage(
                image: image,
                word: collectionViewContent.name,
                definition: collectionViewContent.identifier
            )
            
            cell = mostViewedCell
        }
        
        return cell
    }
}

extension HomePageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.width
        
        let height = collectionView.frame.height
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}

protocol CenterViewControllerDelegate: class {
  func toggleLeftPanel()
  func writeNewWord()
}
