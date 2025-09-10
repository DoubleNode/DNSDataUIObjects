//
//  DNSMediaDisplayTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataUIObjectsTests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import UIKit
import DNSCore
import DNSDataObjects
import Foundation
@testable import DNSDataUIObjects

final class DNSMediaDisplayTests: XCTestCase {
    
    // MARK: - Properties
    
    var imageView: UIImageView!
    var progressView: UIProgressView!
    var placeholderImage: UIImage!
    var secondaryImageViews: [UIImageView]!
    
    // MARK: - Setup and Teardown
    
    override func setUp() {
        super.setUp()
        imageView = UIImageView()
        progressView = UIProgressView()
        placeholderImage = UIImage()
        secondaryImageViews = [UIImageView(), UIImageView()]
    }
    
    override func tearDown() {
        imageView = nil
        progressView = nil
        placeholderImage = nil
        secondaryImageViews = nil
        super.tearDown()
    }
    
    // MARK: - Helper Methods
    
    private func createBasicMediaDisplay() -> DNSMediaDisplay {
        return DNSMediaDisplay(imageView: imageView)
    }
    
    private func createCompleteMediaDisplay() -> DNSMediaDisplay {
        return DNSMediaDisplay(
            imageView: imageView,
            placeholderImage: placeholderImage,
            progressView: progressView,
            secondaryImageViews: secondaryImageViews
        )
    }
    
    // MARK: - Initialization Tests
    
    func testBasicInitialization() {
        // Arrange & Act
        let mediaDisplay = DNSMediaDisplay(imageView: imageView)
        
        // Assert
        XCTAssertEqual(mediaDisplay.imageView, imageView)
        XCTAssertNil(mediaDisplay.placeholderImage)
        XCTAssertNil(mediaDisplay.progressView)
        XCTAssertTrue(mediaDisplay.secondaryImageViews.isEmpty)
    }
    
    func testCompleteInitialization() {
        // Arrange & Act
        let mediaDisplay = createCompleteMediaDisplay()
        
        // Assert
        XCTAssertEqual(mediaDisplay.imageView, imageView)
        XCTAssertEqual(mediaDisplay.placeholderImage, placeholderImage)
        XCTAssertEqual(mediaDisplay.progressView, progressView)
        XCTAssertEqual(mediaDisplay.secondaryImageViews.count, 2)
        XCTAssertEqual(mediaDisplay.secondaryImageViews[0], secondaryImageViews[0])
        XCTAssertEqual(mediaDisplay.secondaryImageViews[1], secondaryImageViews[1])
    }
    
    func testInitializationWithEmptySecondaryViews() {
        // Arrange & Act
        let mediaDisplay = DNSMediaDisplay(
            imageView: imageView,
            placeholderImage: placeholderImage,
            progressView: progressView,
            secondaryImageViews: []
        )
        
        // Assert
        XCTAssertEqual(mediaDisplay.imageView, imageView)
        XCTAssertEqual(mediaDisplay.placeholderImage, placeholderImage)
        XCTAssertEqual(mediaDisplay.progressView, progressView)
        XCTAssertTrue(mediaDisplay.secondaryImageViews.isEmpty)
    }
    
    // MARK: - Property Modification Tests
    
    func testImageViewPropertyModification() {
        // Arrange
        let mediaDisplay = createBasicMediaDisplay()
        let newImageView = UIImageView()
        
        // Act
        mediaDisplay.imageView = newImageView
        
        // Assert
        XCTAssertEqual(mediaDisplay.imageView, newImageView)
        XCTAssertNotEqual(mediaDisplay.imageView, imageView)
    }
    
    func testPlaceholderImagePropertyModification() {
        // Arrange
        let mediaDisplay = createBasicMediaDisplay()
        let newPlaceholderImage = UIImage()
        
        // Act
        mediaDisplay.placeholderImage = newPlaceholderImage
        
        // Assert
        XCTAssertEqual(mediaDisplay.placeholderImage, newPlaceholderImage)
    }
    
    func testProgressViewPropertyModification() {
        // Arrange
        let mediaDisplay = createBasicMediaDisplay()
        let newProgressView = UIProgressView()
        
        // Act
        mediaDisplay.progressView = newProgressView
        
        // Assert
        XCTAssertEqual(mediaDisplay.progressView, newProgressView)
    }
    
    func testSecondaryImageViewsPropertyModification() {
        // Arrange
        let mediaDisplay = createBasicMediaDisplay()
        let newSecondaryViews = [UIImageView(), UIImageView(), UIImageView()]
        
        // Act
        mediaDisplay.secondaryImageViews = newSecondaryViews
        
        // Assert
        XCTAssertEqual(mediaDisplay.secondaryImageViews.count, 3)
        for (index, imageView) in newSecondaryViews.enumerated() {
            XCTAssertEqual(mediaDisplay.secondaryImageViews[index], imageView)
        }
    }
    
