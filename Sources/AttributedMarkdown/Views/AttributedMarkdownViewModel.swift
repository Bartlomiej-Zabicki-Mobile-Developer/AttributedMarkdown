//
//  AttributedMarkdownViewModel.swift
//  
//
//  Created by Bart on 14/04/2022.
//

import SwiftUI

extension AttributedMarkdownView {
    
    final class ViewModel: ObservableObject {
        
        // MARK: - Properties
        
        @Published var textViewPreferredSize: CGSize = .zero
        
        // MARK: - Initialization
        
        init() {}
        
        // MARK: - Public implementation
        
        func textViewContentChanged(_ textView: NSTextView) {
            textViewPreferredSize = textView.intrinsicContentSize
        }
        
    }
    
}
