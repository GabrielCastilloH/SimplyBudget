//
//  HomeProgressBarView.swift
//  Familly Budget
//
//  Created by Gabriel Castillo on 8/10/23.
//

import UIKit

class HomeBudgetCounterView: UIView {
    // Responsible for displaying the correct budget according to different time-ranges.
    
    //MARK: - Variables and Init
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var appUser: User?
    
    init(frame: CGRect, parentVC: HomeViewController) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .clear
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - (Budget Changed) Functions
    func progressBarMetricChanged(to text: String) {
        // Changes budgetCounterText in accordance to time-range selected.
        
        var spendingToBeCalculated: [Expenditure] = []
        var userDailyBudget: Int
        var userBudgetForTime: Int
        let usersCalendar = Calendar.current
        
        do {
            self.appUser = try context.fetch(User.fetchRequest())[0]
            userDailyBudget = Int(appUser!.dailyBudget)
        }
        catch {
            print("Error fetching budget data")
            return
        }
        
        
        if text == "Daily" {
            userBudgetForTime = userDailyBudget
            
        } else if text == "Monthly" {
            guard let daysInMonth = usersCalendar.range(of: .day, in: .month, for: Date())?.count else {
                print("Error counting days in month ")
                return
            }
            
            userBudgetForTime = userDailyBudget * daysInMonth
            
        } else {
            
            guard let daysInYear = usersCalendar.range(of: .day, in: .year, for: Date())?.count else {
                print("Error counting days in year. ")
                return
            }
            
            userBudgetForTime = userDailyBudget * daysInYear

        }
        
        for expenditure in appUser!.totalSpending! {
            // Go through all the expenditures, and depending on selected time-range, include these in the spendingToBeCalculated,
            // Also, change userBudgetForTime depending on selected time-range.
            
            guard let safeExpenditure = expenditure as? Expenditure else {
                print("Expenditure was not of type Expenditure")
                return
            }
            
            // Making sure timeStamp has a date. NOT NEEDED
            
            let dateOfExpense = safeExpenditure.timeStamp
            
            if text == "Daily" {
                if usersCalendar.isDateInToday(dateOfExpense!) {
                    spendingToBeCalculated.append(safeExpenditure)
                }
                
            } else if text == "Monthly" {
                if usersCalendar.isDateInThisMonth(dateOfExpense!) {
                    spendingToBeCalculated.append(safeExpenditure)
                }
                
            } else {
                if usersCalendar.isDateInThisYear(dateOfExpense!) {
                    spendingToBeCalculated.append(safeExpenditure)
                }
            }
        }
        
        // For selected time-range: Remaining Budget = budget for time-range MINUS total spending in time-range.
        var totalAmountSpent = 0
        
        for expenditure in spendingToBeCalculated {
            totalAmountSpent += Int(expenditure.amount)
        }
        
        let remainingBudget = userBudgetForTime - totalAmountSpent
        
        // Update the counter text with the final budget.
        self.budgetCounterText.text? = remainingBudget.addCommas()
    }
    
    //MARK: - UI Elements and Setup
    lazy var budgetCounterText: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = false
        textView.textAlignment = .center
        textView.text = "1080"
        textView.font = UIFont(name: "Arial", size: 70)
        return textView
    }()
    
    private func setupUI() {
        self.addSubview(budgetCounterText)
        budgetCounterText.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        budgetCounterText.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        budgetCounterText.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        budgetCounterText.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }

}
