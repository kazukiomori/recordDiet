//
//  WeightViewModel.swift
//  recordDiet
//
//  Created by Kazuki Omori on 2023/01/01.
//

import Foundation
import RealmSwift

class WeightViewModel {
    
    let model = WeightModel()
    
    // WeightModelでrealmから取り出したデータをWeight型の配列にしてviewに渡す
    func fetchAllData() -> [Weight] {
        var weightList: [Weight] = []
        let results = model.getAllWeightData()
        for result in results {
            let weight = Weight()
            weight.weight = result.weight
            weight.dateSt = result.dateSt
            weight.date = result.date
            weightList.append(weight)
        }
        return weightList
    }
    
    func fetchTheDayData(date: String) -> Float {
        let data = model.getTheDayData(date: date)
        return data.weight
    }
    
    // viewで入力した値をWeight型の変数にまとめて、WeightModelでrealmに保存する
    func addData(weightData: Float, dateData: Date, dateStData: String){
        let weight = Weight()
        weight.weight = weightData
        weight.date = dateData
        weight.dateSt = dateStData
        model.addData(weight: weight)
    }
}
