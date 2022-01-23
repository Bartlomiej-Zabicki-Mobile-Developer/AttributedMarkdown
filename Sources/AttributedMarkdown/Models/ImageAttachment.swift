//
//  ImageAttachment.swift
//  
//
//  Created by Bart on 16/04/2022.
//

import Foundation
#if os(iOS)
import UIKit
#else
import AppKit
#endif

public final class ImageAttachment: NSTextAttachment {
    
    public enum ImageAlignment {
        case left
        case right
        case center
    }
    
    public struct Configuration {
        var maxWidthPercentage: CGFloat = 100
    }
    
    private struct ImageSize {
        let width: CGFloat
        let height: CGFloat
    }
    
    private struct AlignmentPosition {
        let x: CGFloat
        let y: CGFloat
        let width: CGFloat
        let height: CGFloat
    }
    
    // MARK: - Properties
    
    private(set) var configuration: Configuration!
    
    // MARK: - Initialization
    
    public override init(data contentData: Data?, ofType uti: String?) {
        super.init(data: contentData, ofType: uti)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("Please use constructor with configuration")
    }
    
    init(configuration: Configuration) {
        self.configuration = configuration
        super.init(data: nil, ofType: nil)
    }
    
    // MARK: - Public implementation
    
#if os(iOS)
    public override func attachmentBounds(for textContainer: NSTextContainer?, proposedLineFragment lineFrag: CGRect, glyphPosition position: CGPoint, characterIndex charIndex: Int) -> CGRect {
        guard let image = self.image else {
            return super.attachmentBounds(for: textContainer,proposedLineFragment: lineFrag, glyphPosition: position, characterIndex: charIndex)
        }
        
        let containerWidth = min(lineFrag.width, image.size.width)
        let alignmentPosition = calculateAlignmentPosition(for: .init(width: image.size.width, height: image.size.height), in: containerWidth)
        return CGRect(x: alignmentPosition.x, y: alignmentPosition.y, width: alignmentPosition.width, height: alignmentPosition.height)
    }
#endif
    
#if os(macOS)
    public override func attachmentBounds(for textContainer: NSTextContainer?, proposedLineFragment lineFrag: NSRect, glyphPosition position: CGPoint, characterIndex charIndex: Int) -> NSRect {
        guard let image = self.image else {
            return super.attachmentBounds(for: textContainer,proposedLineFragment: lineFrag, glyphPosition: position, characterIndex: charIndex)
        }
        
        let containerWidth = min(lineFrag.width, image.size.width)
        let alignmentPosition = calculateAlignmentPosition(for: .init(width: image.size.width, height: image.size.height), in: containerWidth)
        return NSRect(x: alignmentPosition.x, y: alignmentPosition.y, width: alignmentPosition.width, height: alignmentPosition.height)
  }
#endif
    
    // MARK: - Private implementation
    
    private func calculateAlignmentPosition(for imageSize: ImageSize, in containerWidth: CGFloat) -> AlignmentPosition {
        
        let aspectRatio = imageSize.width / imageSize.height
        //Check for percentage
        let imageWidth: CGFloat = min(containerWidth, containerWidth*configuration.maxWidthPercentage/100)
        let imageHeight: CGFloat = imageWidth / aspectRatio
        
        return .init(x: 0, y: 0, width: imageWidth, height: imageHeight)
    }
    
}
