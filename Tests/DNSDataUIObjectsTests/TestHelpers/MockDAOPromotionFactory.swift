//
//  MockDAOPromotionFactory.swift
//  DNSDataUIObjectsTests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSDataUIObjects
import DNSDataObjects
import DNSDataTypes
import Foundation

class MockDAOPromotionFactory {
    static func create() -> DAOPromotion {
        let dao = DAOPromotion()
        dao.id = "promotion_12345"
        
        // Set promotion content
        dao.title = DNSString(with: "Special Offer")
        dao.subtitle = DNSString(with: "Limited Time Only")
        dao.body = DNSString(with: "Get 50% off on all premium features. Don't miss out on this amazing deal!")
        dao.disclaimer = DNSString(with: "Terms and conditions apply. Valid until end of month.")
        
        // Set promotion properties
        dao.enabled = true
        dao.priority = 100
        dao.placement = "home_banner"
        dao.startTime = Date().addingTimeInterval(-86400) // Started yesterday
        dao.endTime = Date().addingTimeInterval(86400 * 7) // Ends in a week
        
        // Set display settings
        dao.displayDayOfWeek = DNSDayOfWeekFlags(sunday: false, monday: true, tuesday: true, wednesday: true, thursday: true, friday: true, saturday: false)
        
        // Create mock action
        dao.action = MockDAOAppActionFactory.createMockAppAction()
        dao.action?.id = "promotion_action_001"
        
        // Create mock media items
        let media1 = DAOMedia(id: "media_001")
        let media2 = DAOMedia(id: "media_002")
        
        dao.mediaItems = [media1, media2]
        
        return dao
    }
    
    static func createEmpty() -> DAOPromotion {
        return DAOPromotion()
    }
    
    static func createWithId(_ id: String) -> DAOPromotion {
        let dao = create()
        dao.id = id
        return dao
    }
    
    static func createExpired() -> DAOPromotion {
        let dao = create()
        dao.enabled = false
        dao.startTime = Date().addingTimeInterval(-86400 * 7) // Started a week ago
        dao.endTime = Date().addingTimeInterval(-86400) // Ended yesterday
        return dao
    }
    
    static func createHighPriority() -> DAOPromotion {
        let dao = create()
        dao.priority = 200
        dao.placement = "top_banner"
        return dao
    }
}
