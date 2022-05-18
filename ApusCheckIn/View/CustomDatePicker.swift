//
//  CustomDatePicker.swift
//  CalendarTest
//
//  Created by 김나연 on 2022/02/23.
//

import SwiftUI

struct CustomDatePicker: View {
    @State var currentDate = Date()
    @State var currentMonth: Int = 0
    @State var currentDateValue: DateValue = DateValue(day: 0, date: Date())
    @State var showModal = false

    var body: some View {
            ScrollView {
                VStack(spacing: 10) {
                    Text("Apus Check-In").font(.system(size: 33))
                    Spacer()
                    let days = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"]
                    HStack(spacing: 20) {
                        VStack(alignment: .leading, spacing: 10) {
                            Text(extraDate()[0])
                                .font(.system(size: 20))
                            Text(extraDate()[1])
                                .font(.system(size: 30))
                        }
                        Spacer(minLength: 0)
                        Button {
                                currentMonth -= 1
                        } label: {
                            Image(systemName: "chevron.left")
                                .font(.title2)
                        }
                        Button {
                                currentMonth += 1
                        } label: {
                            Image(systemName: "chevron.right")
                                .font(.title2)
                        }
                    }
                    .padding(.horizontal)
                    HStack(spacing: 0) {
                        ForEach(days, id: \.self) { day in
                            if day == "WED" {
                                Spacer()
                                Image(systemName: "swift").foregroundColor(.blue)
                                    .font(.title2)
                                Spacer()
                            } else if day == "SUN" {
                                dayText(text: day).foregroundColor(.red)
                            } else if day == "SAT" {
                                dayText(text: day).foregroundColor(.blue)
                            } else {
                                dayText(text: day)
                            }
                        }
                    }
                    let columns = Array(repeating: GridItem(.flexible()), count: 7)
                    LazyVGrid(columns: columns, spacing: 10) {
                        let dates: [DateValue] = extractDate()
                        ForEach(dates) { value in
                            Button {
                                currentDateValue = value
                                showModal = true
                            } label: {
                                if value.day != -1 {
                                    Text("\(value.day)")
                                        .foregroundColor(Color.myColor)
                                        .padding(.vertical, 8)
                                        .frame(height: 50, alignment: .top)
                                }
                            }
                        }
                    }
                    .sheet(isPresented: $showModal) {
                        MyModalView(viewModel: MyModalViewModel(), date: $currentDateValue.date)
                    }
                    .onChange(of: currentMonth) { newValue in
                        currentDate = getCurrentMonth()
                    }
                    Spacer()
                    Spacer()
                }
                .padding()
            }
    }
    
    func dayText(text: String)->some View {
        Text(text)
            .font(.callout)
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity)
    }

    func extraDate() -> [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY MMM"
        formatter.locale = Locale(identifier: "ko_KR")
        let date = formatter.string(from: currentDate)
        return date.components(separatedBy: " ")
    }

    func getCurrentMonth() -> Date {
        let calendar = Calendar.current

        guard let currentMonth = calendar.date(byAdding: .month, value: self.currentMonth, to: Date()) else {
            return Date()
        }
        return currentMonth
    }

    func extractDate() -> [DateValue] {
        let calendar = Calendar.current
        let currentMonth = getCurrentMonth()
        var days = currentMonth.getAllDates().compactMap { date -> DateValue in
            let day = calendar.component(.day, from: date)
            return DateValue(day: day, date: date)
        }
        let firstWeekday = calendar.component(.weekday, from: days.first?.date ?? Date())
        for _ in 0..<firstWeekday - 1 {
            days.insert(DateValue(day: -1, date: Date()), at: 0)
        }
        return days
    }
}

struct CustomDatePicker_Previews: PreviewProvider {

    @State static var date = Date()
    static var previews: some View {
        CustomDatePicker()
    }
}
