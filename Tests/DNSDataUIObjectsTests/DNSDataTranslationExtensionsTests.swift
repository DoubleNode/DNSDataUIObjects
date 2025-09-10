//
//  DNSDataTranslationExtensionsTests.swift
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

final class DNSDataTranslationExtensionsTests: XCTestCase {
    private var dataTranslation: DNSDataTranslation!
    
    // MARK: - Setup and Teardown
    
    override func setUp() {
        super.setUp()
        dataTranslation = DNSDataTranslation()
    }
    
    override func tearDown() {
        dataTranslation = nil
        super.tearDown()
    }
    
    // MARK: - Helper Methods
    
    private func createMockKeyedDecodingContainer<K: CodingKey>() -> KeyedDecodingContainer<K> {
        let mockDecoder = MockDecoder()
        return try! mockDecoder.container(keyedBy: K.self)
    }
    
    private func createMockAppActionConfig() -> MockAppActionConfig {
        return MockAppActionConfig()
    }
    
    private func createMockPromotionConfig() -> MockPromotionConfig {
        return MockPromotionConfig()
    }
    
    private func createMockAppActionImagesConfig() -> MockAppActionImagesConfig {
        return MockAppActionImagesConfig()
    }
    
    private func createMockAppActionStringsConfig() -> MockAppActionStringsConfig {
        return MockAppActionStringsConfig()
    }
    
    private func createMockAppActionThemesConfig() -> MockAppActionThemesConfig {
        return MockAppActionThemesConfig()
    }
    
    private enum TestCodingKeys: String, CodingKey {
        case appAction, appActionImages, appActionStrings
        case appActionThemes, promotion
    }
    
    // MARK: - DNSDataTranslation+daoAppAction Tests
    
    func testDaoAppActionFromContainer() {
        // Arrange
        let container: KeyedDecodingContainer<TestCodingKeys> = createMockKeyedDecodingContainer()
        let config = createMockAppActionConfig()
        let mockAppAction = DAOAppAction()
        config.mockAppAction = mockAppAction
        
        // Act
        let result = dataTranslation.daoAppAction(with: config, from: container, forKey: .appAction)
        
        // Assert
        XCTAssertNotNil(result)
        XCTAssertTrue(result === mockAppAction)
    }
    
    func testDaoAppActionFromContainerMissing() {
        // Arrange
        let container: KeyedDecodingContainer<TestCodingKeys> = createMockKeyedDecodingContainer()
        let config = createMockAppActionConfig()
        // No mock app action set
        
        // Act
        let result = dataTranslation.daoAppAction(with: config, from: container, forKey: .appAction)
        
        // Assert
        XCTAssertNil(result)
    }
    
    func testDaoAppActionArrayFromContainer() {
        // Arrange
        let container: KeyedDecodingContainer<TestCodingKeys> = createMockKeyedDecodingContainer()
        let config = createMockAppActionConfig()
        let mockAppActions = [DAOAppAction(), DAOAppAction(), DAOAppAction()]
        config.mockAppActionArray = mockAppActions
        
        // Act
        let result = dataTranslation.daoAppActionArray(with: config, from: container, forKey: .appAction)
        
        // Assert
        XCTAssertEqual(result.count, 3)
        XCTAssertTrue(result[0] === mockAppActions[0])
        XCTAssertTrue(result[1] === mockAppActions[1])
        XCTAssertTrue(result[2] === mockAppActions[2])
    }
    
    func testDaoAppActionArrayFromContainerEmpty() {
        // Arrange
        let container: KeyedDecodingContainer<TestCodingKeys> = createMockKeyedDecodingContainer()
        let config = createMockAppActionConfig()
        // No mock app action array set
        
        // Act
        let result = dataTranslation.daoAppActionArray(with: config, from: container, forKey: .appAction)
        
        // Assert
        XCTAssertTrue(result.isEmpty)
    }
    
    // MARK: - DNSDataTranslation+daoAppActionImages Tests
    
    func testDaoAppActionImagesFromContainer() {
        // Arrange
        let container: KeyedDecodingContainer<TestCodingKeys> = createMockKeyedDecodingContainer()
        let config = createMockAppActionImagesConfig()
        let mockImages = DAOAppActionImages()
        config.mockAppActionImages = mockImages
        
        // Act
        let result = dataTranslation.daoAppActionImages(with: config, from: container, forKey: .appActionImages)
        
        // Assert
        XCTAssertNotNil(result)
        XCTAssertTrue(result === mockImages)
    }
    
