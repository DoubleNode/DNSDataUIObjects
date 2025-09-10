//
//  DAOAppActionTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataUIObjectsTests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import DNSCore
import DNSDataTypes
import Foundation
@testable import DNSDataUIObjects

final class DAOAppActionTests: XCTestCase {
    
    // MARK: - Basic Initialization Tests
    
    func testDefaultInitialization() {
        let appAction = DAOAppAction()
        
        XCTAssertNotNil(appAction.id)
        XCTAssertFalse(appAction.id.isEmpty)
        
        // Test default values
        XCTAssertEqual(appAction.actionType, .popup)
        XCTAssertNil(appAction.deepLink)
        
        // Test dependent objects are initialized
        XCTAssertNotNil(appAction.images)
        XCTAssertNotNil(appAction.strings)
        XCTAssertNotNil(appAction.themes)
    }
    
    func testInitializationWithId() {
        let testId = "test-appaction-123"
        let appAction = DAOAppAction(id: testId)
        
        XCTAssertEqual(appAction.id, testId)
        
        // Verify default values are still set
        XCTAssertEqual(appAction.actionType, .popup)
        XCTAssertNotNil(appAction.images)
        XCTAssertNotNil(appAction.strings)
        XCTAssertNotNil(appAction.themes)
    }
    
    // MARK: - Property Assignment Tests
    
    func testPropertyAssignment() {
        let appAction = MockDAOAppActionFactory.createMockAppAction()
        
        XCTAssertEqual(appAction.actionType, .popup)
        XCTAssertEqual(appAction.deepLink?.absoluteString, "https://example.com/action")
        
        // Test dependent objects
        XCTAssertNotNil(appAction.images)
        XCTAssertNotNil(appAction.strings)
        XCTAssertNotNil(appAction.themes)
    }
    
    func testActionTypeEnumValues() {
        let appActions = MockDAOAppActionFactory.createMockAppActionWithAllActionTypes()
        
        XCTAssertEqual(appActions.count, 4)
        
        let actionTypes = appActions.map { $0.actionType }
        XCTAssertTrue(actionTypes.contains(.drawer))
        XCTAssertTrue(actionTypes.contains(.fullScreen))
        XCTAssertTrue(actionTypes.contains(.popup))
        XCTAssertTrue(actionTypes.contains(.stage))
    }
    
    func testDeepLinkHandling() {
        let appActions = MockDAOAppActionFactory.createMockAppActionWithComplexDeepLinks()
        
        for appAction in appActions {
            XCTAssertEqual(appAction.actionType, .fullScreen)
            XCTAssertNotNil(appAction.deepLink)
            XCTAssertTrue(appAction.hasDeepLink)
            XCTAssertTrue(appAction.requiresExternalNavigation)
        }
        
        // Test specific URLs
        let urlStrings = appActions.compactMap { $0.deepLink?.absoluteString }
        XCTAssertTrue(urlStrings.contains("https://example.com/product/123"))
        XCTAssertTrue(urlStrings.contains("myapp://profile/user123"))
        XCTAssertTrue(urlStrings.contains("mailto:support@example.com"))
    }
    
    // MARK: - Copy and Update Tests
    
    func testCopyInitialization() {
        let original = MockDAOAppActionFactory.createMockAppAction()
        let copy = DAOAppAction(from: original)
        
        XCTAssertEqual(original.id, copy.id)
        XCTAssertEqual(original.actionType, copy.actionType)
        XCTAssertEqual(original.deepLink, copy.deepLink)
        
        // Verify they are different instances
        XCTAssertTrue(original !== copy)
    }
    
    func testUpdateFromObject() {
        let appAction1 = DAOAppAction()
        let appAction2 = MockDAOAppActionFactory.createMockAppAction()
        
        appAction1.update(from: appAction2)
        
        XCTAssertEqual(appAction1.actionType, appAction2.actionType)
        XCTAssertEqual(appAction1.deepLink, appAction2.deepLink)
    }
    
    func testNSCopying() {
        let original = MockDAOAppActionFactory.createMockAppAction()
        let copy = original.copy() as! DAOAppAction
        
        XCTAssertTrue(MockDAOAppActionFactory.validateAppActionEquality(original, copy))
        XCTAssertTrue(original !== copy) // Different instances
    }
    
    // MARK: - Dictionary Conversion Tests
    
    func testInitializationFromDictionary() {
        let dictionary = MockDAOAppActionFactory.createMockAppActionDictionary()
        let appAction = DAOAppAction(from: dictionary)
        
        XCTAssertNotNil(appAction)
        XCTAssertEqual(appAction?.id, "appaction123")
        XCTAssertEqual(appAction?.actionType, .popup)
        XCTAssertEqual(appAction?.deepLink?.absoluteString, "https://example.com/action")
    }
    
