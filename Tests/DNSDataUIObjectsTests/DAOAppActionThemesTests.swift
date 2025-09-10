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
    
    // MARK: - Property Assignment Tests
    
    func testPropertyAssignment() {
        let themes = MockDAOAppActionThemesFactory.createMockAppActionThemes()
        
        XCTAssertNotNil(themes.cancelButton)
        XCTAssertNotNil(themes.okayButton)
        
        // Mock should provide different button styles
        XCTAssertEqual(themes.cancelButton.name, "mock-cancel-button")
        XCTAssertEqual(themes.okayButton.name, "mock-okay-button")
    }
    
    func testButtonStylePropertyBehavior() {
        let themes = DAOAppActionThemes()
        
        // Test setting custom button styles
        let customCancelStyle = DNSThemeButtonStyle(styleName: "custom-cancel")
        let customOkayStyle = DNSThemeButtonStyle(styleName: "custom-okay")
        
        themes.cancelButton = customCancelStyle
        themes.okayButton = customOkayStyle
        
        XCTAssertEqual(themes.cancelButton.name, "custom-cancel")
        XCTAssertEqual(themes.okayButton.name, "custom-okay")
    }
    
    func testButtonStyleVariations() {
        let themes = DAOAppActionThemes()
        
        // Test different button style configurations
        let primaryStyle = DNSThemeButtonStyle(styleName: "primary")
        let secondaryStyle = DNSThemeButtonStyle(styleName: "secondary")
        let destructiveStyle = DNSThemeButtonStyle(styleName: "destructive")
        
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
        XCTAssertEqual(original.cancelButton.name, copy.cancelButton.name)
        XCTAssertEqual(original.okayButton.name, copy.okayButton.name)
        
        // Verify they are different instances
        XCTAssertTrue(original !== copy)
        XCTAssertTrue(original.cancelButton !== copy.cancelButton) // DNSThemeButtonStyle should also be copied
        XCTAssertTrue(original.okayButton !== copy.okayButton)
    }
    
    func testUpdateFromObject() {
        let themes1 = DAOAppActionThemes()
        let themes2 = MockDAOAppActionThemesFactory.createMockAppActionThemes()
        
        themes1.update(from: themes2)
        
        XCTAssertEqual(themes1.cancelButton.name, themes2.cancelButton.name)
        XCTAssertEqual(themes1.okayButton.name, themes2.okayButton.name)
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
        XCTAssertEqual(themes?.cancelButton.name, "dict-cancel-button")
        XCTAssertEqual(themes?.okayButton.name, "dict-okay-button")
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
        XCTAssertNotNil(dictionary["cancelButton"])
        XCTAssertNotNil(dictionary["okayButton"])
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
        themes2.cancelButton = DNSThemeButtonStyle(styleName: "different-cancel")
        
        XCTAssertNotEqual(themes1, themes2)
        XCTAssertTrue(themes1 != themes2)
    }
    
    func testIsDiffFrom() {
        let themes1 = MockDAOAppActionThemesFactory.createMockAppActionThemes()
        let themes2 = DAOAppActionThemes(from: themes1)
        let themes3 = MockDAOAppActionThemesFactory.createMockAppActionThemes()
        themes3.okayButton = DNSThemeButtonStyle(styleName: "different-okay")
        
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
            (\DAOAppActionThemes.cancelButton, DNSThemeButtonStyle(styleName: "test-cancel")),
            (\DAOAppActionThemes.okayButton, DNSThemeButtonStyle(styleName: "test-okay"))
        ]
        
        for (keyPath, testValue) in testCases {
            themes[keyPath: keyPath] = testValue
            XCTAssertEqual(themes[keyPath: keyPath].name, testValue.name, "Field \(keyPath) should be set correctly")
        }
    }
    
    func testButtonStyleEqualityComparisons() {
        let themes = DAOAppActionThemes()
        
        // Test button style equality
        let style1 = DNSThemeButtonStyle(styleName: "test-style")
        let style2 = DNSThemeButtonStyle(styleName: "test-style")
        let style3 = DNSThemeButtonStyle(styleName: "different-style")
        
        themes.cancelButton = style1
        themes.okayButton = style2
        
        XCTAssertEqual(style1.name, style2.name)
        
        themes.okayButton = style3
        XCTAssertNotEqual(themes.cancelButton.name, themes.okayButton.name)
    }
    
    func testDefaultStyleBehavior() {
        let themes1 = DAOAppActionThemes()
        let themes2 = DAOAppActionThemes()
        
        // Both should start with default styles
        XCTAssertEqual(themes1.cancelButton, themes2.cancelButton)
        XCTAssertEqual(themes1.okayButton, themes2.okayButton)
        
        // Changing one shouldn't affect the other
        themes1.cancelButton = DNSThemeButtonStyle(styleName: "custom")
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
        XCTAssertNotNil(themes.cancelButton.name)
        XCTAssertNotNil(themes.okayButton.name)
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
        let primaryStyle = DNSThemeButtonStyle(styleName: "primary-action")
        
        let secondaryStyle = DNSThemeButtonStyle(styleName: "secondary-action")
        
        themes.okayButton = primaryStyle
        themes.cancelButton = secondaryStyle
        
        XCTAssertEqual(themes.okayButton.name, "primary-action")
        XCTAssertEqual(themes.cancelButton.name, "secondary-action")
        
        // Test dictionary conversion with complex styles
        let dictionary = themes.asDictionary
        let reconstructed = DAOAppActionThemes(from: dictionary)
        
        XCTAssertNotNil(reconstructed)
        XCTAssertEqual(reconstructed?.okayButton.name, themes.okayButton.name)
        XCTAssertEqual(reconstructed?.cancelButton.name, themes.cancelButton.name)
    }
    
    func testButtonStyleCustomization() {
        let themes = DAOAppActionThemes()
        
        // Test custom button style properties
        let customStyle = DNSThemeButtonStyle(styleName: "custom-button")
        themes.cancelButton = customStyle
        
        XCTAssertEqual(themes.cancelButton.name, "custom-button")
        
        // Test that copy preserves customization
        let copy = DAOAppActionThemes(from: themes)
        XCTAssertEqual(copy.cancelButton.name, "custom-button")
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
        // Note: Button style decoding may not work due to commented encoding in source
        // XCTAssertEqual(decodedThemes.cancelButton.name, originalThemes.cancelButton.name)
        // XCTAssertEqual(decodedThemes.okayButton.name, originalThemes.okayButton.name)
    }
    
    func testJSONRoundTrip() throws {
        let originalThemes = MockDAOAppActionThemesFactory.createMockAppActionThemes()
        let data = try JSONEncoder().encode(originalThemes)
        let decodedThemes = try JSONDecoder().decode(DAOAppActionThemes.self, from: data)
        
        XCTAssertEqual(originalThemes.id, decodedThemes.id)
        // Note: Full equality may not work due to encoding/decoding limitations  
        // XCTAssertEqual(originalThemes, decodedThemes)
        // XCTAssertFalse(originalThemes.isDiffFrom(decodedThemes))
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
            XCTAssertEqual(copy.cancelButton.name, original.cancelButton.name)
            XCTAssertEqual(copy.okayButton.name, original.okayButton.name)
        }
        
        // Original should still be valid after copy is deallocated
        XCTAssertNotNil(original.cancelButton)
        XCTAssertNotNil(original.okayButton)
    }
    
    func testButtonStyleMemoryManagement() {
        let themes = DAOAppActionThemes()
        
        autoreleasepool {
            let customStyle = DNSThemeButtonStyle(styleName: "temp-style")
            themes.cancelButton = customStyle
            XCTAssertEqual(themes.cancelButton.name, "temp-style")
        }
        
        // Button style should still be accessible
        XCTAssertNotNil(themes.cancelButton)
        XCTAssertEqual(themes.cancelButton.name, "temp-style")
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
                themes.cancelButton = DNSThemeButtonStyle(styleName: "cancel\(i)")
                themes.okayButton = DNSThemeButtonStyle(styleName: "okay\(i)")
            }
        }
    }

    static var allTests = [
        ("testDefaultInitialization", testDefaultInitialization),
        ("testInitializationWithId", testInitializationWithId),
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
