//
//  DAOAppActionThemesTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataUIObjectsTests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import DNSBaseTheme
import DNSCore
import DNSDataObjects
import DNSDataTypes
import Foundation
@testable import DNSDataUIObjects

final class DAOAppActionThemesTests: XCTestCase {
    
    // MARK: - Basic Initialization Tests
    
    func testDefaultInitialization() {
        let themes = DAOAppActionThemes()
        
        XCTAssertNotNil(themes.id)
        XCTAssertFalse(themes.id.isEmpty)
        
        // Test default values - should use default button styles
        XCTAssertNotNil(themes.cancelButton)
        XCTAssertNotNil(themes.okayButton)
        
        // Verify default styles are used
        XCTAssertEqual(themes.cancelButton, DAOAppActionThemes.defaultCancelButton)
        XCTAssertEqual(themes.okayButton, DAOAppActionThemes.defaultOkayButton)
    }
    
    func testInitializationWithId() {
        let testId = "test-themes-123"
        let themes = DAOAppActionThemes(id: testId)
        
        XCTAssertEqual(themes.id, testId)
        
        // Verify default values are still set
        XCTAssertNotNil(themes.cancelButton)
        XCTAssertNotNil(themes.okayButton)
        XCTAssertEqual(themes.cancelButton, DAOAppActionThemes.defaultCancelButton)
        XCTAssertEqual(themes.okayButton, DAOAppActionThemes.defaultOkayButton)
    }
    
    func testDefaultButtonStyles() {
        let themes = DAOAppActionThemes()
        
        // Test that default styles are DNSThemeButtonStyle.default
        XCTAssertEqual(DAOAppActionThemes.defaultCancelButton, DNSThemeButtonStyle.default)
        XCTAssertEqual(DAOAppActionThemes.defaultOkayButton, DNSThemeButtonStyle.default)
        
        // Test that instances use defaults
        XCTAssertEqual(themes.cancelButton, DNSThemeButtonStyle.default)
        XCTAssertEqual(themes.okayButton, DNSThemeButtonStyle.default)
    }
    
    // MARK: - Property Assignment Tests
    
    func testPropertyAssignment() {
        let themes = MockDAOAppActionThemesFactory.createMockAppActionThemes()
        
        XCTAssertNotNil(themes.cancelButton)
        XCTAssertNotNil(themes.okayButton)
        
        // Mock should provide different button styles
        XCTAssertEqual(themes.cancelButton.identifier, "mock-cancel-button")
        XCTAssertEqual(themes.okayButton.identifier, "mock-okay-button")
    }
    
    func testButtonStylePropertyBehavior() {
        let themes = DAOAppActionThemes()
        
        // Test setting custom button styles
        let customCancelStyle = DNSThemeButtonStyle(identifier: "custom-cancel")
        let customOkayStyle = DNSThemeButtonStyle(identifier: "custom-okay")
        
        themes.cancelButton = customCancelStyle
        themes.okayButton = customOkayStyle
        
        XCTAssertEqual(themes.cancelButton.identifier, "custom-cancel")
        XCTAssertEqual(themes.okayButton.identifier, "custom-okay")
    }
    
    func testButtonStyleVariations() {
        let themes = DAOAppActionThemes()
        
        // Test different button style configurations
        let primaryStyle = DNSThemeButtonStyle.primary
        let secondaryStyle = DNSThemeButtonStyle.secondary
        let destructiveStyle = DNSThemeButtonStyle.destructive
        
        themes.okayButton = primaryStyle
        themes.cancelButton = secondaryStyle
        
        XCTAssertEqual(themes.okayButton, primaryStyle)
        XCTAssertEqual(themes.cancelButton, secondaryStyle)
        
        // Test destructive style
        themes.cancelButton = destructiveStyle
        XCTAssertEqual(themes.cancelButton, destructiveStyle)
    }
    
    // MARK: - Copy and Update Tests
    
    func testCopyInitialization() {
        let original = MockDAOAppActionThemesFactory.createMockAppActionThemes()
        let copy = DAOAppActionThemes(from: original)
        
        XCTAssertEqual(original.id, copy.id)
        XCTAssertEqual(original.cancelButton.identifier, copy.cancelButton.identifier)
        XCTAssertEqual(original.okayButton.identifier, copy.okayButton.identifier)
        
        // Verify they are different instances
        XCTAssertTrue(original !== copy)
        XCTAssertTrue(original.cancelButton !== copy.cancelButton) // DNSThemeButtonStyle should also be copied
        XCTAssertTrue(original.okayButton !== copy.okayButton)
    }
    
