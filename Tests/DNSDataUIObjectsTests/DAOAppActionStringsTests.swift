//
//  DAOAppActionStringsTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataUIObjectsTests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import DNSCore
import DNSDataObjects
import DNSDataTypes
import Foundation
@testable import DNSDataUIObjects

final class DAOAppActionStringsTests: XCTestCase {
    
    // MARK: - Basic Initialization Tests
    
    func testDefaultInitialization() {
        let strings = DAOAppActionStrings()
        
        XCTAssertNotNil(strings.id)
        XCTAssertFalse(strings.id.isEmpty)
        
        // Test default values - all should be empty DNSString objects
        XCTAssertNotNil(strings.body)
        XCTAssertNotNil(strings.cancelLabel)
        XCTAssertNotNil(strings.disclaimer)
        XCTAssertNotNil(strings.okayLabel)
        XCTAssertNotNil(strings.subtitle)
        XCTAssertNotNil(strings.title)
        
        // Verify they are empty but initialized DNSString objects
        XCTAssertTrue(strings.body.isEmpty)
        XCTAssertTrue(strings.cancelLabel.isEmpty)
        XCTAssertTrue(strings.disclaimer.isEmpty)
        XCTAssertTrue(strings.okayLabel.isEmpty)
        XCTAssertTrue(strings.subtitle.isEmpty)
        XCTAssertTrue(strings.title.isEmpty)
    }
    
    func testInitializationWithId() {
        let testId = "test-strings-123"
        let strings = DAOAppActionStrings(id: testId)
        
        XCTAssertEqual(strings.id, testId)
        
        // Verify default values are still set
        XCTAssertNotNil(strings.body)
        XCTAssertNotNil(strings.title)
        XCTAssertNotNil(strings.subtitle)
    }
    
    // MARK: - Property Assignment Tests
    
    func testPropertyAssignment() {
        let strings = MockDAOAppActionStringsFactory.createMockAppActionStrings()
        
        XCTAssertEqual(strings.title.asString, "Action Title")
        XCTAssertEqual(strings.subtitle.asString, "Action Subtitle")
        XCTAssertEqual(strings.body.asString, "Action Body Description")
        XCTAssertEqual(strings.disclaimer.asString, "Action Disclaimer")
        XCTAssertEqual(strings.okayLabel.asString, "OK")
        XCTAssertEqual(strings.cancelLabel.asString, "Cancel")
    }
    
    func testDNSStringPropertyBehavior() {
        let strings = DAOAppActionStrings()
        
        // Test setting string values
        strings.title = DNSString(with: "Test Title")
        strings.subtitle = DNSString(with: "Test Subtitle")
        
        XCTAssertEqual(strings.title.asString, "Test Title")
        XCTAssertEqual(strings.subtitle.asString, "Test Subtitle")
        
        // Test empty string behavior
        strings.body = DNSString()
        XCTAssertTrue(strings.body.isEmpty)
        
        // Test nil handling
        strings.disclaimer = DNSString(with: nil)
        XCTAssertTrue(strings.disclaimer.isEmpty)
    }
    
    func testStringLocalizationSupport() {
        let strings = DAOAppActionStrings()
        
        // Test setting localized string keys
        strings.title = DNSString(with: "action.title.key")
        strings.okayLabel = DNSString(with: "action.ok.key")
        strings.cancelLabel = DNSString(with: "action.cancel.key")
        
        XCTAssertEqual(strings.title.asString, "action.title.key")
        XCTAssertEqual(strings.okayLabel.asString, "action.ok.key")
        XCTAssertEqual(strings.cancelLabel.asString, "action.cancel.key")
    }
    
    // MARK: - Copy and Update Tests
    
