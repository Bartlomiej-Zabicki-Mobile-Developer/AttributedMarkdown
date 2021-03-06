//
//  AttributedMarkdownView.swift
//  
//
//  Created by Bart on 14/04/2022.
//

import SwiftUI

public struct AttributedMarkdownView: View {
    
    // MARK: - Properties
    
    @StateObject private var viewModel = ViewModel()
    let attributedString: NSAttributedString
    
    public init(_ attributedString: NSAttributedString) {
        self.attributedString = attributedString
    }
    
    // MARK: - View
    
    public var body: some View {
        GeometryReader { geometry in
            let widthWithoutSafeArea = geometry.size.width - geometry.safeAreaInsets.leading - geometry.safeAreaInsets.trailing
            AttributedMarkdownTextView(attributedString, maxLayoutWidth: widthWithoutSafeArea, viewModel: viewModel)
        }
        .frame(idealWidth: viewModel.textViewPreferredSize.width,
               idealHeight: viewModel.textViewPreferredSize.height)
        .fixedSize(horizontal: false, vertical: true)
    }
    
}


struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        AttributedMarkdownView(.init("Test"))
    }
}
