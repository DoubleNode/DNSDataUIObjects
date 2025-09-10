//
//  DAOTestHelpers.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataUIObjectsTests
//
//  Created by Darren Ehlers.
//  Copyright (c) 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import UIKit
import DNSCore
import DNSDataObjects
import DNSDataTypes
import Foundation
@testable import DNSDataUIObjects

// MARK: - MockDAOFactory Protocol -
protocol MockDAOFactory {
    associatedtype DAOType: DAOBaseObject
    
    static func createMock() -> DAOType
    static func createMockWithTestData() -> DAOType
    static func createMockWithEdgeCases() -> DAOType
    static func createMockArray(count: Int) -> [DAOType]
}

// MARK: - Test Helper Utilities -
struct DAOTestHelpers {
    
    // MARK: - Mock Creation Methods -
    
    static func createMockDNSString(_ value: String = "Test String") -> DNSString {
        return DNSString(with: value)
    }
    
    static func createMockDNSURL(_ urlString: String = "https://example.com") -> DNSURL {
        return DNSURL(with: URL(string: urlString))
    }
    
    static func createMockDNSMetadata(status: String = "active") -> DNSMetadata {
        let metadata = [
            "uid": UUID(uuidString: "550e8400-e29b-41d4-a716-446655440000")!,
            "status": status,
            "created": Date(timeIntervalSinceReferenceDate: 1),
            "synced": Date(timeIntervalSinceReferenceDate: 2),
            "updated": Date(timeIntervalSinceReferenceDate: 3),
            "createdBy": "TestUser",
            "updatedBy": "TestUser",
            "views": 42
        ] as [String : Any]
        return DNSMetadata(from: metadata)
    }
    
    static func createMockAnalyticsData(title: String = "Test Analytics",
                                       subtitle: String = "Test Subtitle") -> DAOAnalyticsData {
        let analytics = DAOAnalyticsData()
        analytics.title = title
        analytics.subtitle = subtitle
        return analytics
    }
    
    static func createMockUIImageView() -> UIImageView {
        return UIImageView()
    }
    
    static func createMockUIProgressView() -> UIProgressView {
        return UIProgressView()
    }
    
    static func createMockUIImage() -> UIImage {
        return UIImage()
    }
    
    static func createMockDAOMedia(urlString: String = "https://example.com/media.jpg") -> DAOMedia {
        let media = DAOMedia()
        media.url = createMockDNSURL(urlString)
        return media
    }
    
    // MARK: - Validation Helper Methods -
    
    static func validateCodableRoundtrip<T: Codable>(_ object: T) throws {
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        let jsonData = try encoder.encode(object)
        let decodedObject = try decoder.decode(T.self, from: jsonData)
        
        // Note: We can't directly compare objects here without Equatable conformance
        // Individual tests should validate specific properties after round-trip
        XCTAssertNotNil(decodedObject, "Object should decode successfully")
    }
    
    static func validateDictionaryRoundtrip<T: DAOBaseObject>(_ object: T) {
        let dictionary = object.asDictionary
        XCTAssertNotNil(dictionary, "Object should convert to dictionary")
        XCTAssertFalse(dictionary.isEmpty, "Dictionary should not be empty")
        
        // Verify the dictionary contains expected base fields
        XCTAssertNotNil(dictionary["id"] as Any?, "Dictionary should contain id field")
        XCTAssertNotNil(dictionary["meta"] as Any?, "Dictionary should contain meta field")
    }
    
    static func validateDAOEquality<T: DAOBaseObject & Equatable>(_ lhs: T, _ rhs: T) {
        XCTAssertEqual(lhs, rhs, "Objects should be equal")
        XCTAssertFalse(lhs.isDiffFrom(rhs), "Objects should not be different")
    }
    
    static func validateIsDiffFrom<T: DAOBaseObject>(_ lhs: T, _ rhs: T) {
        XCTAssertTrue(lhs.isDiffFrom(rhs), "Objects should be different")
        XCTAssertNotEqual(lhs as? AnyHashable, rhs as? AnyHashable, "Objects should not be equal")
    }
    
    static func validateCopying<T: DAOBaseObject & NSCopying>(_ object: T) {
        let copy = object.copy() as! T
        XCTAssertEqual(object.id, copy.id, "Copy should have same ID")
        XCTAssertFalse(object === copy, "Copy should be different instance")
        XCTAssertFalse(object.isDiffFrom(copy), "Copy should be equal to original")
    }
    