    func testInitializationFromEmptyDictionary() {
        let emptyDictionary: DNSDataDictionary = [:]
        let appAction = DAOAppAction(from: emptyDictionary)
        
        XCTAssertNil(appAction)
    }
    
    func testAsDictionary() {
        let appAction = MockDAOAppActionFactory.createMockAppAction()
        let dictionary = appAction.asDictionary
        
        XCTAssertNotNil(dictionary["id"])
        XCTAssertNotNil(dictionary["actionType"])
        XCTAssertNotNil(dictionary["deepLink"])
        XCTAssertNotNil(dictionary["images"])
        XCTAssertNotNil(dictionary["strings"])
        XCTAssertNotNil(dictionary["themes"])
        
        // Verify action type is stored as raw value or actual value
        if let actionType = dictionary["actionType"] as? DNSAppActionType {
            XCTAssertEqual(actionType, appAction.actionType)
        }
    }
    
    // MARK: - Equality and Comparison Tests
    
    func testEquality() {
        let appAction1 = MockDAOAppActionFactory.createMockAppAction()
        let appAction2 = DAOAppAction(from: appAction1)
        
        XCTAssertEqual(appAction1, appAction2)
        XCTAssertFalse(appAction1 != appAction2)
    }
    
    func testInequality() {
        let appAction1 = MockDAOAppActionFactory.createMockAppAction()
        let appAction2 = MockDAOAppActionFactory.createMockAppAction()
        appAction2.actionType = .fullScreen
        
        XCTAssertNotEqual(appAction1, appAction2)
        XCTAssertTrue(appAction1 != appAction2)
    }
    
    func testIsDiffFrom() {
        let appAction1 = MockDAOAppActionFactory.createMockAppAction()
        let appAction2 = DAOAppAction(from: appAction1)
        let appAction3 = MockDAOAppActionFactory.createMockAppAction()
        appAction3.deepLink = URL(string: "https://different.com")
        
        XCTAssertFalse(appAction1.isDiffFrom(appAction2))
        XCTAssertTrue(appAction1.isDiffFrom(appAction3))
        XCTAssertTrue(appAction1.isDiffFrom(nil))
        XCTAssertTrue(appAction1.isDiffFrom("not an app action"))
    }
    
    func testSelfComparison() {
        let appAction = MockDAOAppActionFactory.createMockAppAction()
        
        XCTAssertFalse(appAction.isDiffFrom(appAction))
        XCTAssertEqual(appAction, appAction)
    }
    
    // MARK: - Action Type Specific Tests
    
    func testActionTypeSpecificBehavior() {
        let appActions = MockDAOAppActionFactory.createMockAppActionWithAllActionTypes()
        
        for appAction in appActions {
            switch appAction.actionType {
            case .drawer:
                XCTAssertTrue(appAction.isActionable)
                if appAction.hasDeepLink {
                    XCTAssertFalse(appAction.requiresExternalNavigation)
                }
            case .fullScreen:
                XCTAssertTrue(appAction.isActionable)
                if appAction.hasDeepLink {
                    XCTAssertTrue(appAction.requiresExternalNavigation)
                }
            case .popup:
                XCTAssertFalse(appAction.isActionable) // Only actionable if it has a deep link
                XCTAssertFalse(appAction.requiresExternalNavigation)
            case .stage:
                XCTAssertTrue(appAction.isActionable)
                if appAction.hasDeepLink {
                    XCTAssertTrue(appAction.requiresExternalNavigation)
                }
            }
        }
    }
    
    // MARK: - URL Validation Tests
    
    func testURLValidation() {
        let appAction = DAOAppAction()
        
        // Test valid URLs
        appAction.deepLink = URL(string: "https://example.com")
        XCTAssertNotNil(appAction.deepLink)
        XCTAssertTrue(appAction.hasDeepLink)
        
        appAction.deepLink = URL(string: "myapp://internal/page")
        XCTAssertNotNil(appAction.deepLink)
        
        // Test nil URL
        appAction.deepLink = nil
        XCTAssertNil(appAction.deepLink)
        XCTAssertFalse(appAction.hasDeepLink)
    }
    
    // MARK: - Validation Tests
    
    func testValidationHelper() {
        let validAppAction = MockDAOAppActionFactory.createMockAppAction()
        XCTAssertTrue(MockDAOAppActionFactory.validateAppActionProperties(validAppAction))
        
        let minimalAppAction = MockDAOAppActionFactory.createMockAppActionWithMinimalData()
        XCTAssertTrue(MockDAOAppActionFactory.validateAppActionProperties(minimalAppAction))
    }
    
    // MARK: - Array Tests
    
    func testAppActionArray() {
        let appActions = MockDAOAppActionFactory.createMockAppActionArray(count: 5)
        
        XCTAssertEqual(appActions.count, 5)
        
        for (index, appAction) in appActions.enumerated() {
            XCTAssertEqual(appAction.id, "appaction\(index)")
            XCTAssertTrue(MockDAOAppActionFactory.validateAppActionProperties(appAction))
        }
    }
    
