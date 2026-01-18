//
//  ExpendituresTableTitleView.swift
//  Familly Budget
//
//  Created by Gabriel Castillo on 10/11/23.
//

import UIKit

class ExpendituresTableTitleView: UIView {
    // Title view for expenditures table.
    
    //MARK: - Variables and Init
    var parentViewController: ExpendituresTableViewController?
    
    init(frame: CGRect, parentVC: ExpendituresTableViewController) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .clear
        
        self.parentViewController = parentVC
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI Elements and Setup
    var expendituresTableBackBtn: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.tintColor = .black
        button.backgroundColor = .clear
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(expendituresTableBackBtnClicked), for: .touchUpInside)
        return button
    }()
    
    var expendituresTableTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Expenses"
        label.font = .systemFont(ofSize: 40, weight: .medium)
        return label
    }()
    
    @objc func expendituresTableBackBtnClicked() {
        self.parentViewController?.popExpendituresTableView()
    }
    
    func setupUI() {
        self.addSubview(expendituresTableBackBtn)
        expendituresTableBackBtn.heightAnchor.constraint(equalToConstant: 25).isActive = true
        expendituresTableBackBtn.widthAnchor.constraint(equalToConstant: 20).isActive = true
        expendituresTableBackBtn.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20).isActive = true
        expendituresTableBackBtn.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30).isActive = true
        
        self.addSubview(expendituresTableTitle)
        expendituresTableTitle.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -7).isActive = true
//        expendituresTableTitle.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30).isActive = true
        expendituresTableTitle.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    }

}