    static func validateNoMemoryLeaks<T>(_ createObject: () -> T) {
        weak var weakRef: AnyObject?
        
        autoreleasepool {
            let object = createObject() as AnyObject
            weakRef = object
            XCTAssertNotNil(weakRef, "Object should exist")
        }
        
        // Give some time for cleanup
        let expectation = XCTestExpectation(description: "Memory cleanup")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertNil(weakRef, "Object should be deallocated after autoreleasepool")
            expectation.fulfill()
        }
        _ = XCTWaiter.wait(for: [expectation], timeout: 1.0)
    }
    
    static func validateErrorHandling<T>(_ createObject: () throws -> T) {
        do {
            let object = try createObject()
            XCTAssertNotNil(object, "Object should be created successfully")
        } catch {
            XCTFail("Object creation should not throw error: \(error)")
        }
    }
    
    // MARK: - Mock Dictionary Creation -
    
    static func createMockBaseObjectDictionary(id: String? = nil) -> DNSDataDictionary {
        let testId = id ?? UUID().uuidString
        return [
            "id": testId,
            "meta": createMockMetadataDictionary(),
            "analyticsData": []
        ]
    }
    
    static func createMockMetadataDictionary() -> DNSDataDictionary {
        return [
            "uid": UUID(uuidString: "550e8400-e29b-41d4-a716-446655440000")!,
            "status": "active",
            "created": Date(timeIntervalSinceReferenceDate: 1),
            "synced": Date(timeIntervalSinceReferenceDate: 2),
            "updated": Date(timeIntervalSinceReferenceDate: 3),
            "createdBy": "TestUser",
            "updatedBy": "TestUser",
            "views": 42,
            "genericValues": [:],
            "reactions": [:],
            "reactionCounts": [:]
        ]
    }
    
    static func createMockAppActionDictionary(id: String = "testaction123") -> DNSDataDictionary {
        var baseDict = createMockBaseObjectDictionary(id: id)
        baseDict.merge([
            "actionType": DNSAppActionType.popup.rawValue,
            "deepLink": "https://example.com/action",
            "images": createMockAppActionImagesDictionary(),
            "strings": createMockAppActionStringsDictionary(),
            "themes": createMockAppActionThemesDictionary()
        ]) { (current, _) in current }
        return baseDict
    }
    
    static func createMockAppActionImagesDictionary() -> DNSDataDictionary {
        var baseDict = createMockBaseObjectDictionary(id: "images123")
        baseDict.merge([
            "top": DNSURL(with: URL(string: "https://example.com/mock-top.jpg"))
        ]) { (current, _) in current }
        return baseDict
    }
    
    static func createMockAppActionStringsDictionary() -> DNSDataDictionary {
        var baseDict = createMockBaseObjectDictionary(id: "strings123")
        baseDict.merge([
            "title": ["value": "Mock Title"],
            "subtitle": ["value": "Mock Subtitle"],
            "description": ["value": "Mock Body Description"],
            "disclaimer": ["value": "Mock Disclaimer"],
            "okayLabel": ["value": "OK"],
            "cancelLabel": ["value": "Cancel"]
        ]) { (current, _) in current }
        return baseDict
    }
    
    static func createMockAppActionThemesDictionary() -> DNSDataDictionary {
        var baseDict = createMockBaseObjectDictionary(id: "themes123")
        
        let cancelButtonDict: DNSDataDictionary = [
            "name": "dict-cancel-button"
        ]
        
        let okayButtonDict: DNSDataDictionary = [
            "name": "dict-okay-button"
        ]
        
        baseDict.merge([
            "cancelButton": cancelButtonDict,
            "okayButton": okayButtonDict
        ]) { (current, _) in current }
        return baseDict
    }
    
    static func createMockPromotionDictionary(id: String = "promotion123") -> DNSDataDictionary {
        return createMockBaseObjectDictionary(id: id)
    }
    
    // MARK: - Performance Testing Helpers -
    
    static func measureObjectCreationPerformance<T>(_ createObject: () -> T, 
                                                   iterations: Int = 1000) -> TimeInterval {
        let startTime = CFAbsoluteTimeGetCurrent()
        
        for _ in 0..<iterations {
            _ = createObject()
        }
        
        let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
        return timeElapsed
    }
    
    static func measureCopyingPerformance<T: NSCopying>(_ object: T, 
                                                       iterations: Int = 1000) -> TimeInterval {
        let startTime = CFAbsoluteTimeGetCurrent()
        
        for _ in 0..<iterations {
            _ = object.copy()
        }
        
        let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
        return timeElapsed
    }
}

// MARK: - XCTestCase Extensions -
extension XCTestCase {
    
    func validateDAOBaseFunctionality<T: DAOBaseObject>(_ object: T) {
        // Test basic properties
        XCTAssertFalse(object.id.isEmpty, "DAO should have non-empty ID")
        XCTAssertNotNil(object.meta, "DAO should have metadata")
        XCTAssertNotNil(object.analyticsData, "DAO should have analytics data array")
        
        // Test NSCopying
        let copy = object.copy() as? T
        XCTAssertNotNil(copy, "DAO should be copyable")
        XCTAssertEqual(object.id, copy?.id, "Copy should have same ID")
        XCTAssertFalse(object === copy, "Copy should be different object instance")
        
        // Test dictionary conversion
        DAOTestHelpers.validateDictionaryRoundtrip(object)
    }
    
    func validateCodableFunctionality<T: Codable>(_ object: T) {
        do {
            try DAOTestHelpers.validateCodableRoundtrip(object)
        } catch {
            XCTFail("Codable round-trip failed: \(error)")
        }
    }
    
    func validateMediaDisplayFunctionality(_ display: DNSMediaDisplay) {
        // Test basic functionality
        XCTAssertNotNil(display.imageView, "Media display should have image view")
        
        // Test copying
        let copy = display.copy() as! DNSMediaDisplay
        XCTAssertNotNil(copy, "Media display should be copyable")
        XCTAssertTrue(copy !== display, "Copy should be different instance")
        
        // Test display method
        let media = DAOTestHelpers.createMockDAOMedia()
        display.display(from: media) // Should not crash
        display.display(from: nil) // Should handle nil gracefully
    }
    
    func measurePerformance<T>(of operation: () -> T, description: String = "Performance test") {
        measure {
            _ = operation()
        }
    }
    
    func validateNoRetainCycles<T: AnyObject>(_ createObject: () -> T) {
        weak var weakObject: T?
        autoreleasepool {
            let object = createObject()
            weakObject = object
            XCTAssertNotNil(weakObject, "Object should exist")
        }
        
        let expectation = XCTestExpectation(description: "Memory cleanup")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertNil(weakObject, "Object should be deallocated")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func validateThreadSafety<T>(_ object: T, operation: @escaping (T) -> Void) {
        let expectation = XCTestExpectation(description: "Thread safety test")
        expectation.expectedFulfillmentCount = 10
        
        DispatchQueue.concurrentPerform(iterations: 10) { _ in
            operation(object)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
}

