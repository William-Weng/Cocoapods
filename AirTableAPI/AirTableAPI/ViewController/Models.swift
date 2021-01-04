//
//  Models.swift
//  AirTableAPI
//
//  Created by William.Weng on 2021/1/4.
//  Copyright © 2021 William.Weng. All rights reserved.
//

import UIKit
import WWAirTableAPI

// {"records":[{"fields":{"image":[{"url":"https://movies.yahoo.com.tw/i/o/production/movies/November2020/HLffjMYa7OknPGBsy1v8-757x1080.jpg"}],"releaseDate":629308800,"name":"求婚好意外","imdb":6.7,"genre":["喜劇"]}}]}
struct CreateRecord: Encodable, WWAirTableCallable {
    
    let records: [Record]
    
    struct Record: Encodable {
        let fields: Fields
    }
    
    struct Fields: Encodable {
        
        let name: String
        let imdb: Double
        let releaseDate: Date
        let genre: [String]
        let image: [ImageData]
        
        /// 建立電影相關資訊
        /// - Parameters:
        ///   - name: 電影名稱
        ///   - imdb: 電影評比
        ///   - releaseDate: 上映日期
        ///   - genre: 分類
        ///   - images: 圖片
        /// - Returns: Fields?
        static func build(name: String, imdb: Double, releaseDate: (value: String, dateFormat: Utility.DateFormat), genre: [String], images: [String]) -> Fields? {
            
            guard let date = releaseDate.value._date(dateFormat: releaseDate.dateFormat) else { return nil }
            
            let ImageDatas = images.compactMap { (urlString) -> ImageData? in
                guard let url = URL(string: urlString) else { return nil }
                return ImageData(url: url)
            }
            
            return CreateRecord.Fields(name: name, imdb: imdb, releaseDate: date, genre: genre, image: ImageDatas)
        }
    }
    
    struct ImageData: Encodable { let url: URL }
    
    /// Class => JSON Data
    func jsonData() -> Data? {
        guard let jsonData = try? JSONEncoder().encode(self) else { return nil }
        return jsonData
    }
    
    /// Class ==> Data => JSON String
    func jsonString() -> String? {
        
        guard let jsonData = jsonData(),
              let jsonString = jsonData._string()
        else {
            return nil
        }
        
        return jsonString
    }
}
