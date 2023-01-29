//
//  Calendar.swift
//  azukintauranai
//
//  Created by 大塚匡平 on 2023/01/25.
//

import SwiftUI

// 曜日
let weekdays = Calendar.current.shortWeekdaySymbols

struct CalendarDates: Identifiable {
    var id = UUID()
    var date: Date?
}


// 年月リスト配列を作成 今月からマイナス24ヶ月まで
func getYMList() -> Array<String> {
    let date = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "ja_JP")
    dateFormatter.dateStyle = .medium
    dateFormatter.dateFormat = "yyyy"

    var yyyy = Int(dateFormatter.string(from: date))!

    dateFormatter.locale = Locale(identifier: "ja_JP")
    dateFormatter.dateStyle = .medium
    dateFormatter.dateFormat = "MM"

    var mm = Int(dateFormatter.string(from: date))!

    var ymArray:[String] = []
    for _ in 0..<24 {
        ymArray += [String(yyyy) + "/" + String(format: "%02d", mm)]
        mm = mm - 1
        if mm == 0 {
            mm = 12
            yyyy = yyyy - 1
        }
    }
    return ymArray
}
// UserDefaultから過去の結果を復元して返す
func getKakoResult(targetDate: String) -> String {

    if let ret = UserDefaults.standard.string(forKey: targetDate) {
        if let intret = Int(ret) {
            return uranai_titles[intret]
        }else{
            return "-"
        }
    } else {
        return "-"
    }
}

struct CalendarView: View {
    // グリッドアイテム
    let columns: [GridItem] = Array(repeating: .init(.fixed(40)), count: 7)

    // 年月リスト
    let ymList = getYMList()
    @State private var selectedIndex = 0    // 選択値と連携するプロパティ
    @State private var selectedYM = ""

    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack{
            Color.customBackgroundColor
                .ignoresSafeArea()
            VStack {
                Text("過去の占い結果")
                    .font(.system(size: 24))

                // yyyy/MM
                HStack{
                    Picker(selection: $selectedIndex, label: Text("年月を選択")) {
                        ForEach (0..<ymList.count, id: \.self) { index in
                            Text(ymList[index])
                        }
                    }
                    .onChange(of: selectedIndex) { newValue in
                        print("changet to \(ymList[newValue])")
                        selectedYM = ymList[newValue]
                    }
                    //Text(String(format: "%04d/%02d", year, month))
                    //    .font(.system(size: 24))
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
                    let calendarDates = createCalendarDates(ymstr: selectedYM)

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

                Spacer()
                    .padding(.bottom, 20)

                Button(action: {
                    dismiss()
                }){
                    Text("戻る")
                        .font(.largeTitle)
                }
                .buttonStyle(.borderedProminent)
                .padding(30)

                Spacer()
                    .padding(.bottom, 20)
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
func createCalendarDates(ymstr: String) -> [CalendarDates] {
    var days = [CalendarDates]()

    let date : Date
    if ymstr == "" {
        date = Date()
    } else {
        let ccc = Calendar(identifier: .gregorian)
        let arr:[String] = ymstr.components(separatedBy: "/")
        date = ccc.date(from: DateComponents(year: Int(arr[0]), month: Int(arr[1]), day: 1))!
    }

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

