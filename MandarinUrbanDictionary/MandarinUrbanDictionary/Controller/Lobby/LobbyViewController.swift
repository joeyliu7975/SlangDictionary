//
//  LobbyViewController.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 12/9/20.
//

import UIKit
import Hero
import Lottie

class LobbyViewController: JoeyPanelViewController {
    
    @IBOutlet weak var writeNewButtonView: NewPostButtonView!
    
    @IBOutlet weak var tableView: UITableView!
    
    lazy var animationView: UIView = {
        
       var animationView = AnimationView()
        
        animationView = .init(name: "loading_Lotties")
        
        animationView.frame = self.navigationController?.view.bounds ?? view.bounds
        
        animationView.contentMode = .scaleAspectFit
        
        animationView.loopMode = .loop
        
        animationView.play()
        
        return animationView
    }()
    
    private lazy var searchBar: UISearchBar = {
        
        let width = UIScreen.main.bounds.width
        
        let searchBar: UISearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: width, height: 20))
        
        searchBar.placeholder = "搜尋"
        
        searchBar.setTextColor(.homepageDarkBlue, cursorColor: .homepageDarkBlue)
        
        return searchBar
    }()
    
    weak var delegate: CenterViewControllerDelegate?
    
    let viewModel: HomePageViewModel = .init()
    
    let notificationManager: NotificationCenterManager = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        setup()
        
        makeSideMenuButton()
        
        setupTableView()
        
        setupNavigationController()
        
        listen()
    
        viewModelBinding()
    }
}

extension LobbyViewController {

    func scheduleLocal() {
        notificationManager.scheduleLocal()
    }
    
}

private extension LobbyViewController {
    
    func setup() {
        
//        UserDefaults.standard.setValue(false, forKey: UserDefaults.keyForLoginStatus)
//        
//        UserDefaults.standard.setValue(nil, forKey: "uid")
//                
        view.backgroundColor = .homepageDarkBlue
        
        writeNewButtonView.delegate = self
        
        searchBar.delegate = self
        
        let rightNavBarButton = UIBarButtonItem(customView: searchBar)
        
        navigationItem.backButtonTitle = ""
                
        let spacerButton = UIButton()
                
        spacerButton.translatesAutoresizingMaskIntoConstraints = false
        
        spacerButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        spacerButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        spacerButton.isUserInteractionEnabled = false
        
        let rightSpacer = UIBarButtonItem(customView: spacerButton)
        
        navigationItem.rightBarButtonItems = [rightSpacer, rightNavBarButton]
    }
    
    func setupTableView() {
        
        tableView.registerCell(TheNewestWordTableViewCell.reusableIdentifier)
        
        tableView.registerCell(Top5TableViewCell.reusableIdentifier)
        
        tableView.registerCell(RandomWordTableViewCell.reusableIdentifier)
        
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

    }
    
    func tapSearchBar() {
        let searchViewController = SearchPageViewController()
        
        let navController = UINavigationController(rootViewController: searchViewController)
        
        navController.present(self)
    }
    
    func listen() {
        
        view.addSubview(animationView)
        
        viewModel.listen(env: .word, orderBy: .time) { [weak self] (result: Result<[Word], NetworkError>) in
            
            self?.viewModel.handle(result, completion: { [weak self] in
                self?.animationView.removeFromSuperview()
            })
            
        }
    }
    
    func viewModelBinding() {
        
        viewModel.wordViewModels.bind { [weak self] (words) in
            
            switch words.isEmpty {
            case true:
                
                break
                
            case false:
                
                self?.viewModel.newestWord = Array(arrayLiteral: words[0])
                
                let wordOrderByViews = words.sorted { $0.views > $1.views }
                
                self?.viewModel.topFiveWords = Array(wordOrderByViews[0 ... 4])
                
                self?.tableView.reloadData()
            }
        }
    }
}

extension LobbyViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        
        tapSearchBar()
        
        return false
    }
}

extension LobbyViewController: PostButtonDelegate {
    
    func clickButton(_ sender: UIButton) {
        
        delegate?.writeNewWord()
        
    }
}

