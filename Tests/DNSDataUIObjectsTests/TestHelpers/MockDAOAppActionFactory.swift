//
//  MockDAOAppActionFactory.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataUIObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSDataTypes
import Foundation
@testable import DNSDataUIObjects

public class MockDAOAppActionFactory {
    
    // MARK: - Mock Data Creation
    
    public static func createMockAppAction(id: String = "appaction123") -> DAOAppAction {
        let appAction = DAOAppAction(id: id)
        
        appAction.actionType = .popup
        appAction.deepLink = URL(string: "https://example.com/action")
        
        // Create mock images
        appAction.images = MockDAOAppActionImagesFactory.createMockAppActionImages()
        
        // Create mock strings
        appAction.strings = MockDAOAppActionStringsFactory.createMockAppActionStrings()
        
        // Create mock themes
        appAction.themes = MockDAOAppActionThemesFactory.createMockAppActionThemes()
        
        return appAction
    }
    
    public static func createMockAppActionArray(count: Int = 3) -> [DAOAppAction] {
        return (0..<count).map { index in
            createMockAppAction(id: "appaction\(index)")
        }
    }
    
    public static func createMockAppActionWithMinimalData() -> DAOAppAction {
        let appAction = DAOAppAction()
        appAction.actionType = .popup
        return appAction
    }
    
    public static func createMockAppActionWithAllActionTypes() -> [DAOAppAction] {
        let actionTypes: [DNSAppActionType] = [.drawer, .fullScreen, .popup, .stage]
        
        return actionTypes.enumerated().map { index, actionType in
            let appAction = createMockAppAction(id: "appaction_\(actionType.rawValue)")
            appAction.actionType = actionType
            
            switch actionType {
            case .drawer:
                appAction.deepLink = URL(string: "https://example.com/drawer/\(index)")
            case .fullScreen:
                appAction.deepLink = URL(string: "https://example.com/fullscreen/\(index)")
            case .popup:
                appAction.deepLink = nil
            case .stage:
                appAction.deepLink = URL(string: "https://example.com/stage/\(index)")
            }
            
            return appAction
        }
    }
    
    public static func createMockAppActionWithComplexDeepLinks() -> [DAOAppAction] {
        let deepLinks = [
            "https://example.com/product/123",
            "myapp://profile/user123",
            "https://api.example.com/webhook?token=abc123",
            "mailto:support@example.com",
            "tel:+1234567890"
        ]
        
        return deepLinks.enumerated().map { index, urlString in
            let appAction = createMockAppAction(id: "complex_deeplink_\(index)")
            appAction.actionType = .fullScreen
            appAction.deepLink = URL(string: urlString)
            return appAction
        }
    }
    
    // MARK: - Dictionary Creation
    
    public static func createMockAppActionDictionary() -> DNSDataDictionary {
        return [
            "id": "appaction123",
            "actionType": DNSAppActionType.popup.rawValue,
            "deepLink": "https://example.com/action",
            "images": MockDAOAppActionImagesFactory.createMockAppActionImagesDictionary(),
            "strings": MockDAOAppActionStringsFactory.createMockAppActionStringsDictionary(),
            "themes": MockDAOAppActionThemesFactory.createMockAppActionThemesDictionary()
        ]
    }
    
    public static func createInvalidAppActionDictionary() -> DNSDataDictionary {
        return [
            "invalidProperty": "invalidValue",
            "actionType": "invalidActionType",
            "deepLink": "not_a_valid_url"
        ]
    }
    
    // MARK: - Validation Helpers
    
    public static func validateAppActionProperties(_ appAction: DAOAppAction) -> Bool {
        // Validate action type enum
        switch appAction.actionType {
        case .drawer, .fullScreen, .popup, .stage:
            break
        }
        
        // Validate deep link URL if present
        if let deepLink = appAction.deepLink {
            guard deepLink.absoluteString.count > 0 else { return false }
        }
        
        // Validate that dependent objects exist
        guard appAction.images != nil else { return false }
        guard appAction.strings != nil else { return false }
        guard appAction.themes != nil else { return false }
        
        return true
    }
    
