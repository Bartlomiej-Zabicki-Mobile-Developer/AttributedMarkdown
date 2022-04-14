//
//  AttributedMarkdownTextView + iOS.swift
//  
//
//  Created by Bart on 14/04/2022.
//

import SwiftUI

#if os(iOS)
import UIKit

struct AttributedMarkdownTextView: UIViewRepresentable {
    
    typealias NSViewType = UITextView
    
    // MARK: - Properties
    
    let attributedString: NSAttributedString
    private let viewModel: AttributedMarkdownView.ViewModel
    
    // MARK: - Initialization
    
    init(_ attributedString: NSAttributedString, maxWidth: CGFloat, viewModel: AttributedStringView.ViewModel) {
        self.attributedString = attributedString
    }
    
    // MARK: - Public implementation
    
    func makeUIView(context: Context) -> UITextView {
        let view = UITextView()
        view.isEditable = false
        view.isSelectable = false
//        view.isScrollEnabled = false
        view.attributedText = attributedString
        return view
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.attributedText = attributedString
    }
    
}
#endif
