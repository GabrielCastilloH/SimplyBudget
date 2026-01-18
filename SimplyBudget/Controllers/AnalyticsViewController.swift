//
//  AnalyticsVC.swift
//  SimplyBudget
//
//  Created by Gabriel Castillo on 8/7/23.
//

import UIKit
import DGCharts
import CoreData

class AnalyticsViewController: UIViewController {
    // Controls analytics view.
    
    //MARK: - Variables and Init
    var analyticsTitleView: AnalyticsTitleView?
    var allExpenditures: [Expenditure]?
    var allCharts: [Any]?
    var largestCategory: String?
    var chartTitles: [String]?
    var userDailyBudget: Int64?
    
    var selectedCategory = "Click Chart!"
    
    // Categories to label the charts.
    let categories = ["housing", "food", "transportation",
                      "utilities", "personal", "savings", "health", "miscellaneous"]
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        refreshDataAndCharts()
        
        self.analyticsTitleView = AnalyticsTitleView(frame: .zero, parentVC: self)
        setupAnalyticsUI()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    // Fills in allExpenditures data everytime view appears.
    override func viewWillAppear(_ animated: Bool) {
        refreshDataAndCharts()
    }
    
    //MARK: - Data and Setup
    func refreshDataAndCharts() {
        do {
            let appUser = try context.fetch(User.fetchRequest())[0]
            self.userDailyBudget = appUser.dailyBudget
            self.allExpenditures = (appUser.totalSpending?.allObjects as! [Expenditure]).sorted(by: { $0.timeStamp!.compare($1.timeStamp!) == .orderedDescending
            })
        }
        catch {
            fatalError("Error fetching budget data for table view.")
        }
        
        // Put all charts here.
        self.allCharts = [
            createRecentSpending(),
            createMostSpentCatMonthlyLineChart(),
            createAllTimeSpendingLineChart(),
            createMonthlySpendingPieChart(),
            createYearlySpendingPieChart(),
        ]
        
        self.chartTitles = [
            "Recent Spending Under/Over Budget",
            "Most Spent This Month: \(largestCategory?.capitalized ?? "No Data")",
            "Total Daily Spending",
            "Monthly Spending per Category",
            "Yearly Spending per Category",
        ]
    }
    
    var tableView: UITableView = {
        let tableV = UITableView()
        tableV.translatesAutoresizingMaskIntoConstraints = false
        tableV.backgroundColor = .white
        tableV.allowsSelection = false
        tableV.register(AnalyticsTableViewCell.self, forCellReuseIdentifier: AnalyticsTableViewCell.identifier)
        tableV.rowHeight = 370 // Required because we're not using Auto Layout.
        return tableV
    }()
    
    //MARK: - Bar Chart
    func createRecentSpending() -> BarChartView {
        // Returns a bar chart showing how much you spent under or over your budget in the last 10 days.
        let barChart = BarChartView()
        
        
        // Get all expenditures in the last 10 days.
        var expendituresPerDate: [[Expenditure]] = []
        
        for _ in 0...9 {
            expendituresPerDate.append([])
        }
        
        
        for i in 0...9 {
            let dayOfExpense = Calendar.current.date(byAdding: .day, value: -i, to: Date())!
            
            for expenditure in self.allExpenditures! {
                if Calendar.current.isDate(expenditure.timeStamp!, inSameDayAs: dayOfExpense) {
                    expendituresPerDate[i].append(expenditure)
                }
            }
        }
        
        var recentDailySpending: [Int64] = []
        
        for _ in 0...9 {
            recentDailySpending.append(0) // Look into how to consicely create an empty array of n values in swift
        }
        
        // Take the sum of those expenditures per day.
        for i in 0...9 {
            for expenditure in expendituresPerDate[i] {
                recentDailySpending[i] += expenditure.amount
            }
        }
        
        // We now have recentDailySpending, with the total expenditures in the last 10 days.
        var posEntries = [BarChartDataEntry()]
        var negEntries = [BarChartDataEntry()]
        
        for i in 0...(recentDailySpending.count - 1) {
            let budgetMinusExpense = self.userDailyBudget! - recentDailySpending[i]
            let newEntry = BarChartDataEntry(x: Double(i), y: Double(budgetMinusExpense))
            
            if budgetMinusExpense >= 0 {
                posEntries.append(newEntry)
            } else {
                negEntries.append(newEntry)
            }
        }
        
        let set1 = BarChartDataSet(entries: posEntries)
        let set2 = BarChartDataSet(entries: negEntries)
        let data = BarChartData(dataSets: [set1, set2])
        set1.drawValuesEnabled = false
        set2.drawValuesEnabled = false
        barChart.data = data
        
        barChart.xAxis.labelPosition = .bottom
        barChart.legend.enabled = false
        
        barChart.chartDescription.text = "Days ago."
        barChart.chartDescription.font = UIFont(name: "Arial", size: 14)!
        
        let greenColor: UIColor = UIColor(red: 0.20, green: 0.63, blue: 0.42, alpha: 1.00)
        set1.colors = [greenColor]
        
        let redColor = UIColor(red: 201/255, green: 36/255, blue: 91/255, alpha: 1.00)
        set2.colors = [redColor]
        
        
        return barChart
    }
    
    
    //MARK: - Line Charts
    func averageDataIn20(for dailySpendingData:[Double]) -> [ChartDataEntry] {
        // Takes the average of every 20th part of the data and returns these averaged chart entries.
        
        var entries = [ChartDataEntry()]
        var counter = 0
        
        for _ in 0...(dailySpendingData.count - 1) {
            // Setting average value to be changed later, and average divisor to be one 20th of the data set.
            var averageValue = 0.0
            let averageDivisor = Int(dailySpendingData.count / 20)
            
            // Everytime the current day is at a 20th of the whole data, take the average of all the days within that part of the whole data.
            if averageDivisor != 0 {
                if counter % averageDivisor == 0 && counter != 0  {
                    for i in 0...averageDivisor-1 {
                        averageValue += dailySpendingData[counter - averageDivisor + i]
                    }
                    
                    let finalAverage = averageValue/Double(averageDivisor)
                    
                    // Every 20th part append this entry to data entries (should have 20 in total).
                    entries.append(ChartDataEntry(x: Double(counter), y: finalAverage))
                    
                }
                counter += 1
            }
            
        }
        
        // Return entries.
        return entries
    }
    
