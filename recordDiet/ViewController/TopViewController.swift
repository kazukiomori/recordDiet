//
//  ViewController.swift
//  recordDiet
//
//  Created by Apple on 2022/12/18.
//

import UIKit
import Charts
import RxSwift
import RxCocoa
import RealmSwift
import Foundation

class TopViewController: UIViewController, ChartViewDelegate {
    
    private let disposeBag = DisposeBag()
    @IBOutlet weak var lineChartView: LineChartView!
    @IBOutlet weak var segment: UISegmentedControl!
    // 記録するボタンを押下後、体重入力画面に遷移
    @IBOutlet weak var recordButton: UIButton! {
        didSet {
            recordButton.rx.tap.subscribe (onNext :{ _ in
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                guard let nextViewController = storyBoard.instantiateViewController(withIdentifier: "WeightInputViewController") as? WeightInputViewController else { return }
                self.navigationController?.show(nextViewController, sender: nil)
            }).disposed(by: disposeBag)
        }
    }
    var graphMode: GraphMode = GraphMode.Week
    let weightVM = WeightViewModel()
    var allWeightList: [Weight] = []
    var lastDate: Date = Date()
    var currentWeight: Weight = Weight()
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var weightNumberLabel: UILabel!
    @IBOutlet weak var kgLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // データベースから全期間のデータを取ってくる
        
        // セグメントの設定を0にして、週のチャートを表示する
        lineChartView.delegate = self
        segment.selectedSegmentIndex = 0
        self.loadChart()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now()+0.3) {
            self.loadChart()
        }
    }
    
    func loadChart() {
        if self.graphMode != .Week {
            self.changeGraph(mode: .Week)
        } else {
            self.graphMode = .Week
            self.dataLoad()
            self.createData()
        }
    }
    
    // セグメントの切り替えで、体重のチャートを週表示、月表示に変更
    @IBAction func selectIndex(_ sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        self.changeGraph(mode: GraphMode(rawValue: index)!)
    }
    
    func changeGraph(mode: GraphMode) {
        if (self.graphMode == mode) {
            
        } else {
            if mode == .Week {
                segment.selectedSegmentIndex = 0
            } else {
                segment.selectedSegmentIndex = 1
            }
            self.graphMode = mode
            self.lastDate = Date()
            self.createData()
        }
    }
    
    func dataLoad() {
        let weightList = weightVM.fetchAllData()
        self.allWeightList = weightList.sorted(by:{ $0.dateSt < $1.dateSt })
        if allWeightList.count != 0 {
            self.currentWeight = self.allWeightList.last!
            self.weightNumberLabel.text = "\(self.currentWeight.weight)"
        }
    }
    
    func createData() {
        self.dataLoad()
        switch graphMode {
        case .Week:
            createWeekList()
            break
        case .Month:
            createMonthList()
            break
        default:
            break
        }
    }
    
    func createWeekList() {
        var weekDateArray: [Weight] = []
        let endDateStr = AppDate().toStringWithCurrentLocale(date: self.lastDate)
        var endDate = AppDate().strDate(date: endDateStr)
        
        for date in AppDate().pastWeek(lastGetDate: self.lastDate) {
            
            for weight in allWeightList {
                if(weight.dateSt == AppDate().dateStrOnlyDate(date: date)) {
                    weekDateArray.append(weight)
                }
            }
        }
        var weightGraph = weightGraph(dateSt: AppDate().dateStrOnlyDate(date: Date()), totalWeight: 0, averageWeight: 0, graphMode: .Week)
        weightGraph.dataArray = weekDateArray
        self.chartSet(weightGraph: weightGraph)
    }
    
    func createMonthList() {
        var temDate = lastDate
        var monthDateArray: [Weight] = []
        var endDate = self.lastDate
        
        for date in AppDate().pastMonth(lastGetDate: self.lastDate) {
            
            for weight in allWeightList {
                if(weight.dateSt == AppDate().dateStrOnlyDate(date: date)) {
                    monthDateArray.append(weight)
                }
            }
        }
        var weightGraph = weightGraph(dateSt: AppDate().dateStrOnlyDate(date: Date()), totalWeight: 0, averageWeight: 0, graphMode: .Month)
        weightGraph.dataArray = monthDateArray
    
        self.chartSet(weightGraph: weightGraph)
    }
    
    func chartSet(weightGraph: weightGraph) {
        var labelCount = 0
        let model = weightGraphModel.createGraphModel(weightGraph: weightGraph)
        
        var labelNum = model.labelsNum
        
        let entries = model.rawData.enumerated().map {ChartDataEntry(x: Double($0.offset), y: Double($0.element))}
        let dataSet = LineChartDataSet(entries: entries)
        let data = LineChartData(dataSet: dataSet)
        
        switch weightGraph.graphMode {
        case .Week:
            labelCount = 6
            labelNum = 200
            break
        case .Month:
            labelCount = 30
            labelNum = 200
            dataSet.drawValuesEnabled = false
            break
        }
        
        dataSet.drawCirclesEnabled = false
        dataSet.drawIconsEnabled = false
        dataSet.lineWidth = 3
        dataSet.formLineWidth = 1
        dataSet.formSize = 15
        
        let gradientColors = [UIColor.systemBlue.cgColor, UIColor.systemMint.cgColor]
        let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)
        
        dataSet.fillAlpha = 0
        dataSet.fill = LinearGradientFill(gradient: gradient!, angle: 90)
        dataSet.drawFilledEnabled = true
        
        lineChartView.data = data
        model.formatter.mode = weightGraph.graphMode
        
        lineChartView.xAxis.labelPosition = .bottom
        lineChartView.rightAxis.enabled = false
        lineChartView.leftAxis.axisMinimum = 0
        lineChartView.leftAxis.axisMaxLabels = labelNum
        lineChartView.setVisibleXRangeMaximum(Double(labelCount))
        lineChartView.setVisibleYRangeMaximum(Double(labelNum), axis: YAxis.AxisDependency.right)
        
        lineChartView.xAxis.valueFormatter = model.formatter
        lineChartView.xAxis.labelCount = labelCount
        lineChartView.xAxis.drawGridLinesEnabled = false
        lineChartView.leftAxis.labelCount = 3
        lineChartView.dragEnabled = false
        lineChartView.dragXEnabled = false
        lineChartView.dragYEnabled = false
        lineChartView.doubleTapToZoomEnabled = false
        lineChartView.setVisibleXRange(minXRange: Double(labelCount), maxXRange: Double(labelCount))
        lineChartView.legend.enabled = false
        lineChartView.animate(xAxisDuration: 1, yAxisDuration: 1)
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        if let entry = entry as? ChartDataEntry {
            weightNumberLabel.text = "\(entry.y)"
        }
    }
}

