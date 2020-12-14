//
//  LobbyViewController.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 12/9/20.
//

import UIKit
import Hero

class LobbyViewController: UIViewController {
    
    @IBOutlet weak var writeNewButtonView: NewPostButtonView!
    
    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate: CenterViewControllerDelegate?
    
    let viewModel: HomePageViewModel = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        setup()
        
        setupTableView()
        
        setupNavigationController()
        
        binding()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        userHasSignedIn()
    }
    
    @objc func toggleSideMenu() {
        //Remove leftBarButtonItem when SidePanel show
        delegate?.toggleLeftPanel()
    }
}

private extension LobbyViewController {
   
    func userHasSignedIn() {
        if let hasLogin = UserDefaults.standard.value(forKey: UserDefaults.keyForLoginStatus) as? Bool {
            if hasLogin == false {
                jumpToLoginpage()
            }
        }
    }
    
    func jumpToLoginpage() {

        let loginPage = LoginViewController()

        loginPage.modalTransitionStyle = .coverVertical

        loginPage.modalPresentationStyle = .fullScreen

        present(loginPage, animated: true)
    }
    
    func setup() {
        
        viewModel.listen(in: .word(orderBy: .time))
        
        view.backgroundColor = .homepageDarkBlue
        
        writeNewButtonView.delegate = self
    }
    
    func setupTableView() {
        
        tableView.registerCell(TheNewestWordTableViewCell.reusableIdentifier)
        
        tableView.registerCell(Top5TableViewCell.reusableIdentifier)
        
        tableView.registerHeaderFooterCell(LobbyTableHeaderView.reusableIdentifier)
        
        tableView.separatorStyle = .none
        
        tableView.delegate = self
        
        tableView.dataSource = self
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
    
    func binding() {
        
        viewModel.wordViewModels.bind { [weak self] (words) in
            
            if words.isEmpty {
                return
            }
            
            self?.viewModel.newestWord = Array(arrayLiteral: words[0])
            
            let wordOrderByViews = words.sorted { $0.views > $1.views }
            
            self?.viewModel.topFiveWords = Array(wordOrderByViews[0 ... 4])
            
            self?.tableView.reloadData()
        }
        
    }
    
}

extension LobbyViewController: PostButtonDelegate {
    
    func clickButton(_ sender: UIButton) {
        
        delegate?.writeNewWord()
        
    }
}

extension LobbyViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var viewController = UIViewController()
        
        let type = viewModel.carouselList[indexPath.row]
        
        switch type {
        
        case .newestWord:
            
            let word = viewModel.newestWord[indexPath.row]
            
            let definitionController = DefinitionViewController(identifierNumber: word.identifier, word: word.title)
            
            viewController = definitionController
            
        case .mostViewedWord:
            
            return
            
        case .dailyWord:
            
            let titles = viewModel.wordViewModels.value.map { $0.title }
            
            if let cell = tableView.cellForRow(at: indexPath) as? TheNewestWordTableViewCell,
               let title = cell.titleLabel.text,
               let index = titles.firstIndex(of: title) {
                
                let id = viewModel.wordViewModels.value[index].identifier
                
                let definitionController = DefinitionViewController(identifierNumber: id, word: title)
                
                viewController = definitionController
            }
        }
        
        self.navigationItem.backButtonTitle = ""
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (indexPath.row % 2) == 0 ? tableView.frame.height * 0.5 : tableView.frame.height * 0.9
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: LobbyTableHeaderView.reusableIdentifier)
        
        if let headerView = headerView as? LobbyTableHeaderView {
            
            let headerBackgroundView = UIView()
            
            headerView.searchButton.setCorner(radius: 10)
            
            headerView.delegate = self
            
            headerBackgroundView.backgroundColor = .homepageDarkBlue
            
            headerView.backgroundView = headerBackgroundView
            
            return headerView
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 72
    }
}

extension LobbyViewController: LobbyHeaderDelegate {
    func clickSearch() {
        
        let searchViewController = SearchPageViewController()
        
        let navController = UINavigationController(rootViewController: searchViewController)
        
        navController.modalPresentationStyle = .fullScreen
        
        navController.modalTransitionStyle = .crossDissolve
        
        present(navController, animated: true)
    }
}

extension LobbyViewController: Top5TableViewDelegate {
    
    func didSelectWord<T>(_ word: T) where T: Codable {
        
        guard let word = word as? Word else { return }
        
        let viewController = DefinitionViewController(identifierNumber: word.identifier, word: word.title)
        
        self.navigationItem.backButtonTitle = ""

        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension LobbyViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewModel.wordViewModels.value.count >= 3 ? viewModel.carouselList.count : 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        
        let type = viewModel.carouselList[indexPath.row]
        
        switch type {
        
        case .newestWord:
            
            cell = tableView.dequeueReusableCell(withIdentifier: TheNewestWordTableViewCell.reusableIdentifier, for: indexPath)
            
            if let newestWordCell = cell as? TheNewestWordTableViewCell {
                
                let word = viewModel.newestWord[indexPath.row]
                
                newestWordCell.renderUI(
                    title: word.title,
                    description: word.time.timeStampToStringDetail(),
                    image: type.getImage()
                )
                
                cell = newestWordCell
            }
            
        case .mostViewedWord:
            cell = tableView.dequeueReusableCell(withIdentifier: Top5TableViewCell.reusableIdentifier, for: indexPath)
            
            if let topFiveCell = cell as? Top5TableViewCell {
                
                topFiveCell.topFive = viewModel.topFiveWords
                
                topFiveCell.delegate = self
                
                cell = topFiveCell
            }
            
        case .dailyWord:
            cell = tableView.dequeueReusableCell(withIdentifier: TheNewestWordTableViewCell.reusableIdentifier, for: indexPath)
            
            if let wordOfTheDayCell = cell as? TheNewestWordTableViewCell {
                
                let number = Int.random(in: 0 ..< viewModel.wordViewModels.value.count)
                
                let word = viewModel.wordViewModels.value[number]
                
                wordOfTheDayCell.renderUI(
                    title: word.title,
                    description: word.time.timeStampToStringDetail(),
                    image: type.getImage()
                )
                
                cell = wordOfTheDayCell
            }
        }
        
        return cell
    }
}

protocol CenterViewControllerDelegate: class {
    
  func toggleLeftPanel()
    
  func writeNewWord()
}