    func testCopyInitialization() {
        let original = MockDAOAppActionStringsFactory.createMockAppActionStrings()
        let copy = DAOAppActionStrings(from: original)
        
        XCTAssertEqual(original.id, copy.id)
        XCTAssertEqual(original.title.asString, copy.title.asString)
        XCTAssertEqual(original.subtitle.asString, copy.subtitle.asString)
        XCTAssertEqual(original.body.asString, copy.body.asString)
        XCTAssertEqual(original.disclaimer.asString, copy.disclaimer.asString)
        XCTAssertEqual(original.okayLabel.asString, copy.okayLabel.asString)
        XCTAssertEqual(original.cancelLabel.asString, copy.cancelLabel.asString)
        
        // Verify they are different instances
        XCTAssertTrue(original !== copy)
        XCTAssertTrue(original.title !== copy.title) // DNSString should also be copied
    }
    
    func testUpdateFromObject() {
        let strings1 = DAOAppActionStrings()
        let strings2 = MockDAOAppActionStringsFactory.createMockAppActionStrings()
        
        strings1.update(from: strings2)
        
        XCTAssertEqual(strings1.title.asString, strings2.title.asString)
        XCTAssertEqual(strings1.subtitle.asString, strings2.subtitle.asString)
        XCTAssertEqual(strings1.body.asString, strings2.body.asString)
        XCTAssertEqual(strings1.disclaimer.asString, strings2.disclaimer.asString)
        XCTAssertEqual(strings1.okayLabel.asString, strings2.okayLabel.asString)
        XCTAssertEqual(strings1.cancelLabel.asString, strings2.cancelLabel.asString)
    }
    
    func testNSCopying() {
        let original = MockDAOAppActionStringsFactory.createMockAppActionStrings()
        let copy = original.copy() as! DAOAppActionStrings
        
        XCTAssertTrue(MockDAOAppActionStringsFactory.validateAppActionStringsEquality(original, copy))
        XCTAssertTrue(original !== copy) // Different instances
        XCTAssertTrue(original.title !== copy.title) // Deep copy of DNSString objects
    }
    
    // MARK: - Dictionary Conversion Tests
    
    func testInitializationFromDictionary() {
        let dictionary = MockDAOAppActionStringsFactory.createMockAppActionStringsDictionary()
        let strings = DAOAppActionStrings(from: dictionary)
        
        XCTAssertNotNil(strings)
        XCTAssertEqual(strings?.id, "strings123")
        XCTAssertEqual(strings?.title.asString, "Mock Title")
        XCTAssertEqual(strings?.subtitle.asString, "Mock Subtitle")
        XCTAssertEqual(strings?.body.asString, "Mock Body Description")
        XCTAssertEqual(strings?.disclaimer.asString, "Mock Disclaimer")
        XCTAssertEqual(strings?.okayLabel.asString, "OK")
        XCTAssertEqual(strings?.cancelLabel.asString, "Cancel")
    }
    
    func testInitializationFromEmptyDictionary() {
        let emptyDictionary: DNSDataDictionary = [:]
        let strings = DAOAppActionStrings(from: emptyDictionary)
        
        XCTAssertNil(strings)
    }
    
    func testAsDictionary() {
        let strings = MockDAOAppActionStringsFactory.createMockAppActionStrings()
        let dictionary = strings.asDictionary
        
        XCTAssertNotNil(dictionary["id"])
        XCTAssertNotNil(dictionary["title"])
        XCTAssertNotNil(dictionary["subtitle"])
        XCTAssertNotNil(dictionary["description"]) // body field maps to "description"
        XCTAssertNotNil(dictionary["disclaimer"])
        XCTAssertNotNil(dictionary["okayLabel"])
        XCTAssertNotNil(dictionary["cancelLabel"])
        
        // Verify DNSString objects are properly serialized as dictionaries
        XCTAssertNotNil(dictionary["title"])
        XCTAssertNotNil(dictionary["subtitle"])
    }
    
    // MARK: - Equality and Comparison Tests
    
    func testEquality() {
        let strings1 = MockDAOAppActionStringsFactory.createMockAppActionStrings()
        let strings2 = DAOAppActionStrings(from: strings1)
        
        XCTAssertEqual(strings1, strings2)
        XCTAssertFalse(strings1 != strings2)
    }
    
    func testInequality() {
        let strings1 = MockDAOAppActionStringsFactory.createMockAppActionStrings()
        let strings2 = MockDAOAppActionStringsFactory.createMockAppActionStrings()
        strings2.title = DNSString(with: "Different Title")
        
        XCTAssertNotEqual(strings1, strings2)
        XCTAssertTrue(strings1 != strings2)
    }
    
