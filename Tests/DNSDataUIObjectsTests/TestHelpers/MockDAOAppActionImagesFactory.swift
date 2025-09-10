//
//  MockDAOAppActionImagesFactory.swift
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

// MARK: - MockDAOAppActionImagesFactory -
class MockDAOAppActionImagesFactory {
    
    // MARK: - Creation Methods
    
    static func createMockAppActionImages(id: String = "images123") -> DAOAppActionImages {
        let images = DAOAppActionImages(id: id)
        images.topUrl = DNSURL(with: URL(string: "https://example.com/top-image.jpg"))
        return images
    }
    
    static func createMockAppActionImagesWithMinimalData() -> DAOAppActionImages {
        let images = DAOAppActionImages(id: "minimal123")
        // Leave topUrl as default (empty)
        return images
    }
    
    static func createMockAppActionImagesArray(count: Int) -> [DAOAppActionImages] {
        return (0..<count).map { index in
            let images = DAOAppActionImages(id: "images\(index)")
            images.topUrl = DNSURL(with: URL(string: "https://example.com/image\(index).jpg"))
            return images
        }
    }
    
    // MARK: - Dictionary Creation Methods
    
    static func createMockAppActionImagesDictionary(id: String = "images123") -> DNSDataDictionary {
        var baseDict = DAOTestHelpers.createMockBaseObjectDictionary(id: id)
        baseDict.merge([
            "top": DNSURL(with: URL(string: "https://example.com/mock-top.jpg"))
        ]) { (current, _) in current }
        return baseDict
    }
    
    static func createInvalidAppActionImagesDictionary() -> DNSDataDictionary {
        return [
            "id": "invalid123",
            "top": "Not a DNSURL object", // Wrong type
            "invalidField": ["invalid": "structure"]
        ]
    }
    
    // MARK: - Validation Methods
    
    static func validateAppActionImagesProperties(_ images: DAOAppActionImages) -> Bool {
        guard !images.id.isEmpty else { return false }
        // DNSURL property should be non-nil
        return images.topUrl != nil
    }
    
    static func validateAppActionImagesEquality(_ lhs: DAOAppActionImages, _ rhs: DAOAppActionImages) -> Bool {
        return lhs.id == rhs.id &&
               lhs.topUrl == rhs.topUrl
    }
}