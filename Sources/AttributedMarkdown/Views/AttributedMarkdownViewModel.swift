//
//  AttributedMarkdownViewModel.swift
//  
//
//  Created by Bart on 14/04/2022.
//

import SwiftUI

extension AttributedMarkdownView {
    
    final class ViewModel: ObservableObject {
        
        #if os(iOS)
        typealias TextView = UITextView
        #else
        typealias TextView = NSTextView
        #endif
        
        // MARK: - Properties
        
        @Published var textViewPreferredSize: CGSize = .zero
        
        // MARK: - Initialization
        
        init() {}
        
        // MARK: - Public implementation
        
        func textViewContentChanged(_ textView: TextView) {
            textViewPreferredSize = textView.intrinsicContentSize
        }
        
    }
    
}
