//
//  PropertiesManager.swift
//  vpncore - Created on 26.06.19.
//
//  Copyright (c) 2019 Proton Technologies AG
//
//  This file is part of vpncore.
//
//  vpncore is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  vpncore is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with vpncore.  If not, see <https://www.gnu.org/licenses/>.

import Foundation

public protocol PropertiesManagerFactory {
    func makePropertiesManager() -> PropertiesManagerProtocol
}

public protocol PropertiesManagerProtocol: class {

    static var hasConnectedNotification: Notification.Name { get }
    static var userIpNotification: Notification.Name { get }
    static var earlyAccessNotification: Notification.Name { get }
    static var vpnProtocolNotification: Notification.Name { get }
    static var excludeLocalNetworksNotification: Notification.Name { get }
    static var vpnAcceleratorNotification: Notification.Name { get }
    static var killSwitchNotification: Notification.Name { get }
    static var smartProtocolNotification: Notification.Name { get }    
    static var featureFlagsNotification: Notification.Name { get }

    var onAlternativeRoutingChange: ((Bool) -> Void)? { get set }
    
    func getAutoConnect(for username: String) -> (enabled: Bool, profileId: String?)
    func setAutoConnect(for username: String, enabled: Bool, profileId: String?)

    var hasConnected: Bool { get set }
    var lastIkeConnection: ConnectionConfiguration? { get set }
    var lastOpenVpnConnection: ConnectionConfiguration? { get set }
    var lastWireguardConnection: ConnectionConfiguration? { get set }
    var lastPreparedServer: ServerModel? { get set }
    var lastConnectedTimeStamp: Double { get set }
    var lastConnectionRequest: ConnectionRequest? { get set }

    func getLastAccountPlan(for username: String) -> AccountPlan?
    func setLastAccountPlan(for username: String, plan: AccountPlan?)

    func getQuickConnect(for username: String) -> String? // profile + username (incase multiple users are using the app)
    func setQuickConnect(for username: String, quickConnect: String?)

    var secureCoreToggle: Bool { get set }
    var serverTypeToggle: ServerType { get }
    var reportBugEmail: String? { get set }
    var discourageSecureCore: Bool { get set }
    var newBrandModalShown: Bool { get set }
    
    // Distinguishes if kill switch should be disabled
    var intentionallyDisconnected: Bool { get set }
    var userLocation: UserLocation? { get set }
    var userDataDisclaimerAgreed: Bool { get set }
    
    var trialWelcomed: Bool { get set }
    var warnedTrialExpiring: Bool { get set }
    var warnedTrialExpired: Bool { get set }
    
    var openVpnConfig: OpenVpnConfig { get set }
    var vpnProtocol: VpnProtocol { get set }

    var featureFlags: FeatureFlags { get set }
    var maintenanceServerRefreshIntereval: Int { get set }
    var killSwitch: Bool { get set }
    var excludeLocalNetworks: Bool { get set }
    var vpnAcceleratorEnabled: Bool { get set }
    
    // Development properties
    var apiEndpoint: String? { get set }
    
    var lastAppVersion: String { get set }
    var lastTimeForeground: Date? { get set }
    
    var humanValidationFailed: Bool { get set }
    var alternativeRouting: Bool { get set }
    var smartProtocol: Bool { get set }
    
    var streamingServices: StreamingDictServices { get set }
    var streamingResourcesUrl: String? { get set }

    var connectionProtocol: ConnectionProtocol { get }

    var wireguardConfig: WireguardConfig { get set }

    var smartProtocolConfig: SmartProtocolConfig { get set }

    var ratingSettings: RatingSettings { get set }

    #if os(macOS)
    var forceExtensionUpgrade: Bool { get set }
    #endif
    
    func logoutCleanup()
    
    func getValue(forKey: String) -> Bool
    func setValue(_ value: Bool, forKey: String)

    /// Logs all the properties with their current values
    func logCurrentState()
}

