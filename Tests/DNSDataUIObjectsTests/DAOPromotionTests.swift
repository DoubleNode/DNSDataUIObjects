//
//  DAOPromotionTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataUIObjectsTests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import DNSCore
import DNSDataObjects
import DNSDataTypes
@testable import DNSDataUIObjects

final class DAOPromotionTests: XCTestCase {
    
    // MARK: - Initialization Tests
    
    func testInitialization() {
        let promotion = DAOPromotion()
        XCTAssertNotNil(promotion)
        XCTAssertNotNil(promotion.title)
        XCTAssertNotNil(promotion.subtitle)
        XCTAssertNotNil(promotion.body)
        XCTAssertNotNil(promotion.disclaimer)
        XCTAssertTrue(promotion.enabled)
        XCTAssertEqual(promotion.priority, 500)
        XCTAssertTrue(promotion.mediaItems.isEmpty)
        XCTAssertNil(promotion.action)
    }
    
    func testInitializationWithId() {
        let testId = "promotion_test_12345"
        let promotion = DAOPromotion(id: testId)
        XCTAssertEqual(promotion.id, testId)
    }
    
    // MARK: - Property Tests
    
    func testBasicProperties() {
        let promotion = MockDAOPromotionFactory.create()
        XCTAssertEqual(promotion.id, "promotion_12345")
        XCTAssertTrue(promotion.enabled)
        XCTAssertEqual(promotion.priority, 100)
        XCTAssertEqual(promotion.placement, "home_banner")
    }
    
    func testContentProperties() {
        let promotion = MockDAOPromotionFactory.create()
        XCTAssertNotNil(promotion.title)
        XCTAssertNotNil(promotion.subtitle)
        XCTAssertNotNil(promotion.body)
        XCTAssertNotNil(promotion.disclaimer)
    }
    
    func testTimeProperties() {
        let promotion = MockDAOPromotionFactory.create()
        XCTAssertNotNil(promotion.startTime)
        XCTAssertNotNil(promotion.endTime)
        XCTAssertTrue(promotion.endTime > promotion.startTime)
    }
    
    func testDisplayDayOfWeekProperty() {
        let promotion = MockDAOPromotionFactory.create()
        XCTAssertNotNil(promotion.displayDayOfWeek)
    }
    
    func testActionProperty() {
        let promotion = MockDAOPromotionFactory.create()
        XCTAssertNotNil(promotion.action)
        XCTAssertEqual(promotion.action?.id, "promotion_action_001")
    }
    
    func testMediaItemsProperty() {
        let promotion = MockDAOPromotionFactory.create()
        XCTAssertFalse(promotion.mediaItems.isEmpty)
        XCTAssertEqual(promotion.mediaItems.count, 2)
        XCTAssertEqual(promotion.mediaItems[0].id, "media_001")
        XCTAssertEqual(promotion.mediaItems[1].id, "media_002")
    }
    
    func testPriorityBounds() {
        let promotion = DAOPromotion()
        
        // Test upper bound
        promotion.priority = 1000
        XCTAssertEqual(promotion.priority, DNSPriority.highest)
        
        // Test lower bound
        promotion.priority = -50
        XCTAssertEqual(promotion.priority, DNSPriority.none)
        
        // Test normal value
        promotion.priority = 150
        XCTAssertEqual(promotion.priority, 150)
    }
    
    // MARK: - Copy Tests
    
    func testCopyFromObject() {
        let originalPromotion = MockDAOPromotionFactory.create()
        let copiedPromotion = DAOPromotion(from: originalPromotion)
        
        XCTAssertEqual(copiedPromotion.id, originalPromotion.id)
        XCTAssertEqual(copiedPromotion.enabled, originalPromotion.enabled)
        XCTAssertEqual(copiedPromotion.priority, originalPromotion.priority)
        XCTAssertEqual(copiedPromotion.placement, originalPromotion.placement)
        XCTAssertEqual(copiedPromotion.mediaItems.count, originalPromotion.mediaItems.count)
        
        // Verify it's a deep copy
        // Mutate the copy and ensure the original is unchanged
        let originalCount = originalPromotion.mediaItems.count
        let originalFirstId = originalPromotion.mediaItems.first?.id

        copiedPromotion.mediaItems.append(DAOMedia(id: "media_new"))
        XCTAssertEqual(originalPromotion.mediaItems.count, originalCount, "Original mediaItems should not change when copy is mutated")

        if var first = copiedPromotion.mediaItems.first {
            first.id = "modified_id"
            // Replace first element in copied to simulate change
            copiedPromotion.mediaItems[0] = first
        }
        XCTAssertEqual(originalPromotion.mediaItems.first?.id, originalFirstId, "Original first media item should remain unchanged")
    }
    
