//
//  HomeAddMenuView.swift
//  Familly Budget
//
//  Created by Gabriel Castillo on 8/12/23.
//

import UIKit

class HomeAddExpenditureView: UIView {
    // View of a single category (small squares in bottom half of the home screen).
    
    //MARK: - Variables and Init
    var parentView: HomeCategoriesView?
    var currentCategoryName: String?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // Needs parentVC because class calls refreshBudget2 from HomeCategoriesView, as it is nested within 2 parentVCs.
    init(frame: CGRect, parentVC: HomeCategoriesView) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        parentView = parentVC
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - (Add Expenditure) Functions
    @objc func addExpenditureButtonClicked() {
        // When plus button is clicked on any one of the categories. Add expenditure to database.
        
        guard let textFieldText = addExpenditureTextField.text else { return }
        
        if textFieldText != "" {
            // Add new expenditure to database
            do {
                let appUser = try context.fetch(User.fetchRequest())[0]
                let newExpenditure = Expenditure(context: context)
                
                newExpenditure.timeStamp = Date()
                newExpenditure.amount = Int64(textFieldText)! // Only numbers allowed in textfield.
                newExpenditure.category = self.currentCategoryName! // Category name is set as soon as button is clicked.
                appUser.addToTotalSpending(newExpenditure)
                self.addExpenditureTextField.text = ""
                self.endEditing(true)

                do {
                    // Try to add expenditure to the database.
                    try context.save()
                }
                catch {
                    // If adding expenditure fails abort operations.
                    fatalError("Error: failed to save data.")
                }
                
            }
            catch {
                // If you cannot fetch data from the database abort operations.
                fatalError("Error fetching budget data")
            }
            
            self.parentView!.refreshBudget2()
            
            // Hide addExpenditure view after button is clicked.
            self.showHideAddExpenditure(0, category: nil, imageName: nil)
        }
    }
    
    func showHideAddExpenditure(_ value: Int, category: String?, imageName: String?) {
        // Shows and hides add menu with appropriate category when a categoryIsClicked.
        // Value = 1 to show, 0 to hide.
        if value == 1 {
            addMenuCategoryImage.image = UIImage(named: imageName!)
            addMenuCategoryTitle.text = category?.capitalized
            self.currentCategoryName = category
            
            self.isHidden = false
        }
        else {
            self.isHidden = true
            addExpenditureTextField.text = ""
        }
    }
    
    @objc func didTapDarkBackground(sender : UITapGestureRecognizer) {
        // AddMenu is hidden when background is tapped.
        self.showHideAddExpenditure(0, category: nil, imageName: nil)
        self.endEditing(true)
    }
    
    //MARK: - UI Elements and Setup
    var darkBackgroundLayer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        return view
    }()
    
    var addMenuBackground: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.backgroundColor = UIColor(red: 0.95, green: 0.99, blue: 0.96, alpha: 1.00)
        return view
    }()
    
    var addExpenditureTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.cornerRadius = 10
        textField.clipsToBounds = true
        textField.backgroundColor = .white
        textField.placeholder = "Enter Quantity..."
        textField.setLeftPaddingPoints(20)
        textField.keyboardType = .numberPad
        return textField
    }()
    
    var addMenuCategoryImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var addMenuCategoryTitle: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textColor = .black
        textView.backgroundColor = .clear
        textView.isEditable = false
        textView.text = ""
        textView.isScrollEnabled = false
        textView.font = UIFont(name: "Arial", size: 30)
        return textView
    }()
        
    var addMenuAddButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = UIColor(red: 0.21, green: 0.66, blue: 0.44, alpha: 1.00)
        button.clipsToBounds = true
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(addExpenditureButtonClicked), for: .touchUpInside)
        return button
    }()
    
    private func setupUI() {
        self.showHideAddExpenditure(0, category: nil, imageName: nil)
        
        self.addSubview(darkBackgroundLayer)
        darkBackgroundLayer.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1).isActive = true
        darkBackgroundLayer.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1).isActive = true
        darkBackgroundLayer.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        darkBackgroundLayer.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        self.addSubview(addMenuBackground)
        addMenuBackground.widthAnchor.constraint(equalToConstant: 300).isActive = true
        addMenuBackground.heightAnchor.constraint(equalToConstant: 150).isActive = true
        addMenuBackground.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        addMenuBackground.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        self.addSubview(addExpenditureTextField)
        addExpenditureTextField.delegate = self
        addExpenditureTextField.widthAnchor.constraint(equalTo: addMenuBackground.widthAnchor, multiplier: 0.7).isActive = true
        addExpenditureTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        addExpenditureTextField.leftAnchor.constraint(equalTo: addMenuBackground.leftAnchor, constant: 15).isActive = true
        addExpenditureTextField.bottomAnchor.constraint(equalTo: addMenuBackground.bottomAnchor, constant: -15).isActive = true
        
        self.addSubview(addMenuCategoryImage)
        addMenuCategoryImage.widthAnchor.constraint(equalToConstant: 70).isActive = true
        addMenuCategoryImage.heightAnchor.constraint(equalToConstant: 70).isActive = true
        addMenuCategoryImage.leftAnchor.constraint(equalTo: addMenuBackground.leftAnchor, constant: 10).isActive = true
        addMenuCategoryImage.topAnchor.constraint(equalTo: addMenuBackground.topAnchor, constant: 5).isActive = true
        
        self.addSubview(addMenuCategoryTitle)
        addMenuCategoryTitle.leftAnchor.constraint(equalTo: addMenuCategoryImage.rightAnchor, constant: 10).isActive = true
        addMenuCategoryTitle.centerYAnchor.constraint(equalTo: addMenuCategoryImage.centerYAnchor).isActive = true
        
        self.addSubview(addMenuAddButton)
        addMenuAddButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        addMenuAddButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        addMenuAddButton.leftAnchor.constraint(equalTo: addExpenditureTextField.rightAnchor, constant: 10).isActive = true
        addMenuAddButton.centerYAnchor.constraint(equalTo: addExpenditureTextField.centerYAnchor).isActive = true
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.didTapDarkBackground))
        self.darkBackgroundLayer.addGestureRecognizer(gesture)
    }
}

//MARK: - Extensions: Text Field
extension HomeAddExpenditureView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 10
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =  currentString.replacingCharacters(in: range, with: string) as NSString
        
        return newString.length <= maxLength
    }
    
}
