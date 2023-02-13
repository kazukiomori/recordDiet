//
//  BodyImageViewModel.swift
//  recordDiet
//
//  Created by Kazuki Omori on 2023/02/13.
//

import Foundation
import RealmSwift

class BodyImageViewModel {
    
    let model = BodyImageModel()
    
    func fetchTheDayData(date: String) -> UIImage {
        let data = model.getTheDayData(date: date)
        if let imageData = data.imageData {
            let image = UIImage(data: imageData)
            return image!
        }
        return UIImage()
    }
    
    // viewで入力した値をWeight型の変数にまとめて、WeightModelでrealmに保存する
    func addData(date: String, image: UIImage){
        let body = BodyImage()
        body.date = date
        body.imageData = image.pngData()
        model.addData(body: body)
    }
}