    func testUpdateFromObject() {
        let originalPromotion = MockDAOPromotionFactory.create()
        let targetPromotion = DAOPromotion()
        
        targetPromotion.update(from: originalPromotion)
        
        XCTAssertEqual(targetPromotion.id, originalPromotion.id)
        XCTAssertEqual(targetPromotion.enabled, originalPromotion.enabled)
        XCTAssertEqual(targetPromotion.priority, originalPromotion.priority)
        XCTAssertEqual(targetPromotion.mediaItems.count, originalPromotion.mediaItems.count)
    }
    
    func testNSCopying() {
        let originalPromotion = MockDAOPromotionFactory.create()
        let copiedPromotion = originalPromotion.copy() as! DAOPromotion
        
        XCTAssertEqual(copiedPromotion.id, originalPromotion.id)
        XCTAssertFalse(copiedPromotion === originalPromotion)
    }
    
    // MARK: - Dictionary Translation Tests
    
    func testDictionaryTranslation() {
        let originalPromotion = MockDAOPromotionFactory.create()
        let dictionary = originalPromotion.asDictionary
        
        XCTAssertNotNil(dictionary["id"])
        XCTAssertNotNil(dictionary["title"])
        XCTAssertNotNil(dictionary["subtitle"])
        XCTAssertNotNil(dictionary["body"])
        XCTAssertNotNil(dictionary["enabled"])
        XCTAssertNotNil(dictionary["priority"])
        XCTAssertNotNil(dictionary["placement"])
        XCTAssertNotNil(dictionary["startTime"])
        XCTAssertNotNil(dictionary["endTime"])
        XCTAssertNotNil(dictionary["mediaItems"])
        
        let reconstructedPromotion = DAOPromotion(from: dictionary)
        XCTAssertNotNil(reconstructedPromotion)
        XCTAssertEqual(reconstructedPromotion?.id, originalPromotion.id)
        XCTAssertEqual(reconstructedPromotion?.enabled, originalPromotion.enabled)
    }
    
    func testDictionaryTranslationEmpty() {
        let emptyDictionary: [String: Any] = [:]
        let promotion = DAOPromotion(from: emptyDictionary)
        XCTAssertNil(promotion)
    }
    
    // MARK: - Equality Tests
    
    func testEquality() {
        let promotion1 = MockDAOPromotionFactory.create()
        let promotion2 = DAOPromotion(from: promotion1)
        let promotion3 = MockDAOPromotionFactory.createEmpty()
        
        XCTAssertEqual(promotion1, promotion2)
        XCTAssertNotEqual(promotion1, promotion3)
        XCTAssertFalse(promotion1.isDiffFrom(promotion2))
        XCTAssertTrue(promotion1.isDiffFrom(promotion3))
    }
    
    func testEqualityWithDifferentMediaItems() {
        let promotion1 = MockDAOPromotionFactory.create()
        let promotion2 = DAOPromotion(from: promotion1)
        
        // Modify media items
        promotion2.mediaItems.removeLast()
        
        XCTAssertNotEqual(promotion1, promotion2)
        XCTAssertTrue(promotion1.isDiffFrom(promotion2))
    }
    
    // MARK: - Codable Tests
    
    func testJSONEncoding() throws {
        let originalPromotion = MockDAOPromotionFactory.create()
        let data = try JSONEncoder().encode(originalPromotion)
        XCTAssertFalse(data.isEmpty)
    }
    
    func testJSONDecoding() throws {
        let originalPromotion = MockDAOPromotionFactory.create()
        let data = try JSONEncoder().encode(originalPromotion)
        let decodedPromotion = try JSONDecoder().decode(DAOPromotion.self, from: data)
        
        XCTAssertEqual(decodedPromotion.id, originalPromotion.id)
        XCTAssertEqual(decodedPromotion.enabled, originalPromotion.enabled)
        XCTAssertEqual(decodedPromotion.priority, originalPromotion.priority)
    }
    
