//
//  RecommendationVC.swift
//  ZeusApp
//
//  Created by Macbook Pro 15 on 2/3/20.
//  Copyright © 2020 SamuelFolledo. All rights reserved.
//

import UIKit

class RecommendationVC: UIViewController {
//MARK: Properties
    var stocks: [Stock] = []
    
//MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
//MARK: App Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        populateTableView()
    }
    
//MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case kSEGUETOSTOCKDETAILSVC:
            guard let stock = sender as? Stock else { return }
            let vc: StockDetailsVC = (segue.destination as? StockDetailsVC)!
            vc.stock = stock
        default:
            break
        }
    }
    
//MARK: Private Methods
    fileprivate func setupViews() {
        self.title = "Trending"
        self.view.backgroundColor = SettingsService.blackColor
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = SettingsService.grayColor //button color
        navigationController?.setStatusBarColor(backgroundColor: kMAINCOLOR)
        setupTableView()
        populateTableView()
        setupTabBar()
    }
    
    fileprivate func setupTableView() {
        tableView.register(UINib(nibName: "StockCell", bundle: nil), forCellReuseIdentifier: "stockCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView() //removes extra unpopulated cells
        tableView.backgroundColor = SettingsService.blackColor
        tableView.separatorStyle = .none //removes separator line
    }
    
    fileprivate func populateTableView() {
        let stock1 = Stock(_name: "Bitcoin", _shortName: "BTC", _price: "00.00", _imageUrl: "", _rank: 1)
        let stock2 = Stock(_name: "Etherium", _shortName: "ETH", _price: "00.00", _imageUrl: "", _rank: 2)
        let stock3 = Stock(_name: "Tesla", _shortName: "TSL", _price: "00.00", _imageUrl: "", _rank: 3)
        let stock4 = Stock(_name: "Apple", _shortName: "APL", _price: "00.00", _imageUrl: "", _rank: 4)
        let stock5 = Stock(_name: "Amazon", _shortName: "AMZ", _price: "00.00", _imageUrl: "", _rank: 5)
        let stock6 = Stock(_name: "Twitter", _shortName: "TWTR", _price: "00.00", _imageUrl: "", _rank: 6)
        let stock7 = Stock(_name: "Facebook", _shortName: "FB", _price: "00.00", _imageUrl: "", _rank: 7)
        let stock8 = Stock(_name: "Microsoft", _shortName: "MSFT", _price: "00.00", _imageUrl: "", _rank: 8)
        let stock9 = Stock(_name: "Netflix", _shortName: "NFLX", _price: "00.00", _imageUrl: "", _rank: 9)
        let stock10 = Stock(_name: "Starbucks", _shortName: "SBUX", _price: "00.00", _imageUrl: "", _rank: 10)
        let stock11 = Stock(_name: "Rite Aid", _shortName: "RAD", _price: "00.00", _imageUrl: "", _rank: 11)
        let stock12 = Stock(_name: "IBM", _shortName: "IBM", _price: "00.00", _imageUrl: "", _rank: 12)
        stocks.append(contentsOf: [stock1, stock2, stock3, stock4, stock5, stock6, stock7, stock8, stock9, stock10, stock11, stock12])
        saveTrendingStocks(stocks: self.stocks)
        fetchAllStocks(stocks: stocks) { (error, resultsStocks) in
            DispatchQueue.main.async {
                if let error = error {
                    Service.presentAlert(on: self, title: "Fetch All Stocks Error", message: error)
                    return
                }
                self.stocks = resultsStocks
                self.tableView.reloadData()
            }
        }
    }
    
    fileprivate func setupTabBar() {
        guard var tabBar = self.tabBarController?.tabBar else { return }
        SettingsService.isMainTabBar(tabBar: &tabBar)
        tabBar.isTranslucent = false
    }
    
//MARK: IBActions
    
//MARK: Helpers
    
}

//MARK: Extensions
extension RecommendationVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let stock = stocks[indexPath.row]
        self.performSegue(withIdentifier: kSEGUETOSTOCKDETAILSVC, sender: stock)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension RecommendationVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stocks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: StockCell = tableView.dequeueReusableCell(withIdentifier: "stockCell") as! StockCell
        cell.selectionStyle = .none //remove the selection indicator
        cell.stock = stocks[indexPath.row]
        cell.populateViews(showRank: true)
//        cell.backgroundColor = UIColor(hexString: "#2b2b30")
        cell.backgroundColor = SettingsService.blackColor
        return cell
    }
}

//MARK: StockDetailsProtocol
extension RecommendationVC: StockDetailProtocol {
    func didUpdateStock(stock: Stock) {
        print("Updated fav stock =",stock.name)
        guard let user = getCurrentUser() else { return }
        for favStock in user.stocks where stock.name == favStock {
//            user.delete(<#T##stockIndex: Int##Int#>)
        }
    }
}