public class PropertiesManager: PropertiesManagerProtocol {
    internal enum Keys: String, CaseIterable {
        
        case autoConnect = "AutoConnect"
        case autoConnectProfile = "AutoConnect_"
        case connectOnDemand = "ConnectOnDemand"
        case lastIkeConnection = "LastIkeConnection"
        case lastOpenVpnConnection = "LastOpenVPNConnection"
        case lastWireguardConnection = "LastWireguardConnection"
        case lastPreparingServer = "LastPreparingServer"
        case lastConnectedTimeStamp = "LastConnectedTimeStamp"
        case lastConnectionRequest = "LastConnectionRequest"
        case lastUserAccountPlan = "LastUserAccountPlan"
        case quickConnectProfile = "QuickConnect_"
        case secureCoreToggle = "SecureCoreToggle"
        case intentionallyDisconnected = "IntentionallyDisconnected"
        case userLocation = "UserLocation"
        case userDataDisclaimerAgreed = "UserDataDisclaimerAgreed"
        case lastBugReportEmail = "LastBugReportEmail"

        // Subscriptions
        case servicePlans = "servicePlans"
        case currentSubscription = "currentSubscription"
        case defaultPlanDetails = "defaultPlanDetails"
        case isIAPUpgradePlanAvailable = "isIAPUpgradePlanAvailable" // Old name is left for backwards compatibility
        
        // Trial
        case trialWelcomed = "TrialWelcomed"
        case warnedTrialExpiring = "WarnedTrialExpiring"
        case warnedTrialExpired = "WarnedTrialExpired"
        
        // OpenVPN
        case openVpnConfig = "OpenVpnConfig"
        case vpnProtocol = "VpnProtocol"
        
        case apiEndpoint = "ApiEndpoint"
        
        // Migration
        case lastAppVersion = "LastAppVersion"
        
        // AppState
        case lastTimeForeground = "LastTimeForeground"

        // Discourage Secure Core
        case discourageSecureCore = "DiscourageSecureCore"

        // Did Show New Brand Modal
        case newBrandModalShown = "NewBrandModalShown"

        // Kill Switch
        case killSwitch = "Firewall" // kill switch is a legacy name in the user's preferences
        case excludeLocalNetworks = "excludeLocalNetworks"
        
        // Features
        case featureFlags = "FeatureFlags"
        case maintenanceServerRefreshIntereval = "MaintenanceServerRefreshIntereval"
        case vpnAcceleratorEnabled = "VpnAcceleratorEnabled"
        
        case humanValidationFailed = "humanValidationFailed"
        case alternativeRouting = "alternativeRouting"
        case smartProtocol = "smartProtocol"
        case streamingServices = "streamingServices"
        case streamingResourcesUrl = "streamingResourcesUrl"

        case wireguardConfig = "WireguardConfig"
        case smartProtocolConfig = "SmartProtocolConfig"
        case ratingSettings = "RatingSettings"

        #if os(macOS)
        case forceExtensionUpgrade = "ForceExtensionUpgrade"
        #endif
    }
    
    public static let hasConnectedNotification = Notification.Name("HasConnectedChanged")
    public static let userIpNotification = Notification.Name("UserIp")
    public static let featureFlagsNotification = Notification.Name("FeatureFlags")
    public static let earlyAccessNotification: Notification.Name = Notification.Name("EarlyAccessChanged")
    public static let vpnProtocolNotification: Notification.Name = Notification.Name("VPNProtocolChanged")
    public static let killSwitchNotification: Notification.Name = Notification.Name("KillSwitchChanged")
    public static let vpnAcceleratorNotification: Notification.Name = Notification.Name("VpnAcceleratorChanged")    
    public static let excludeLocalNetworksNotification: Notification.Name = Notification.Name("ExcludeLocalNetworksChanged")
    public static let smartProtocolNotification: Notification.Name = Notification.Name("SmartProtocolChanged")

    public var onAlternativeRoutingChange: ((Bool) -> Void)?

