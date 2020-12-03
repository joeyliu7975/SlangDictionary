//
//  RankViewController.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 12/3/20.
//

import UIKit
import Charts

class RankViewController: UIViewController {
    
    private lazy var pieChartView: PieChartView = {
        let chartView = PieChartView()
        
        chartView.backgroundColor = .white
        
        return chartView
    }()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        
        loadChartData()
        
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
            
            let item = dataPoints[index].makeIcon()
            
            let dataEntryOne = PieChartDataEntry(value: values[index].rounded(), label: item.name, data: dataPoints[index] as AnyObject)
            
            dataEntries.append(dataEntryOne)
            
        }
        
        let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: "Genre")
        
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        
        pieChartView.data = pieChartData
        
        var colors: [UIColor] = []
        
        for _ in 0..<dataPoints.count {
            
            let red = Double(arc4random_uniform(256))
            
            let green = Double(arc4random_uniform(256))
            
            let blue = Double(arc4random_uniform(256))
            
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            
            colors.append(color)
        }
        
        pieChartDataSet.colors = colors
    }
}
