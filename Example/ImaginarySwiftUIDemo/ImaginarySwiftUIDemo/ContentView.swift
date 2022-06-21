//
//  ContentView.swift
//  ImaginarySwiftUIDemo
//
//  Created by Arslan Rafique on 2022-06-21.
//

import SwiftUI
import Imaginary

struct ContentView: SwiftUI.View {
    
    struct Constants {
      static let imageWidth = 500
      static let imageHeight = 500
      static let imageNumber = 400
    }

    var imaginaryArray: [URL] = {
      var array = [URL]()

      for i in 0..<Constants.imageNumber {
        if let imageURL = URL(
          string: "https://placeimg.com/640/480/any/\(i)") {
              array.append(imageURL)
        }
      }

      return array
      }()
    
    var body: some SwiftUI.View {
        ScrollView {
            VStack {
                ForEach(imaginaryArray, id: \.self) { url in
                    ImageViewAdapter(url: url)
                        .id(url.absoluteString)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        ContentView()
    }
}
