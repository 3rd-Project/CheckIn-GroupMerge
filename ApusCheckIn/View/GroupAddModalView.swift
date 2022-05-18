
//
//  ModalView.swift
//  yosong
//
//  Created by Suji Lee on 2022/05/01.
//

import SwiftUI

struct ModalView: View {

    @State var testGroups: [String] = [
        "ApusOfus", "42FC", "42CodeC", "SUJI"
    ]
    
    @StateObject var vm = GroupAddModalViewModel()
    
    @State var searchFor = ""
    
    
    /*
     
     ForEach(viewModel.groups) { group in
     if group.didUserAddThisGroup(theGRoup: self.group) == false {
         HStack() {
             Text("\(group.groupName)")
                 .foregroundColor(.gray)
         }
     }
     
 }*/

    
var body: some View {
    NavigationView {
        VStack {
            List {
                ForEach(results, id: \.self) { group in
                   Text(group)
                            .swipeActions(edge: .trailing,
                                allowsFullSwipe : true) {
                                Button("Add") {
                                    vm.addToMyGroup()
                                }
                                .tint(.green)

                                Button("★") {
                                    vm.addToLikeGroup()
                                }
                                .tint(.yellow)
                            }
                }
            }
            .navigationBarTitle("그룹 추가", displayMode: .inline)
            
        }


    }
    .searchable(text: $searchFor, placement: .navigationBarDrawer(displayMode: .always))

    

}
    
    
    var results: [String] {
        if searchFor.isEmpty {
            return testGroups
        }else {
            return testGroups.filter {
                $0.contains(searchFor)
            }
        }
    }


    
}