    // MARK: - NSCopying Protocol Tests
    
    func testCopyWithZone() {
        // Arrange
        let original = createCompleteMediaDisplay()
        
        // Act
        let copy = original.copy() as! DNSMediaDisplay
        
        // Assert
        XCTAssertEqual(copy.imageView, original.imageView)
        XCTAssertEqual(copy.progressView, original.progressView)
        XCTAssertEqual(copy.secondaryImageViews.count, original.secondaryImageViews.count)
        
        // Verify they are different instances
        XCTAssertTrue(copy !== original)
    }
    
    func testCopyWithMinimalProperties() {
        // Arrange
        let original = createBasicMediaDisplay()
        
        // Act
        let copy = original.copy() as! DNSMediaDisplay
        
        // Assert
        XCTAssertEqual(copy.imageView, original.imageView)
        XCTAssertNil(copy.placeholderImage)
        XCTAssertNil(copy.progressView)
        XCTAssertTrue(copy.secondaryImageViews.isEmpty)
        
        // Verify they are different instances
        XCTAssertTrue(copy !== original)
    }
    
    // MARK: - Equality Tests
    
    func testEquality() {
        // Arrange
        let mediaDisplay1 = createCompleteMediaDisplay()
        let mediaDisplay2 = createCompleteMediaDisplay()
        
        // Act & Assert
        XCTAssertEqual(mediaDisplay1, mediaDisplay2)
        XCTAssertFalse(mediaDisplay1 != mediaDisplay2)
    }
    
    func testInequality() {
        // Arrange
        let mediaDisplay1 = createCompleteMediaDisplay()
        let mediaDisplay2 = createBasicMediaDisplay()
        
        // Act & Assert
        XCTAssertNotEqual(mediaDisplay1, mediaDisplay2)
        XCTAssertTrue(mediaDisplay1 != mediaDisplay2)
    }
    
    func testIsDiffFrom() {
        // Arrange
        let mediaDisplay1 = createCompleteMediaDisplay()
        let mediaDisplay2 = createCompleteMediaDisplay()
        let mediaDisplay3 = createBasicMediaDisplay()
        
        // Act & Assert
        XCTAssertFalse(mediaDisplay1.isDiffFrom(mediaDisplay2))
        XCTAssertTrue(mediaDisplay1.isDiffFrom(mediaDisplay3))
        XCTAssertTrue(mediaDisplay1.isDiffFrom(nil))
        XCTAssertTrue(mediaDisplay1.isDiffFrom("not a media display"))
    }
    
    func testSelfComparison() {
        // Arrange
        let mediaDisplay = createCompleteMediaDisplay()
        
        // Act & Assert
        XCTAssertFalse(mediaDisplay.isDiffFrom(mediaDisplay))
        XCTAssertEqual(mediaDisplay, mediaDisplay)
    }
    
    // MARK: - Method Tests
    
    func testContentInit() {
        // Arrange & Act
        let mediaDisplay = createCompleteMediaDisplay()
        
        // Assert - contentInit is called during initialization
        // This is a virtual method that can be overridden
        XCTAssertNotNil(mediaDisplay)
    }
    
    func testDisplayFromMedia() {
        // Arrange
        let mediaDisplay = createCompleteMediaDisplay()
        let mockMedia = DAOMedia()
        
        // Act - This is a virtual method that can be overridden
        mediaDisplay.display(from: mockMedia)
        
        // Assert - Base implementation does nothing
        XCTAssertNotNil(mediaDisplay)
    }
    
    func testDisplayFromNilMedia() {
        // Arrange
        let mediaDisplay = createCompleteMediaDisplay()
        
        // Act - This is a virtual method that can be overridden
        mediaDisplay.display(from: nil)
        
        // Assert - Base implementation does nothing
        XCTAssertNotNil(mediaDisplay)
    }
    
    func testUtilityDisplayPrepareForReuse() {
        // Arrange
        let mediaDisplay = createCompleteMediaDisplay()
        
        // Act - Base implementation does nothing
        mediaDisplay.utilityDisplayPrepareForReuse()
        
        // Assert
        XCTAssertNotNil(mediaDisplay)
    }
    
    func testUtilityDisplayPrepareForReuseVideoOnly() {
        // Arrange
        let mediaDisplay = createCompleteMediaDisplay()
        
        // Act - Base implementation does nothing
        mediaDisplay.utilityDisplayPrepareForReuse(videoOnly: true)
        
        // Assert
        XCTAssertNotNil(mediaDisplay)
    }
    
    // MARK: - Edge Cases
    