    func testDaoAppActionImagesArrayFromContainer() {
        // Arrange
        let container: KeyedDecodingContainer<TestCodingKeys> = createMockKeyedDecodingContainer()
        let config = createMockAppActionImagesConfig()
        let mockImagesArray = [DAOAppActionImages(), DAOAppActionImages()]
        config.mockAppActionImagesArray = mockImagesArray
        
        // Act
        let result = dataTranslation.daoAppActionImagesArray(with: config, from: container, forKey: .appActionImages)
        
        // Assert
        XCTAssertEqual(result.count, 2)
        XCTAssertTrue(result[0] === mockImagesArray[0])
        XCTAssertTrue(result[1] === mockImagesArray[1])
    }
    
    // MARK: - DNSDataTranslation+daoAppActionStrings Tests
    
    func testDaoAppActionStringsFromContainer() {
        // Arrange
        let container: KeyedDecodingContainer<TestCodingKeys> = createMockKeyedDecodingContainer()
        let config = createMockAppActionStringsConfig()
        let mockStrings = DAOAppActionStrings()
        config.mockAppActionStrings = mockStrings
        
        // Act
        let result = dataTranslation.daoAppActionStrings(with: config, from: container, forKey: .appActionStrings)
        
        // Assert
        XCTAssertNotNil(result)
        XCTAssertTrue(result === mockStrings)
    }
    
    func testDaoAppActionStringsArrayFromContainer() {
        // Arrange
        let container: KeyedDecodingContainer<TestCodingKeys> = createMockKeyedDecodingContainer()
        let config = createMockAppActionStringsConfig()
        let mockStringsArray = [DAOAppActionStrings(), DAOAppActionStrings()]
        config.mockAppActionStringsArray = mockStringsArray
        
        // Act
        let result = dataTranslation.daoAppActionStringsArray(with: config, from: container, forKey: .appActionStrings)
        
        // Assert
        XCTAssertEqual(result.count, 2)
        XCTAssertTrue(result[0] === mockStringsArray[0])
        XCTAssertTrue(result[1] === mockStringsArray[1])
    }
    
    // MARK: - DNSDataTranslation+daoAppActionThemes Tests
    
    func testDaoAppActionThemesFromContainer() {
        // Arrange
        let container: KeyedDecodingContainer<TestCodingKeys> = createMockKeyedDecodingContainer()
        let config = createMockAppActionThemesConfig()
        let mockThemes = DAOAppActionThemes()
        config.mockAppActionThemes = mockThemes
        
        // Act
        let result = dataTranslation.daoAppActionThemes(with: config, from: container, forKey: .appActionThemes)
        
        // Assert
        XCTAssertNotNil(result)
        XCTAssertTrue(result === mockThemes)
    }
    
    func testDaoAppActionThemesArrayFromContainer() {
        // Arrange
        let container: KeyedDecodingContainer<TestCodingKeys> = createMockKeyedDecodingContainer()
        let config = createMockAppActionThemesConfig()
        let mockThemesArray = [DAOAppActionThemes(), DAOAppActionThemes()]
        config.mockAppActionThemesArray = mockThemesArray
        
        // Act
        let result = dataTranslation.daoAppActionThemesArray(with: config, from: container, forKey: .appActionThemes)
        
        // Assert
        XCTAssertEqual(result.count, 2)
        XCTAssertTrue(result[0] === mockThemesArray[0])
        XCTAssertTrue(result[1] === mockThemesArray[1])
    }
    
    // MARK: - DNSDataTranslation+daoPromotion Tests
    
    func testDaoPromotionFromContainer() {
        // Arrange
        let container: KeyedDecodingContainer<TestCodingKeys> = createMockKeyedDecodingContainer()
        let config = createMockPromotionConfig()
        let mockPromotion = DAOPromotion()
        config.mockPromotion = mockPromotion
        
        // Act
        let result = dataTranslation.daoPromotion(with: config, from: container, forKey: .promotion)
        
        // Assert
        XCTAssertNotNil(result)
        XCTAssertTrue(result === mockPromotion)
    }
    
