//
//  FirebaseService.swift
//  ApusCheckIn
//
//  Created by JaemooJung on 2022/03/24.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

struct FireBaseService {
    
    private let db = Firestore.firestore()
    
    func fetchMembers() async throws -> [Member] {
        let snapshot = try await db.collection("testCollection").getDocuments()
        return snapshot.documents.compactMap { document in
            try? document.data(as: Member.self)
        }
    }
    
}
