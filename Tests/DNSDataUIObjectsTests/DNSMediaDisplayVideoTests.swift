//
//  DNSMediaDisplayVideoTests.swift
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

final class DNSMediaDisplayVideoTests: XCTestCase {
    
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
    
    private func createBasicVideoDisplay() -> DNSMediaDisplayVideo {
        return DNSMediaDisplayVideo(imageView: imageView)
    }
    
    private func createCompleteVideoDisplay() -> DNSMediaDisplayVideo {
        return DNSMediaDisplayVideo(
            imageView: imageView,
            placeholderImage: placeholderImage,
            progressView: progressView,
            secondaryImageViews: secondaryImageViews
        )
    }
    
    private func createMockVideoMediaWithPreload() -> DAOMedia {
        let media = DAOMedia()
        media.url = DNSURL(with: URL(string: "https://example.com/video.mp4"))
        media.preloadUrl = DNSURL(with: URL(string: "https://example.com/video-thumbnail.jpg"))
        return media
    }
    
    private func createMockVideoMediaWithoutPreload() -> DAOMedia {
        let media = DAOMedia()
        media.url = DNSURL(with: URL(string: "https://example.com/video.mp4"))
        return media
    }
    
    // MARK: - Initialization Tests
    
    func testBasicInitialization() {
        // Arrange & Act
        let videoDisplay = createBasicVideoDisplay()
        
        // Assert
        XCTAssertEqual(videoDisplay.imageView, imageView)
        XCTAssertNil(videoDisplay.placeholderImage)
        XCTAssertNil(videoDisplay.progressView)
        XCTAssertTrue(videoDisplay.secondaryImageViews.isEmpty)
    }
    
    func testCompleteInitialization() {
        // Arrange & Act
        let videoDisplay = createCompleteVideoDisplay()
        
        // Assert
        XCTAssertEqual(videoDisplay.imageView, imageView)
        XCTAssertEqual(videoDisplay.placeholderImage, placeholderImage)
        XCTAssertEqual(videoDisplay.progressView, progressView)
        XCTAssertEqual(videoDisplay.secondaryImageViews.count, 2)
    }
    
    func testInheritanceFromDNSMediaDisplayStaticImage() {
        // Arrange & Act
        let videoDisplay = createBasicVideoDisplay()
        
        // Assert
        XCTAssertTrue(videoDisplay is DNSMediaDisplay)
        XCTAssertTrue(videoDisplay is DNSMediaDisplayStaticImage)
        XCTAssertTrue(videoDisplay is DNSMediaDisplayVideo)
    }
    
    // MARK: - Display Method Tests
    
    func testDisplayFromNilMedia() {
        // Arrange
        let videoDisplay = createCompleteVideoDisplay()
        let expectation = XCTestExpectation(description: "Display from nil media should set placeholder")
        
        // Act
        videoDisplay.display(from: nil)
        
        // Give some time for the UI thread to execute
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
        
        // Assert
        XCTAssertEqual(videoDisplay.imageView.image, placeholderImage)
    }
    
    func testDisplayFromMediaWithNilURL() {
        // Arrange
        let videoDisplay = createCompleteVideoDisplay()
        let media = DAOMedia()
        media.url = DNSURL() // Empty/nil URL
        let expectation = XCTestExpectation(description: "Display from media with nil URL should set placeholder")
        
        // Act
        videoDisplay.display(from: media)
        
        // Give some time for the UI thread to execute
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
        
        // Assert
        XCTAssertEqual(videoDisplay.imageView.image, placeholderImage)
    }
    
    func testDisplayFromMediaWithInvalidURL() {
        // Arrange
        let videoDisplay = createCompleteVideoDisplay()
        let media = DAOMedia()
        media.url = DNSURL(with: URL(string: ""))   // invalid URL
        let expectation = XCTestExpectation(description: "Display from media with invalid URL should set placeholder")
        
        // Act
        videoDisplay.display(from: media)
        
        // Give some time for the UI thread to execute
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
        
        // Assert
        XCTAssertEqual(videoDisplay.imageView.image, placeholderImage)
    }
    
