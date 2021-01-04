//
//  Extension+.swift
//  AirTableAPI
//
//  Created by William.Weng on 2021/1/4.
//  Copyright © 2021 William.Weng. All rights reserved.
//

import UIKit
import WWAirTableAPI

extension Data {
        
    func _string(encoding: String.Encoding = .utf8) -> String? {
        return String(bytes: self, encoding: encoding)
    }
}

extension Date {
    
    /// 將"2020-07-08 16:36:31 +0800" => Date()
    /// - Parameters:
    ///   - dateString: 時間字串
    ///   - dateFormat: 時間格式 (yyyy/mm/dd)
    /// - Returns: Date?
    static func _stringToDate(_ dateString: String, dateFormat: Utility.DateFormat = .full) -> Date? {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat.rawValue

        return dateFormatter.date(from: dateString)
    }
}

extension String {
    
    /// 將"2020-07-08 16:36:31 +0800" => Date()
    /// - Parameter dateFormat: 時間格式
    /// - Returns: Date?
    func _date(dateFormat: Utility.DateFormat = .short) -> Date? {
        return Date._stringToDate(self, dateFormat: dateFormat)
    }
}
