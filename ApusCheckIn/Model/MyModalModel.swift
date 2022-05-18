//
//  MyModalModel.swift
//  MyModal
//
//  Created by Suji Lee on 2022/02/23.
//

import Foundation
import FirebaseFirestoreSwift

//구조체로 내가 쓸 데이터 덩어리를 정의 -> ex) Member
//그 안에는 멤버에 대한 정보가 담겨있다 -> ex) name, attendedDates, id, etc
//사용자의 액션에 의해 정보를 조작하는 함수 또한 존재 -> ex) didMemberCheckInToday, didMemberCheckInTwice

struct Member: Identifiable, Codable {
    
    @DocumentID var id: String?
    var intraID: String
    var dates: [String: Date]
    
    enum CodingKeys: String, CodingKey {
        case id
        case intraID
        case dates = "Dates"
    }
    
    func didMemberCheckInOnTheDate(theDate: Date) -> Bool {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yy-MM-dd"
        
        //for in 문으로 attendedDates를 순회하며 오늘이 있는지 확인한다
        for date in self.dates {
            if formatter.string(from: date.value) == formatter.string(from: theDate) {
                return true
            }
        }
        return false
    }
    
    
    func didMemberCheckInWed(theDate: Date) -> Bool {
        
                
        //목요일값 == 5
        let weekdayOfToday = Calendar.current.component(.weekday, from: theDate)
        if weekdayOfToday == 4 {
            return true
        }
        return false
    }
    
    func getCheckedInDate(theDate: Date) -> Date? {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yy-MM-dd"
        
        for date in self.dates {
            if formatter.string(from: date.value) == formatter.string(from: theDate) {
                return date.value
            }
        }
        return nil
    }
    
    
    func getCheckInTime(today: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        let checkInTime = formatter.string(from: today)
        
        return checkInTime
    }
    
    
    static func changeDateToString(theDate: Date) -> String {
    
        let formatter = DateFormatter()
        //한국 시간으로 표시
        formatter.locale = Locale(identifier: "ko_kr")
        formatter.timeZone = TimeZone(abbreviation: "KST")
        //형태 변환
        formatter.dateFormat = " yy. MM. dd (EE)"
        
        return formatter.string(from: theDate)
    }
}
