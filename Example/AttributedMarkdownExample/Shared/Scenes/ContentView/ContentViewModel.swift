//
//  ContentViewModel.swift
//  AttributedMarkdownExample (iOS)
//
//  Created by Bart on 31/01/2022.
//

import Foundation
import SwiftUI
import AttributedMarkdown

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
        @Published var curentFileContent: NSMutableAttributedString = .init()
        private lazy var attributedMarkdownParser = AttributedMarkdownParser(configuration: .default)
        
        
        
        func fetchAllFiles() async {
            do {
                let mercuryFile1 = try await fetchFile(file: .file1)
                let newContent = try await attributedMarkdownParser.parse(markdown: mercuryFile1.content)
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
        
        @MainActor
        func selectFile(file: File) async {
            do {
                let mercuryFile = try await fetchFile(file: file)
                let newContent = try await attributedMarkdownParser.parse(markdown: mercuryFile.content)
                curentFileContent = newContent
            } catch {
                print("Fetch error: \(error)")
            }
        }
        
    }
    
}

extension ContentView.ViewModel.File {
    
    init(from: Int) {
        switch from {
        case 0: self = .file1
        case 1: self = .file2
        case 2: self = .file3
        case 3: self = .file4
        case 4: self = .file5
        default: self = .file6
        }
    }
    
}
