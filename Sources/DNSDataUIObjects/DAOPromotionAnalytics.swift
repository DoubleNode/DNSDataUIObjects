//
//  DAOPromotionAnalytics.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataUIObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSDataObjects
import DNSError
import Foundation

public protocol PTCLCFGDAOPromotionAnalytics: PTCLCFGBaseObject {
    var promotionAnalyticsType: DAOPromotionAnalytics.Type { get }
    func promotionAnalytics<K>(from container: KeyedDecodingContainer<K>,
                               forKey key: KeyedDecodingContainer<K>.Key) -> DAOPromotionAnalytics? where K: CodingKey
    func promotionAnalyticsArray<K>(from container: KeyedDecodingContainer<K>,
                                    forKey key: KeyedDecodingContainer<K>.Key) -> [DAOPromotionAnalytics] where K: CodingKey
}

public protocol PTCLCFGPromotionAnalyticsObject: PTCLCFGDAOPromotion {
}
public class CFGPromotionAnalyticsObject: PTCLCFGPromotionAnalyticsObject {
    public var promotionType: DAOPromotion.Type = DAOPromotion.self
    open func promotion<K>(from container: KeyedDecodingContainer<K>,
                           forKey key: KeyedDecodingContainer<K>.Key) -> DAOPromotion? where K: CodingKey {
        do { return try container.decodeIfPresent(DAOPromotion.self, forKey: key, configuration: self) ?? nil } catch { }
        return nil
    }
    open func promotionArray<K>(from container: KeyedDecodingContainer<K>,
                                forKey key: KeyedDecodingContainer<K>.Key) -> [DAOPromotion] where K: CodingKey {
        do { return try container.decodeIfPresent([DAOPromotion].self, forKey: key, configuration: self) ?? [] } catch { }
        return []
    }
}
open class DAOPromotionAnalytics: DAOBaseObject, DecodingConfigurationProviding, EncodingConfigurationProviding {
    public typealias Config = PTCLCFGPromotionAnalyticsObject
    public static var config: Config = CFGPromotionAnalyticsObject()

    public static var decodingConfiguration: DAOBaseObject.Config { Self.config }
    public static var encodingConfiguration: DAOBaseObject.Config { Self.config }

    // MARK: - Class Factory methods -
    open class func createPromotion() -> DAOPromotion { config.promotionType.init() }
    open class func createPromotion(from object: DAOPromotion) -> DAOPromotion { config.promotionType.init(from: object) }
    open class func createPromotion(from data: DNSDataDictionary) -> DAOPromotion? { config.promotionType.init(from: data) }
    
    // MARK: - Properties -
    private func field(_ from: CodingKeys) -> String { return from.rawValue }
    public enum CodingKeys: String, CodingKey {
        case promotion, period, metrics
    }

    @CodableConfiguration(from: DAOPromotion.self) open var promotion: DAOPromotion? = nil
    public var period = Period()
    public var metrics = Metrics()

    // MARK: - Nested Types
    public struct Period: Codable, Hashable {
        public var start = Date()
        public var end = Date()

        public init() {}

        public init(start: Date, end: Date) {
            self.start = start
            self.end = end
        }
    }

    public struct Metrics: Codable, Hashable {
        public var totalViews = 0
        public var totalTaps = 0
        public var viewsByPlatform = PlatformBreakdown()
        public var tapsByPlatform = PlatformBreakdown()
        public var byScreen: [String: ScreenMetrics] = [:]
        public var timeline: [TimelineEntry] = []

        public init() {}

        /// Calculated engagement rate (taps / views)
        public var engagementRate: Double {
            guard totalViews > 0 else { return 0.0 }
            return Double(totalTaps) / Double(totalViews)
        }
    }

    public struct ScreenMetrics: Codable, Hashable {
        public var views: Int = 0
        public var taps: Int = 0

        public init() {}

        public init(views: Int, taps: Int) {
            self.views = views
            self.taps = taps
        }

        /// Calculated engagement rate for this screen
        public var engagementRate: Double {
            guard views > 0 else { return 0.0 }
            return Double(taps) / Double(views)
        }
    }

    public struct PlatformBreakdown: Codable, Hashable {
        public var ios: Int = 0
        public var android: Int = 0

        public init() {}

        public init(ios: Int, android: Int) {
            self.ios = ios
            self.android = android
        }
    }

    public struct TimelineEntry: Codable, Hashable {
        public var period: String = "" // Date string (format varies by granularity)
        public var views: Int = 0
        public var taps: Int = 0

        public init() {}

        public init(period: String, views: Int, taps: Int) {
            self.period = period
            self.views = views
            self.taps = taps
        }