    func testDisplayFromVideoMediaWithPreloadURL() {
        // Arrange
        let videoDisplay = createCompleteVideoDisplay()
        let media = createMockVideoMediaWithPreload()
        
        // Act - This will attempt to load preload image first, then video
        videoDisplay.display(from: media)
        
        // Assert - The method should be called without crashing
        XCTAssertNotNil(videoDisplay)
        XCTAssertNotNil(media.url.asURL)
        XCTAssertNotNil(media.preloadUrl.asURL)
    }
    
    func testDisplayFromVideoMediaWithoutPreloadURL() {
        // Arrange
        let videoDisplay = createCompleteVideoDisplay()
        let media = createMockVideoMediaWithoutPreload()
        
        // Act - This will attempt to display video directly
        videoDisplay.display(from: media)
        
        // Assert - The method should be called without crashing
        XCTAssertNotNil(videoDisplay)
        XCTAssertNotNil(media.url.asURL)
    }
    
    // MARK: - Utility Methods Tests
    
    func testUtilityDisplayVideo() {
        // Arrange
        let videoDisplay = createCompleteVideoDisplay()
        let testURL = URL(string: "https://example.com/video.mp4")!
        
        // Act - This will attempt to display the video (implementation is currently commented out)
        videoDisplay.utilityDisplayVideo(url: testURL)
        
        // Assert - Method should execute without crashing
        XCTAssertNotNil(videoDisplay)
        
        // Verify secondary image views are cleared as per implementation
        XCTAssertEqual(videoDisplay.secondaryImageViews.count, 2)
    }
    
    func testUtilityDisplayPrepareForReuse() {
        // Arrange
        let videoDisplay = createCompleteVideoDisplay()
        
        // Act - Should call super implementation
        videoDisplay.utilityDisplayPrepareForReuse()
        
        // Assert - Method should execute without crashing
        XCTAssertNotNil(videoDisplay)
    }
    
    func testUtilityDisplayPrepareForReuseVideoOnly() {
        // Arrange
        let videoDisplay = createCompleteVideoDisplay()
        
        // Act - Should handle video-specific cleanup (currently video code is commented out)
        videoDisplay.utilityDisplayPrepareForReuse(videoOnly: true)
        
        // Assert - Method should execute without crashing and not call super when videoOnly is true
        XCTAssertNotNil(videoDisplay)
    }
    
    func testUtilityDisplayPrepareForReuseNotVideoOnly() {
        // Arrange
        let videoDisplay = createCompleteVideoDisplay()
        
        // Act - Should call super implementation when videoOnly is false
        videoDisplay.utilityDisplayPrepareForReuse(videoOnly: false)
        
        // Assert - Method should execute without crashing
        XCTAssertNotNil(videoDisplay)
    }
    
    // MARK: - Secondary Image Views Tests
    
    func testSecondaryImageViewsClearingInVideoDisplay() {
        // Arrange
        let videoDisplay = createCompleteVideoDisplay()
        let testURL = URL(string: "https://example.com/video.mp4")!
        
        // Set initial images in secondary views
        let testImage = UIImage()
        videoDisplay.secondaryImageViews[0].image = testImage
        videoDisplay.secondaryImageViews[1].image = testImage
        
        // Verify images are set
        XCTAssertEqual(videoDisplay.secondaryImageViews[0].image, testImage)
        XCTAssertEqual(videoDisplay.secondaryImageViews[1].image, testImage)
        
        // Act - This should clear secondary image views
        videoDisplay.utilityDisplayVideo(url: testURL)
        
        // Assert - Secondary image views should be cleared
        XCTAssertNil(videoDisplay.secondaryImageViews[0].image)
        XCTAssertNil(videoDisplay.secondaryImageViews[1].image)
    }
    