    func testUpdateFromObject() {
        let themes1 = DAOAppActionThemes()
        let themes2 = MockDAOAppActionThemesFactory.createMockAppActionThemes()
        
        themes1.update(from: themes2)
        
        XCTAssertEqual(themes1.cancelButton.identifier, themes2.cancelButton.identifier)
        XCTAssertEqual(themes1.okayButton.identifier, themes2.okayButton.identifier)
    }
    
    func testNSCopying() {
        let original = MockDAOAppActionThemesFactory.createMockAppActionThemes()
        let copy = original.copy() as! DAOAppActionThemes
        
        XCTAssertTrue(MockDAOAppActionThemesFactory.validateAppActionThemesEquality(original, copy))
        XCTAssertTrue(original !== copy) // Different instances
        XCTAssertTrue(original.cancelButton !== copy.cancelButton) // Deep copy of button style objects
        XCTAssertTrue(original.okayButton !== copy.okayButton)
    }
    
    // MARK: - Dictionary Conversion Tests
    
    func testInitializationFromDictionary() {
        let dictionary = MockDAOAppActionThemesFactory.createMockAppActionThemesDictionary()
        let themes = DAOAppActionThemes(from: dictionary)
        
        XCTAssertNotNil(themes)
        XCTAssertEqual(themes?.id, "themes123")
        XCTAssertEqual(themes?.cancelButton.identifier, "dict-cancel-button")
        XCTAssertEqual(themes?.okayButton.identifier, "dict-okay-button")
    }
    
    func testInitializationFromEmptyDictionary() {
        let emptyDictionary: DNSDataDictionary = [:]
        let themes = DAOAppActionThemes(from: emptyDictionary)
        
        XCTAssertNil(themes)
    }
    
    func testAsDictionary() {
        let themes = MockDAOAppActionThemesFactory.createMockAppActionThemes()
        let dictionary = themes.asDictionary
        
        XCTAssertNotNil(dictionary["id"])
        XCTAssertNotNil(dictionary["cancelButton"])
        XCTAssertNotNil(dictionary["okayButton"])
        
        // Verify DNSThemeButtonStyle objects are properly serialized as dictionaries
        XCTAssertTrue(dictionary["cancelButton"] is DNSDataDictionary)
        XCTAssertTrue(dictionary["okayButton"] is DNSDataDictionary)
    }
    
    // MARK: - Equality and Comparison Tests
    
    func testEquality() {
        let themes1 = MockDAOAppActionThemesFactory.createMockAppActionThemes()
        let themes2 = DAOAppActionThemes(from: themes1)
        
        XCTAssertEqual(themes1, themes2)
        XCTAssertFalse(themes1 != themes2)
    }
    
    func testInequality() {
        let themes1 = MockDAOAppActionThemesFactory.createMockAppActionThemes()
        let themes2 = MockDAOAppActionThemesFactory.createMockAppActionThemes()
        themes2.cancelButton = DNSThemeButtonStyle(identifier: "different-cancel")
        
        XCTAssertNotEqual(themes1, themes2)
        XCTAssertTrue(themes1 != themes2)
    }
    
    func testIsDiffFrom() {
        let themes1 = MockDAOAppActionThemesFactory.createMockAppActionThemes()
        let themes2 = DAOAppActionThemes(from: themes1)
        let themes3 = MockDAOAppActionThemesFactory.createMockAppActionThemes()
        themes3.okayButton = DNSThemeButtonStyle(identifier: "different-okay")
        
        XCTAssertFalse(themes1.isDiffFrom(themes2))
        XCTAssertTrue(themes1.isDiffFrom(themes3))
        XCTAssertTrue(themes1.isDiffFrom(nil))
        XCTAssertTrue(themes1.isDiffFrom("not a themes object"))
    }
    
    func testSelfComparison() {
        let themes = MockDAOAppActionThemesFactory.createMockAppActionThemes()
        
        XCTAssertFalse(themes.isDiffFrom(themes))
        XCTAssertEqual(themes, themes)
    }
    
