//
//  ImageViewAdapter.swift
//  
//
//  Created by Arslan Rafique on 2022-06-21.
//

import SwiftUI

@available(iOS 13.0, macOS 10.15, *)
public struct ImageViewAdapter: UIViewRepresentable {

    let url: URL

    public init(url: URL) {
        self.url = url
    }

    public func makeUIView(context: Context) -> UIView {
        let imageView: UIImageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.setImage(url: self.url)
        return imageView
    }

    public func updateUIView(_ uiView: UIView, context: Context) {}
}
