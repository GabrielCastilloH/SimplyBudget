//
//  ViewController.swift
//  Familly Budget
//
//  Created by Gabriel Castillo on 7/30/23.
//


import UIKit
import DropDown
import CoreData


class HomeViewController: UIViewController {
    // Controls the home screen.
    
    //MARK: - Variables and Init
    // Sub-Views: TimeRangeView, BudgetCounterView, Categories View. Other VC: ExpenditureTableVC
    var timeRangeView: HomeTimeRangeView?
    var budgetCounterView: HomeBudgetCounterView?
    var categoriesView: HomeCategoriesView?
    var userClass: User?
    var expendituresTableVC: ExpendituresTableViewController?
    
    // Context for database (CoreData).
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true

        budgetCounterView = HomeBudgetCounterView(frame: .zero, parentVC: self)
        timeRangeView = HomeTimeRangeView(frame: .zero, budgetCount: budgetCounterView!)
        categoriesView = HomeCategoriesView(frame: .zero, parentVC: self)
        expendituresTableVC = ExpendituresTableViewController(homeVC: self)

        setupBudget()
        setupHomeUI()
        setupSwipeLeftGesture()
        setupSwipeRightGesture()
        
        deleteAllData() 
        makeFillerData()
        
    }
    
    func deleteAllData() {
            // Deletes data in case database needs to be changed.
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
            do {
                let appUser = try context.fetch(User.fetchRequest())[0]
                let allExpenditures = appUser.totalSpending!
                for expenditure in allExpenditures {
                    context.delete(expenditure as! NSManagedObject)
                }
            }
            catch {
                fatalError("Error deleting budget data for table view.")
            }
            
            do {
                try context.save()
            }
            catch {
                print("Error: failed to save data.")
            }
        
        }
    
    func makeFillerData() {
        
        for _ in 0...300 {
            do {
                let appUser = try context.fetch(User.fetchRequest())[0]
                let newExpenditure = Expenditure(context: context)
                newExpenditure.amount = Int64.random(in: 4...30)
                let randomDate = Double.random(in: 1674230218...1697659847)
                newExpenditure.timeStamp = Date(timeIntervalSince1970: randomDate)
                newExpenditure.category = ["housing", "food", "transportation",
                                           "utilities", "personal", "savings", "health", "miscellaneous"].randomElement()!
                
                appUser.addToTotalSpending(newExpenditure)
            }
            catch {
                print("Error fetching budget data")
            }
            
            do {
                try context.save()
            }
            catch {
                print("Error: failed to save data.")
            }
        }
        
    }
    
    
    //MARK: - Functions and UI Setup
    func refreshBudget() {
        // Updates the text on BudgetCounterView according to time-range set, by reading database.
        self.budgetCounterView!.progressBarMetricChanged(to: self.timeRangeView!.titleTimeRangeLabel.text!)
        
        do {
            let appUser = try context.fetch(User.fetchRequest())[0]
            
            if appUser.totalSpending != [] {
                expendituresTableVC!.tableView.reloadData()
            }
            
        }
        catch {
            fatalError("Error fetching budget data to refresh view in HomeViewController.")
        }
        
    }
    
    func setupBudget() {
        // If there is no User in database, adds a User with a daily budget of 10. Otherwise, updates UI from database.
        
        do {
            let appUsers = try context.fetch(User.fetchRequest())
            
            if appUsers == [] {
                let defaultUser = User(context: self.context)
                defaultUser.dailyBudget = 10
                do {
                    try context.save()
                }
            }
            
            self.refreshBudget()
        }
        catch {
            print("Error fetching budget data.")
        }
    }
    
    
    private func setupHomeUI() {
        // Sets-up UI for Home Screen.
        // Since all sub-views were assigned values in initialization, it is fine to force unwrap optionals.
        view.addSubview(timeRangeView!)
        timeRangeView!.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        timeRangeView!.heightAnchor.constraint(equalToConstant: 150).isActive = true
        timeRangeView!.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
        
        view.addSubview(budgetCounterView!)
        budgetCounterView?.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        budgetCounterView?.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -135).isActive = true
        budgetCounterView?.heightAnchor.constraint(equalToConstant: 200).isActive = true
        budgetCounterView?.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        view.addSubview(categoriesView!)
        categoriesView?.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        categoriesView?.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        categoriesView?.heightAnchor.constraint(equalToConstant: 400).isActive = true
        categoriesView?.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true

        view.addSubview(categoriesView!.addMenu!)
        categoriesView?.addMenu?.center = view.center
        categoriesView?.addMenu?.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
        categoriesView?.addMenu?.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1).isActive = true
        
        view.addSubview(categoriesView!.budgetMenu!)
        categoriesView?.budgetMenu?.center = view.center
        categoriesView?.budgetMenu?.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
        categoriesView?.budgetMenu?.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1).isActive = true
    }
    
    //MARK: - Swiped Gestures
    func setupSwipeLeftGesture() {
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeLeft))
        swipeLeftGesture.direction = .left
        self.view.addGestureRecognizer(swipeLeftGesture)
    }
    
    @objc func didSwipeLeft() {
        let analyticsVC = AnalyticsViewController()
        self.navigationController?.pushViewController(analyticsVC, animated: true)
    }
    
    func setupSwipeRightGesture() {
        let swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeRight))
        swipeRightGesture.direction = .right
        self.view.addGestureRecognizer(swipeRightGesture)
    }
    
    @objc func didSwipeRight() {
        self.navigationController?.pushViewControllerFromLeft(controller: expendituresTableVC!)
    }
    
    func popCurrentView() {
        self.navigationController?.popViewController(animated: true)
    }
}