    func styleLineChart(for lineChart: LineChartView,
                        withData setOfData: LineChartDataSet,
                        xBeing descriptionText: String,
                        colored color: UIColor) {
        
        setOfData.drawCirclesEnabled = false
        setOfData.mode = .cubicBezier
        setOfData.lineWidth = 3
        
        setOfData.setColor(color)
        
        lineChart.data?.setDrawValues(false)
        lineChart.legend.enabled = false
        lineChart.leftAxis.enabled = false
        lineChart.rightAxis.setLabelCount(5, force: false)
        lineChart.rightAxis.labelFont = .systemFont(ofSize: 13)
        
        lineChart.xAxis.labelPosition = .bottom
        lineChart.xAxis.setLabelCount(5, force: false)
        lineChart.xAxis.labelFont = .systemFont(ofSize: 13)
        
        lineChart.animate(xAxisDuration: 0.5)
        
        
        lineChart.chartDescription.text = descriptionText
        lineChart.chartDescription.font = UIFont(name: "Arial", size: 14)!
    }
    
    func createMostSpentCatMonthlyLineChart() -> LineChartView {
        let lineChart = LineChartView()
        
        // First value in the x-axis has to be earliest data entry.
        let userCalendar = Calendar.current
        
        // In case there are no expenditures
        if self.allExpenditures! != [] {
            
            // Get first day of month.
            guard let firstDayMonth = userCalendar.date(from: Calendar.current.dateComponents([.year, .month], from: Date())) else {
                fatalError("Error calculating first day of month.")
            }
            
            // Find the number of days in the month.
            let numDays = userCalendar.range(of: .day, in: .month, for: Date())!.count
            var expendituresPerDate: [[Expenditure]] = []
            
            // For each day in the month, create an empty array.
            for _ in 0...numDays {
                expendituresPerDate.append([])
            }
            
            // For each day in the month, fill the empty array with the expenditures in that day of that month.
            for i in 0...numDays {
                let dayOfExpense = userCalendar.date(byAdding: .day, value: i, to: firstDayMonth)!
                
                for expenditure in self.allExpenditures! {
                    if userCalendar.isDateInThisMonth(expenditure.timeStamp!) {
                        if userCalendar.isDate(expenditure.timeStamp!, inSameDayAs: dayOfExpense) {
                            expendituresPerDate[i].append(expenditure)
                        }
                    }
                }
            }
            
            // Find the category with the most spending this month by getting the total for each category in that month.
            let totalPerCategory = getTotalPerCategoryMonthly()
            var largestCategoryIndex = 0
            
            var counter = 0
            for currentCategory in totalPerCategory {
                
                if currentCategory > totalPerCategory[largestCategoryIndex] {
                    largestCategoryIndex = counter
                }
                counter += 1
            }
            
            // Add to dailySpendingInMostCategory how much was spent in that category each day.
            let largestCategory = self.categories[largestCategoryIndex]
            self.largestCategory = largestCategory
            
            var dailySpendingInMostCategory: [Double] = []
            
            for _ in 0...(expendituresPerDate.count - 1) {
                dailySpendingInMostCategory.append(0.0)
            }
            
            for i in 0...(expendituresPerDate.count - 1) {
                for expenditure in expendituresPerDate[i] {
                    if expenditure.category == largestCategory {
                        dailySpendingInMostCategory[i] += Double(expenditure.amount)
                    }
                }
            }
            
            // Average the data to make a smooth graph.
            let entries = averageDataIn20(for: dailySpendingInMostCategory)

            let set1 = LineChartDataSet(entries: entries)
            let data = LineChartData(dataSet: set1)
            lineChart.data = data
            
            // Styling
            let magentaColor = UIColor(red: 201/255, green: 36/255, blue: 91/255, alpha: 1.00)
            styleLineChart(for: lineChart, withData: set1, xBeing: "Days in month", colored: magentaColor)
            
            return lineChart
            
        } else { return lineChart }
    }
    