        /// Calculated engagement rate for this period
        public var engagementRate: Double {
            guard views > 0 else { return 0.0 }
            return Double(taps) / Double(views)
        }
    }

    // MARK: - Initializers
    required public init() {
        super.init()
    }
    required public init(id: String) {
        super.init(id: id)
    }
    public init(promotion: DAOPromotion,
                period: Period,
                metrics: Metrics) {
        self.promotion = promotion
        self.period = period
        self.metrics = metrics
        super.init()
    }

    // MARK: - DAO copy methods -
   required public init(from object: DAOPromotionAnalytics) {
       super.init(from: object)
       self.update(from: object)
   }
   open func update(from object: DAOPromotionAnalytics) {
       super.update(from: object)
       self.metrics = object.metrics
       self.period = object.period
       // swiftlint:disable force_cast
       self.promotion = object.promotion?.copy() as? DAOPromotion
       // swiftlint:enable force_cast
   }

    // MARK: - DAO translation methods -
   required public init?(from data: DNSDataDictionary) {
       guard !data.isEmpty else { return nil }
       super.init(from: data)
   }
    override open func dao(from data: DNSDataDictionary) -> DAOPromotionAnalytics {
        _ = super.dao(from: data)
        // The API returns promoCode and promoType, but we store a promotion object
        // Create a minimal promotion from the API data
        let promoCode = self.string(from: data["promoCode"] as Any?) ?? ""
        let promoType = self.string(from: data["promoType"] as Any?) ?? "DEAL"
        let promoData = [
            "id": promoCode,
            "type": promoType,
        ]
        self.promotion = Self.createPromotion(from: promoData)
        if let periodData = data[field(.period)] as? DNSDataDictionary {
            self.period = self.period(from: periodData)
        }
        if let metricsData = data[field(.metrics)] as? DNSDataDictionary {
            self.metrics = self.metrics(from: metricsData)
        }
        return self
    }
    override open var asDictionary: DNSDataDictionary {
        var retval = super.asDictionary
        if let promotion = self.promotion {
            retval.merge([
                field(.promotion): promotion.asDictionary,
            ]) { current, _ in current }
        }
        retval.merge([
            field(.period): self.periodAsDictionary(self.period),
            field(.metrics): self.metricsAsDictionary(self.metrics),
        ]) { current, _ in current }
        return retval
    }