    func testDaoPromotionArrayFromContainer() {
        // Arrange
        let container: KeyedDecodingContainer<TestCodingKeys> = createMockKeyedDecodingContainer()
        let config = createMockPromotionConfig()
        let mockPromotionArray = [DAOPromotion(), DAOPromotion(), DAOPromotion()]
        config.mockPromotionArray = mockPromotionArray
        
        // Act
        let result = dataTranslation.daoPromotionArray(with: config, from: container, forKey: .promotion)
        
        // Assert
        XCTAssertEqual(result.count, 3)
        XCTAssertTrue(result[0] === mockPromotionArray[0])
        XCTAssertTrue(result[1] === mockPromotionArray[1])
        XCTAssertTrue(result[2] === mockPromotionArray[2])
    }
    
    // MARK: - Edge Cases and Error Handling
    
    func testAllExtensionsWithEmptyConfiguration() {
        // Arrange
        let container: KeyedDecodingContainer<TestCodingKeys> = createMockKeyedDecodingContainer()
        let appActionConfig = createMockAppActionConfig()
        let imagesConfig = createMockAppActionImagesConfig()
        let stringsConfig = createMockAppActionStringsConfig()
        let themesConfig = createMockAppActionThemesConfig()
        let promotionConfig = createMockPromotionConfig()
        
        // Act & Assert - Should handle empty configurations gracefully (no mocked data)
        XCTAssertNil(dataTranslation.daoAppAction(with: appActionConfig, from: container, forKey: .appAction))
        XCTAssertTrue(dataTranslation.daoAppActionArray(with: appActionConfig, from: container, forKey: .appAction).isEmpty)
        
        XCTAssertNil(dataTranslation.daoAppActionImages(with: imagesConfig, from: container, forKey: .appActionImages))
        XCTAssertTrue(dataTranslation.daoAppActionImagesArray(with: imagesConfig, from: container, forKey: .appActionImages).isEmpty)
        
        XCTAssertNil(dataTranslation.daoAppActionStrings(with: stringsConfig, from: container, forKey: .appActionStrings))
        XCTAssertTrue(dataTranslation.daoAppActionStringsArray(with: stringsConfig, from: container, forKey: .appActionStrings).isEmpty)
        
        XCTAssertNil(dataTranslation.daoAppActionThemes(with: themesConfig, from: container, forKey: .appActionThemes))
        XCTAssertTrue(dataTranslation.daoAppActionThemesArray(with: themesConfig, from: container, forKey: .appActionThemes).isEmpty)
        
        XCTAssertNil(dataTranslation.daoPromotion(with: promotionConfig, from: container, forKey: .promotion))
        XCTAssertTrue(dataTranslation.daoPromotionArray(with: promotionConfig, from: container, forKey: .promotion).isEmpty)
    }
    
    func testExtensionsWithDifferentCodingKeys() {
        // Arrange
        let config = createMockAppActionConfig()
        
        enum DifferentKeys: String, CodingKey {
            case differentKey
        }
        
        let differentContainer: KeyedDecodingContainer<DifferentKeys> = {
            let mockDecoder = MockDecoder()
            return try! mockDecoder.container(keyedBy: DifferentKeys.self)
        }()
        
        // Act & Assert - Should handle different coding keys
        XCTAssertNil(dataTranslation.daoAppAction(with: config, from: differentContainer, forKey: .differentKey))
        XCTAssertTrue(dataTranslation.daoAppActionArray(with: config, from: differentContainer, forKey: .differentKey).isEmpty)
    }
    
    // MARK: - Performance Tests
    
    func testPerformanceAppActionFromContainer() {
        let container: KeyedDecodingContainer<TestCodingKeys> = createMockKeyedDecodingContainer()
        let config = createMockAppActionConfig()
        config.mockAppAction = DAOAppAction()
        
        measure {
            for _ in 0..<1000 {
                _ = dataTranslation.daoAppAction(with: config, from: container, forKey: .appAction)
            }
        }
    }
    
    func testPerformanceAppActionArrayFromContainer() {
        let container: KeyedDecodingContainer<TestCodingKeys> = createMockKeyedDecodingContainer()
        let config = createMockAppActionConfig()
        config.mockAppActionArray = [DAOAppAction(), DAOAppAction(), DAOAppAction()]
        
        measure {
            for _ in 0..<1000 {
                _ = dataTranslation.daoAppActionArray(with: config, from: container, forKey: .appAction)
            }
        }
    }
    