    func createAllTimeSpendingLineChart() -> LineChartView {
        let lineChart = LineChartView()
        
        // First value in the x-axis has to be earliest data entry.
        let userCalendar = Calendar.current
        
        // In case there are no expenditures
        if self.allExpenditures! != [] {
            
            let startDate = self.allExpenditures!.last!.timeStamp
            let endDate = self.allExpenditures![0].timeStamp
        
            let numDays = endDate!.interval(ofComponent: .day, fromDate: startDate!)
            
            var expendituresPerDate: [[Expenditure]] = []
            
            for _ in 0...numDays {
                expendituresPerDate.append([])
            }
            
            for i in 0...numDays {
                let dayOfExpense = userCalendar.date(byAdding: .day, value: i, to: startDate!)!
                
                for expenditure in self.allExpenditures! {
                    if userCalendar.isDate(expenditure.timeStamp!, inSameDayAs: dayOfExpense) {
                        expendituresPerDate[i].append(expenditure)
                    }
                }
            }
            
            // Gets total spending per day.
            var totalSpendingPerDay: [Double] = []
                    
            for _ in 0...(expendituresPerDate.count - 1) {
                totalSpendingPerDay.append(0.0)
            }
            
            for i in 0...(expendituresPerDate.count - 1) {
                for expenditure in expendituresPerDate[i] {
                    totalSpendingPerDay[i] += Double(expenditure.amount)
                }
            }
            
            let entries = averageDataIn20(for: totalSpendingPerDay)
            
            let set1 = LineChartDataSet(entries: entries)
            let data = LineChartData(dataSet: set1)
            lineChart.data = data
            
            // Styling
            let blueColor = UIColor(red: 0.22, green: 0.38, blue: 0.83, alpha: 1.00)
            styleLineChart(for: lineChart, withData: set1, xBeing: "Days since using app.", colored: blueColor)
            
            return lineChart
            
        } else { return lineChart }
    }
    
    
    //MARK: - Pie Chart Functions
    func getTotalPerCategoryMonthly() -> [Int] {
        var totalPerCategoryMonthly: [Int] = []
        for _ in self.categories {
            totalPerCategoryMonthly.append(0)
        }
        
        for expenditure in allExpenditures! {
            // For every expenditure: find category and add amount to that categories total spending.
            var categoryIndex = 0
            let userCalendar = Calendar.current
            
            for category in self.categories {
                if userCalendar.isDateInThisMonth(expenditure.timeStamp!) {
                    if expenditure.category == category {
                        totalPerCategoryMonthly[categoryIndex] += Int(expenditure.amount)
                    }
                }
                categoryIndex += 1
            }
        }
        
        return totalPerCategoryMonthly
    }
    
    func stylePieChart(for pieChart: PieChartView) {
        pieChart.animate(xAxisDuration: 0.5, easingOption: .easeInOutCirc)
        pieChart.rotationEnabled = false
        pieChart.legend.enabled = false

        pieChart.centerText = self.selectedCategory.capitalized
        pieChart.centerTextRadiusPercent = 0.95
    }
    
    func createMonthlySpendingPieChart() -> PieChartView {
        // Creates a MONTHLY spending per category pie chart.
        
        // Create chart
        let pieChart = PieChartView()
        pieChart.delegate = self
        
        // Supply Data
        let totalPerCategoryMonthly = getTotalPerCategoryMonthly()
        
        
        // For each category add a PieChartDataEntry with the total spending in that category.
        var entries = [PieChartDataEntry()]
        
        for i in 0...(categories.count - 1) {
            var chartLabel = categories[i].capitalized
            if categories[i] == "transportation" {
                chartLabel = "Transp."
            } else if categories[i] == "miscellaneous" {
                chartLabel = "Misc."
            }
            
            entries.append(PieChartDataEntry(value: Double(totalPerCategoryMonthly[i]), label: chartLabel))
        }
        
        let dataSet = PieChartDataSet(entries: entries)
        
        // Main style
        dataSet.colors = ChartColorTemplates.pastel()
        dataSet.drawValuesEnabled = false
        
        let data = PieChartData(dataSet: dataSet)
        pieChart.data = data
        
        // Other styling
        stylePieChart(for: pieChart)
        
        return pieChart
    }
    
