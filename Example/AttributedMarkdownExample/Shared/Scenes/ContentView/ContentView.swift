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
                CustomTextView(attr: viewModel.curentFileContent)
                .frame(idealHeight: 10000)
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
#if os(iOS)
struct CustomTextView: UIViewRepresentable {
    typealias NSViewType = UITextView
    let attr: NSAttributedString
    func makeUIView(context: Context) -> UITextView {
        let view = UITextView()
        view.isEditable = false
        view.isSelectable = false
//        view.isScrollEnabled = false
        view.attributedText = NSAttributedString(attr)
        return view
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        let uiattr =  NSAttributedString(attr)
        if uiView.attributedText == nil || uiattr != uiView.attributedText! {
            uiView.attributedText = uiattr
        }
    }
    
}
#endif
#if os(macOS)
struct CustomTextView: NSViewRepresentable {
    typealias NSViewType = NSTextView
    let attr: NSAttributedString
//    var nsAttributedString: NSAttributedString {
//        .init(attr)
//    }
    func makeNSView(context: Context) -> NSTextView {
        let view = NSTextView()
        view.isEditable = false
        view.isSelectable = true
        view.isRichText = false
//        view.textContainer?.widthTracksTextView = false
        view.textStorage?.setAttributedString(attr)
        return view
    }

    func updateNSView(_ nsView: NSTextView, context: Context) {
//        if nsView.attributedString() == .init() {
            nsView.textStorage?.setAttributedString(attr)
//        }
    }

}
#endif
