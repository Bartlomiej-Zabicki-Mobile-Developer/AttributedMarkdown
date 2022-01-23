import SwiftUI
import Markdown

public final class AttributedMarkdownParser {
    
    // MARK: - Properties
    
    private(set) var configuration: ParserConfiguration
    
    // MARK: - Initialization

    public init(configuration: ParserConfiguration) {
        self.configuration = configuration
    }
    
    // MARK: - Functions
    
    public func parse(markdown: String) async throws -> NSMutableAttributedString {
        var document = Document(parsing: markdown)
        var imagesWalker = ImagesWalker()
        imagesWalker.visit(document)
        do {
            let imageResults = try await fetchAllImages(from: imagesWalker.imageURLs.compactMap({ URL(string: $0) }))
            var imagesRewriter = ImagesRewriter(imageOutputs: imageResults)
            if let documentWithImages = imagesRewriter.visit(document) as? Document {
                document = documentWithImages
            }
        } catch {
            print("Images error: \(error)")
        }
        
        var visitor = AttributedStringVisitor(styles: configuration.sectionStyles)
        let newDocument = visitor.visit(document)
        return newDocument
    }
    
    // MARK: - Private implementation
    
    private func fetchAllImages(from urls: [URL]) async throws -> [ImageOutput] {
        try await withThrowingTaskGroup(of: ImageOutput.self,
                            returning: [ImageOutput].self,
                            body: { taskGroup in
            for url in urls {
                taskGroup.addTask {
                    let (data, _) = try await URLSession.shared.data(from: url)
                    if let targetURL = self.configuration.imagesHandler.urlToSave(remoteURL: url) {
                        FileManager.default.createFile(atPath: targetURL.path, contents: data)
                        return .init(remoteURL: url, localURL: targetURL)
                    }
                    return .init(remoteURL: url, localURL: nil)
                }
            }
            
            var values: [ImageOutput] = []
            for try await value in taskGroup {
                values.append(value)
            }
            return values
        })
    }
    
}
