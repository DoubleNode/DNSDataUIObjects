//
//  MockDAOAppActionFactory.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataUIObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSDataTypes
import DNSThemeTypes
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