// x軸の値を表示する
// 週：月曜日〜日曜日
// 月：1日〜31日　表示自体は5日刻み
public class lineChartFormatter: NSObject, AxisValueFormatter {
    var mode: GraphMode = .Week
    var array:[String] = []

    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        switch mode {
        case .Week:
            for i in 0..<8 {
                switch i {
                case 0:
                    array.append(NSLocalizedString("sunday", comment: ""))
                    break
                case 1:
                    array.append(NSLocalizedString("monday", comment: ""))
                    break
                case 2:
                    array.append(NSLocalizedString("tuesday", comment: ""))
                    break
                case 3:
                    array.append(NSLocalizedString("wednesday", comment: ""))
                    break
                case 4:
                    array.append(NSLocalizedString("tursday", comment: ""))
                    break
                case 5:
                    array.append(NSLocalizedString("friday", comment: ""))
                    break
                case 6:
                    array.append(NSLocalizedString("saturday", comment: ""))
                    break
                case 7:
                    array.append("")
                    break
                default:
                    break
                }
            }
            break
        case .Month:
            for i in 0..<31 {
                if (i == 4 || i == 9 || i == 14 || i == 19 || i == 24 || i == 29) {
                    array.append("\(i+1)+\(NSLocalizedString("date", comment: ""))")
                } else {
                    array.append("")
                }
            }
            break
        }
        return array[Int(value)]
    }

}


struct weightGraphModel {
    var rawData: [Float]
    var formatter: lineChartFormatter
    var labelsNum: Int
    var currentDate: Date
    
    static func createGraphModel(weightGraph: weightGraph) -> weightGraphModel {
        let model = weightGraphModel(rawData: getRawData(weightGraph:weightGraph), formatter: lineChartFormatter(), labelsNum: 200, currentDate: Date())
        return model
    }
    
    
    static func getRawData(weightGraph: weightGraph) -> [Float] {
        let weekConst = [1,2,3,4,5,6,7]
        var weekArray: [Float] = [0,0,0,0,0,0,0]
        
        var monthConst: [Int] = []
        for i in 0..<31 {
            monthConst.append(i+1)
        }
        
        var monthArray: [Float] = []
        for _ in 0..<31 {
            monthArray.append(0)
        }
        
        var returnArray:[Float] = []
        
        switch weightGraph.graphMode {
        case .Week:
            for weight in weightGraph.dataArray {
                if (weekConst.contains(weight.date.weekday)) {
                    weekArray[(weight.date.weekday)-1] = weight.weight
                }
            }
            returnArray = weekArray
            break
        case .Month:
            for weight in weightGraph.dataArray {
                if (monthConst.contains(weight.date.day)) {
                    monthArray[(weight.date.day)-1] = weight.weight
                }
            }
            returnArray = monthArray
            break
        }
        return returnArray
    }
}

struct weightGraph {
    var dateSt: String
    var totalWeight: Float
    var averageWeight: Float
    var dataArray: Array<Weight> = []
    //    var period: String
    var graphMode: GraphMode
    
    init(dateSt: String, totalWeight: Float, averageWeight: Float, graphMode: GraphMode = .Week) {
        self.dateSt = dateSt
        self.totalWeight = totalWeight
        self.averageWeight = averageWeight
        self.graphMode = graphMode
    }
}
    
public enum GraphMode: Int {
   case Week = 0
   case Month = 1
}



 
