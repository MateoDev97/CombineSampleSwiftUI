//
//  ContentViewModel.swift
//  CombineSampleSwiftUI
//
//  Created by Brian Ortiz on 2023-04-01.
//

import Foundation
import Combine

class PostViewModel: ObservableObject {
    
    @Published var posts: [PostData] = []
    
    var cancellables = Set<AnyCancellable>()
    
    func fetchPosts() {
        
        NetworkManager.shared.genericPostRequest(type: [PostData].self)
        .sink { completion in
            switch completion {
            case .failure(let err):
                print("Error is \(err.localizedDescription)")
            case .finished:
                print("Finished")
            }
        }
        receiveValue: { [weak self] postData in
            self?.posts = postData
        }
        .store(in: &cancellables)
        
    }
    
}
