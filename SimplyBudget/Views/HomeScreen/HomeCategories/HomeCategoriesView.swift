//
//  HomeCategoriesView.swift
//  Familly Budget
//
//  Created by Gabriel Castillo on 8/10/23.
//

import UIKit
import CoreData

class HomeCategoriesView: UIView {
    // Class responsible for creating the whole of the categories view (bottom half of the home screen).
    
    var addMenu: HomeAddExpenditureView?
    var parentViewController: HomeViewController?
    var budgetMenu: HomeBudgetMenuView?
    
    let fillerFrame = CGRect(x: 0, y: 0, width: 0, height: 0)
    
    init(frame: CGRect, parentVC: HomeViewController) {
        super.init(frame: frame)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .clear
        
        
        self.budgetMenu = HomeBudgetMenuView(frame: fillerFrame, parentVC: self)
        self.addMenu = HomeAddExpenditureView(frame: fillerFrame, parentVC: self)
        self.parentViewController = parentVC
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Functions
    func refreshBudget2() {
        self.parentViewController?.refreshBudget()
//        print("refresh budget 2 called.")
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
    
    //MARK: - UI Elements and Setup
    lazy var categoriesMainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        return stackView
    }()

    private func categoriesSubViewFunc(item1: UIView, item2: UIView, item3: UIView) -> UIStackView {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(item1)
        stackView.addArrangedSubview(item2)
        stackView.addArrangedSubview(item3)
        return stackView
    }

    func createCategoriesButon(for category: String, with image: String) -> UIButton {
        let button = CategoryButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: image), for: .normal)
        button.categoryName = category
        button.imageName = image
        button.addTarget(self, action: #selector(categoryButtonClicked), for: .touchUpInside)
        return button
    }

    @objc func categoryButtonClicked(sender: CategoryButton) {
        addMenu!.showHideAddExpenditure(1, category: sender.categoryName, imageName: sender.imageName!)
    }

    func createHolderView(colored color: UIColor) -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = color
        return view
    }

    // Extra categories in the end:
    lazy var editBudgetButton: UIButton = {
        // this is only a temporary button, the real image needs to be added as png with custom padding.
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "settings-img"), for: .normal)
        button.addTarget(self, action: #selector(editBudgetButtonClicked), for: .touchUpInside)
        return button
    }()

    private func setupUI() {
        self.addSubview(categoriesMainStackView)
        categoriesMainStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        categoriesMainStackView.widthAnchor.constraint(equalToConstant: 320).isActive = true
        categoriesMainStackView.heightAnchor.constraint(equalToConstant: 320).isActive = true
        categoriesMainStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -70).isActive = true

        let btn1 = createCategoriesButon(for: "housing", with: "housing-img")
        let btn2 = createCategoriesButon(for: "food", with: "food-img")
        let btn3 = createCategoriesButon(for: "transportation", with: "transportation-img")
        let btn4 = createCategoriesButon(for: "utilities", with: "utilities-img")
        let btn5 = createCategoriesButon(for: "personal", with: "personal-img")
        let btn6 = createCategoriesButon(for: "savings", with: "savings-img")
        let btn7 = createCategoriesButon(for: "health", with: "health-img")
        let btn8 = createCategoriesButon(for: "miscellaneous", with: "miscellaneous-img")
        let btn9 = editBudgetButton

        let subView1 = categoriesSubViewFunc(item1: btn1, item2: btn2, item3: btn3)
        let subView2 = categoriesSubViewFunc(item1: btn4, item2: btn5, item3: btn6)
        let subView3 = categoriesSubViewFunc(item1: btn7, item2: btn8, item3: btn9)

        categoriesMainStackView.addArrangedSubview(subView1)
        categoriesMainStackView.addArrangedSubview(subView2)
        categoriesMainStackView.addArrangedSubview(subView3)
    }
    
    @objc func editBudgetButtonClicked() {
        budgetMenu?.showHideBudgetMenu(1)
    }

}
