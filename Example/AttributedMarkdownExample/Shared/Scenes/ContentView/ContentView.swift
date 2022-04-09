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
                Text(viewModel.curentFileContent)
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
