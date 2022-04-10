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
    
    public func parse(markdown: String) async throws -> AttributedString {
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
                        print("TargetURL: \(targetURL)")
                        do {
                            print("Saving file to: \(targetURL)")
                            FileManager.default.createFile(atPath: targetURL.path, contents: data)
//                            try data.write(to: targetURL)
                        } catch {
                            print("Save error: \(error)")
                        }
                        print("File exists: \(FileManager.default.fileExists(atPath: targetURL.path))")
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

struct ImagesWalker: MarkupWalker {
    
    var imageURLs: [String] = []
    
    mutating func visitImage(_ image: Markdown.Image) {
        if let source = image.source {
            imageURLs.append(source)
        }
        descendInto(image)
    }
    
}

private struct ImageOutput {
    let remoteURL: URL
    let localURL: URL?
}

struct ImagesRewriter: MarkupRewriter {
    
    fileprivate var imageOutputs: [ImageOutput]
    
    mutating func visitImage(_ image: Markdown.Image) -> Markup? {
        if let fetchedOutput = imageOutputs.first(where: { $0.remoteURL.absoluteString == image.source }), let localURL = fetchedOutput.localURL {
            var image = image
            image.source = localURL.path
            return image
        } else {
            return image
        }
    }
    
}
