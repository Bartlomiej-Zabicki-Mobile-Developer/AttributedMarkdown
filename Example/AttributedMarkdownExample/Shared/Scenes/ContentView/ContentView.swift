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
            Picker("All demo files", selection: $viewModel.selectedIndex) {
                ForEach(ViewModel.File.allCases) {
                    Text($0.rawValue).tag($0.id)
                }
            }
            .pickerStyle(.segmented)
            Text(viewModel.curentFileContent)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