    public func getAutoConnect(for username: String) -> (enabled: Bool, profileId: String?) {
        let autoConnectEnabled = storage.defaults.bool(forKey: Keys.autoConnect.rawValue)
        let profileId = storage.defaults.string(forKey: Keys.autoConnectProfile.rawValue + username)
        return (autoConnectEnabled, profileId)
    }

    public func setAutoConnect(for username: String, enabled: Bool, profileId: String?) {
        storage.setValue(enabled, forKey: Keys.autoConnect.rawValue)
        if let profileId = profileId {
            storage.setValue(profileId, forKey: Keys.autoConnectProfile.rawValue + username)
        }
    }

    // Use to do first time connecting stuff if needed
    public var hasConnected: Bool {
        get {
            return storage.defaults.bool(forKey: Keys.connectOnDemand.rawValue)
        }
        set {
            storage.setValue(newValue, forKey: Keys.connectOnDemand.rawValue)
            postNotificationOnUIThread(type(of: self).hasConnectedNotification, object: newValue)
        }
    }

    private var _lastIkeConnection: ConnectionConfiguration?
    public var lastIkeConnection: ConnectionConfiguration? {
        get {
            if let _lastIkeConnection = _lastIkeConnection {
                return _lastIkeConnection
            }

            return storage.getDecodableValue(ConnectionConfiguration.self, forKey: Keys.lastIkeConnection.rawValue)
        }
        set {
            _lastIkeConnection = newValue
            storage.setEncodableValue(newValue, forKey: Keys.lastIkeConnection.rawValue)
        }
    }

    private var _lastOpenVpnConnection: ConnectionConfiguration?
    public var lastOpenVpnConnection: ConnectionConfiguration? {
        get {
            if let _lastOpenVpnConnection = _lastOpenVpnConnection {
                return _lastOpenVpnConnection
            }

            return storage.getDecodableValue(ConnectionConfiguration.self, forKey: Keys.lastOpenVpnConnection.rawValue)
        }
        set {
            _lastOpenVpnConnection = newValue
            storage.setEncodableValue(newValue, forKey: Keys.lastOpenVpnConnection.rawValue)
        }
    }
    
    private var _lastWireguardConnection: ConnectionConfiguration?
    public var lastWireguardConnection: ConnectionConfiguration? {
        get {
            if let _lastWireguardConnection = _lastWireguardConnection {
                return _lastWireguardConnection
            }

            return storage.getDecodableValue(ConnectionConfiguration.self, forKey: Keys.lastWireguardConnection.rawValue)
        }
        set {
            _lastWireguardConnection = newValue
            storage.setEncodableValue(newValue, forKey: Keys.lastWireguardConnection.rawValue)
        }
    }

    public var lastPreparedServer: ServerModel? {
        get {
            return storage.getDecodableValue(ServerModel.self, forKey: Keys.lastPreparingServer.rawValue)
        }
        set {
            storage.setEncodableValue(newValue, forKey: Keys.lastPreparingServer.rawValue)
        }
    }

    public var lastConnectedTimeStamp: Double {
        get {
            return storage.defaults.double(forKey: Keys.lastConnectedTimeStamp.rawValue)
        }
        set {
            storage.setValue(newValue, forKey: Keys.lastConnectedTimeStamp.rawValue)
        }
    }
    
    public var lastConnectionRequest: ConnectionRequest? {
        get {
            return storage.getDecodableValue(ConnectionRequest.self, forKey: Keys.lastConnectionRequest.rawValue)
        }
        set {
            storage.setEncodableValue(newValue, forKey: Keys.lastConnectionRequest.rawValue)
        }
    }

    public func getLastAccountPlan(for username: String) -> AccountPlan? {
        guard let result = storage.defaults.string(forKey: Keys.lastUserAccountPlan.rawValue + username) else {
            return nil
        }
        return AccountPlan(rawValue: result)
    }

