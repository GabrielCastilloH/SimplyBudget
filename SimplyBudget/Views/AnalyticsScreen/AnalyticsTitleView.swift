//
//  AnalyticsTitleView.swift
//  Familly Budget
//
//  Created by Gabriel Castillo on 10/11/23.
//

import UIKit

class AnalyticsTitleView: UIView {
    //MARK: - Variables and Init
    
    var parentViewController: AnalyticsViewController?
    
    init(frame: CGRect, parentVC: AnalyticsViewController) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.parentViewController = parentVC
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI Elements and Setup
    var analyticsBackBtn: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.tintColor = .black
        button.backgroundColor = .clear
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(analyticsBackBtnClicked), for: .touchUpInside)
        return button
    }()
    
    var expendituresTableTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Analytics"
        label.font = .systemFont(ofSize: 40, weight: .medium)
        return label
    }()
    
    @objc func analyticsBackBtnClicked() {
        self.parentViewController?.popAnalyticsView()
    }
    
    func setupUI() {
        self.backgroundColor = .clear
        
        self.addSubview(analyticsBackBtn)
        analyticsBackBtn.heightAnchor.constraint(equalToConstant: 25).isActive = true
        analyticsBackBtn.widthAnchor.constraint(equalToConstant: 20).isActive = true
        analyticsBackBtn.topAnchor.constraint(equalTo: self.topAnchor, constant: 75).isActive = true
        analyticsBackBtn.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30).isActive = true
        
        self.addSubview(expendituresTableTitle)
        expendituresTableTitle.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        expendituresTableTitle.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    }

}