    public static func validateAppActionEquality(_ appAction1: DAOAppAction, _ appAction2: DAOAppAction) -> Bool {
        return appAction1.id == appAction2.id &&
               appAction1.actionType == appAction2.actionType &&
               appAction1.deepLink == appAction2.deepLink &&
               appAction1.images == appAction2.images &&
               appAction1.strings == appAction2.strings &&
               appAction1.themes == appAction2.themes
    }
}

// MARK: - Extensions for Test Support

extension DAOAppAction {
    public var hasDeepLink: Bool {
        return deepLink != nil
    }
    
    public var isActionable: Bool {
        return actionType != .popup || hasDeepLink
    }
    
    public var requiresExternalNavigation: Bool {
        return (actionType == .fullScreen || actionType == .stage) && hasDeepLink
    }
}

// MARK: - Mock Factory for DAOAppActionImages

public class MockDAOAppActionImagesFactory {
    
    public static func createMockAppActionImages(id: String = "images123") -> DAOAppActionImages {
        let images = DAOAppActionImages(id: id)
        images.topUrl = DNSURL(with: URL(string: "https://example.com/top-image.jpg"))
        return images
    }
    
    public static func createMockAppActionImagesWithMinimalData() -> DAOAppActionImages {
        let images = DAOAppActionImages()
        // Leave topUrl empty for minimal data
        return images
    }
    
    public static func createMockAppActionImagesArray(count: Int = 3) -> [DAOAppActionImages] {
        return (0..<count).map { index in
            createMockAppActionImages(id: "images\(index)")
        }
    }
    
    public static func createMockAppActionImagesDictionary(id: String = "images123") -> DNSDataDictionary {
        var baseDict = DAOTestHelpers.createMockBaseObjectDictionary(id: id)
        baseDict.merge([
            "top": "https://example.com/mock-top.jpg"
        ]) { (current, _) in current }
        return baseDict
    }
    
    public static func createInvalidAppActionImagesDictionary() -> DNSDataDictionary {
        return [
            "invalidProperty": "invalidValue",
            "top": "not-a-valid-url-format"
        ]
    }
    
    // MARK: - Validation Helpers
    
    public static func validateAppActionImagesProperties(_ images: DAOAppActionImages) -> Bool {
        // Validate that topUrl property exists
        guard images.topUrl != nil else { return false }
        
        // If URL is set, validate it's not malformed
        if let url = images.topUrl.url {
            guard url.absoluteString.count > 0 else { return false }
        }
        
        return true
    }
    
    public static func validateAppActionImagesEquality(_ images1: DAOAppActionImages, _ images2: DAOAppActionImages) -> Bool {
        return images1.id == images2.id &&
               images1.topUrl.url?.absoluteString == images2.topUrl.url?.absoluteString
    }
}

// MARK: - Mock Factory for DAOAppActionStrings

public class MockDAOAppActionStringsFactory {
    
    public static func createMockAppActionStrings(id: String = "strings123") -> DAOAppActionStrings {
        let strings = DAOAppActionStrings(id: id)
        
        strings.title = DNSString(with: "Action Title")
        strings.subtitle = DNSString(with: "Action Subtitle")
        strings.body = DNSString(with: "Action Body Description")
        strings.disclaimer = DNSString(with: "Action Disclaimer")
        strings.okayLabel = DNSString(with: "OK")
        strings.cancelLabel = DNSString(with: "Cancel")
        
        return strings
    }
    
    public static func createMockAppActionStringsWithMinimalData() -> DAOAppActionStrings {
        let strings = DAOAppActionStrings()
        strings.title = DNSString(with: "Minimal Title")
        // Leave other fields empty/default
        return strings
    }
    
    public static func createMockAppActionStringsArray(count: Int = 3) -> [DAOAppActionStrings] {
        return (0..<count).map { index in
            createMockAppActionStrings(id: "strings\(index)")
        }
    }
    
    public static func createMockAppActionStringsDictionary(id: String = "strings123") -> DNSDataDictionary {
        var baseDict = DAOTestHelpers.createMockBaseObjectDictionary(id: id)
        baseDict.merge([
            "title": createMockDNSStringDictionary("Mock Title"),
            "subtitle": createMockDNSStringDictionary("Mock Subtitle"),
            "description": createMockDNSStringDictionary("Mock Body Description"),
            "disclaimer": createMockDNSStringDictionary("Mock Disclaimer"),
            "okayLabel": createMockDNSStringDictionary("OK"),
            "cancelLabel": createMockDNSStringDictionary("Cancel")
        ]) { (current, _) in current }
        return baseDict
    }
    