    public func setLastAccountPlan(for username: String, plan: AccountPlan?) {
        storage.setValue(plan?.rawValue, forKey: Keys.lastUserAccountPlan.rawValue + username)
    }

    public func getQuickConnect(for username: String) -> String? {
        storage.defaults.string(forKey: Keys.quickConnectProfile.rawValue + username)
    }

    public func setQuickConnect(for username: String, quickConnect: String?) {
        storage.setValue(quickConnect, forKey: Keys.quickConnectProfile.rawValue + username)
    }

    public var secureCoreToggle: Bool {
        get {
            return storage.defaults.bool(forKey: Keys.secureCoreToggle.rawValue)
        }
        set {
            storage.setValue(newValue, forKey: Keys.secureCoreToggle.rawValue)
        }
    }
    
    public var serverTypeToggle: ServerType {
        return secureCoreToggle ? .secureCore : .standard
    }
    
    public var reportBugEmail: String? {
        get {
            return storage.defaults.string(forKey: Keys.lastBugReportEmail.rawValue)
        }
        set {
            storage.setValue(newValue, forKey: Keys.lastBugReportEmail.rawValue)
        }
    }
    
    // Destinguishes if kill switch should be disabled
    public var intentionallyDisconnected: Bool {
        get {
            return storage.defaults.bool(forKey: Keys.intentionallyDisconnected.rawValue)
        }
        set {
            storage.setValue(newValue, forKey: Keys.intentionallyDisconnected.rawValue)
        }
    }

    public var userLocation: UserLocation? {
        get {
            return storage.getDecodableValue(UserLocation.self, forKey: Keys.userLocation.rawValue)
        }
        set {
            storage.setEncodableValue(newValue, forKey: Keys.userLocation.rawValue)
            postNotificationOnUIThread(type(of: self).userIpNotification, object: userLocation)
        }
    }
    
    public var userDataDisclaimerAgreed: Bool {
        get {
            return storage.defaults.bool(forKey: Keys.userDataDisclaimerAgreed.rawValue)
        }
        set {
            storage.setValue(newValue, forKey: Keys.userDataDisclaimerAgreed.rawValue)
        }
    }
    
    public var trialWelcomed: Bool {
        get {
            return storage.defaults.bool(forKey: Keys.trialWelcomed.rawValue)
        }
        set {
            storage.setValue(newValue, forKey: Keys.trialWelcomed.rawValue)
        }
    }
    
    public var warnedTrialExpiring: Bool {
        get {
            return storage.defaults.bool(forKey: Keys.warnedTrialExpiring.rawValue)
        }
        set {
            storage.setValue(newValue, forKey: Keys.warnedTrialExpiring.rawValue)
        }
    }
    
    public var warnedTrialExpired: Bool {
        get {
            return storage.defaults.bool(forKey: Keys.warnedTrialExpired.rawValue)
        }
        set {
            storage.setValue(newValue, forKey: Keys.warnedTrialExpired.rawValue)
        }
    }

    public var apiEndpoint: String? {
        get {
            return storage.defaults.string(forKey: Keys.apiEndpoint.rawValue)
        }
        set {
            storage.setValue(newValue, forKey: Keys.apiEndpoint.rawValue)
        }
    }
    
    public var openVpnConfig: OpenVpnConfig {
        get {
            return storage.getDecodableValue(OpenVpnConfig.self, forKey: Keys.openVpnConfig.rawValue) ?? OpenVpnConfig()
        }
        set {
            storage.setEncodableValue(newValue, forKey: Keys.openVpnConfig.rawValue)
        }
    }

    public var wireguardConfig: WireguardConfig {
        get {
            return storage.getDecodableValue(WireguardConfig.self, forKey: Keys.wireguardConfig.rawValue) ?? WireguardConfig()
        }
        set {
            storage.setEncodableValue(newValue, forKey: Keys.wireguardConfig.rawValue)
        }
    }