    // MARK: - Theme-specific Tests
    
    func testButtonStyleFields() {
        let themes = DAOAppActionThemes()
        
        let testCases = [
            (\DAOAppActionThemes.cancelButton, DNSThemeButtonStyle(identifier: "test-cancel")),
            (\DAOAppActionThemes.okayButton, DNSThemeButtonStyle(identifier: "test-okay"))
        ]
        
        for (keyPath, testValue) in testCases {
            themes[keyPath: keyPath] = testValue
            XCTAssertEqual(themes[keyPath: keyPath].identifier, testValue.identifier, "Field \(keyPath) should be set correctly")
        }
    }
    
    func testButtonStyleEqualityComparisons() {
        let themes = DAOAppActionThemes()
        
        // Test button style equality
        let style1 = DNSThemeButtonStyle(identifier: "test-style")
        let style2 = DNSThemeButtonStyle(identifier: "test-style")
        let style3 = DNSThemeButtonStyle(identifier: "different-style")
        
        themes.cancelButton = style1
        themes.okayButton = style2
        
        XCTAssertEqual(style1.identifier, style2.identifier)
        
        themes.okayButton = style3
        XCTAssertNotEqual(themes.cancelButton.identifier, themes.okayButton.identifier)
    }
    
    func testDefaultStyleBehavior() {
        let themes1 = DAOAppActionThemes()
        let themes2 = DAOAppActionThemes()
        
        // Both should start with default styles
        XCTAssertEqual(themes1.cancelButton, themes2.cancelButton)
        XCTAssertEqual(themes1.okayButton, themes2.okayButton)
        
        // Changing one shouldn't affect the other
        themes1.cancelButton = DNSThemeButtonStyle(identifier: "custom")
        XCTAssertNotEqual(themes1.cancelButton, themes2.cancelButton)
        XCTAssertEqual(themes2.cancelButton, DAOAppActionThemes.defaultCancelButton)
    }
    
    // MARK: - Validation Tests
    
    func testValidationHelper() {
        let validThemes = MockDAOAppActionThemesFactory.createMockAppActionThemes()
        XCTAssertTrue(MockDAOAppActionThemesFactory.validateAppActionThemesProperties(validThemes))
        
        let minimalThemes = MockDAOAppActionThemesFactory.createMockAppActionThemesWithMinimalData()
        XCTAssertTrue(MockDAOAppActionThemesFactory.validateAppActionThemesProperties(minimalThemes))
    }
    
    func testDefaultValuesValidation() {
        let themes = DAOAppActionThemes()
        
        // DNSThemeButtonStyle properties should be initialized
        XCTAssertNotNil(themes.cancelButton)
        XCTAssertNotNil(themes.okayButton)
        
        // Should be valid button styles
        XCTAssertNotNil(themes.cancelButton.identifier)
        XCTAssertNotNil(themes.okayButton.identifier)
    }
    
    // MARK: - Array Tests
    
    func testAppActionThemesArray() {
        let themesArray = MockDAOAppActionThemesFactory.createMockAppActionThemesArray(count: 5)
        
        XCTAssertEqual(themesArray.count, 5)
        
        for (index, themes) in themesArray.enumerated() {
            XCTAssertEqual(themes.id, "themes\(index)")
            XCTAssertTrue(MockDAOAppActionThemesFactory.validateAppActionThemesProperties(themes))
        }
    }
    
    // MARK: - Edge Cases
    
    func testMinimalDataThemes() {
        let themes = MockDAOAppActionThemesFactory.createMockAppActionThemesWithMinimalData()
        
        XCTAssertNotNil(themes)
        XCTAssertNotNil(themes.cancelButton)
        XCTAssertNotNil(themes.okayButton)
    }
    
    func testInvalidDictionaryHandling() {
        let invalidDict = MockDAOAppActionThemesFactory.createInvalidAppActionThemesDictionary()
        let themes = DAOAppActionThemes(from: invalidDict)
        
        // Should still create object with default values
        XCTAssertNotNil(themes)
        if let themes = themes {
            XCTAssertNotNil(themes.cancelButton)
            XCTAssertNotNil(themes.okayButton)
            // Should fall back to defaults
            XCTAssertEqual(themes.cancelButton, DAOAppActionThemes.defaultCancelButton)
            XCTAssertEqual(themes.okayButton, DAOAppActionThemes.defaultOkayButton)
        }
    }
    