    static var allTests = [
        ("testDaoAppActionFromContainer", testDaoAppActionFromContainer),
        ("testDaoAppActionFromContainerMissing", testDaoAppActionFromContainerMissing),
        ("testDaoAppActionArrayFromContainer", testDaoAppActionArrayFromContainer),
        ("testDaoAppActionArrayFromContainerEmpty", testDaoAppActionArrayFromContainerEmpty),
        ("testDaoAppActionImagesFromContainer", testDaoAppActionImagesFromContainer),
        ("testDaoAppActionImagesArrayFromContainer", testDaoAppActionImagesArrayFromContainer),
        ("testDaoAppActionStringsFromContainer", testDaoAppActionStringsFromContainer),
        ("testDaoAppActionStringsArrayFromContainer", testDaoAppActionStringsArrayFromContainer),
        ("testDaoAppActionThemesFromContainer", testDaoAppActionThemesFromContainer),
        ("testDaoAppActionThemesArrayFromContainer", testDaoAppActionThemesArrayFromContainer),
        ("testDaoPromotionFromContainer", testDaoPromotionFromContainer),
        ("testDaoPromotionArrayFromContainer", testDaoPromotionArrayFromContainer),
        ("testAllExtensionsWithEmptyConfiguration", testAllExtensionsWithEmptyConfiguration),
        ("testExtensionsWithDifferentCodingKeys", testExtensionsWithDifferentCodingKeys),
        ("testPerformanceAppActionFromContainer", testPerformanceAppActionFromContainer),
        ("testPerformanceAppActionArrayFromContainer", testPerformanceAppActionArrayFromContainer),
    ]
}

// MARK: - Mock Classes for Testing

private struct MockDecoder: Decoder {
    var codingPath: [CodingKey] = []
    var userInfo: [CodingUserInfoKey : Any] = [:]
    
    func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key : CodingKey {
        return KeyedDecodingContainer(MockKeyedContainer<Key>())
    }
    
    func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: codingPath, debugDescription: "Mock implementation"))
    }
    
    func singleValueContainer() throws -> SingleValueDecodingContainer {
        throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: codingPath, debugDescription: "Mock implementation"))
    }
}

private struct MockKeyedContainer<K: CodingKey>: KeyedDecodingContainerProtocol {
    typealias Key = K
    
    var codingPath: [CodingKey] = []
    var allKeys: [K] = []
    
    func contains(_ key: K) -> Bool {
        return true
    }
    
    func decodeNil(forKey key: K) throws -> Bool {
        return false
    }
    
    func decode(_ type: Bool.Type, forKey key: K) throws -> Bool {
        return false
    }
    
    func decode(_ type: String.Type, forKey key: K) throws -> String {
        return ""
    }
    
    func decode(_ type: Double.Type, forKey key: K) throws -> Double {
        return 0.0
    }
    
    func decode(_ type: Float.Type, forKey key: K) throws -> Float {
        return 0.0
    }
    
    func decode(_ type: Int.Type, forKey key: K) throws -> Int {
        return 0
    }
    
    func decode(_ type: Int8.Type, forKey key: K) throws -> Int8 {
        return 0
    }
    
    func decode(_ type: Int16.Type, forKey key: K) throws -> Int16 {
        return 0
    }
    
    func decode(_ type: Int32.Type, forKey key: K) throws -> Int32 {
        return 0
    }
    
    func decode(_ type: Int64.Type, forKey key: K) throws -> Int64 {
        return 0
    }
    
    func decode(_ type: UInt.Type, forKey key: K) throws -> UInt {
        return 0
    }
    
    func decode(_ type: UInt8.Type, forKey key: K) throws -> UInt8 {
        return 0
    }
    
    func decode(_ type: UInt16.Type, forKey key: K) throws -> UInt16 {
        return 0
    }
    
    func decode(_ type: UInt32.Type, forKey key: K) throws -> UInt32 {
        return 0
    }
    
    func decode(_ type: UInt64.Type, forKey key: K) throws -> UInt64 {
        return 0
    }
    
    func decode<T>(_ type: T.Type, forKey key: K) throws -> T where T : Decodable {
        throw DecodingError.keyNotFound(key, DecodingError.Context(codingPath: codingPath, debugDescription: "Mock implementation"))
    }
    