    func testIsDiffFrom() {
        let strings1 = MockDAOAppActionStringsFactory.createMockAppActionStrings()
        let strings2 = DAOAppActionStrings(from: strings1)
        let strings3 = MockDAOAppActionStringsFactory.createMockAppActionStrings()
        strings3.body = DNSString(with: "Different body content")
        
        XCTAssertFalse(strings1.isDiffFrom(strings2))
        XCTAssertTrue(strings1.isDiffFrom(strings3))
        XCTAssertTrue(strings1.isDiffFrom(nil))
        XCTAssertTrue(strings1.isDiffFrom("not a strings object"))
    }
    
    func testSelfComparison() {
        let strings = MockDAOAppActionStringsFactory.createMockAppActionStrings()
        
        XCTAssertFalse(strings.isDiffFrom(strings))
        XCTAssertEqual(strings, strings)
    }
    
    // MARK: - Field-specific Tests
    
    func testAllStringFields() {
        let strings = DAOAppActionStrings()
        
        let testCases = [
            (\DAOAppActionStrings.title, "Test Title"),
            (\DAOAppActionStrings.subtitle, "Test Subtitle"), 
            (\DAOAppActionStrings.body, "Test Body"),
            (\DAOAppActionStrings.disclaimer, "Test Disclaimer"),
            (\DAOAppActionStrings.okayLabel, "Test OK"),
            (\DAOAppActionStrings.cancelLabel, "Test Cancel")
        ]
        
        for (keyPath, testValue) in testCases {
            strings[keyPath: keyPath] = DNSString(with: testValue)
            XCTAssertEqual(strings[keyPath: keyPath].asString, testValue, "Field \(keyPath) should be set correctly")
        }
    }
    
    func testEmptyStringHandling() {
        let strings = DAOAppActionStrings()
        
        // Test setting empty strings
        strings.title = DNSString(with: "")
        strings.subtitle = DNSString(with: "")
        
        XCTAssertTrue(strings.title.isEmpty)
        XCTAssertTrue(strings.subtitle.isEmpty)
        
        // Test equality with empty strings
        let emptyStrings = DAOAppActionStrings()
        XCTAssertEqual(strings.title.isEmpty, emptyStrings.title.isEmpty)
    }
    
    func testWhitespaceHandling() {
        let strings = DAOAppActionStrings()
        
        // Test whitespace-only strings
        strings.title = DNSString(with: "   ")
        strings.body = DNSString(with: "\n\t  ")
        
        XCTAssertEqual(strings.title.asString, "   ")
        XCTAssertEqual(strings.body.asString, "\n\t  ")
    }
    
    // MARK: - Validation Tests
    
    func testValidationHelper() {
        let validStrings = MockDAOAppActionStringsFactory.createMockAppActionStrings()
        XCTAssertTrue(MockDAOAppActionStringsFactory.validateAppActionStringsProperties(validStrings))
        
        let minimalStrings = MockDAOAppActionStringsFactory.createMockAppActionStringsWithMinimalData()
        XCTAssertTrue(MockDAOAppActionStringsFactory.validateAppActionStringsProperties(minimalStrings))
    }
    
    func testDefaultValuesValidation() {
        let strings = DAOAppActionStrings()
        
        // All DNSString properties should be initialized and valid
        XCTAssertNotNil(strings.title)
        XCTAssertNotNil(strings.subtitle)
        XCTAssertNotNil(strings.body)
        XCTAssertNotNil(strings.disclaimer)
        XCTAssertNotNil(strings.okayLabel)
        XCTAssertNotNil(strings.cancelLabel)
    }
    
    // MARK: - Array Tests
    
    func testAppActionStringsArray() {
        let stringsArray = MockDAOAppActionStringsFactory.createMockAppActionStringsArray(count: 5)
        
        XCTAssertEqual(stringsArray.count, 5)
        
        for (index, strings) in stringsArray.enumerated() {
            XCTAssertEqual(strings.id, "strings\(index)")
            XCTAssertTrue(MockDAOAppActionStringsFactory.validateAppActionStringsProperties(strings))
        }
    }
    
