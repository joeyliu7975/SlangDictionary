//
//  RankViewController.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 12/3/20.
//

import UIKit
import Charts

class RankViewController: JoeyPanelViewController {
    
    private lazy var pieChartView: PieChartView = {
        let chartView = PieChartView()
        
        chartView.backgroundColor = .white
        
        return chartView
    }()

    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: RankViewModel?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        viewModel = .init()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
//    private let rankList: [RankColor] = [
//        .top,
//        .second,
//        .third,
//        .fourth,
//        .fifth
//    ]

//    private let nameList = [
//        "You're salty",
//        "Low Key",
//        "Sugar Daddy",
//        "Sup",
//        "Rat"
//    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        
        loadChartData()
        
        setupTableView()
        
        setupNavigationController()
    
    }
}

private extension RankViewController {
    
    func setup() {
        view.addSubview(pieChartView)
        
        pieChartView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            pieChartView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            pieChartView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            pieChartView.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: -10),
            pieChartView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0)
        ])
    }
    
    func setupTableView() {
        
        tableView.registerCell(RankTableViewCell.identifierName)
        
        tableView.separatorStyle = .none
        
        tableView.delegate = self
        
        tableView.dataSource = self
        
    }
    
    func setupNavigationController() {
        
        removeBackButtonItem()
        
        setBarAppearance(title: "Top 5")
        
        makeSideMenuButton()
        
    }
    
    func loadChartData() {
        
        let categories: [Category] = [
            .engineer,
            .game,
            .gym,
            .job
        ]
        
        var piePercentageList = [Double]()
        
        for category in categories {
            
            switch category {
            case .engineer:
                piePercentageList.append(50.0)
            case .game:
                piePercentageList.append(10.0)
            case .job:
                piePercentageList.append(30.0)
            case .gym:
                piePercentageList.append(40.0)
            default:
                continue
            }
            
        }
        
        setChart(dataPoints: categories, values: piePercentageList)
        
    }
    
    func setChart(dataPoints: [Category], values: [Double]) {
        
        var dataEntries = [ChartDataEntry]()
        
        for index in 0 ..< dataPoints.count {
            
            let item = dataPoints[index].instance()
            
            let dataEntryOne = PieChartDataEntry(value: values[index].rounded(), label: item.name, data: dataPoints[index] as AnyObject)
            
            dataEntries.append(dataEntryOne)
            
        }
        
        let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: "Genre")
        
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        
        pieChartView.data = pieChartData
        
        var colors: [UIColor] = []
        
        for _ in 0..<dataPoints.count {
            
            let red = Double.random(in: 0 ... 150)
            
            let green = Double.random(in: 0 ... 150)
            
            let blue = Double.random(in: 0 ... 150)
            
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            
            colors.append(color)
        }
        
        pieChartDataSet.colors = colors
    }
}

extension RankViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.bounds.height / 5
    }
}

extension RankViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.rankList.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: RankTableViewCell.identifierName, for: indexPath)
        
        guard let viewModel = viewModel else { return cell }
        
        let rank = viewModel.rankList[indexPath.row]
        
        let color = rank.makeColor()
        
        let word = viewModel.nameList[indexPath.row]
        
        if let rankCell = cell as? RankTableViewCell {
            
            rankCell.renderUI(boardColor: color, title: word)
            
            if rank == .top {
                
                rankCell.layoutSubviews()
                
                rankCell.makeCrown()
                
            }
            
            cell = rankCell
        }
        
        return cell
    }
}