    func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: K) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
        throw DecodingError.keyNotFound(key, DecodingError.Context(codingPath: codingPath, debugDescription: "Mock implementation"))
    }
    
    func nestedUnkeyedContainer(forKey key: K) throws -> UnkeyedDecodingContainer {
        throw DecodingError.keyNotFound(key, DecodingError.Context(codingPath: codingPath, debugDescription: "Mock implementation"))
    }
    
    func superDecoder() throws -> Decoder {
        throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: codingPath, debugDescription: "Mock implementation"))
    }
    
    func superDecoder(forKey key: K) throws -> Decoder {
        throw DecodingError.keyNotFound(key, DecodingError.Context(codingPath: codingPath, debugDescription: "Mock implementation"))
    }
}

// MARK: - Mock Configuration Classes

private class MockAppActionConfig: PTCLCFGDAOAppAction {
    var appActionType: DAOAppAction.Type = DAOAppAction.self
    var mockAppAction: DAOAppAction?
    var mockAppActionArray: [DAOAppAction] = []
    
    func appAction<K>(from container: KeyedDecodingContainer<K>,
                      forKey key: KeyedDecodingContainer<K>.Key) -> DAOAppAction? where K: CodingKey {
        return mockAppAction
    }
    
    func appActionArray<K>(from container: KeyedDecodingContainer<K>,
                           forKey key: KeyedDecodingContainer<K>.Key) -> [DAOAppAction] where K: CodingKey {
        return mockAppActionArray
    }
}

private class MockAppActionImagesConfig: PTCLCFGDAOAppActionImages {
    var appActionImagesType: DAOAppActionImages.Type = DAOAppActionImages.self
    var mockAppActionImages: DAOAppActionImages?
    var mockAppActionImagesArray: [DAOAppActionImages] = []
    
    func appActionImages<K>(from container: KeyedDecodingContainer<K>,
                            forKey key: KeyedDecodingContainer<K>.Key) -> DAOAppActionImages? where K: CodingKey {
        return mockAppActionImages
    }
    
    func appActionImagesArray<K>(from container: KeyedDecodingContainer<K>,
                                 forKey key: KeyedDecodingContainer<K>.Key) -> [DAOAppActionImages] where K: CodingKey {
        return mockAppActionImagesArray
    }
}

private class MockAppActionStringsConfig: PTCLCFGDAOAppActionStrings {
    var appActionStringsType: DAOAppActionStrings.Type = DAOAppActionStrings.self
    var mockAppActionStrings: DAOAppActionStrings?
    var mockAppActionStringsArray: [DAOAppActionStrings] = []
    
    func appActionStrings<K>(from container: KeyedDecodingContainer<K>,
                             forKey key: KeyedDecodingContainer<K>.Key) -> DAOAppActionStrings? where K: CodingKey {
        return mockAppActionStrings
    }
    
    func appActionStringsArray<K>(from container: KeyedDecodingContainer<K>,
                                  forKey key: KeyedDecodingContainer<K>.Key) -> [DAOAppActionStrings] where K: CodingKey {
        return mockAppActionStringsArray
    }
}

private class MockAppActionThemesConfig: PTCLCFGDAOAppActionThemes {
    var appActionThemesType: DAOAppActionThemes.Type = DAOAppActionThemes.self
    var mockAppActionThemes: DAOAppActionThemes?
    var mockAppActionThemesArray: [DAOAppActionThemes] = []
    
    func appActionThemes<K>(from container: KeyedDecodingContainer<K>,
                            forKey key: KeyedDecodingContainer<K>.Key) -> DAOAppActionThemes? where K: CodingKey {
        return mockAppActionThemes
    }
    
    func appActionThemesArray<K>(from container: KeyedDecodingContainer<K>,
                                 forKey key: KeyedDecodingContainer<K>.Key) -> [DAOAppActionThemes] where K: CodingKey {
        return mockAppActionThemesArray
    }
}

private class MockPromotionConfig: PTCLCFGDAOPromotion {
    var promotionType: DAOPromotion.Type = DAOPromotion.self
    var mockPromotion: DAOPromotion?
    var mockPromotionArray: [DAOPromotion] = []
    
    func promotion<K>(from container: KeyedDecodingContainer<K>,
                      forKey key: KeyedDecodingContainer<K>.Key) -> DAOPromotion? where K: CodingKey {
        return mockPromotion
    }
    
    func promotionArray<K>(from container: KeyedDecodingContainer<K>,
                           forKey key: KeyedDecodingContainer<K>.Key) -> [DAOPromotion] where K: CodingKey {
        return mockPromotionArray
    }
}