    func testNilStyleHandling() {
        let themes = DAOAppActionThemes()
        
        // Test that styles are never nil (should always have defaults)
        XCTAssertNotNil(themes.cancelButton)
        XCTAssertNotNil(themes.okayButton)
        
        // Even after copying, styles should not be nil
        let copy = DAOAppActionThemes(from: themes)
        XCTAssertNotNil(copy.cancelButton)
        XCTAssertNotNil(copy.okayButton)
    }
    
    // MARK: - Complex Scenarios
    
    func testComplexButtonStyleScenarios() {
        let themes = DAOAppActionThemes()
        
        // Test comprehensive button style setup
        let primaryStyle = DNSThemeButtonStyle.primary
        primaryStyle.identifier = "primary-action"
        
        let secondaryStyle = DNSThemeButtonStyle.secondary
        secondaryStyle.identifier = "secondary-action"
        
        themes.okayButton = primaryStyle
        themes.cancelButton = secondaryStyle
        
        XCTAssertEqual(themes.okayButton.identifier, "primary-action")
        XCTAssertEqual(themes.cancelButton.identifier, "secondary-action")
        
        // Test dictionary conversion with complex styles
        let dictionary = themes.asDictionary
        let reconstructed = DAOAppActionThemes(from: dictionary)
        
        XCTAssertNotNil(reconstructed)
        XCTAssertEqual(reconstructed?.okayButton.identifier, themes.okayButton.identifier)
        XCTAssertEqual(reconstructed?.cancelButton.identifier, themes.cancelButton.identifier)
    }
    
    func testButtonStyleCustomization() {
        let themes = DAOAppActionThemes()
        
        // Test custom button style properties
        let customStyle = DNSThemeButtonStyle(identifier: "custom-button")
        themes.cancelButton = customStyle
        
        XCTAssertEqual(themes.cancelButton.identifier, "custom-button")
        
        // Test that copy preserves customization
        let copy = DAOAppActionThemes(from: themes)
        XCTAssertEqual(copy.cancelButton.identifier, "custom-button")
        XCTAssertTrue(copy.cancelButton !== themes.cancelButton) // Should be different instances
    }
    
    // MARK: - Codable Tests
    
    func testJSONEncoding() throws {
        let originalThemes = MockDAOAppActionThemesFactory.createMockAppActionThemes()
        let data = try JSONEncoder().encode(originalThemes)
        XCTAssertFalse(data.isEmpty)
    }
    
    func testJSONDecoding() throws {
        let originalThemes = MockDAOAppActionThemesFactory.createMockAppActionThemes()
        let data = try JSONEncoder().encode(originalThemes)
        let decodedThemes = try JSONDecoder().decode(DAOAppActionThemes.self, from: data)
        
        XCTAssertEqual(decodedThemes.id, originalThemes.id)
        XCTAssertEqual(decodedThemes.cancelButton.identifier, originalThemes.cancelButton.identifier)
        XCTAssertEqual(decodedThemes.okayButton.identifier, originalThemes.okayButton.identifier)
    }
    
    func testJSONRoundTrip() throws {
        let originalThemes = MockDAOAppActionThemesFactory.createMockAppActionThemes()
        let data = try JSONEncoder().encode(originalThemes)
        let decodedThemes = try JSONDecoder().decode(DAOAppActionThemes.self, from: data)
        
        XCTAssertEqual(originalThemes, decodedThemes)
        XCTAssertFalse(originalThemes.isDiffFrom(decodedThemes))
    }
    
    func testJSONEncodingWithDefaultStyles() throws {
        let themes = DAOAppActionThemes()
        
        let data = try JSONEncoder().encode(themes)
        XCTAssertFalse(data.isEmpty)
        
        let decoded = try JSONDecoder().decode(DAOAppActionThemes.self, from: data)
        XCTAssertEqual(decoded.cancelButton, DAOAppActionThemes.defaultCancelButton)
        XCTAssertEqual(decoded.okayButton, DAOAppActionThemes.defaultOkayButton)
    }
    
    // MARK: - Memory Management Tests
    
    func testMemoryManagement() {
        validateNoRetainCycles {
            MockDAOAppActionThemesFactory.createMockAppActionThemes()
        }
    }
    
