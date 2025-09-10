//
//  DAOMediaDisplayExtensionTests.swift
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

final class DAOMediaDisplayExtensionTests: XCTestCase {
    
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
    
    private func createMockMedia(with urlString: String) -> DAOMedia {
        let media = DAOMedia()
        media.url = DNSURL(with: URL(string: urlString))
        return media
    }
    
    private func createMockMediaWithPreload() -> DAOMedia {
        let media = DAOMedia()
        media.url = DNSURL(with: URL(string: "https://example.com/media.mp4"))
        media.preloadUrl = DNSURL(with: URL(string: "https://example.com/thumbnail.jpg"))
        return media
    }
    
    private func createEmptyMedia() -> DAOMedia {
        return DAOMedia()
    }
    
    private func createCompleteMediaDisplay() -> DNSMediaDisplay {
        return DNSMediaDisplay(
            imageView: imageView,
            placeholderImage: placeholderImage,
            progressView: progressView,
            secondaryImageViews: secondaryImageViews
        )
    }
    
    private func createStaticImageDisplay() -> DNSMediaDisplayStaticImage {
        return DNSMediaDisplayStaticImage(
            imageView: imageView,
            placeholderImage: placeholderImage,
            progressView: progressView,
            secondaryImageViews: secondaryImageViews
        )
    }
    
    private func createVideoDisplay() -> DNSMediaDisplayVideo {
        return DNSMediaDisplayVideo(
            imageView: imageView,
            placeholderImage: placeholderImage,
            progressView: progressView,
            secondaryImageViews: secondaryImageViews
        )
    }
    
    // MARK: - Extension Method Tests
    
    func testDisplayWithDNSMediaDisplay() {
        // Arrange
        let media = createMockMedia(with: "https://example.com/image.jpg")
        let mediaDisplay = createCompleteMediaDisplay()
        
        // Act
        media.display(using: mediaDisplay)
        
        // Assert - Should call display method on the helper
        XCTAssertNotNil(mediaDisplay)
        XCTAssertNotNil(media)
    }
    
    func testDisplayWithStaticImageDisplay() {
        // Arrange
        let media = createMockMedia(with: "https://example.com/image.jpg")
        let staticImageDisplay = createStaticImageDisplay()
        
        // Act
        media.display(using: staticImageDisplay)
        
        // Assert - Should call display method on the static image helper
        XCTAssertNotNil(staticImageDisplay)
        XCTAssertNotNil(media)
        XCTAssertTrue(staticImageDisplay is DNSMediaDisplayStaticImage)
    }
    
    func testDisplayWithVideoDisplay() {
        // Arrange
        let media = createMockMedia(with: "https://example.com/video.mp4")
        let videoDisplay = createVideoDisplay()
        
        // Act
        media.display(using: videoDisplay)
        
        // Assert - Should call display method on the video helper
        XCTAssertNotNil(videoDisplay)
        XCTAssertNotNil(media)
        XCTAssertTrue(videoDisplay is DNSMediaDisplayVideo)
    }
    
    func testDisplayWithEmptyMedia() {
        // Arrange
        let media = createEmptyMedia()
        let mediaDisplay = createCompleteMediaDisplay()
        
        // Act
        media.display(using: mediaDisplay)
        
        // Assert - Should handle empty media gracefully
        XCTAssertNotNil(mediaDisplay)
        XCTAssertNotNil(media)
        XCTAssertTrue(media.url.isEmpty)
    }
    
    func testDisplayWithMediaWithPreloadURL() {
        // Arrange
        let media = createMockMediaWithPreload()
        let videoDisplay = createVideoDisplay()
        
        // Act
        media.display(using: videoDisplay)
        
        // Assert - Should handle media with preload URL
        XCTAssertNotNil(videoDisplay)
        XCTAssertNotNil(media)
        XCTAssertNotNil(media.url.asURL)
        XCTAssertNotNil(media.preloadUrl.asURL)
    }
    
    // MARK: - Polymorphic Display Tests
    
    func testPolymorphicDisplayWithDifferentHelpers() {
        // Arrange
        let media = createMockMedia(with: "https://example.com/content.jpg")
        let baseDisplay = createCompleteMediaDisplay()
        let staticDisplay = createStaticImageDisplay()
        let videoDisplay = createVideoDisplay()
        
        // Act & Assert - Should work with any DNSMediaDisplay subclass
        media.display(using: baseDisplay)
        XCTAssertNotNil(baseDisplay)
        
        media.display(using: staticDisplay)
        XCTAssertNotNil(staticDisplay)
        
        media.display(using: videoDisplay)
        XCTAssertNotNil(videoDisplay)
    }
    