    func createYearlySpendingPieChart() -> PieChartView {
        // Creates a YEARLY spending per category pie chart.
        
        // Create chart
        let pieChart = PieChartView()
        pieChart.delegate = self
        
        // Supply Data
        var totalPerCategoryYearly: [Int] = []
        for _ in self.categories {
            totalPerCategoryYearly.append(0)
        }
        
        for expenditure in allExpenditures! {
            // For every expenditure: find category and add amount to that categories total spending.
            var categoryIndex = 0
            let userCalendar = Calendar.current
            
            for category in categories {
                if userCalendar.isDateInThisYear(expenditure.timeStamp!) {
                    if expenditure.category == category {
                        totalPerCategoryYearly[categoryIndex] += Int(expenditure.amount)
                    }
                    categoryIndex += 1
                }
                
            }
        }
        
        // For each category add a PieChartDataEntry with the total spending in that category.
        var entries = [PieChartDataEntry()]
        
        for i in 0...(categories.count - 1) {
            var chartLabel = categories[i].capitalized
            if categories[i] == "transportation" {
                chartLabel = "Transp."
            } else if categories[i] == "miscellaneous" {
                chartLabel = "Misc."
            }
            
            entries.append(PieChartDataEntry(value: Double(totalPerCategoryYearly[i]), label: chartLabel))
        }
        
        let dataSet = PieChartDataSet(entries: entries)
        
        // Main style
        dataSet.colors = ChartColorTemplates.pastel()
        dataSet.drawValuesEnabled = false
        
        let data = PieChartData(dataSet: dataSet)
        pieChart.data = data
        
        // Other styling
        stylePieChart(for: pieChart)
        
        return pieChart
    }
    
    
    //MARK: - Functions and UI Setup
    func popAnalyticsView() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func setupAnalyticsUI() {
        view.backgroundColor = .white
        
        view.addSubview(analyticsTitleView!)
        analyticsTitleView!.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        analyticsTitleView!.heightAnchor.constraint(equalToConstant: 120).isActive = true
        analyticsTitleView!.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
        
        view.addSubview(tableView)
        self.tableView.topAnchor.constraint(equalTo: analyticsTitleView!.bottomAnchor, constant: 20).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        self.tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        self.tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
    }

}

//MARK: - Extensions: Table and Chart

extension AnalyticsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allCharts?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AnalyticsTableViewCell.identifier, for: indexPath) as? AnalyticsTableViewCell else {
            fatalError("The table view could not dequeue a ExpendituresTableCell.")
        }
        
        let currentChart = self.allCharts![indexPath.row]
        let title = self.chartTitles![indexPath.row]
        
        if currentChart is PieChartView {
            cell.configurePieChart(title: title, pieChart: currentChart as! PieChartView)
        }
        else if currentChart is LineChartView {
            let lineChart = currentChart as! LineChartView
            cell.configureLineChart(title: title, lineChart: lineChart)
            if lineChart.chartDescription.text == "Days in month" {
                let usersCalendar = Calendar.current
                let month = usersCalendar.component(.month, from: Date())
                let monthName = DateFormatter().monthSymbols[month - 1]
                lineChart.chartDescription.text = "Days in \(monthName)"
            }
        }
        else if currentChart is BarChartView {
            cell.configureBarChart(title: title, barChart: currentChart as! BarChartView)
        }
        
        return cell
    }
}

extension AnalyticsViewController: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        let valueLabel: String = entry.value(forKey: "label")! as! String
        let valueNum: Int = Int(entry.value(forKey: "value")! as! Double)
        
        // Goes through all charts available, and check to see which one is the being clicked on.
        for chart in allCharts! {
            if chartView.isEqual(chart) {
                // If it is a piechart then display data in center.
                guard let currentChart = chart as? PieChartView else { return }
                currentChart.centerText = """
                    \(valueLabel)
                    \(valueNum.addCommas())
                    """
            }
        }
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        for chart in allCharts! {
            if chartView.isEqual(chart) {
                // If it is a piechart then display data in center.
                guard let currentChart = chart as? PieChartView else { return }
                currentChart.centerText = ""
            }
        }
    }
}