    func testDeepCopyMemoryManagement() {
        let original = MockDAOAppActionThemesFactory.createMockAppActionThemes()
        
        autoreleasepool {
            let copy = DAOAppActionThemes(from: original)
            XCTAssertEqual(copy.cancelButton.identifier, original.cancelButton.identifier)
            XCTAssertEqual(copy.okayButton.identifier, original.okayButton.identifier)
        }
        
        // Original should still be valid after copy is deallocated
        XCTAssertNotNil(original.cancelButton)
        XCTAssertNotNil(original.okayButton)
    }
    
    func testButtonStyleMemoryManagement() {
        let themes = DAOAppActionThemes()
        
        autoreleasepool {
            let customStyle = DNSThemeButtonStyle(identifier: "temp-style")
            themes.cancelButton = customStyle
            XCTAssertEqual(themes.cancelButton.identifier, "temp-style")
        }
        
        // Button style should still be accessible
        XCTAssertNotNil(themes.cancelButton)
        XCTAssertEqual(themes.cancelButton.identifier, "temp-style")
    }
    
    // MARK: - Performance Tests
    
    func testPerformanceCreateThemes() {
        measure {
            for _ in 0..<1000 {
                let _ = MockDAOAppActionThemesFactory.createMockAppActionThemes()
            }
        }
    }
    
    func testPerformanceCopyThemes() {
        let themes = MockDAOAppActionThemesFactory.createMockAppActionThemes()
        
        measure {
            for _ in 0..<1000 {
                let _ = DAOAppActionThemes(from: themes)
            }
        }
    }
    
    func testPerformanceDictionaryConversion() {
        let themes = MockDAOAppActionThemesFactory.createMockAppActionThemes()
        
        measure {
            for _ in 0..<1000 {
                let _ = themes.asDictionary
            }
        }
    }
    
    func testPerformanceButtonStyleAssignment() {
        let themes = DAOAppActionThemes()
        
        measure {
            for i in 0..<1000 {
                themes.cancelButton = DNSThemeButtonStyle(identifier: "cancel\(i)")
                themes.okayButton = DNSThemeButtonStyle(identifier: "okay\(i)")
            }
        }
    }

    static var allTests = [
        ("testDefaultInitialization", testDefaultInitialization),
        ("testInitializationWithId", testInitializationWithId),
        ("testDefaultButtonStyles", testDefaultButtonStyles),
        ("testPropertyAssignment", testPropertyAssignment),
        ("testButtonStylePropertyBehavior", testButtonStylePropertyBehavior),
        ("testButtonStyleVariations", testButtonStyleVariations),
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
        ("testButtonStyleFields", testButtonStyleFields),
        ("testButtonStyleEqualityComparisons", testButtonStyleEqualityComparisons),
        ("testDefaultStyleBehavior", testDefaultStyleBehavior),
        ("testValidationHelper", testValidationHelper),
        ("testDefaultValuesValidation", testDefaultValuesValidation),
        ("testAppActionThemesArray", testAppActionThemesArray),
        ("testMinimalDataThemes", testMinimalDataThemes),
        ("testInvalidDictionaryHandling", testInvalidDictionaryHandling),
        ("testNilStyleHandling", testNilStyleHandling),
        ("testComplexButtonStyleScenarios", testComplexButtonStyleScenarios),
        ("testButtonStyleCustomization", testButtonStyleCustomization),
        ("testJSONEncoding", testJSONEncoding),
        ("testJSONDecoding", testJSONDecoding),
        ("testJSONRoundTrip", testJSONRoundTrip),
        ("testJSONEncodingWithDefaultStyles", testJSONEncodingWithDefaultStyles),
        ("testMemoryManagement", testMemoryManagement),
        ("testDeepCopyMemoryManagement", testDeepCopyMemoryManagement),
        ("testButtonStyleMemoryManagement", testButtonStyleMemoryManagement),
        ("testPerformanceCreateThemes", testPerformanceCreateThemes),
        ("testPerformanceCopyThemes", testPerformanceCopyThemes),
        ("testPerformanceDictionaryConversion", testPerformanceDictionaryConversion),
        ("testPerformanceButtonStyleAssignment", testPerformanceButtonStyleAssignment),
    ]
}
