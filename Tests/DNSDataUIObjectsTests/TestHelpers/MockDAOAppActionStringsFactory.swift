//
//  MockDAOAppActionStringsFactory.swift
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

// MARK: - MockDAOAppActionStringsFactory -
class MockDAOAppActionStringsFactory {
    
    // MARK: - Creation Methods
    
    static func createMockAppActionStrings(id: String = "strings123") -> DAOAppActionStrings {
        let strings = DAOAppActionStrings(id: id)
        strings.title = DNSString(with: "Action Title")
        strings.subtitle = DNSString(with: "Action Subtitle")
        strings.body = DNSString(with: "Action Body Description")
        strings.disclaimer = DNSString(with: "Action Disclaimer")
        strings.okayLabel = DNSString(with: "OK")
        strings.cancelLabel = DNSString(with: "Cancel")
        return strings
    }
    
    static func createMockAppActionStringsWithMinimalData() -> DAOAppActionStrings {
        let strings = DAOAppActionStrings(id: "minimal123")
        strings.title = DNSString(with: "Minimal Title")
        // Leave other fields as defaults (empty)
        return strings
    }
    
    static func createMockAppActionStringsArray(count: Int) -> [DAOAppActionStrings] {
        return (0..<count).map { index in
            createMockAppActionStrings(id: "strings\(index)")
        }
    }
    
    // MARK: - Dictionary Creation Methods
    
    static func createMockAppActionStringsDictionary(id: String = "strings123") -> DNSDataDictionary {
        var baseDict = DAOTestHelpers.createMockBaseObjectDictionary(id: id)
        baseDict.merge([
            "title": ["en": "Mock Title"],
            "subtitle": ["en": "Mock Subtitle"],
            "description": ["en": "Mock Body Description"],
            "disclaimer": ["en": "Mock Disclaimer"],
            "okayLabel": ["en": "OK"],
            "cancelLabel": ["en": "Cancel"]
        ]) { (current, _) in current }
        return baseDict
    }
    
    static func createInvalidAppActionStringsDictionary() -> DNSDataDictionary {
        return [
            "id": "invalid123",
            "title": "Not a DNSString dictionary",
            "subtitle": 12345, // Wrong type
            "description": ["invalid": "structure"]
        ]
    }
    
    // MARK: - Validation Methods
    
    static func validateAppActionStringsProperties(_ strings: DAOAppActionStrings) -> Bool {
        guard !strings.id.isEmpty else { return false }
        // All DNSString properties should be non-nil
        return strings.title != nil &&
               strings.subtitle != nil &&
               strings.body != nil &&
               strings.disclaimer != nil &&
               strings.okayLabel != nil &&
               strings.cancelLabel != nil
    }
    
    static func validateAppActionStringsEquality(_ lhs: DAOAppActionStrings, _ rhs: DAOAppActionStrings) -> Bool {
        return lhs.id == rhs.id &&
               lhs.title == rhs.title &&
               lhs.subtitle == rhs.subtitle &&
               lhs.body == rhs.body &&
               lhs.disclaimer == rhs.disclaimer &&
               lhs.okayLabel == rhs.okayLabel &&
               lhs.cancelLabel == rhs.cancelLabel
    }
}