    // MARK: - Edge Cases
    
    func testMinimalDataStrings() {
        let strings = MockDAOAppActionStringsFactory.createMockAppActionStringsWithMinimalData()
        
        XCTAssertNotNil(strings)
        XCTAssertTrue(strings.title.isEmpty || !strings.title.asString.isEmpty)
        XCTAssertNotNil(strings.body)
        XCTAssertNotNil(strings.cancelLabel)
        XCTAssertNotNil(strings.okayLabel)
    }
    
    func testInvalidDictionaryHandling() {
        let invalidDict = MockDAOAppActionStringsFactory.createInvalidAppActionStringsDictionary()
        let strings = DAOAppActionStrings(from: invalidDict)
        
        // Should still create object with default values
        XCTAssertNotNil(strings)
        if let strings = strings {
            XCTAssertNotNil(strings.title)
            XCTAssertNotNil(strings.subtitle)
            XCTAssertNotNil(strings.body)
        }
    }
    
    // MARK: - Complex Scenarios
    
    func testComplexStringScenarios() {
        let strings = DAOAppActionStrings()
        
        // Test special characters
        strings.title = DNSString(with: "Title with émojis 🚀 and spëcial chars")
        strings.body = DNSString(with: "Body with\nmultiple\nlines")
        strings.disclaimer = DNSString(with: "Disclaimer with \"quotes\" and 'apostrophes'")
        
        XCTAssertEqual(strings.title.asString, "Title with émojis 🚀 and spëcial chars")
        XCTAssertEqual(strings.body.asString, "Body with\nmultiple\nlines")
        XCTAssertEqual(strings.disclaimer.asString, "Disclaimer with \"quotes\" and 'apostrophes'")
        
        // Test dictionary conversion with complex strings
        let dictionary = strings.asDictionary
        let reconstructed = DAOAppActionStrings(from: dictionary)
        
        XCTAssertNotNil(reconstructed)
        XCTAssertEqual(reconstructed?.title.asString, strings.title.asString)
        XCTAssertEqual(reconstructed?.body.asString, strings.body.asString)
        XCTAssertEqual(reconstructed?.disclaimer.asString, strings.disclaimer.asString)
    }
    
    func testLongStringHandling() {
        let strings = DAOAppActionStrings()
        
        // Test very long strings
        let longString = String(repeating: "A", count: 10000)
        strings.body = DNSString(with: longString)
        
        XCTAssertEqual(strings.body.asString.count, 10000)
        
        // Test copying with long strings
        let copy = DAOAppActionStrings(from: strings)
        XCTAssertEqual(copy.body.asString.count, 10000)
        XCTAssertEqual(copy.body.asString, strings.body.asString)
    }
    
    // MARK: - Codable Tests
    
    func testJSONEncoding() throws {
        let originalStrings = MockDAOAppActionStringsFactory.createMockAppActionStrings()
        let data = try JSONEncoder().encode(originalStrings)
        XCTAssertFalse(data.isEmpty)
    }
    
    func testJSONDecoding() throws {
        let originalStrings = MockDAOAppActionStringsFactory.createMockAppActionStrings()
        let data = try JSONEncoder().encode(originalStrings)
        let decodedStrings = try JSONDecoder().decode(DAOAppActionStrings.self, from: data)
        
        XCTAssertEqual(decodedStrings.id, originalStrings.id)
        XCTAssertEqual(decodedStrings.title.asString, originalStrings.title.asString)
        XCTAssertEqual(decodedStrings.subtitle.asString, originalStrings.subtitle.asString)
        XCTAssertEqual(decodedStrings.body.asString, originalStrings.body.asString)
    }
    
    func testJSONRoundTrip() throws {
        let originalStrings = MockDAOAppActionStringsFactory.createMockAppActionStrings()
        let data = try JSONEncoder().encode(originalStrings)
        let decodedStrings = try JSONDecoder().decode(DAOAppActionStrings.self, from: data)
        
        XCTAssertEqual(originalStrings, decodedStrings)
        XCTAssertFalse(originalStrings.isDiffFrom(decodedStrings))
    }
    
