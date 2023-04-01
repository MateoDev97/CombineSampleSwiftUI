//
//  PostData.swift
//  CombineSampleSwiftUI
//
//  Created by Brian Ortiz on 2023-04-01.
//

import Foundation

struct PostData: Codable, Identifiable {
  let id: Int
  let title: String
  let body: String
}