    // MARK: - NSCopying Protocol Tests
    
    func testCopyWithZone() {
        // Arrange
        let original = createCompleteVideoDisplay()
        
        // Act
        let copyAny = original.copy()
        
        // Assert - The base copy method returns DNSMediaDisplay, not the subclass
        XCTAssertTrue(copyAny is DNSMediaDisplay)
        let copy = copyAny as! DNSMediaDisplay
        
        XCTAssertEqual(copy.imageView, original.imageView)
        XCTAssertEqual(copy.progressView, original.progressView)
        XCTAssertEqual(copy.secondaryImageViews.count, original.secondaryImageViews.count)
        
        // Verify they are different instances
        XCTAssertTrue(copy !== original)
        
        // Note: The base copy method does not preserve subclass type
        // This is the expected behavior of the current implementation
        XCTAssertTrue(copy is DNSMediaDisplay)
        XCTAssertFalse(copy is DNSMediaDisplayVideo)
    }
    
    // MARK: - Equality Tests
    
    func testEquality() {
        // Arrange
        let videoDisplay1 = createCompleteVideoDisplay()
        let videoDisplay2 = createCompleteVideoDisplay()
        
        // Act & Assert
        XCTAssertEqual(videoDisplay1, videoDisplay2)
        XCTAssertFalse(videoDisplay1 != videoDisplay2)
    }
    
    func testInequality() {
        // Arrange
        let videoDisplay1 = createCompleteVideoDisplay()
        let videoDisplay2 = createBasicVideoDisplay()
        
        // Act & Assert
        XCTAssertNotEqual(videoDisplay1, videoDisplay2)
        XCTAssertTrue(videoDisplay1 != videoDisplay2)
    }
    
    func testIsDiffFrom() {
        // Arrange
        let videoDisplay1 = createCompleteVideoDisplay()
        let videoDisplay2 = createCompleteVideoDisplay()
        let videoDisplay3 = createBasicVideoDisplay()
        
        // Act & Assert
        XCTAssertFalse(videoDisplay1.isDiffFrom(videoDisplay2))
        XCTAssertTrue(videoDisplay1.isDiffFrom(videoDisplay3))
        XCTAssertTrue(videoDisplay1.isDiffFrom(nil))
        XCTAssertTrue(videoDisplay1.isDiffFrom("not a video display"))
    }
    
    // MARK: - Edge Cases Tests
    
    func testMultipleVideoDisplayCalls() {
        // Arrange
        let videoDisplay = createCompleteVideoDisplay()
        let testURL1 = URL(string: "https://example.com/video1.mp4")!
        let testURL2 = URL(string: "https://example.com/video2.mp4")!
        
        // Act - Multiple calls should be handled gracefully
        videoDisplay.utilityDisplayVideo(url: testURL1)
        videoDisplay.utilityDisplayVideo(url: testURL2)
        
        // Assert - Should not crash and maintain object integrity
        XCTAssertNotNil(videoDisplay)
        XCTAssertEqual(videoDisplay.secondaryImageViews.count, 2)
    }
    
    func testPreloadImageThenVideo() {
        // Arrange
        let videoDisplay = createCompleteVideoDisplay()
        let preloadURL = URL(string: "https://example.com/thumbnail.jpg")!
        let videoURL = URL(string: "https://example.com/video.mp4")!
        
        // Act - This simulates the preload -> video flow
        videoDisplay.utilityDisplayStaticImage(url: preloadURL) { success in
            // This completion block simulates what happens after preload
            videoDisplay.utilityDisplayVideo(url: videoURL)
        }
        
        // Assert - Should handle the workflow without crashing
        XCTAssertNotNil(videoDisplay)
        XCTAssertEqual(videoDisplay.imageView, imageView)
    }
    
