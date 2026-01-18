//
//  ExpendituresTableCell.swift
//  Familly Budget
//
//  Created by Gabriel Castillo on 10/11/23.
//

import UIKit

class ExpendituresTableCell: UITableViewCell {
    
    //MARK: - Variables, Init and Functions
    static let identifier = "ExpendituresTableCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(category: String, amount: Int64, timeStamp: Date) {
        self.categoryImage.image = UIImage(named: "\(category)-img")
//        self.categoryImage.image = UIImage(named: "speed-img")
        self.amountLabel.text = "\(amount)"
        
        let usersCalendar = Calendar.current
        
        let day = usersCalendar.component(.day, from: timeStamp)
        let month = usersCalendar.component(.month, from: timeStamp)
        let monthName = DateFormatter().monthSymbols[month - 1].prefix(3)
        let year = usersCalendar.component(.year, from: timeStamp)
        let hour = usersCalendar.component(.hour, from: timeStamp)
        let minute = usersCalendar.component(.minute, from: timeStamp)
        
        self.dateLabel.text = "\(day) \(monthName). \(year) at \(hour):\(minute)"
    }
    
    //MARK: - UI elements and setup.
    var categoryImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = .label
        return imageView
    }()
    
    var amountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.text = "1_"
        return label
    }()
    
    var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 17, weight: .light)
        label.text = "2_"
        return label
    }()
    
    func setupUI() {
        
        let margins = self.contentView.layoutMarginsGuide
        self.contentView.addSubview(categoryImage)
        categoryImage.heightAnchor.constraint(equalToConstant: 60).isActive = true
        categoryImage.widthAnchor.constraint(equalToConstant: 60).isActive = true
        categoryImage.centerYAnchor.constraint(equalTo: margins.centerYAnchor).isActive = true
        categoryImage.leftAnchor.constraint(equalTo: margins.leftAnchor).isActive = true
        
        self.contentView.addSubview(amountLabel)
        amountLabel.leftAnchor.constraint(equalTo: categoryImage.rightAnchor, constant: 30).isActive = true
        amountLabel.topAnchor.constraint(equalTo: margins.topAnchor, constant: 12).isActive = true
        amountLabel.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -8).isActive = true
        
        self.contentView.addSubview(dateLabel)
        dateLabel.rightAnchor.constraint(equalTo: margins.rightAnchor, constant: -20).isActive = true
        dateLabel.centerYAnchor.constraint(equalTo: amountLabel.centerYAnchor).isActive = true
    }
    
}
