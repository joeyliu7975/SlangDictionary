//
//  UserViewController.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 12/16/20.
//

import UIKit

class UserViewController: JoeyPanelViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private let shapeLayer = CAShapeLayer()
    
    private let viewModel: UserViewModel = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
    }
    
    func setupTableView() {
        tableView.registerCell(UserTableViewCell.reusableIdentifier)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension UserViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height * 0.5
    }
}

extension UserViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UserTableViewCell = tableView.makeCell(indexPath: indexPath)
        
        cell.renderUI(title: "我的挑戰")
        
        return cell
    }
    
    
}
//        startDownloading()
//
//        drawDiscoveryTracker()
//
//        setNavigationController()
//
//        binding()
//    }
//
//    override func viewDidLayoutSubviews() {
//
//    }
//
//    func startDownloading() {
//        viewModel.startDownloading()
//    }
//
//    func setNavigationController() {
//
//        removeBackButtonItem()
//
//        setBarAppearance(title: "用戶")
//
//        makeSideMenuButton()
//    }
//
//    func binding() {
//
//        viewModel.allWords.bind { [weak self] (words) in
//
//            let totalVocabulary = words.count
//
//            if let discoveredVocabulary = self?.viewModel.discoveredWords.count,
//               discoveredVocabulary != 0,
//               totalVocabulary != 0
//               {
//                self?.calculate(discoveredWords: discoveredVocabulary, totalWords: totalVocabulary)
//            }
//        }
//    }
//
//    func drawDiscoveryTracker() {
//
//        view.layoutIfNeeded()
//
//        let trackLayer = CAShapeLayer()
//
//        let circularPath = UIBezierPath(arcCenter: .zero, radius: 100, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
//
//        trackLayer.path = circularPath.cgPath
//
//        trackLayer.strokeColor = UIColor.lightGray.cgColor
//
//        trackLayer.lineWidth = 10
//
//        trackLayer.fillColor = UIColor.clear.cgColor
//
//        trackLayer.lineCap = .round
//
//        trackLayer.position = chartContainerView.center
//
//        view.layer.addSublayer(trackLayer)
//
//        shapeLayer.path = circularPath.cgPath
//
//        shapeLayer.strokeColor = UIColor.red.cgColor
//
//        shapeLayer.lineWidth = 10
//
//        shapeLayer.lineCap = .round
//
//        shapeLayer.fillColor = UIColor.clear.cgColor
//
//        shapeLayer.strokeEnd = 0
//
//        shapeLayer.position = chartContainerView.center
//
//        shapeLayer.transform = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1)
//
//        view.layer.addSublayer(shapeLayer)
        
//        chartContainerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
//    }
//
//    func calculate(discoveredWords: Int, totalWords: Int) {
//
//        let percentage = CGFloat(discoveredWords) / CGFloat(totalWords)
//
//        runPercentage(value: percentage)
        
//    }
    
//    @objc private func handleTap() {
//
//        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
//
//        basicAnimation.toValue = 0.3
//
//        basicAnimation.duration = 2
//
//        basicAnimation.fillMode = .forwards
//
//        basicAnimation.isRemovedOnCompletion = false
//
//        shapeLayer.add(basicAnimation, forKey: "urSoBasic")
//    }
    
//    private func runPercentage(value: CGFloat) {
//        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
//
//        basicAnimation.toValue = value
//
//        basicAnimation.duration = 2
//
//        basicAnimation.fillMode = .forwards
//
//        basicAnimation.isRemovedOnCompletion = false
//
//        shapeLayer.add(basicAnimation, forKey: "urSoBasic")
//    }

