//
//  Calendar.swift
//  azukintauranai
//
//  Created by 大塚匡平 on 2023/01/25.
//

import SwiftUI

struct CalendarDates: Identifiable {
    var id = UUID()
    var date: Date?
}

func getKakoResult(targetDate: String) -> String {
    if let ret = UserDefaults.standard.string(forKey: targetDate) {
        
        if let intret = Int(ret) {
            return uranai_titles[intret]
        }else{
            return ""
        }
    } else {
        return ""
    }
}

struct CalendarView: View {
    
    // 年
    let year = Calendar.current.year(for: Date()) ?? 0
    // 月
    let month = Calendar.current.month(for: Date()) ?? 0
    // 日付配列
    let calendarDates = createCalendarDates(Date())
    // 曜日
    let weekdays = Calendar.current.shortWeekdaySymbols
    // グリッドアイテム
    let columns: [GridItem] = Array(repeating: .init(.fixed(40)), count: 7)

    var body: some View {
        ZStack{
            Color.customBackgroundColor
                .ignoresSafeArea()
            VStack {
                // yyyy/MM
                HStack{
                    Text("<")
                        .font(.system(size: 30))
                    Spacer().frame(width: 30)
                    Text(String(format: "%04d/%02d", year, month))
                        .font(.system(size: 24))
                    Spacer().frame(width: 30)
                    Text(">")
                        .font(.system(size: 30))
                }
                
                // 曜日
                HStack {
                    ForEach(weekdays, id: \.self) { weekday in
                        if (weekday == "日" || weekday == "Sun"){
                            Text(weekday)
                                .frame(width: 40, height: 40, alignment: .center)
                                .foregroundColor(Color.red)
                        } else if (weekday == "土" || weekday == "Sat"){
                            Text(weekday)
                                .frame(width: 40, height: 40, alignment: .center)
                                .foregroundColor(Color.blue)
                        } else {
                            Text(weekday)
                                .frame(width: 40, height: 40, alignment: .center)
                                .foregroundColor(Color.black)
                        }
                        
                    }
                }
                
                // カレンダー
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(calendarDates) { calendarDates in
                        if let date = calendarDates.date, let day = Calendar.current.day(for: date) {
                            VStack{
                                if Calendar.current.weekday(for: date) == 1 {
                                    Text("\(day)")
                                        .foregroundColor(Color.red)
                                } else if Calendar.current.weekday(for: date) == 7 {
                                    Text("\(day)")
                                        .foregroundColor(Color.blue)
                                } else {
                                    Text("\(day)")
                                        .foregroundColor(Color.black)
                                }
                                
                                Text(
                                    getKakoResult(targetDate: Calendar.current.dateStr(for: date))
                                )
                            }
                        } else {
                            Text("")
                        }
                    }
                }
            }
            .frame(width: 400, height: 400, alignment: .center)
        }
    }
}

extension Calendar {
    /// 今月の開始日を取得する
    /// - Parameter date: 対象日
    /// - Returns: 開始日
    func startOfMonth(for date:Date) -> Date? {
        let comps = dateComponents([.month, .year], from: date)
        return self.date(from: comps)
    }
    
    /// 今月の日数を取得する
    /// - Parameter date: 対象日
    /// - Returns: 日数
    func daysInMonth(for date:Date) -> Int? {
        return range(of: .day, in: .month, for: date)?.count
    }
    
    /// 今月の週数を取得する
    /// - Parameter date: 対象日
    /// - Returns: 週数
    func weeksInMonth(for date:Date) -> Int? {
        return range(of: .weekOfMonth, in: .month, for: date)?.count
    }
    
    func year(for date: Date) -> Int? {
        let comps = dateComponents([.year], from: date)
        return comps.year
    }
    
    func month(for date: Date) -> Int? {
        let comps = dateComponents([.month], from: date)
        return comps.month
    }
    
    func day(for date: Date) -> Int? {
        let comps = dateComponents([.day], from: date)
        return comps.day
    }
    
    func weekday(for date: Date) -> Int? {
        let comps = dateComponents([.weekday], from: date)
        return comps.weekday
    }

    func dateStr(for date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
}

/// カレンダー表示用の日付配列を取得
/// - Parameter date: カレンダー表示の対象日
/// - Returns: 日付配列
func createCalendarDates(_ date: Date) -> [CalendarDates] {
    var days = [CalendarDates]()
    
    // 今月の開始日
    let startOfMonth = Calendar.current.startOfMonth(for: date)
    // 今月の日数
    let daysInMonth = Calendar.current.daysInMonth(for: date)

    guard let daysInMonth = daysInMonth, let startOfMonth = startOfMonth else { return [] }

    // 今月の全ての日付
    for day in 0..<daysInMonth {
        // 今月の開始日から1日ずつ加算
        days.append(CalendarDates(date: Calendar.current.date(byAdding: .day, value: day, to: startOfMonth)))
    }

    guard let firstDay = days.first, let lastDay = days.last,
          let firstDate = firstDay.date, let lastDate = lastDay.date,
          let firstDateWeekday = Calendar.current.weekday(for: firstDate),
          let lastDateWeekday = Calendar.current.weekday(for: lastDate) else { return [] }
    
    // 初週のオフセット日数
    let firstWeekEmptyDays = firstDateWeekday - 1
    // 最終週のオフセット日数
    let lastWeekEmptyDays = 7 - lastDateWeekday
    
    // 初週のオフセットを追加
    for _ in 0..<firstWeekEmptyDays {
        days.insert(CalendarDates(date: nil), at: 0)
    }

    // 最終週のオフセットを追加
    for _ in 0..<lastWeekEmptyDays {
        days.append(CalendarDates(date: nil))
    }
    
    return days
}


struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}

