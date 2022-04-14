//
//  ContentView.swift
//  Shared
//
//  Created by Bart on 23/01/2022.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var viewModel: ViewModel = .init()
    
    var body: some View {
        VStack {
            Text("Demo files")
            Picker("", selection: $viewModel.selectedIndex) {
                ForEach(ViewModel.File.allCases) {
                    Text($0.rawValue)
                        .tag($0.id)
                }
            }
            .onChange(of: viewModel.selectedIndex, perform: { newValue in
                Task {
                    await viewModel.selectFile(file: .init(from: newValue))
                }
             })
            .pickerStyle(.segmented)
            ScrollView {
                AttributedStringView(viewModel.curentFileContent)
            }
        }
        .onAppear {
            Task {
                await viewModel.selectFile(file: .file1)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct AttributedStringView: View {
    
    // MARK: - Properties
    
    @StateObject private var viewModel = ViewModel()
    let attributedString: NSAttributedString
    
    init(_ attributedString: NSAttributedString) {
        self.attributedString = attributedString
    }
    
    // MARK: - View
    
    var body: some View {
        GeometryReader { geometry in
            // TODO: - Should calculate safe area insets
            CustomTextView(attributedString, maxLayoutWidth: geometry.size.width, viewModel: viewModel)
        }
        .frame(idealWidth: viewModel.textViewPreferredSize.width,
               idealHeight: viewModel.textViewPreferredSize.height)
        .fixedSize(horizontal: false, vertical: true)
    }
    
}

private extension AttributedStringView {
    
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

#if os(iOS)
struct CustomTextView: UIViewRepresentable {
    
    typealias NSViewType = UITextView
    
    // MARK: - Properties
    
    let attributedString: NSAttributedString
    private let viewModel: AttributedStringView.ViewModel
    
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
#if os(macOS)
struct CustomTextView: NSViewRepresentable {
    
    typealias NSViewType = MacOSTextView
    
    // MARK: - Properties
    
    let attributedString: NSAttributedString
    let maxLayoutWidth: CGFloat
    private let viewModel: AttributedStringView.ViewModel
    
    // MARK: - Initialization
    
    fileprivate init(_ attributedString: NSAttributedString, maxLayoutWidth: CGFloat, viewModel: AttributedStringView.ViewModel) {
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
