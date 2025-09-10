//
//  DNSDataUIObjectsCodeLocation.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataUIObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSError

public extension DNSCodeLocation {
    typealias dataUIObjects = DNSDataUIObjectsCodeLocation
}
open class DNSDataUIObjectsCodeLocation: DNSCodeLocation {
    override open class var domainPreface: String { "com.doublenode.dataUIObjects." }
}