    // MARK: - Edge Cases
    
    func testMinimalDataAppAction() {
        let appAction = MockDAOAppActionFactory.createMockAppActionWithMinimalData()
        
        XCTAssertNotNil(appAction)
        XCTAssertEqual(appAction.actionType, .popup)
        XCTAssertNil(appAction.deepLink)
        XCTAssertFalse(appAction.isActionable) // popup without deepLink is not actionable
    }
    
    func testInvalidDictionaryHandling() {
        let invalidDict = MockDAOAppActionFactory.createInvalidAppActionDictionary()
        let appAction = DAOAppAction(from: invalidDict)
        
        // Should still create object but with default values
        XCTAssertNotNil(appAction)
        if let appAction = appAction {
            XCTAssertEqual(appAction.actionType, .popup) // Should fall back to default
        }
    }
    
    // MARK: - Complex Scenarios
    
    func testComplexActionScenarios() {
        // Test popup action without deep link
        let popupAction = DAOAppAction()
        popupAction.actionType = .popup
        popupAction.deepLink = nil
        
        XCTAssertFalse(popupAction.isActionable) // popup without deepLink is not actionable
        XCTAssertFalse(popupAction.hasDeepLink)
        XCTAssertFalse(popupAction.requiresExternalNavigation)
        
        // Test fullScreen action with URL
        let fullScreenAction = DAOAppAction()
        fullScreenAction.actionType = .fullScreen
        fullScreenAction.deepLink = URL(string: "https://example.com/deep")
        
        XCTAssertTrue(fullScreenAction.isActionable)
        XCTAssertTrue(fullScreenAction.hasDeepLink)
        XCTAssertTrue(fullScreenAction.requiresExternalNavigation)
        
        // Test fullScreen action without URL (edge case)
        let brokenFullScreenAction = DAOAppAction()
        brokenFullScreenAction.actionType = .fullScreen
        brokenFullScreenAction.deepLink = nil
        
        XCTAssertTrue(brokenFullScreenAction.isActionable) // fullScreen is actionable even without URL
        XCTAssertFalse(brokenFullScreenAction.hasDeepLink)
        XCTAssertFalse(brokenFullScreenAction.requiresExternalNavigation)
    }
    
    // MARK: - Factory Object Tests
    
    func testFactoryObjectCreation() {
        let appAction = DAOAppAction()
        
        // Test that factory methods work
        let images = DAOAppAction.createAppActionImages()
        let strings = DAOAppAction.createAppActionStrings()
        let themes = DAOAppAction.createAppActionThemes()
        
        XCTAssertNotNil(images)
        XCTAssertNotNil(strings)
        XCTAssertNotNil(themes)
        
        // Test assignment
        appAction.images = images
        appAction.strings = strings
        appAction.themes = themes
        
        XCTAssertEqual(appAction.images, images)
        XCTAssertEqual(appAction.strings, strings)
        XCTAssertEqual(appAction.themes, themes)
    }
    
    // MARK: - Performance Tests
    
    func testPerformanceCreateAppAction() {
        measure {
            for _ in 0..<1000 {
                let _ = MockDAOAppActionFactory.createMockAppAction()
            }
        }
    }
    
    func testPerformanceCopyAppAction() {
        let appAction = MockDAOAppActionFactory.createMockAppAction()
        
        measure {
            for _ in 0..<1000 {
                let _ = DAOAppAction(from: appAction)
            }
        }
    }
    
    func testPerformanceDictionaryConversion() {
        let appAction = MockDAOAppActionFactory.createMockAppAction()
        
        measure {
            for _ in 0..<1000 {
                let _ = appAction.asDictionary
            }
        }
    }

    static var allTests = [
        ("testDefaultInitialization", testDefaultInitialization),
        ("testInitializationWithId", testInitializationWithId),
        ("testPropertyAssignment", testPropertyAssignment),
        ("testActionTypeEnumValues", testActionTypeEnumValues),
        ("testDeepLinkHandling", testDeepLinkHandling),
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
        ("testActionTypeSpecificBehavior", testActionTypeSpecificBehavior),
        ("testURLValidation", testURLValidation),
        ("testValidationHelper", testValidationHelper),
        ("testAppActionArray", testAppActionArray),
        ("testMinimalDataAppAction", testMinimalDataAppAction),
        ("testInvalidDictionaryHandling", testInvalidDictionaryHandling),
        ("testComplexActionScenarios", testComplexActionScenarios),
        ("testFactoryObjectCreation", testFactoryObjectCreation),
        ("testPerformanceCreateAppAction", testPerformanceCreateAppAction),
        ("testPerformanceCopyAppAction", testPerformanceCopyAppAction),
        ("testPerformanceDictionaryConversion", testPerformanceDictionaryConversion),
    ]
}