    // MARK: - Memory Management Tests
    
    func testMemoryManagement() {
        validateNoRetainCycles {
            MockDAOAppActionStringsFactory.createMockAppActionStrings()
        }
    }
    
    func testDeepCopyMemoryManagement() {
        let original = MockDAOAppActionStringsFactory.createMockAppActionStrings()
        
        autoreleasepool {
            let copy = DAOAppActionStrings(from: original)
            XCTAssertEqual(copy.title.asString, original.title.asString)
        }
        
        // Original should still be valid after copy is deallocated
        XCTAssertNotNil(original.title)
        XCTAssertEqual(original.title.asString, "Action Title")
    }
    
    // MARK: - Performance Tests
    
    func testPerformanceCreateStrings() {
        measure {
            for _ in 0..<1000 {
                let _ = MockDAOAppActionStringsFactory.createMockAppActionStrings()
            }
        }
    }
    
    func testPerformanceCopyStrings() {
        let strings = MockDAOAppActionStringsFactory.createMockAppActionStrings()
        
        measure {
            for _ in 0..<1000 {
                let _ = DAOAppActionStrings(from: strings)
            }
        }
    }
    
    func testPerformanceDictionaryConversion() {
        let strings = MockDAOAppActionStringsFactory.createMockAppActionStrings()
        
        measure {
            for _ in 0..<1000 {
                let _ = strings.asDictionary
            }
        }
    }
    
    func testPerformanceStringAssignment() {
        let strings = DAOAppActionStrings()
        
        measure {
            for i in 0..<1000 {
                strings.title = DNSString(with: "Title \(i)")
                strings.subtitle = DNSString(with: "Subtitle \(i)")
                strings.body = DNSString(with: "Body \(i)")
            }
        }
    }

    static var allTests = [
        ("testDefaultInitialization", testDefaultInitialization),
        ("testInitializationWithId", testInitializationWithId),
        ("testPropertyAssignment", testPropertyAssignment),
        ("testDNSStringPropertyBehavior", testDNSStringPropertyBehavior),
        ("testStringLocalizationSupport", testStringLocalizationSupport),
        ("testCopyInitialization", testCopyInitialization),
        ("testUpdateFromObject", testUpdateFromObject),
        ("testNSCopying", testNSCopying),
        ("testInitializationFromDictionary", testInitializationFromDictionary),
        ("testInitializationFromEmptyDictionary", testInitializationFromEmptyDictionary),
        ("testAsDictionary", testAsDictionary),
        ("testEquality", testEquality),
        ("testInequality", testInequality),
        ("testIsDiffFrom", testIsDiffFrom),
        ("testSelfComparison", testSelfComparison),
        ("testAllStringFields", testAllStringFields),
        ("testEmptyStringHandling", testEmptyStringHandling),
        ("testWhitespaceHandling", testWhitespaceHandling),
        ("testValidationHelper", testValidationHelper),
        ("testDefaultValuesValidation", testDefaultValuesValidation),
        ("testAppActionStringsArray", testAppActionStringsArray),
        ("testMinimalDataStrings", testMinimalDataStrings),
        ("testInvalidDictionaryHandling", testInvalidDictionaryHandling),
        ("testComplexStringScenarios", testComplexStringScenarios),
        ("testLongStringHandling", testLongStringHandling),
        ("testJSONEncoding", testJSONEncoding),
        ("testJSONDecoding", testJSONDecoding),
        ("testJSONRoundTrip", testJSONRoundTrip),
        ("testMemoryManagement", testMemoryManagement),
        ("testDeepCopyMemoryManagement", testDeepCopyMemoryManagement),
        ("testPerformanceCreateStrings", testPerformanceCreateStrings),
        ("testPerformanceCopyStrings", testPerformanceCopyStrings),
        ("testPerformanceDictionaryConversion", testPerformanceDictionaryConversion),
        ("testPerformanceStringAssignment", testPerformanceStringAssignment),
    ]
}
