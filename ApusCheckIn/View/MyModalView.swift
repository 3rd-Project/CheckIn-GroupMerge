//
//  MyModalView.swift
//  MyModal
//
//  Created by Suji Lee on 2022/02/23.
//

import SwiftUI

struct MyModalView: View {
    
    //뷰모델의 클래스를 @ObservedObject 변수명 viewModel로 선언한다.
    @ObservedObject var viewModel: MyModalViewModel
    @Binding var date: Date
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    Section {
                        //여기서 ForEach를 쓰려면 Model ->idenfiable
                        //VieMode -> private(set)으로 해야함
                        ForEach(viewModel.members.sorted(by: {
                            return (getCheckInTimeString($0, self.date)).compare(getCheckInTimeString($1, self.date)) == .orderedAscending
                        })) { member in
                            if member.didMemberCheckInOnTheDate(theDate: self.date) {
                                HStack() {
                                    Text("\(member.intraID)")
                                    Spacer()
                                    Text(getCheckInTimeString(member, self.date))
                                        .font(.caption)
                                        .foregroundColor(Color.gray)
                                    //이미지를 뷰로 따로 빼기. 템플릿화
                                    if member.didMemberCheckInWed(theDate: self.date) {
                                        Image(systemName: "swift")
                                            .foregroundColor(.blue)
                                    } else {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(.blue)
                                        
                                        
                                    }
                                    
                                    
                                }
                            }
                            
                        }
                    } header: {
                        Text("APUS On")
                            .foregroundColor(.blue)
                    }
                    Section {
                        ForEach(viewModel.members) { member in
                            if member.didMemberCheckInOnTheDate(theDate: self.date) == false {
                                HStack() {
                                    Text("\(member.intraID)")
                                        .foregroundColor(.gray)
                                }
                            }
                            
                        }
                    } header: {
                        Text("APUS Off")
                            .foregroundColor(.gray)
                    }
                }
                .listStyle(SidebarListStyle())
                
            }
            .navigationBarTitle(Member.changeDateToString(theDate: self.date))
        }
        
    }
    func getCheckInTimeString(_ member: Member, _ checkedInDate: Date) -> String {
        if let date = member.getCheckedInDate(theDate: checkedInDate) {
            let checkedInTime = member.getCheckInTime(today: date)
            return checkedInTime
        }
        return "NONE"
    } /* this function was originally placed in extension */
}

//extension MyModalView {
//    func getCheckInTimeString(_ member: Member, _ checkedInDate: Date) -> String {
//        if let date = member.getCheckedInDate(theDate: checkedInDate) {
//            let checkedInTime = member.getCheckInTime(today: date)
//            return checkedInTime
//        }
//        return "NONE"
//    }
//}


//
//struct MyModalView_Previews: PreviewProvider {
//    static var previews: some View {
//        MyModalView(viewModel: MyModalViewModel(), date: Date())
//    }
//}