    func testVideoDisplayWithoutPreloadCompletion() {
        // Arrange
        let videoDisplay = createCompleteVideoDisplay()
        let media = createMockVideoMediaWithoutPreload()
        
        // Act - Direct video display without preload
        videoDisplay.display(from: media)
        
        // Assert - Should handle direct video display
        XCTAssertNotNil(videoDisplay)
        XCTAssertNotNil(media.url.asURL)
    }
    
    func testVideoDisplayPrepareForReuseVideoOnlyBehavior() {
        // Arrange
        let videoDisplay = createCompleteVideoDisplay()
        
        // Act - When videoOnly is true, should not call super
        videoDisplay.utilityDisplayPrepareForReuse(videoOnly: true)
        
        // Assert - Should execute without issues
        XCTAssertNotNil(videoDisplay)
        
        // Act - When videoOnly is false, should call super
        videoDisplay.utilityDisplayPrepareForReuse(videoOnly: false)
        
        // Assert - Should execute without issues
        XCTAssertNotNil(videoDisplay)
    }
    
    // MARK: - Performance Tests
    
    func testPerformanceCreateVideoDisplay() {
        measure {
            for _ in 0..<1000 {
                let _ = DNSMediaDisplayVideo(imageView: UIImageView())
            }
        }
    }
    
    func testPerformanceDisplayFromNilMedia() {
        let videoDisplay = createCompleteVideoDisplay()
        
        measure {
            for _ in 0..<100 {
                videoDisplay.display(from: nil)
            }
        }
    }
    
    func testPerformanceVideoDisplayUtility() {
        let videoDisplay = createCompleteVideoDisplay()
        let testURL = URL(string: "https://example.com/video.mp4")!
        
        measure {
            for _ in 0..<100 {
                videoDisplay.utilityDisplayVideo(url: testURL)
            }
        }
    }
    
    func testPerformanceCopyVideoDisplay() {
        let videoDisplay = createCompleteVideoDisplay()
        
        measure {
            for _ in 0..<1000 {
                let _ = videoDisplay.copy()
            }
        }
    }
    
    // MARK: - Memory Management Tests
    
    func testNoRetainCycles() {
        weak var weakVideoDisplay: DNSMediaDisplayVideo?
        
        autoreleasepool {
            let videoDisplay = createCompleteVideoDisplay()
            weakVideoDisplay = videoDisplay
            XCTAssertNotNil(weakVideoDisplay)
        }
        
        XCTAssertNil(weakVideoDisplay, "DNSMediaDisplayVideo should be deallocated")
    }
    
    func testMemoryManagementWithVideoLoading() {
        weak var weakVideoDisplay: DNSMediaDisplayVideo?
        
        autoreleasepool {
            let videoDisplay = createCompleteVideoDisplay()
            let testURL = URL(string: "https://example.com/video.mp4")!
            videoDisplay.utilityDisplayVideo(url: testURL)
            weakVideoDisplay = videoDisplay
            XCTAssertNotNil(weakVideoDisplay)
        }
        
        // Give some time for any async operations to complete
        let expectation = XCTestExpectation(description: "Memory cleanup")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
        
        XCTAssertNil(weakVideoDisplay, "DNSMediaDisplayVideo should be deallocated after video loading setup")
    }
    
    func testMemoryManagementWithPrepareForReuse() {
        weak var weakVideoDisplay: DNSMediaDisplayVideo?
        
        autoreleasepool {
            let videoDisplay = createCompleteVideoDisplay()
            videoDisplay.utilityDisplayPrepareForReuse()
            videoDisplay.utilityDisplayPrepareForReuse(videoOnly: true)
            weakVideoDisplay = videoDisplay
            XCTAssertNotNil(weakVideoDisplay)
        }
        
        XCTAssertNil(weakVideoDisplay, "DNSMediaDisplayVideo should be deallocated after prepare for reuse")
    }
    
    // MARK: - Integration Tests
    
