////
////  GraphView.swift
////  recordDiet
////
////  Created by Kazuki Omori on 2023/02/02.
////
//
//import UIKit
//import Charts
//import RxSwift
//
//class GraphView: UIView {
//
//    @IBOutlet weak var weightLabel: UILabel!
//    @IBOutlet weak var dateLabel: UILabel!
//    @IBOutlet weak var cardView: UIView!
//    @IBOutlet weak var scrollView: UIScrollView!
//    var chartDataSet: LineChartDataSet!
//    var allWeightDataList: [String: Float] = [:]
//    var allWeightList: [Weight] = []
//    let weightVM = WeightViewModel()
//    var minNum: Double = +0
//    
//    var list: [WeightView] = []
//    var requestCount = 0
//    
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        instantiateView()
//    }
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        instantiateView()
//    }
//
////    override func viewDidLoad() {
////        super.viewDidLoad()
////        lineChart.delegate = self
////        self.loadWeightData()
////        self.createData()
////    }
//
//    private func instantiateView() {
//        let nib = UINib(nibName: "GraphView", bundle: .main)
//        let rootView = nib.instantiate(withOwner: self).first as! UIView
//        rootView.frame = self.bounds
//        self.addSubview(rootView)
//        loadWeightData()
//        NotificationCenter.default.addObserver(self, selector: #selector(setChartView), name: .graphViewShow, object: nil)
//
//    }
//

//
//    func dispGraph(isTop: Bool) {
//        if isTop {
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
//                self.currentPageIndex()
//            }
//        }
//    }
//
//    func currentPageIndex() {
//        let weightGraph = self.list[self.list.count - 1]
//        weightGraph.lineChartView.animate(xAxisDuration: 1, yAxisDuration: 1)
//    }
//
//    func loadWeightData() {
//        var weight = Weight()
//        let allWeightData = weightVM.getAllWeightData()
//        for weightData in allWeightData {
//            allWeightDataList.updateValue(weightData.weight, forKey: weightData.dateSt)
//            weight.weight = weightData.weight
//            weight.date = weightData.date
//            weight.dateSt = weightData.dateSt
//            allWeightList.append(weight)
//        }
//    }
//
//    func createWeekList() {
//        
//    }
//
//    func createMonthList() {
//        
//    }
//
//    func changeGraph(mode: GraphMode) {
//        self.graphMode == mode
//        self.list = []
//        self.lastDate = Date()
//        createData()
//
//    }
//
//    func addData(weightGraph: weightGraph) -> WeightView {
//        let baseView = WeightView()
//        baseView.weightGraph = weightGraph
//        var rect = scrollView.bounds
//        rect.origin.x = 0
//        rect.origin.y = 0
//        rect.size.width = cardView.frame.width
//        baseView.frame = rect
//        let chartView = LineChartView(frame: rect)
//        
//        baseView.addSubview(chartView)
//        baseView.lineChartView = chartView
//        return baseView
//    }
//
//    func averageCalc(data: [Weight]) -> Float {
//        var calcWeight = 0.0
//
//        for weight in data {
//            calcWeight += Double(weight.weight)
//        }
//
//        return Float(calcWeight / Double(data.count))
//    }
//
//    func calcMin(array: [Weight]) -> Double {
//        var weightArray: [Float] = []
//
//        for weight in array {
//            weightArray.append(weight.weight )
//        }
//        return Double(weightArray.min() ?? 0)
//    }
//
//    func chartSet(chartView: LineChartView, weightGraph: weightGraph) {
//        
//    }
//
//
//
//
//}
//
//
//

//}
//
//

//}
//
//class WeightView: UIView {
//    var lineChartView = LineChartView()
//    lazy var weightGraph: weightGraph = recordDiet.weightGraph(dateSt: "", totalWeight: 0, averageWeight: 0, graphMode: .Week)
//}
//

