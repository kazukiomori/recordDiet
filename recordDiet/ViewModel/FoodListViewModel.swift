//
//  FoodListViewModel.swift
//  recordDiet
//
//  Created by Kazuki Omori on 2023/02/11.
//

import Foundation
import RealmSwift

class FoodListViewModel {
    
    let model = FoodListModel()
    
    // FoodListModelでrealmから取り出したデータをFoodList型の配列にしてviewに渡す
    func fetchTheDayData(date: String) -> [FoodList] {
        var foodList: [FoodList] = []
        let results = model.getTheDayData(date: date)
        for result in results {
            let food = FoodList()
            food.time = result.time
            food.menu = result.menu
            food.calorie = result.calorie
            food.memo = result.memo
            food.date = result.date
            foodList.append(food)
        }
        return foodList
    }
    
    func fetchTheDayFood(date: String, food: String) -> FoodList {
        let results = model.getTheDayData(date: date)
        var food = FoodList()
        for result in results {
            if result.date == date {
                food = result
            }
        }
        return food
    }
    
    
    // viewで入力した値をFoodList型の変数にまとめて、FoodListModelでrealmに保存する
    func addData(time: String, menu: String, calorie: Int, memo: String, date: String){
        let food = FoodList()
        food.time = time
        food.menu = menu
        food.calorie = calorie
        food.memo = memo
        food.date = date
        model.addData(food: food)
    }
}
