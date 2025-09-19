//
//  MockDAOAppActionThemesFactory.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataUIObjectsTests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import DNSCore
import DNSDataObjects
import DNSDataTypes
import DNSThemeTypes
import Foundation
@testable import DNSDataUIObjects

// MARK: - MockDAOAppActionThemesFactory -
class MockDAOAppActionThemesFactory {
    
    // MARK: - Creation Methods
    
    static func createMockAppActionThemes(id: String = "themes123") -> DAOAppActionThemes {
        let themes = DAOAppActionThemes(id: id)
        themes.cancelButton = DNSThemeButtonStyle(styleName: "mock-cancel-button")
        themes.okayButton = DNSThemeButtonStyle(styleName: "mock-okay-button")
        return themes
    }
    
    static func createMockAppActionThemesWithMinimalData() -> DAOAppActionThemes {
        let themes = DAOAppActionThemes(id: "minimal123")
        // Use default button styles
        return themes
    }
    
    static func createMockAppActionThemesArray(count: Int) -> [DAOAppActionThemes] {
        return (0..<count).map { index in
            let themes = DAOAppActionThemes(id: "themes\(index)")
            themes.cancelButton = DNSThemeButtonStyle(styleName: "cancel\(index)")
            themes.okayButton = DNSThemeButtonStyle(styleName: "okay\(index)")
            return themes
        }
    }
    
    // MARK: - Dictionary Creation Methods
    
    static func createMockAppActionThemesDictionary(id: String = "themes123") -> DNSDataDictionary {
        var baseDict = DAOTestHelpers.createMockBaseObjectDictionary(id: id)
        
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
    
    static func createInvalidAppActionThemesDictionary() -> DNSDataDictionary {
        return [
            "id": "invalid123",
            "cancelButton": "Not a button style dictionary", // Wrong type
            "okayButton": 12345, // Wrong type
            "invalidField": ["invalid": "structure"]
        ]
    }
    
    // MARK: - Validation Methods
    
    static func validateAppActionThemesProperties(_ themes: DAOAppActionThemes) -> Bool {
        guard !themes.id.isEmpty else { return false }
        // DNSThemeButtonStyle properties should be non-nil
        return themes.cancelButton != nil &&
               themes.okayButton != nil
    }
    
    static func validateAppActionThemesEquality(_ lhs: DAOAppActionThemes, _ rhs: DAOAppActionThemes) -> Bool {
        return lhs.id == rhs.id &&
               lhs.cancelButton == rhs.cancelButton &&
               lhs.okayButton == rhs.okayButton
    }
}