extension LobbyViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var viewController: UIViewController = .init()
        
        let reusableCell = viewModel.carouselList[indexPath.row]
        
        let words = viewModel.wordViewModels.value
        
        switch reusableCell {
        
        case .newestWord:
            
            let word = viewModel.newestWord[indexPath.row]
            
            let definitionController = DefinitionViewController(identifierNumber: word.identifier, word: word.title, category: word.category)
            
            viewController = definitionController
            
        case .dailyWord:
            
            let titles = viewModel.wordViewModels.value.map { $0.title }
            
            if let cell = tableView.cellForRow(at: indexPath) as? TheNewestWordTableViewCell,
               let title = cell.titleLabel.text,
               let index = titles.firstIndex(of: title) {
                
                let word = words[index]
                
                let uid = word.identifier
                
                let category = word.category
                
                let definitionController = DefinitionViewController(
                    identifierNumber: uid,
                    word: title,
                    category: category
                )
                
                viewController = definitionController
            }
            
        case .mostViewedWord:
            
            return
            
        case .randomWord:
            
            let word = viewModel.wordViewModels.value[viewModel.randomNumber]
            
            let definitionController = DefinitionViewController(identifierNumber: word.identifier, word: word.title, category: word.category)
            
            viewController = definitionController
        }
                
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let height = tableView.frame.height
        
        let reusableCell = viewModel.carouselList[indexPath.row]
        
        switch reusableCell {
        case .mostViewedWord:
            
            return height * 0.9
            
        default:
            
            return height * 0.5
            
        }
    
    }
}

extension LobbyViewController: Top5TableViewDelegate {
    
    func didSelectWord<T>(_ word: T) where T: Codable {
        
        guard let word = word as? Word else { return }
        
        let viewController = DefinitionViewController(
            identifierNumber: word.identifier,
            word: word.title,
            category: word.category
        )
                
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension LobbyViewController: RandomWordTableViewDelegate {
   
    func getRandomWord(_ cell: UITableViewCell) {
        guard let index = tableView.indexPath(for: cell) else { return }
        
        tableView.beginUpdates()
        
        viewModel.makeRandomNumber()
        
        tableView.reloadRows(at: [index], with: .fade)
        
        tableView.endUpdates()
    }
    
}

extension LobbyViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch viewModel.wordViewModels.value.count {
        
        case 0 ... 4:
            
            return 0
            
        default:
            
            return viewModel.carouselList.count
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                
        let reusableCell = viewModel.carouselList[indexPath.row]
        
        let image = reusableCell.getImage()
        
        switch reusableCell {
        
        case .newestWord:
            
            let newestWordCell: TheNewestWordTableViewCell = tableView.makeCell(indexPath: indexPath)
            
            let word = viewModel.newestWord[indexPath.row]
            
            newestWordCell.renderUI(
                title: word.title,
                category: word.category,
                image: image
            )
            
            return newestWordCell
            
        case .mostViewedWord:
            
            let topFiveCell: Top5TableViewCell = tableView.makeCell(indexPath: indexPath)
            
            topFiveCell.setTopFiveWord(viewModel.topFiveWords)
            
            topFiveCell.delegate = self
            
            return topFiveCell
            
        case .dailyWord:
            
            let wordOfDayCell: TheNewestWordTableViewCell = tableView.makeCell( indexPath: indexPath)
            
            guard let word = viewModel.dailyWord else { return wordOfDayCell }
            
            wordOfDayCell.renderUI(
                title: word.title,
                category: word.category,
                image: image
            )
            
            return wordOfDayCell
        
        case .randomWord:
            
            let randomWordCell: RandomWordTableViewCell = tableView.makeCell(indexPath: indexPath)
            
            randomWordCell.delegate = self
            
            let word = viewModel
                .wordViewModels
                .value[viewModel.randomNumber]
            
            randomWordCell.renderUI(
                title: word.title,
                category: word.category,
                image: image
            )
            
            return randomWordCell
        }
    }
}

protocol CenterViewControllerDelegate: class {
    
    func toggleLeftPanel()
    
    func writeNewWord()
}
