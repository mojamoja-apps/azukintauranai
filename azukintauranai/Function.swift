//
//  Function.swift
//  azukintauranai
//
//  Created by 大塚匡平 on 2023/01/28.
//

import Foundation

///文字列を投げて、正常に変換できたらそのままリターン、できなかったら現在時刻をリターン
func StringToDate(dateValue: String, format: String) -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.calendar = Calendar(identifier: .gregorian)
    dateFormatter.dateFormat = format
    return dateFormatter.date(from: dateValue) ?? Date()
}

