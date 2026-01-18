//
//  ExpendituresTableViewController.swift
//  Familly Budget
//
//  Created by Gabriel Castillo on 10/11/23.
//

import UIKit

class ExpendituresTableViewController: UIViewController {

    //MARK: - Variables and Init
    var expTableTitleView: ExpendituresTableTitleView?
    var homeViewController: HomeViewController?
    var allExpenditures: [Expenditure]?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // Requires a way to communicate with homeVC, as it changes data.
    init(homeVC: HomeViewController?) {
        super.init(nibName: nil, bundle: nil)
        homeViewController = homeVC
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.expTableTitleView = ExpendituresTableTitleView(frame: .zero, parentVC: self)
        setupTableExpendituresUI()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    //MARK: - Table View
    var tableView: UITableView = {
        let tableV = UITableView()
        tableV.translatesAutoresizingMaskIntoConstraints = false
        tableV.backgroundColor = .white
        tableV.allowsSelection = false
        tableV.register(ExpendituresTableCell.self, forCellReuseIdentifier: ExpendituresTableCell.identifier)
        return tableV
    }()
    
    //MARK: - UI Setup and Functions
    func popExpendituresTableView() {
        self.navigationController?.popViewControllerFromRight()
    }
    
    func setupTableExpendituresUI() {
        view.backgroundColor = .white
        
        view.addSubview(expTableTitleView!)
        expTableTitleView!.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        expTableTitleView!.heightAnchor.constraint(equalToConstant: 130).isActive = true
        expTableTitleView!.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
        
        view.addSubview(tableView)
        self.tableView.topAnchor.constraint(equalTo: expTableTitleView!.bottomAnchor, constant: 20).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        self.tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 20).isActive = true
        self.tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
    }
}

extension ExpendituresTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // How many table rows we want.
        do {
            let appUser = try context.fetch(User.fetchRequest())[0]
            return appUser.totalSpending?.count ?? 0
        }
        catch {
            fatalError("Error fetching budget data for table view.")
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Pick what custom cell and pass in data.
        do {
            let appUser = try context.fetch(User.fetchRequest())[0]
            self.allExpenditures = (appUser.totalSpending?.allObjects as! [Expenditure]).sorted(by: { $0.timeStamp!.compare($1.timeStamp!) == .orderedDescending
            })
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ExpendituresTableCell.identifier, for: indexPath) as? ExpendituresTableCell else {
                fatalError("The table view could not dequeue a ExpendituresTableCell.")
            }

            let cellCategory = allExpenditures![indexPath.row].category
            let cellAmount = allExpenditures![indexPath.row].amount
            let cellTime = allExpenditures![indexPath.row].timeStamp
            
            cell.configure(category: cellCategory!, amount: cellAmount, timeStamp: cellTime!)
            return cell
        }
        catch {
            fatalError("Error fetching budget data for table view.")
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            let expenditureToRemove = self.allExpenditures![indexPath.row] // Table was made, allExpenditures != nil
            self.context.delete(expenditureToRemove)
            
            // Saving data and refreshing budget.
            do {
                try context.save()
            }
            catch {
                print("Error: failed to save data.")
            }
            
            homeViewController!.refreshBudget()
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
    
    
}
