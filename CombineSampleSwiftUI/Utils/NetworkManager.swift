//
//  NetworkRouter.swift
//  CombineSampleSwiftUI
//
//  Created by Brian Ortiz on 2023-04-01.
//

import Foundation
import Combine

class NetworkManager {
    
    static let shared = NetworkManager()
        
    private var cancellables = Set<AnyCancellable>()
    
    func genericPostRequest<T: Decodable>(type: T.Type) -> Future<T, Error> {
        
        return Future<T, Error> { [weak self] promise in
            
            guard let self = self, let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else {
                return promise(.failure(NetworkError.invalidURL))
            }
            
            URLSession.shared.dataTaskPublisher(for: url)
                .map { $0.data }
                .decode(type: T.self, decoder: JSONDecoder())
                .receive(on: DispatchQueue.main)
                .sink(
                    receiveCompletion: { (completion) in
                        if case let .failure(error) = completion {
                            switch error {
                            case let decodingError as DecodingError:
                                promise(.failure(decodingError))
                            case let apiError as NetworkError:
                                promise(.failure(apiError))
                            case let urlError as URLError:
                                promise(.failure(urlError))
                            default:
                                promise(.failure(NetworkError.unknown))
                            }
                        }
                    },
                    receiveValue: { promise(.success($0)) }
                )
                .store(in: &self.cancellables)
        }
        
    }
    
  
}

enum NetworkError: Error {
    case invalidURL
    case responseError
    case unknown
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return NSLocalizedString("Invalid URL", comment: "Invalid URL")
        case .responseError:
            return NSLocalizedString("Unexpected status code", comment: "Invalid response")
        case .unknown:
            return NSLocalizedString("Unknown error", comment: "Unknown error")
        }
    }
}
