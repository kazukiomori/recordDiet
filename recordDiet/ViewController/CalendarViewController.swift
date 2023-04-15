//
//  CalendarViewController.swift
//  recordDiet
//
//  Created by Apple on 2022/12/24.
//

import UIKit
import FSCalendar
import CalculateCalendarLogic
import GoogleMobileAds

class CalendarViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance{
    
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var bannerView: GADBannerView!
    let gregorian: Calendar = Calendar(identifier: .gregorian)
    lazy var dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.calendar.dataSource = self
        self.calendar.delegate = self
        bannerView.adUnitID = "ca-app-pub-3293568654583905/4911273024"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
    
    // 祝日判定を行い結果を返すメソッド(True:祝日)
        func judgeHoliday(_ date : Date) -> Bool {
            //祝日判定用のカレンダークラスのインスタンス
            let tmpCalendar = Calendar(identifier: .gregorian)

            // 祝日判定を行う日にちの年、月、日を取得
            let year = tmpCalendar.component(.year, from: date)
            let month = tmpCalendar.component(.month, from: date)
            let day = tmpCalendar.component(.day, from: date)

            // CalculateCalendarLogic()：祝日判定のインスタンスの生成
            let holiday = CalculateCalendarLogic()

            return holiday.judgeJapaneseHoliday(year: year, month: month, day: day)
        }
        // date型 -> 年月日をIntで取得
//        func getDay(_ date:Date) -> (Int,Int,Int){
//            let tmpCalendar = Calendar(identifier: .gregorian)
//            let year = tmpCalendar.component(.year, from: date)
//            let month = tmpCalendar.component(.month, from: date)
//            let day = tmpCalendar.component(.day, from: date)
//            return (year,month,day)
//        }

        //曜日判定(日曜日:1 〜 土曜日:7)
        func getWeekIdx(_ date: Date) -> Int{
            let tmpCalendar = Calendar(identifier: .gregorian)
            return tmpCalendar.component(.weekday, from: date)
        }

        // 土日や祝日の日の文字色を変える
        func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
            
            // カレンダーのヘッダーの年月を日本語表示
            calendar.appearance.headerDateFormat = "yyyy年MM月"
            
            // カレンダーの曜日を日本語表示
            let JapaneseWeek = ["日","月","火","水","木","金","土"]
            for i in 0..<JapaneseWeek.count {
                calendar.calendarWeekdayView.weekdayLabels[i].text = JapaneseWeek[i]
            }
            //祝日判定をする（祝日は赤色で表示する）
            if self.judgeHoliday(date){
                return UIColor.red
            }

            //土日の判定を行う（土曜日は青色、日曜日は赤色で表示する）
            let weekday = self.getWeekIdx(date)
            if weekday == 1 {   //日曜日
                return UIColor.red
            }
            else if weekday == 7 {  //土曜日
                return UIColor.blue
            }

            return nil
        }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let nextViewController = storyBoard.instantiateViewController(withIdentifier: "FoodListViewController") as? FoodListViewController else { return }
        nextViewController.date = AppDate().stringFromDate(date: date, format: "yyyy/MM/dd")
        self.navigationController?.show(nextViewController, sender: nil)
        print (date)
    }

}