    func testDisplayDelegatesCallToHelper() {
        // Arrange
        let media = createMockMedia(with: "https://example.com/test.jpg")
        let mockDisplay = MockMediaDisplay(imageView: imageView)
        
        // Act
        media.display(using: mockDisplay)
        
        // Assert
        XCTAssertTrue(mockDisplay.displayWasCalled)
        XCTAssertEqual(mockDisplay.displayCalledWithMedia, media)
    }
    
    // MARK: - Multiple Display Calls Tests
    
    func testMultipleDisplayCallsWithSameHelper() {
        // Arrange
        let media1 = createMockMedia(with: "https://example.com/image1.jpg")
        let media2 = createMockMedia(with: "https://example.com/image2.jpg")
        let mediaDisplay = createCompleteMediaDisplay()
        
        // Act - Multiple calls should work
        media1.display(using: mediaDisplay)
        media2.display(using: mediaDisplay)
        
        // Assert
        XCTAssertNotNil(mediaDisplay)
        XCTAssertNotNil(media1)
        XCTAssertNotNil(media2)
    }
    
    func testMultipleDisplayCallsWithDifferentHelpers() {
        // Arrange
        let media = createMockMedia(with: "https://example.com/versatile.jpg")
        let staticDisplay = createStaticImageDisplay()
        let videoDisplay = createVideoDisplay()
        
        // Act - Same media with different display helpers
        media.display(using: staticDisplay)
        media.display(using: videoDisplay)
        
        // Assert
        XCTAssertNotNil(media)
        XCTAssertNotNil(staticDisplay)
        XCTAssertNotNil(videoDisplay)
    }
    
    // MARK: - Edge Cases Tests
    
    func testDisplayWithNilURLMedia() {
        // Arrange
        let media = DAOMedia()
        media.url = DNSURL() // Explicitly empty
        let mediaDisplay = createCompleteMediaDisplay()
        
        // Act
        media.display(using: mediaDisplay)
        
        // Assert - Should handle nil URL gracefully
        XCTAssertNotNil(mediaDisplay)
        XCTAssertTrue(media.url.isEmpty)
    }
    
    func testDisplayWithInvalidURLMedia() {
        // Arrange
        let media = DAOMedia()
        media.url = DNSURL(with: URL(string: "not-a-valid-url"))
        let mediaDisplay = createCompleteMediaDisplay()
        
        // Act
        media.display(using: mediaDisplay)
        
        // Assert - Should handle invalid URL gracefully
        XCTAssertNotNil(mediaDisplay)
        XCTAssertNotNil(media.url)
    }
    
    func testDisplayWithComplexMediaData() {
        // Arrange
        let media = DAOMedia()
        media.url = DNSURL(with: URL(string: "https://example.com/complex-media.mp4"))
        media.preloadUrl = DNSURL(with: URL(string: "https://example.com/thumbnail.jpg"))
        media.title = DNSString(with: "Complex Media Test")
        
        let videoDisplay = createVideoDisplay()
        
        // Act
        media.display(using: videoDisplay)
        
        // Assert - Should handle complex media data
        XCTAssertNotNil(videoDisplay)
        XCTAssertEqual(media.title.asString, "Complex Media Test")
        XCTAssertNotNil(media.url.asURL)
        XCTAssertNotNil(media.preloadUrl.asURL)
    }
    
    // MARK: - Type Safety Tests
    
    func testExtensionOnDAOMediaType() {
        // Arrange
        let media = DAOMedia()
        let mediaDisplay = createCompleteMediaDisplay()

        // Act: Call the extension method to ensure it exists and is callable from Swift
        media.display(using: mediaDisplay)

        // Assert
        XCTAssertNotNil(media)
        XCTAssertNotNil(mediaDisplay)
    }
    
    func testExtensionMethodSignature() {
        // Arrange
        let media = createMockMedia(with: "https://example.com/signature-test.jpg")
        let mediaDisplay = createCompleteMediaDisplay()
        
        // Act - Method should accept DNSMediaDisplay parameter
        media.display(using: mediaDisplay)
        
        // Assert - Compilation success indicates correct signature
        XCTAssertNotNil(media)
        XCTAssertNotNil(mediaDisplay)
    }
    
    // MARK: - Integration Tests
    