    private static func createMockDNSStringDictionary(_ value: String) -> DNSDataDictionary {
        return DNSString(with: value).asDictionary
    }
    
    public static func createInvalidAppActionStringsDictionary() -> DNSDataDictionary {
        return [
            "invalidProperty": "invalidValue",
            "title": 12345, // Invalid type for DNSString
            "subtitle": ["invalid", "array"]
        ]
    }
    
    // MARK: - Validation Helpers
    
    public static func validateAppActionStringsProperties(_ strings: DAOAppActionStrings) -> Bool {
        // Validate that all DNSString properties exist
        guard strings.title != nil,
              strings.subtitle != nil,
              strings.body != nil,
              strings.disclaimer != nil,
              strings.okayLabel != nil,
              strings.cancelLabel != nil else { return false }
        
        return true
    }
    
    public static func validateAppActionStringsEquality(_ strings1: DAOAppActionStrings, _ strings2: DAOAppActionStrings) -> Bool {
        return strings1.id == strings2.id &&
               strings1.title.asString == strings2.title.asString &&
               strings1.subtitle.asString == strings2.subtitle.asString &&
               strings1.body.asString == strings2.body.asString &&
               strings1.disclaimer.asString == strings2.disclaimer.asString &&
               strings1.okayLabel.asString == strings2.okayLabel.asString &&
               strings1.cancelLabel.asString == strings2.cancelLabel.asString
    }
}

// MARK: - Mock Factory for DAOAppActionThemes

public class MockDAOAppActionThemesFactory {
    
    public static func createMockAppActionThemes(id: String = "themes123") -> DAOAppActionThemes {
        let themes = DAOAppActionThemes(id: id)
        
        // Create custom button styles for testing
        let cancelStyle = DNSThemeButtonStyle(identifier: "mock-cancel-button")
        let okayStyle = DNSThemeButtonStyle(identifier: "mock-okay-button")
        
        themes.cancelButton = cancelStyle
        themes.okayButton = okayStyle
        
        return themes
    }
    
    public static func createMockAppActionThemesWithMinimalData() -> DAOAppActionThemes {
        let themes = DAOAppActionThemes()
        // Use default button styles
        return themes
    }
    
    public static func createMockAppActionThemesArray(count: Int = 3) -> [DAOAppActionThemes] {
        return (0..<count).map { index in
            createMockAppActionThemes(id: "themes\(index)")
        }
    }
    
    public static func createMockAppActionThemesDictionary(id: String = "themes123") -> DNSDataDictionary {
        var baseDict = DAOTestHelpers.createMockBaseObjectDictionary(id: id)
        baseDict.merge([
            "cancelButton": createMockButtonStyleDictionary("dict-cancel-button"),
            "okayButton": createMockButtonStyleDictionary("dict-okay-button")
        ]) { (current, _) in current }
        return baseDict
    }
    
    private static func createMockButtonStyleDictionary(_ identifier: String) -> DNSDataDictionary {
        let buttonStyle = DNSThemeButtonStyle(identifier: identifier)
        return buttonStyle.asDictionary
    }
    
    public static func createInvalidAppActionThemesDictionary() -> DNSDataDictionary {
        return [
            "invalidProperty": "invalidValue",
            "cancelButton": "not-a-button-style", // Invalid type
            "okayButton": 12345 // Invalid type
        ]
    }
    
    // MARK: - Validation Helpers
    
    public static func validateAppActionThemesProperties(_ themes: DAOAppActionThemes) -> Bool {
        // Validate that all button style properties exist and are valid
        guard themes.cancelButton != nil,
              themes.okayButton != nil else { return false }
        
        // Validate button styles have identifiers
        guard !themes.cancelButton.identifier.isEmpty,
              !themes.okayButton.identifier.isEmpty else { return false }
        
        return true
    }
    
    public static func validateAppActionThemesEquality(_ themes1: DAOAppActionThemes, _ themes2: DAOAppActionThemes) -> Bool {
        return themes1.id == themes2.id &&
               themes1.cancelButton.identifier == themes2.cancelButton.identifier &&
               themes1.okayButton.identifier == themes2.okayButton.identifier
    }
}
