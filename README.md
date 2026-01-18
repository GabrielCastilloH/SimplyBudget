# SimplyBudget

A comprehensive iOS budget tracking application developed as part of the IB Diploma Programme Computer Science Internal Assessment. SimplyBudget helps users manage their daily expenses across multiple categories with intuitive visualizations and analytics.

## 📱 Demo Video

Watch the application in action:

[![SimplyBudget Demo](https://img.youtube.com/vi/v1UCKnqSMdU/0.jpg)](https://www.youtube.com/watch?v=v1UCKnqSMdU)

## ✨ Features

### Core Functionality
- **Expense Tracking**: Record and categorize daily expenditures across 8 predefined categories
- **Budget Management**: Set and monitor daily budget limits with real-time progress tracking
- **Time Range Filtering**: View spending patterns across different time periods (daily, weekly, monthly)
- **Category Management**: Organize expenses into categories:
  - Housing
  - Food
  - Transportation
  - Utilities
  - Personal
  - Savings
  - Health
  - Miscellaneous

### Analytics & Visualization
- **Recent Spending Analysis**: Bar chart showing budget performance over the last 10 days
- **Monthly Category Breakdown**: Line chart tracking spending in the most-used category
- **All-Time Spending Trends**: Historical spending patterns visualized through line charts
- **Monthly & Yearly Pie Charts**: Interactive pie charts showing spending distribution by category
- **Interactive Charts**: Tap on pie charts to view detailed category information

### User Experience
- **Swipe Navigation**: Intuitive gesture-based navigation between screens
  - Swipe left: Navigate to Analytics
  - Swipe right: View Expenditures Table
- **Expenditure Management**: View, sort, and delete expense entries
- **Persistent Storage**: All data saved locally using CoreData

## 🛠 Technologies Used

- **Swift**: Primary programming language
- **UIKit**: iOS user interface framework
- **CoreData**: Local data persistence
- **DGCharts**: Chart visualization library (bar charts, line charts, pie charts)
- **DropDown**: Custom dropdown menu components
- **CocoaPods**: Dependency management

## 📋 Requirements

- macOS operating system
- Xcode (latest version recommended)
- iOS Simulator or physical iOS device
- CocoaPods installed (`sudo gem install cocoapods`)

## 🚀 Getting Started

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/SimplyBudget.git
   cd SimplyBudget
   ```

2. **Install CocoaPods dependencies**
   ```bash
   cd SimplyBudget
   pod install
   ```

3. **Open the workspace**
   - Open `SimplyBudget.xcworkspace` (not `.xcodeproj`) in Xcode
   - Note: You may need to change the bundle identifier to run the project

4. **Build and Run**
   - Select your target device or simulator
   - Press `Command + R` or click the Run button
   - The app will launch in the iOS Simulator

### First Launch

On first launch, the app will:
- Create a default user with a daily budget of $10
- Initialize the CoreData database
- Display the home screen with budget counter and category views

## 📁 Project Structure

```
SimplyBudget/
├── SimplyBudget/
│   ├── Controllers/          # View controllers
│   │   ├── HomeViewController.swift
│   │   ├── AnalyticsViewController.swift
│   │   └── ExpendituresTableViewController.swift
│   ├── Views/                # Custom UI components
│   │   ├── HomeScreen/
│   │   ├── AnalyticsScreen/
│   │   └── TableScreen/
│   ├── Model/                # Data models
│   │   ├── CoreDataObjects/
│   │   └── Expenditure+CoreDataProperties.swift
│   ├── Assets.xcassets/      # Images and icons
│   └── Extensions.swift      # Swift extensions
├── Documentation/            # IB IA Documentation
│   ├── Crit_A_Planning.pdf
│   ├── Crit_B_Design.pdf
│   ├── Crit_B_Record_of_tasks.pdf
│   ├── Crit_C_Development.pdf
│   ├── Crit_E_Evaluation.pdf
│   └── Appendix.pdf
└── Pods/                     # CocoaPods dependencies
```

## 📚 IB Diploma Programme Documentation

This project was completed as part of the IB Computer Science Internal Assessment. The following documentation provides detailed information about the development process:

### Planning & Design
- **[Planning Document](Documentation/Crit_A_Planning.pdf)** - Initial project planning and requirements analysis
- **[Design Document](Documentation/Crit_B_Design.pdf)** - System design, architecture, and UI/UX planning
- **[Record of Tasks](Documentation/Crit_B_Record_of_tasks.pdf)** - Detailed task breakdown and progress tracking

### Development & Evaluation
- **[Development Document](Documentation/Crit_C_Development.pdf)** - Implementation details, code explanations, and development process
- **[Evaluation Document](Documentation/Crit_E_Evaluation.pdf)** - Project evaluation, testing results, and future improvements
- **[Appendix](Documentation/Appendix.pdf)** - Additional materials, code snippets, and supplementary documentation

## 🎯 Key Learning Outcomes

This project demonstrates:
- **iOS Development**: Native iOS app development using Swift and UIKit
- **Data Persistence**: CoreData integration for local data storage
- **Data Visualization**: Complex chart implementations using DGCharts
- **MVC Architecture**: Proper separation of concerns in iOS development
- **User Interface Design**: Custom UI components and gesture-based navigation
- **Project Management**: Structured development following IB criteria

## 📝 Notes

- The app includes sample data generation for demonstration purposes
- CoreData models are defined in the Model folder
- All charts are dynamically generated based on user expenditure data
- The app supports both portrait and landscape orientations

## 🤝 Contributing

This is a portfolio project from my IB Diploma Programme. While contributions are welcome, please note that this project was completed as part of academic coursework.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👤 Author

**Gabriel Castillo**
- IB Diploma Programme Computer Science Internal Assessment
- Developed as part of the International Baccalaureate curriculum

---

*This project was developed as part of the IB Diploma Programme Computer Science Internal Assessment, demonstrating proficiency in software development, problem-solving, and technical documentation.*
