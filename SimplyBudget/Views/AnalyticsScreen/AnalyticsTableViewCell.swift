//
//  AnalyticsTableViewCell.swift
//  Familly Budget
//
//  Created by Gabriel Castillo on 10/12/23.
//

import UIKit
import DGCharts

class AnalyticsTableViewCell: UITableViewCell {

    //MARK: - Variables, Init and Functions
    static let identifier = "AnalyticsTableCell"

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configurePieChart(title: String, pieChart: PieChartView) {
        self.chartTitle.text = "\(title)"
        let cellView = self.contentView
        
        self.contentView.addSubview(pieChart)
        pieChart.translatesAutoresizingMaskIntoConstraints = false
        pieChart.centerXAnchor.constraint(equalTo: cellView.centerXAnchor).isActive = true
        pieChart.centerYAnchor.constraint(equalTo: cellView.centerYAnchor, constant: 20).isActive = true
        pieChart.heightAnchor.constraint(equalToConstant: 300).isActive = true
        pieChart.widthAnchor.constraint(equalToConstant: 300).isActive = true
    }
    
    func configureLineChart(title: String, lineChart: LineChartView) {
        self.chartTitle.text = "\(title)"
        let cellView = self.contentView
        
        self.contentView.addSubview(lineChart)
        lineChart.translatesAutoresizingMaskIntoConstraints = false
        lineChart.centerXAnchor.constraint(equalTo: cellView.centerXAnchor).isActive = true
        lineChart.centerYAnchor.constraint(equalTo: cellView.centerYAnchor, constant: 20).isActive = true
        lineChart.heightAnchor.constraint(equalToConstant: 300).isActive = true
        lineChart.widthAnchor.constraint(equalTo: cellView.widthAnchor, multiplier: 0.9).isActive = true
    }
    
    func configureBarChart(title: String, barChart: BarChartView) {
        self.chartTitle.text = "\(title)"
        let cellView = self.contentView
        
        self.contentView.addSubview(barChart)
        barChart.translatesAutoresizingMaskIntoConstraints = false
        barChart.centerXAnchor.constraint(equalTo: cellView.centerXAnchor).isActive = true
        barChart.centerYAnchor.constraint(equalTo: cellView.centerYAnchor, constant: 20).isActive = true
        barChart.heightAnchor.constraint(equalToConstant: 300).isActive = true
        barChart.widthAnchor.constraint(equalTo: cellView.widthAnchor, multiplier: 0.9).isActive = true
    }
    
    //MARK: - UI elements and setup.
    
    var chartTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.text = "_"
        return label
    }()
    
    
    func setupUI() {
        let cellView = self.contentView
        
        self.contentView.addSubview(chartTitle)
        chartTitle.leftAnchor.constraint(equalTo: cellView.leftAnchor, constant: 20).isActive = true
        chartTitle.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 15).isActive = true
    }

}