    func testJSONRoundTrip() throws {
        let originalPromotion = MockDAOPromotionFactory.create()
        let data = try JSONEncoder().encode(originalPromotion)
        let decodedPromotion = try JSONDecoder().decode(DAOPromotion.self, from: data)
        
        XCTAssertEqual(originalPromotion, decodedPromotion)
        XCTAssertFalse(originalPromotion.isDiffFrom(decodedPromotion))
    }
    
    // MARK: - Edge Cases
    
    func testDisabledPromotion() {
        let promotion = DAOPromotion()
        promotion.enabled = false
        
        XCTAssertFalse(promotion.enabled)
        
        let dictionary = promotion.asDictionary
        let reconstructed = DAOPromotion(from: dictionary)
        XCTAssertNotNil(reconstructed)
        XCTAssertFalse(reconstructed!.enabled)
    }
    
    func testNilAction() {
        let promotion = DAOPromotion()
        promotion.action = nil
        
        XCTAssertNil(promotion.action)
        
        let dictionary = promotion.asDictionary
        let reconstructed = DAOPromotion(from: dictionary)
        XCTAssertNotNil(reconstructed)
        XCTAssertNil(reconstructed?.action)
    }
    
    func testEmptyMediaItems() {
        let promotion = DAOPromotion()
        promotion.mediaItems = []
        
        XCTAssertTrue(promotion.mediaItems.isEmpty)
        
        let dictionary = promotion.asDictionary
        let reconstructed = DAOPromotion(from: dictionary)
        XCTAssertNotNil(reconstructed)
        XCTAssertTrue(reconstructed!.mediaItems.isEmpty)
    }
    
    // MARK: - Factory Tests
    
    func testMockFactory() {
        let promotion = MockDAOPromotionFactory.create()
        XCTAssertNotNil(promotion)
        XCTAssertEqual(promotion.id, "promotion_12345")
        XCTAssertTrue(promotion.enabled)
        XCTAssertFalse(promotion.mediaItems.isEmpty)
    }
    
    func testMockFactoryEmpty() {
        let promotion = MockDAOPromotionFactory.createEmpty()
        XCTAssertNotNil(promotion)
        XCTAssertTrue(promotion.mediaItems.isEmpty)
    }
    
    func testMockFactoryWithId() {
        let testId = "custom_promotion_id"
        let promotion = MockDAOPromotionFactory.createWithId(testId)
        XCTAssertEqual(promotion.id, testId)
    }
    
    func testMockFactoryExpired() {
        let promotion = MockDAOPromotionFactory.createExpired()
        XCTAssertFalse(promotion.enabled)
        XCTAssertTrue(promotion.endTime < Date())
    }
    
    func testMockFactoryHighPriority() {
        let promotion = MockDAOPromotionFactory.createHighPriority()
        XCTAssertEqual(promotion.priority, 200)
        XCTAssertEqual(promotion.placement, "top_banner")
    }

    static var allTests = [
        ("testInitialization", testInitialization),
        ("testInitializationWithId", testInitializationWithId),
        ("testBasicProperties", testBasicProperties),
        ("testContentProperties", testContentProperties),
        ("testTimeProperties", testTimeProperties),
        ("testDisplayDayOfWeekProperty", testDisplayDayOfWeekProperty),
        ("testActionProperty", testActionProperty),
        ("testMediaItemsProperty", testMediaItemsProperty),
        ("testPriorityBounds", testPriorityBounds),
        ("testCopyFromObject", testCopyFromObject),
        ("testUpdateFromObject", testUpdateFromObject),
        ("testNSCopying", testNSCopying),
        ("testDictionaryTranslation", testDictionaryTranslation),
        ("testDictionaryTranslationEmpty", testDictionaryTranslationEmpty),
        ("testEquality", testEquality),
        ("testEqualityWithDifferentMediaItems", testEqualityWithDifferentMediaItems),
        ("testJSONEncoding", testJSONEncoding),
        ("testJSONDecoding", testJSONDecoding),
        ("testJSONRoundTrip", testJSONRoundTrip),
        ("testDisabledPromotion", testDisabledPromotion),
        ("testNilAction", testNilAction),
        ("testEmptyMediaItems", testEmptyMediaItems),
        ("testMockFactory", testMockFactory),
        ("testMockFactoryEmpty", testMockFactoryEmpty),
        ("testMockFactoryWithId", testMockFactoryWithId),
        ("testMockFactoryExpired", testMockFactoryExpired),
        ("testMockFactoryHighPriority", testMockFactoryHighPriority),
    ]
}

