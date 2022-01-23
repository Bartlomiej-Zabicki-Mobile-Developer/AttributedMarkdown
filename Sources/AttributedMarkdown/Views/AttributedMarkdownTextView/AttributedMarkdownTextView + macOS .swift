//
//  AttributedMarkdownTextView + macOS.swift
//  
//
//  Created by Bart on 14/04/2022.
//

import SwiftUI

#if os(macOS)
import AppKit

struct AttributedMarkdownTextView: NSViewRepresentable {
    
    typealias NSViewType = MacOSTextView
    
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
    
    func makeNSView(context: Context) -> MacOSTextView {
        let view = MacOSTextView()
        view.isEditable = false
        view.isSelectable = true
        view.isRichText = false
        view.textContainer?.widthTracksTextView = false
        view.textStorage?.setAttributedString(attributedString)
        view.delegate = context.coordinator
        return view
    }

    func updateNSView(_ nsView: MacOSTextView, context: Context) {
        nsView.textStorage?.setAttributedString(attributedString)
        nsView.maxLayoutWidth = maxLayoutWidth
        nsView.textContainer?.maximumNumberOfLines = context.environment.lineLimit ?? 0
        viewModel.textViewContentChanged(nsView)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject, NSTextViewDelegate {}
    
    final class MacOSTextView: NSTextView {
        
        var maxLayoutWidth: CGFloat {
          get { textContainer?.containerSize.width ?? 0 }
          set {
            guard textContainer?.containerSize.width != newValue else { return }
            textContainer?.containerSize.width = newValue
            invalidateIntrinsicContentSize()
          }
        }

        override var intrinsicContentSize: NSSize {
          guard maxLayoutWidth > 0,
            let textContainer = self.textContainer,
            let layoutManager = self.layoutManager
          else {
            return super.intrinsicContentSize
          }

          layoutManager.ensureLayout(for: textContainer)
          return layoutManager.usedRect(for: textContainer).size
        }
        
    }

}
#endif
