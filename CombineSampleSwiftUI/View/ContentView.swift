//
//  ContentView.swift
//  CombineSampleSwiftUI
//
//  Created by Brian Ortiz on 2023-04-01.
//

import SwiftUI

struct ContentView: View {
  @ObservedObject var viewModel = PostViewModel()
  
  var body: some View {
    NavigationView {
      List(viewModel.posts) { post in
        VStack(alignment: .leading) {
          Text(post.title)
            .font(.headline)
          Text(post.body)
            .font(.subheadline)
        }
      }
      .navigationBarTitle("Posts")
      .onAppear {
        viewModel.fetchPosts()
      }
    }
  }
}
