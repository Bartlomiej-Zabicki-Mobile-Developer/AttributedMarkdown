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
    
    typealias NSViewType = iOSTextView
    
    // MARK: - Properties
    
    let attributedString: NSAttributedString
    let maxLayoutWidth: CGFloat
    private let viewModel: AttributedMarkdownView.ViewModel
    
    // MARK: - Initialization
    
    init(_ attributedString: NSAttributedString, maxLayoutWidth: CGFloat, viewModel: AttributedMarkdownView.ViewModel) {
        self.attributedString = attributedString
        self.maxLayoutWidth = maxLayoutWidth
        self.viewModel = viewModel
    }
    
    // MARK: - Public implementation
    
    func makeUIView(context: Context) -> iOSTextView {
        let view = iOSTextView()
        view.isEditable = false
        view.isSelectable = false
        view.isScrollEnabled = false
        view.attributedText = attributedString
        view.maxLayoutWidth = maxLayoutWidth
        return view
    }
    
    func updateUIView(_ uiView: iOSTextView, context: Context) {
        uiView.attributedText = attributedString
        viewModel.textViewContentChanged(uiView)
    }
    
    final class iOSTextView: UITextView {
        
        var maxLayoutWidth: CGFloat = 0 {
            didSet {
                guard maxLayoutWidth != oldValue else { return }
                invalidateIntrinsicContentSize()
            }
        }
        
        override var intrinsicContentSize: CGSize {
            guard maxLayoutWidth > 0 else {
                return super.intrinsicContentSize
            }
            
            return sizeThatFits(CGSize(width: maxLayoutWidth, height: .greatestFiniteMagnitude))
        }
        
    }
    
}
#endif