    public var smartProtocolConfig: SmartProtocolConfig {
        get {
            return storage.getDecodableValue(SmartProtocolConfig.self, forKey: Keys.smartProtocolConfig.rawValue) ?? SmartProtocolConfig()
        }
        set {
            storage.setEncodableValue(newValue, forKey: Keys.smartProtocolConfig.rawValue)
        }
    }

    public var ratingSettings: RatingSettings {
        get {
            return storage.getDecodableValue(RatingSettings.self, forKey: Keys.ratingSettings.rawValue) ?? RatingSettings()
        }
        set {
            storage.setEncodableValue(newValue, forKey: Keys.ratingSettings.rawValue)
        }
    }

    #if os(macOS)
    public var forceExtensionUpgrade: Bool {
        get {
            return storage.defaults.bool(forKey: Keys.forceExtensionUpgrade.rawValue)
        }
        set {
            storage.setValue(newValue, forKey: Keys.forceExtensionUpgrade.rawValue)
        }
    }
    #endif
    
    public var vpnProtocol: VpnProtocol {
        get {
            return storage.getDecodableValue(VpnProtocol.self, forKey: Keys.vpnProtocol.rawValue) ?? DefaultConstants.vpnProtocol
        }
        set {
            storage.setEncodableValue(newValue, forKey: Keys.vpnProtocol.rawValue)
            postNotificationOnUIThread(PropertiesManager.vpnProtocolNotification, object: newValue)
        }
    }
    
    public var lastAppVersion: String {
        get {
            return storage.defaults.string(forKey: Keys.lastAppVersion.rawValue) ?? "0.0.0"
        }
        set {
            storage.setValue(newValue, forKey: Keys.lastAppVersion.rawValue)
        }
    }
    
    public var lastTimeForeground: Date? {
        get {
            guard let timeSince1970 = storage.defaults.value(forKey: Keys.lastTimeForeground.rawValue) as? Double else { return nil }
            return Date(timeIntervalSince1970: timeSince1970)
        }
        set {
            storage.setValue(newValue?.timeIntervalSince1970, forKey: Keys.lastTimeForeground.rawValue)
        }
    }
    
    public var featureFlags: FeatureFlags {
        get {
            return storage.getDecodableValue(FeatureFlags.self, forKey: Keys.featureFlags.rawValue) ?? FeatureFlags()
        }
        set {
            storage.setEncodableValue(newValue, forKey: Keys.featureFlags.rawValue)
            postNotificationOnUIThread(type(of: self).featureFlagsNotification, object: newValue)
        }
    }
    
    public var maintenanceServerRefreshIntereval: Int {
        get {
            if storage.contains(Keys.maintenanceServerRefreshIntereval.rawValue) {
                return storage.defaults.integer(forKey: Keys.maintenanceServerRefreshIntereval.rawValue)
            } else {
                return CoreAppConstants.Maintenance.defaultMaintenanceCheckTime
            }
        }
        set {
            storage.setValue(newValue, forKey: Keys.maintenanceServerRefreshIntereval.rawValue)
        }
    }
    
    public var vpnAcceleratorEnabled: Bool {
        get {
            return storage.defaults.object(forKey: Keys.vpnAcceleratorEnabled.rawValue) as? Bool ?? true
        }
        set {
            storage.setValue(newValue, forKey: Keys.vpnAcceleratorEnabled.rawValue)
            postNotificationOnUIThread(type(of: self).vpnAcceleratorNotification, object: newValue)
        }
    }

    public var discourageSecureCore: Bool {
        get {
            return storage.defaults.bool(forKey: Keys.discourageSecureCore.rawValue)
        }
        set {
            storage.setValue(newValue, forKey: Keys.discourageSecureCore.rawValue)
        }
    }

    public var newBrandModalShown: Bool {
        get {
            return storage.defaults.bool(forKey: Keys.newBrandModalShown.rawValue)
        }
        set {
            storage.setValue(newValue, forKey: Keys.newBrandModalShown.rawValue)
        }
    }
    
