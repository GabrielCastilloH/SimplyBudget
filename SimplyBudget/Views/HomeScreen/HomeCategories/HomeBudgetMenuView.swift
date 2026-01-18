//
//  HomeBudgetView.swift
//  Familly Budget
//
//  Created by Gabriel Castillo on 8/18/23.
//

import UIKit

class HomeBudgetMenuView: UIView {
    // Edits user budget, bottom left gear icon in Home Screen.
    
    var parentViewController: HomeCategoriesView?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    init(frame: CGRect, parentVC: HomeCategoriesView) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        // Problem here.
        setupUI()
        
        self.parentViewController = parentVC
    
    }
    
    //MARK: - (Edit Budget) Functions
    @objc func editButtonClicked() {
        if self.budgetMenuTextField.text ?? "" != "" {
            do {
                let appUser = try context.fetch(User.fetchRequest())[0]
                appUser.dailyBudget = Int64(self.budgetMenuTextField.text!) ?? 0 // setting daily budget to value of text field.

                let newBudget = "\(appUser.dailyBudget)"
                self.budgetMenuCurrentValue.text = newBudget
                self.parentViewController?.refreshBudget2()
                
                self.budgetMenuTextField.text = ""
                self.endEditing(true)
            }
            catch {
                print("Error fetching data.")
                return
            }
            
            do {
                try context.save()
            }
            catch {
                print("Error: failed to save data.")
                return
            }
        }
    }
    
    //MARK: - UI Elements and Setup
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var darkBackgroundLayer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        return view
    }()
    
    var budgetMenuBackground: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.backgroundColor = UIColor(red: 0.95, green: 0.99, blue: 0.96, alpha: 1.00)
        return view
    }()
    
    
    var budgetMenuTextField: UITextField = {
        let textField = UITextField()
        let centeredParagraphStyle = NSMutableParagraphStyle()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.cornerRadius = 10
        textField.clipsToBounds = true
        textField.backgroundColor = .white
        textField.placeholder = "Enter Quantity..."
        textField.setLeftPaddingPoints(20)
        textField.keyboardType = .numberPad
        return textField
    }()
    
    var budgetMenuTitleText: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textColor = .black
        textView.backgroundColor = .clear
        textView.isEditable = false
        textView.text = "Edit Budget"
        textView.isScrollEnabled = false
        textView.font = UIFont(name: "Arial", size: 35)
        return textView
    }()
    
    var budgetMenuCurrentValue: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.textAlignment = .center
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.clipsToBounds = true
        textView.backgroundColor = .clear
        textView.text = "texto"
        textView.font = UIFont(name: "Arial", size: 25)
        textView.textAlignment = .center
        return textView
    }()
        
    var budgetMenuEditButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = UIColor(red: 0.21, green: 0.66, blue: 0.44, alpha: 1.00)
        button.clipsToBounds = true
        button.layer.cornerRadius = 20 // Height ÷ 2, i dunno how to get the height tho
        button.addTarget(self, action: #selector(editButtonClicked), for: .touchUpInside)
        return button
    }()
    
    private func setupUI() {
        showHideBudgetMenu(0)
        
        self.addSubview(darkBackgroundLayer)
        darkBackgroundLayer.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1).isActive = true
        darkBackgroundLayer.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1).isActive = true
        darkBackgroundLayer.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        darkBackgroundLayer.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        self.addSubview(budgetMenuBackground)
        budgetMenuBackground.widthAnchor.constraint(equalToConstant: 300).isActive = true
        budgetMenuBackground.heightAnchor.constraint(equalToConstant: 300).isActive = true
        budgetMenuBackground.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        budgetMenuBackground.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.showHideBudgetMenu(0)
        
        self.addSubview(budgetMenuTitleText)
        budgetMenuTitleText.leftAnchor.constraint(equalTo: budgetMenuBackground.leftAnchor, constant: 10).isActive = true
        budgetMenuTitleText.centerYAnchor.constraint(equalTo: budgetMenuBackground.topAnchor, constant: 50).isActive = true
        
        // Setting up the current budget
        self.addSubview(budgetMenuCurrentValue)
        budgetMenuCurrentValue.widthAnchor.constraint(equalTo: budgetMenuBackground.widthAnchor, multiplier: 0.7).isActive = true
        budgetMenuCurrentValue.heightAnchor.constraint(equalToConstant: 50).isActive = true
        budgetMenuCurrentValue.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        budgetMenuCurrentValue.topAnchor.constraint(equalTo: budgetMenuTitleText.bottomAnchor, constant: 10).isActive = true
        
        // Problem is here.
        do {
            let appUsers = try context.fetch(User.fetchRequest())
            if appUsers != [] {
                let dailyBudgetValue = appUsers[0].dailyBudget
                budgetMenuCurrentValue.text = "\(dailyBudgetValue)"
            }
//            print(appUsers)
            
        } catch {
            print("Error setting defaul budget value in this screen.")
        }
        
        self.addSubview(budgetMenuTextField)
        budgetMenuTextField.delegate = self
        budgetMenuTextField.widthAnchor.constraint(equalTo: budgetMenuBackground.widthAnchor, multiplier: 0.7).isActive = true
        budgetMenuTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        budgetMenuTextField.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        budgetMenuTextField.topAnchor.constraint(equalTo: budgetMenuCurrentValue.bottomAnchor, constant: 10).isActive = true
      
        self.addSubview(budgetMenuEditButton)
        budgetMenuEditButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        budgetMenuEditButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        budgetMenuEditButton.topAnchor.constraint(equalTo: budgetMenuTextField.bottomAnchor, constant: 20).isActive = true
        budgetMenuEditButton.centerXAnchor.constraint(equalTo: budgetMenuTextField.centerXAnchor).isActive = true
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.didTapDarkBackground))
        self.darkBackgroundLayer.addGestureRecognizer(gesture)
    }
    
    @objc func didTapDarkBackground(sender : UITapGestureRecognizer) {
        self.showHideBudgetMenu(0)
        self.endEditing(true)
    }
    
    func showHideBudgetMenu(_ value: Int) {
        // Value = 1 to show, 0 to hide.
        if value == 1 {
            self.isHidden = false
        }
        else {
            self.isHidden = true
        }
    }


}

//MARK: - Extensions: Text Field

extension HomeBudgetMenuView: UITextFieldDelegate {
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