    func testCopyingWithMultipleSecondaryViews() {
        // Arrange
        let multipleSecondaryViews = [
            UIImageView(),
            UIImageView(),
            UIImageView(),
            UIImageView(),
            UIImageView()
        ]
        let original = DNSMediaDisplay(
            imageView: imageView,
            placeholderImage: placeholderImage,
            progressView: progressView,
            secondaryImageViews: multipleSecondaryViews
        )
        
        // Act
        let copy = original.copy() as! DNSMediaDisplay
        
        // Assert
        XCTAssertEqual(copy.secondaryImageViews.count, 5)
        XCTAssertTrue(copy !== original)
    }
    
    func testEqualityWithDifferentProgressView() {
        // Arrange
        let mediaDisplay1 = createCompleteMediaDisplay()
        let mediaDisplay2 = DNSMediaDisplay(
            imageView: imageView,
            placeholderImage: placeholderImage,
            progressView: UIProgressView(), // Different progress view
            secondaryImageViews: secondaryImageViews
        )
        
        // Act & Assert
        XCTAssertNotEqual(mediaDisplay1, mediaDisplay2)
        XCTAssertTrue(mediaDisplay1.isDiffFrom(mediaDisplay2))
    }
    
    func testEqualityWithDifferentSecondaryViews() {
        // Arrange
        let mediaDisplay1 = createCompleteMediaDisplay()
        let mediaDisplay2 = DNSMediaDisplay(
            imageView: imageView,
            placeholderImage: placeholderImage,
            progressView: progressView,
            secondaryImageViews: [UIImageView()] // Different secondary views
        )
        
        // Act & Assert
        XCTAssertNotEqual(mediaDisplay1, mediaDisplay2)
        XCTAssertTrue(mediaDisplay1.isDiffFrom(mediaDisplay2))
    }
    
    // MARK: - Performance Tests
    
    func testPerformanceCreateMediaDisplay() {
        measure {
            for _ in 0..<1000 {
                let _ = DNSMediaDisplay(imageView: UIImageView())
            }
        }
    }
    
    func testPerformanceCopyMediaDisplay() {
        let mediaDisplay = createCompleteMediaDisplay()
        
        measure {
            for _ in 0..<1000 {
                let _ = mediaDisplay.copy()
            }
        }
    }
    
    func testPerformanceCompareMediaDisplay() {
        let mediaDisplay1 = createCompleteMediaDisplay()
        let mediaDisplay2 = createCompleteMediaDisplay()
        
        measure {
            for _ in 0..<1000 {
                let _ = mediaDisplay1.isDiffFrom(mediaDisplay2)
            }
        }
    }
    
    // MARK: - Memory Management Tests
    
    func testNoRetainCycles() {
        weak var weakMediaDisplay: DNSMediaDisplay?
        
        autoreleasepool {
            let mediaDisplay = createCompleteMediaDisplay()
            weakMediaDisplay = mediaDisplay
            XCTAssertNotNil(weakMediaDisplay)
        }
        
        XCTAssertNil(weakMediaDisplay, "DNSMediaDisplay should be deallocated")
    }
    
    static var allTests = [
        ("testBasicInitialization", testBasicInitialization),
        ("testCompleteInitialization", testCompleteInitialization),
        ("testInitializationWithEmptySecondaryViews", testInitializationWithEmptySecondaryViews),
        ("testImageViewPropertyModification", testImageViewPropertyModification),
        ("testPlaceholderImagePropertyModification", testPlaceholderImagePropertyModification),
        ("testProgressViewPropertyModification", testProgressViewPropertyModification),
        ("testSecondaryImageViewsPropertyModification", testSecondaryImageViewsPropertyModification),
        ("testCopyWithZone", testCopyWithZone),
        ("testCopyWithMinimalProperties", testCopyWithMinimalProperties),
        ("testEquality", testEquality),
        ("testInequality", testInequality),
        ("testIsDiffFrom", testIsDiffFrom),
        ("testSelfComparison", testSelfComparison),
        ("testContentInit", testContentInit),
        ("testDisplayFromMedia", testDisplayFromMedia),
        ("testDisplayFromNilMedia", testDisplayFromNilMedia),
        ("testUtilityDisplayPrepareForReuse", testUtilityDisplayPrepareForReuse),
        ("testUtilityDisplayPrepareForReuseVideoOnly", testUtilityDisplayPrepareForReuseVideoOnly),
        ("testCopyingWithMultipleSecondaryViews", testCopyingWithMultipleSecondaryViews),
        ("testEqualityWithDifferentProgressView", testEqualityWithDifferentProgressView),
        ("testEqualityWithDifferentSecondaryViews", testEqualityWithDifferentSecondaryViews),
        ("testPerformanceCreateMediaDisplay", testPerformanceCreateMediaDisplay),
        ("testPerformanceCopyMediaDisplay", testPerformanceCopyMediaDisplay),
        ("testPerformanceCompareMediaDisplay", testPerformanceCompareMediaDisplay),
        ("testNoRetainCycles", testNoRetainCycles),
    ]
}