    // MARK: - Codable protocol methods -
    required public init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        try commonInit(from: decoder, configuration: Self.config)
    }
    override open func encode(to encoder: Encoder) throws {
        try self.encode(to: encoder, configuration: Self.config)
    }

    // MARK: - CodableWithConfiguration protocol methods -
    required public init(from decoder: Decoder, configuration: DAOBaseObject.Config) throws {
        try super.init(from: decoder, configuration: configuration)
        try self.commonInit(from: decoder, configuration: Self.config)
    }
    required public init(from decoder: Decoder, configuration: Config) throws {
        try super.init(from: decoder, configuration: configuration)
        try self.commonInit(from: decoder, configuration: configuration)
    }
    private func commonInit(from decoder: Decoder, configuration: Config) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        promotion = self.daoPromotion(with: configuration, from: container, forKey: .promotion) ?? promotion
        period = try container.decodeIfPresent(Period.self, forKey: .period) ?? period
        metrics = try container.decodeIfPresent(Metrics.self, forKey: .metrics) ?? metrics
    }
    override open func encode(to encoder: Encoder, configuration: DAOBaseObject.Config) throws {
        try self.encode(to: encoder, configuration: Self.config)
    }
    open func encode(to encoder: Encoder, configuration: Config) throws {
        try super.encode(to: encoder, configuration: configuration)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(promotion, forKey: .promotion, configuration: configuration)
        try container.encode(period, forKey: .period)
        try container.encode(metrics, forKey: .metrics)
    }

    // MARK: - NSCopying protocol methods -
    override open func copy(with zone: NSZone? = nil) -> Any {
        let copy = DAOPromotionAnalytics(from: self)
        return copy
    }
    override open func isDiffFrom(_ rhs: Any?) -> Bool {
        guard let rhs = rhs as? DAOPromotionAnalytics else { return true }
        guard self !== rhs else { return false }
        guard !super.isDiffFrom(rhs) else { return true }
        let lhs = self
        return (lhs.promotion?.isDiffFrom(rhs.promotion) ?? (lhs.promotion != rhs.promotion)) ||
            lhs.period != rhs.period ||
            lhs.metrics != rhs.metrics
    }

    // MARK: - Equatable protocol methods -
    static public func !=(lhs: DAOPromotionAnalytics, rhs: DAOPromotionAnalytics) -> Bool {
        lhs.isDiffFrom(rhs)
    }
    static public func ==(lhs: DAOPromotionAnalytics, rhs: DAOPromotionAnalytics) -> Bool {
        !lhs.isDiffFrom(rhs)
    }

    // MARK: - Helper methods for nested structs
    private func period(from data: DNSDataDictionary) -> Period {
        var period = Period()
        if let startDate = self.date(from: data["start"] as? String) {
            period.start = startDate
        }
        if let endDate = self.date(from: data["end"] as? String) {
            period.end = endDate
        }
        return period
    }

    private func periodAsDictionary(_ period: Period) -> DNSDataDictionary {
        return [
            "start": period.start,
            "end": period.end,
        ]
    }

    private func metrics(from data: DNSDataDictionary) -> Metrics {
        var metrics = Metrics()

        metrics.totalViews = data["totalViews"] as? Int ?? 0
        metrics.totalTaps = data["totalTaps"] as? Int ?? 0

        let viewsByPlatformData = self.dictionary(from: data["viewsByPlatform"] as Any?)
        metrics.viewsByPlatform = self.platformBreakdown(from: viewsByPlatformData)

        let tapsByPlatformData = self.dictionary(from: data["tapsByPlatform"] as Any?)
        metrics.tapsByPlatform = self.platformBreakdown(from: tapsByPlatformData)

        // Parse byScreen data if available (when includeScreens=1)
        let byScreenData = self.dictionary(from: data["byScreen"] as Any?)
        var screenMetrics: [String: ScreenMetrics] = [:]
        for (screenName, screenData) in byScreenData {
            let screenDict = self.dictionary(from: screenData)
            screenMetrics[screenName] = self.screenMetrics(from: screenDict)
        }
        metrics.byScreen = screenMetrics

        // timeline is expected to be an array of dictionaries
        if let timelineArray = data["timeline"] as? [DNSDataDictionary] {
            metrics.timeline = timelineArray.map { self.timelineEntry(from: $0) }
        } else if let timelineAnyArray = data["timeline"] as? [Any] {
            // Fallback: coerce any-array into DNSDataDictionary array
            metrics.timeline = timelineAnyArray.compactMap { self.dictionary(from: $0) }.map { self.timelineEntry(from: $0) }
        } else if let timelineDict = self.dictionary(from: data["timeline"] as Any?) as DNSDataDictionary?,
                  !timelineDict.isEmpty {
            // Some APIs might incorrectly send a single object instead of an array
            metrics.timeline = [self.timelineEntry(from: timelineDict)]
        } else {
            metrics.timeline = []
        }

        return metrics
    }

    private func metricsAsDictionary(_ metrics: Metrics) -> DNSDataDictionary {
        var byScreenDict: [String: DNSDataDictionary] = [:]
        for (screenName, screenData) in metrics.byScreen {
            byScreenDict[screenName] = self.screenMetricsAsDictionary(screenData)
        }
        return [
            "totalViews": metrics.totalViews,
            "totalTaps": metrics.totalTaps,
            "viewsByPlatform": self.platformBreakdownAsDictionary(metrics.viewsByPlatform),
            "tapsByPlatform": self.platformBreakdownAsDictionary(metrics.tapsByPlatform),
            "byScreen": byScreenDict,
            "timeline": metrics.timeline.map { self.timelineEntryAsDictionary($0) }
        ]
    }

    private func screenMetrics(from data: DNSDataDictionary) -> ScreenMetrics {
        return ScreenMetrics(
            views: self.int(from: data["views"] as Any?) ?? 0,
            taps: self.int(from: data["taps"] as Any?) ?? 0
        )
    }

    private func screenMetricsAsDictionary(_ metrics: ScreenMetrics) -> DNSDataDictionary {
        return [
            "views": metrics.views,
            "taps": metrics.taps
        ]
    }

    private func platformBreakdown(from data: DNSDataDictionary) -> PlatformBreakdown {
        return PlatformBreakdown(
            ios: self.int(from: data["ios"] as Any?) ?? 0,
            android: self.int(from: data["android"] as Any?) ?? 0
        )
    }

    private func platformBreakdownAsDictionary(_ breakdown: PlatformBreakdown) -> DNSDataDictionary {
        return [
            "ios": breakdown.ios,
            "android": breakdown.android
        ]
    }

    private func timelineEntry(from data: DNSDataDictionary) -> TimelineEntry {
        return TimelineEntry(
            period: self.string(from: data["period"] as Any?) ?? "",
            views: self.int(from: data["views"] as Any?) ?? 0,
            taps: self.int(from: data["taps"] as Any?) ?? 0
        )
    }

    private func timelineEntryAsDictionary(_ entry: TimelineEntry) -> DNSDataDictionary {
        return [
            "period": entry.period,
            "views": entry.views,
            "taps": entry.taps
        ]
    }
}

