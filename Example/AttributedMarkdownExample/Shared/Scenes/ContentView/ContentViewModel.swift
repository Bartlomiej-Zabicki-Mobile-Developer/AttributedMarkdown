//
//  ContentViewModel.swift
//  AttributedMarkdownExample (iOS)
//
//  Created by Bart on 31/01/2022.
//

import Foundation
import SwiftUI

struct MercuryFile: Codable {
    let title: String
    let content: String
}

extension ContentView {
    
    final class ViewModel: ObservableObject {
        
        enum File: String, CaseIterable, Identifiable {
            case file1
            case file2
            case file3
            case file4
            case file5
            case file6
            
            var id: Int {
                switch self {
                case .file1:
                    return 0
                case .file2:
                    return 1
                case .file3:
                    return 2
                case .file4:
                    return 3
                case .file5:
                    return 4
                case .file6:
                    return 5
                }
            }
        }
        
        enum Error: Swift.Error {
            case noSuchFile
        }
        
        @Published var selectedIndex: Int = 0
        @Published var curentFileContent: AttributedString = .init()
        private lazy var attributedMarkdownParser = AttributedMarkdownParser(configuration: .default)
        
        func fetchAllFiles() async {
            do {
                let mercuryFile1 = try await fetchFile(file: .file1)
                let newContent = attributedMarkdownParser.parse(markdown: mercuryFile1.content)
                curentFileContent = newContent
            } catch {
                print("Fetch error: \(error)")
            }
        }
        
        func fetchFile(file: File) async throws -> MercuryFile {
            guard  let path = Bundle.main.path(forResource: file.rawValue, ofType: "json") else {
                throw Error.noSuchFile
            }
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            return try JSONDecoder().decode(MercuryFile.self, from: data)
        }
        
    }
    
}