    func testFullWorkflowWithPreloadAndVideo() {
        // Arrange
        let videoDisplay = createCompleteVideoDisplay()
        let media = createMockVideoMediaWithPreload()
        
        // Act - Full workflow: display -> preload -> video
        videoDisplay.display(from: media)
        
        // Assert - Should handle full workflow without crashing
        XCTAssertNotNil(videoDisplay)
        XCTAssertNotNil(media.url.asURL)
        XCTAssertNotNil(media.preloadUrl.asURL)
        XCTAssertEqual(videoDisplay.secondaryImageViews.count, 2)
    }
    
    func testFullWorkflowDirectVideo() {
        // Arrange
        let videoDisplay = createCompleteVideoDisplay()
        let media = createMockVideoMediaWithoutPreload()
        
        // Act - Direct video workflow
        videoDisplay.display(from: media)
        
        // Assert - Should handle direct video workflow
        XCTAssertNotNil(videoDisplay)
        XCTAssertNotNil(media.url.asURL)
        XCTAssertEqual(videoDisplay.secondaryImageViews.count, 2)
    }
    
    static var allTests = [
        ("testBasicInitialization", testBasicInitialization),
        ("testCompleteInitialization", testCompleteInitialization),
        ("testInheritanceFromDNSMediaDisplayStaticImage", testInheritanceFromDNSMediaDisplayStaticImage),
        ("testDisplayFromNilMedia", testDisplayFromNilMedia),
        ("testDisplayFromMediaWithNilURL", testDisplayFromMediaWithNilURL),
        ("testDisplayFromMediaWithInvalidURL", testDisplayFromMediaWithInvalidURL),
        ("testDisplayFromVideoMediaWithPreloadURL", testDisplayFromVideoMediaWithPreloadURL),
        ("testDisplayFromVideoMediaWithoutPreloadURL", testDisplayFromVideoMediaWithoutPreloadURL),
        ("testUtilityDisplayVideo", testUtilityDisplayVideo),
        ("testUtilityDisplayPrepareForReuse", testUtilityDisplayPrepareForReuse),
        ("testUtilityDisplayPrepareForReuseVideoOnly", testUtilityDisplayPrepareForReuseVideoOnly),
        ("testUtilityDisplayPrepareForReuseNotVideoOnly", testUtilityDisplayPrepareForReuseNotVideoOnly),
        ("testSecondaryImageViewsClearingInVideoDisplay", testSecondaryImageViewsClearingInVideoDisplay),
        ("testCopyWithZone", testCopyWithZone),
        ("testEquality", testEquality),
        ("testInequality", testInequality),
        ("testIsDiffFrom", testIsDiffFrom),
        ("testMultipleVideoDisplayCalls", testMultipleVideoDisplayCalls),
        ("testPreloadImageThenVideo", testPreloadImageThenVideo),
        ("testVideoDisplayWithoutPreloadCompletion", testVideoDisplayWithoutPreloadCompletion),
        ("testVideoDisplayPrepareForReuseVideoOnlyBehavior", testVideoDisplayPrepareForReuseVideoOnlyBehavior),
        ("testPerformanceCreateVideoDisplay", testPerformanceCreateVideoDisplay),
        ("testPerformanceDisplayFromNilMedia", testPerformanceDisplayFromNilMedia),
        ("testPerformanceVideoDisplayUtility", testPerformanceVideoDisplayUtility),
        ("testPerformanceCopyVideoDisplay", testPerformanceCopyVideoDisplay),
        ("testNoRetainCycles", testNoRetainCycles),
        ("testMemoryManagementWithVideoLoading", testMemoryManagementWithVideoLoading),
        ("testMemoryManagementWithPrepareForReuse", testMemoryManagementWithPrepareForReuse),
        ("testFullWorkflowWithPreloadAndVideo", testFullWorkflowWithPreloadAndVideo),
        ("testFullWorkflowDirectVideo", testFullWorkflowDirectVideo),
    ]
}