    public var killSwitch: Bool {
        get {
            return storage.defaults.bool(forKey: Keys.killSwitch.rawValue)
        }
        set {
            storage.setValue(newValue, forKey: Keys.killSwitch.rawValue)
            postNotificationOnUIThread(type(of: self).killSwitchNotification, object: newValue)
        }
    }
    
    public var excludeLocalNetworks: Bool {
        get {
            #if os(iOS)
            guard #available(iOS 14.2, *) else { return false }
            #endif
            return storage.defaults.bool(forKey: Keys.excludeLocalNetworks.rawValue)
        }
        set {
            storage.setValue(newValue, forKey: Keys.excludeLocalNetworks.rawValue)
            postNotificationOnUIThread(type(of: self).excludeLocalNetworksNotification, object: newValue)
        }
    }
        
    public var humanValidationFailed: Bool {
        get {
            return storage.defaults.bool(forKey: Keys.humanValidationFailed.rawValue)
        }
        set {
            storage.setValue(newValue, forKey: Keys.humanValidationFailed.rawValue)
        }
    }

    public var alternativeRouting: Bool {
        get {
            return storage.defaults.bool(forKey: Keys.alternativeRouting.rawValue)
        }
        set {
            storage.setValue(newValue, forKey: Keys.alternativeRouting.rawValue)
            onAlternativeRoutingChange?(newValue)
        }
    }

    public var smartProtocol: Bool {
        get {
            return storage.defaults.bool(forKey: Keys.smartProtocol.rawValue)
        }
        set {
            storage.setValue(newValue, forKey: Keys.smartProtocol.rawValue)
            postNotificationOnUIThread(type(of: self).smartProtocolNotification, object: newValue)
        }
    }

    private var _streamingServices: StreamingDictServices?
    public var streamingServices: StreamingDictServices {
        get {
            if let _streamingServices = _streamingServices {
                return _streamingServices
            }

            return storage.getDecodableValue(StreamingDictServices.self, forKey: Keys.streamingServices.rawValue) ?? StreamingDictServices()
        }
        set {
            _streamingServices = newValue
            storage.setEncodableValue(newValue, forKey: Keys.streamingServices.rawValue)
        }
    }
    
    public var streamingResourcesUrl: String? {
        get {
            return storage.defaults.string(forKey: Keys.streamingResourcesUrl.rawValue)
        }
        set {
            storage.setValue(newValue, forKey: Keys.streamingResourcesUrl.rawValue)
        }
    }

    public var connectionProtocol: ConnectionProtocol {
        return smartProtocol ? .smartProtocol : .vpnProtocol(vpnProtocol)
    }
    
    private let storage: Storage
        
    public init(storage: Storage) {
        self.storage = storage

        storage.defaults.register(defaults: [
            Keys.alternativeRouting.rawValue: true,
            Keys.excludeLocalNetworks.rawValue: true,
            Keys.smartProtocol.rawValue: true,
            Keys.discourageSecureCore.rawValue: true
        ])
    }
    
    public func logoutCleanup() {
        hasConnected = false
        secureCoreToggle = false
        discourageSecureCore = true
        lastIkeConnection = nil
        lastOpenVpnConnection = nil
        lastWireguardConnection = nil
        lastConnectedTimeStamp = -1
        trialWelcomed = false
        warnedTrialExpiring = false
        warnedTrialExpired = false
        reportBugEmail = nil
        alternativeRouting = true
        smartProtocol = true
        excludeLocalNetworks = true
        killSwitch = false
    }
    
    func postNotificationOnUIThread(_ name: NSNotification.Name, object: Any?, userInfo: [AnyHashable: Any]? = nil) {
        executeOnUIThread {
            NotificationCenter.default.post(name: name, object: object, userInfo: userInfo)
        }
    }
    
    public func getValue(forKey key: String) -> Bool {
        return storage.defaults.bool(forKey: key)
    }
    
    public func setValue(_ value: Bool, forKey key: String) {
        storage.setValue(value, forKey: key)
    }
}
