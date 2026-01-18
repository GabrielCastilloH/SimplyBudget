//
//  HomeTitleView.swift
//  Familly Budget
//
//  Created by Gabriel Castillo on 8/10/23.
//

import UIKit
import DropDown

class HomeTimeRangeView: UIView {
    // View for all category options in home screen.

    //MARK: - Variables and Init
    var budgetCounter: HomeBudgetCounterView?
    
    var timeRange = "Daily" as NSString
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    // Init requires budgetCount as this view will call functions defined in budgetCounter as its time-range changes.
    init(frame: CGRect, budgetCount: HomeBudgetCounterView) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .clear
        
        budgetCounter = budgetCount
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Dropdown Variables and Functions
    lazy var titleDropdownButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(red: 1.00, green: 0.69, blue: 0.50, alpha: 0)
        button.addTarget(self, action: #selector(titleTextIsClicked), for: .touchUpInside)
        button.backgroundColor = .clear
        return button
    }()

    @objc func titleTextIsClicked() {
        // Executes when the title is clicked.
        titleDropdown.show()
    }

    lazy var titleDropdownImage: UIImageView = {
        let image = UIImageView(image: UIImage(systemName: "chevron.up")!)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.tintColor = .black
        return image
    }()

    lazy var titleDropdownView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()

    let titleDropdown: DropDown = DropDown()
    let titleDropdownOptions = ["Daily", "Monthly", "Yearly"]
    
    func titleDropdownImageAnimation(_ multiplier: CGFloat) {
        UIView.animate(withDuration: 0) {
            self.titleDropdownImage.transform = CGAffineTransform(scaleX: 1, y: 1 * multiplier)
        }
    }
    
    
    //MARK: - UI Elements and Setup
    lazy var titleTimeRangeLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.font = UIFont(name: "Arial", size: 40)
        textLabel.textColor = .black
        
        // Underline Capability
        let mutableStr = NSMutableAttributedString(string: self.timeRange as String)
        let underlineAtr = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
        mutableStr.addAttributes(underlineAtr, range: self.timeRange.range(of: self.timeRange as String))
        textLabel.attributedText = mutableStr
        return textLabel
    }()
    
    lazy var titleStaticText: UILabel = {
        let textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.font = UIFont(name: "Arial", size: 40)
        textLabel.textColor = .black
        textLabel.text = "Budget"
        return textLabel
    }()
    
    
    private func setupUI() {
        // Title Text related views.
        self.addSubview(titleTimeRangeLabel)
        titleTimeRangeLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 50).isActive = true
        titleTimeRangeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 90).isActive = true
        
        self.addSubview(titleStaticText)
        titleStaticText.topAnchor.constraint(equalTo: titleTimeRangeLabel.topAnchor, constant: 2).isActive = true
        titleStaticText.leftAnchor.constraint(equalTo: titleTimeRangeLabel.rightAnchor, constant: 10).isActive = true
        

        // Dropdown views and actions setup.
        self.addSubview(titleDropdownImage)
        titleDropdownImage.topAnchor.constraint(equalTo: titleTimeRangeLabel.bottomAnchor, constant: -33).isActive = true
        titleDropdownImage.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 28).isActive = true

        self.addSubview(titleDropdownView)
        titleDropdownView.widthAnchor.constraint(equalTo: titleTimeRangeLabel.widthAnchor, multiplier: 1).isActive = true
        titleDropdownView.heightAnchor.constraint(equalTo: titleTimeRangeLabel.heightAnchor, multiplier: 1).isActive = true
        titleDropdownView.topAnchor.constraint(equalTo: titleTimeRangeLabel.topAnchor).isActive = true
        titleDropdownView.centerXAnchor.constraint(equalTo: titleTimeRangeLabel.centerXAnchor).isActive = true

        titleDropdown.anchorView = titleDropdownView
        titleDropdown.dataSource = titleDropdownOptions

        titleDropdown.bottomOffset = CGPoint(x: 0, y: (titleDropdown.anchorView?.plainView.bounds.height)!)
        titleDropdown.topOffset = CGPoint(x: 0, y: -(titleDropdown.anchorView?.plainView.bounds.height)!)
        titleDropdown.direction = .bottom

        // Setup of actions of different dropdown events.
        titleDropdown.selectionAction = { (index: Int, item: String) in
            self.titleTimeRangeLabel.text = self.titleDropdownOptions[index]
            self.titleTimeRangeLabel.textColor = .black
            self.titleDropdownImageAnimation(1)
            
            self.budgetCounter!.progressBarMetricChanged(to: self.titleTimeRangeLabel.text!)
        }

        titleDropdown.cancelAction = { [] in
            self.titleDropdownImageAnimation(1)
        }

        titleDropdown.willShowAction = { [] in
            self.titleDropdownImageAnimation(-1)
        }

        self.addSubview(titleDropdownButton)
        titleDropdownButton.widthAnchor.constraint(equalTo: titleTimeRangeLabel.widthAnchor, multiplier: 1.2).isActive = true
        titleDropdownButton.heightAnchor.constraint(equalTo: titleTimeRangeLabel.heightAnchor, multiplier: 1).isActive = true
        titleDropdownButton.topAnchor.constraint(equalTo: titleTimeRangeLabel.topAnchor).isActive = true
        titleDropdownButton.centerXAnchor.constraint(equalTo: titleTimeRangeLabel.centerXAnchor).isActive = true
    }
}
