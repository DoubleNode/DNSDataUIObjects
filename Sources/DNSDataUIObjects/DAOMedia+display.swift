//
//  DAOMedia+display.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataUIObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSDataObjects
import Foundation

extension DAOMedia {
    public func display(using helper: DNSMediaDisplay) {
        helper.display(from: self)
    }
}
