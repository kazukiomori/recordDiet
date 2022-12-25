//
//  ViewController.swift
//  recordDiet
//
//  Created by Apple on 2022/12/18.
//

import UIKit
import Charts

class TopViewController: UIViewController {
    
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var chartView: UIView!
    @IBOutlet weak var recordButton: UIButton!
    
    var lineChartView: LineChartView!
    var chartDataSet: LineChartDataSet!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    func displayChart(data: [Double]) {
        
    }

}