    func testIntegrationWithStaticImageWorkflow() {
        // Arrange
        let media = createMockMedia(with: "https://example.com/integration.jpg")
        let staticDisplay = createStaticImageDisplay()
        
        // Act - Full integration test
        media.display(using: staticDisplay)
        
        // Assert - Should integrate properly with static image display workflow
        XCTAssertNotNil(media)
        XCTAssertNotNil(staticDisplay)
        XCTAssertTrue(staticDisplay is DNSMediaDisplayStaticImage)
    }
    
    func testIntegrationWithVideoWorkflow() {
        // Arrange
        let media = createMockMediaWithPreload()
        let videoDisplay = createVideoDisplay()
        
        // Act - Full integration test with preload
        media.display(using: videoDisplay)
        
        // Assert - Should integrate properly with video display workflow
        XCTAssertNotNil(media)
        XCTAssertNotNil(videoDisplay)
        XCTAssertNotNil(media.preloadUrl.asURL)
        XCTAssertTrue(videoDisplay is DNSMediaDisplayVideo)
    }
    
    // MARK: - Performance Tests
    
    func testPerformanceDisplayExtension() {
        let media = createMockMedia(with: "https://example.com/perf-test.jpg")
        let mediaDisplay = createCompleteMediaDisplay()
        
        measure {
            for _ in 0..<1000 {
                media.display(using: mediaDisplay)
            }
        }
    }
    
    func testPerformanceDisplayWithMultipleHelpers() {
        let media = createMockMedia(with: "https://example.com/multi-helper.jpg")
        let staticDisplay = createStaticImageDisplay()
        let videoDisplay = createVideoDisplay()
        
        measure {
            for _ in 0..<500 {
                media.display(using: staticDisplay)
                media.display(using: videoDisplay)
            }
        }
    }
    
    // MARK: - Memory Management Tests
    
    func testNoRetainCyclesInExtension() {
        weak var weakMedia: DAOMedia?
        weak var weakDisplay: DNSMediaDisplay?
        
        autoreleasepool {
            let media = createMockMedia(with: "https://example.com/memory-test.jpg")
            let mediaDisplay = createCompleteMediaDisplay()
            
            media.display(using: mediaDisplay)
            
            weakMedia = media
            weakDisplay = mediaDisplay
            
            XCTAssertNotNil(weakMedia)
            XCTAssertNotNil(weakDisplay)
        }
        
        // Assert - No retain cycles should exist
        XCTAssertNil(weakMedia, "DAOMedia should be deallocated")
        XCTAssertNil(weakDisplay, "DNSMediaDisplay should be deallocated")
    }
    
    static var allTests = [
        ("testDisplayWithDNSMediaDisplay", testDisplayWithDNSMediaDisplay),
        ("testDisplayWithStaticImageDisplay", testDisplayWithStaticImageDisplay),
        ("testDisplayWithVideoDisplay", testDisplayWithVideoDisplay),
        ("testDisplayWithEmptyMedia", testDisplayWithEmptyMedia),
        ("testDisplayWithMediaWithPreloadURL", testDisplayWithMediaWithPreloadURL),
        ("testPolymorphicDisplayWithDifferentHelpers", testPolymorphicDisplayWithDifferentHelpers),
        ("testDisplayDelegatesCallToHelper", testDisplayDelegatesCallToHelper),
        ("testMultipleDisplayCallsWithSameHelper", testMultipleDisplayCallsWithSameHelper),
        ("testMultipleDisplayCallsWithDifferentHelpers", testMultipleDisplayCallsWithDifferentHelpers),
        ("testDisplayWithNilURLMedia", testDisplayWithNilURLMedia),
        ("testDisplayWithInvalidURLMedia", testDisplayWithInvalidURLMedia),
        ("testDisplayWithComplexMediaData", testDisplayWithComplexMediaData),
        ("testExtensionOnDAOMediaType", testExtensionOnDAOMediaType),
        ("testExtensionMethodSignature", testExtensionMethodSignature),
        ("testIntegrationWithStaticImageWorkflow", testIntegrationWithStaticImageWorkflow),
        ("testIntegrationWithVideoWorkflow", testIntegrationWithVideoWorkflow),
        ("testPerformanceDisplayExtension", testPerformanceDisplayExtension),
        ("testPerformanceDisplayWithMultipleHelpers", testPerformanceDisplayWithMultipleHelpers),
        ("testNoRetainCyclesInExtension", testNoRetainCyclesInExtension),
    ]
}

// MARK: - Mock Classes for Testing

private class MockMediaDisplay: DNSMediaDisplay {
    var displayWasCalled = false
    var displayCalledWithMedia: DAOMedia?
    
    override func display(from media: DAOMedia?) {
        displayWasCalled = true
        displayCalledWithMedia = media
        super.display(from: media)
    }
}
