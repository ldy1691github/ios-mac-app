//
//  VpnGatewayMock.swift
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

public class VpnGatewayMock: VpnGatewayProtocol {
    public static var connectionChanged: Notification.Name = Notification.Name("")
    public static var activeServerTypeChanged: Notification.Name = Notification.Name("")
    public static var needsReconnectNotification: Notification.Name = Notification.Name("")
    
    public init(propertiesManager: PropertiesManagerProtocol, activeServerType: ServerType, connection: ConnectionStatus) {
        self.connection = connection
        self.activeServerType = activeServerType
        
        propertiesManager.secureCoreToggle = activeServerType == .secureCore
    }
    
    public var connection: ConnectionStatus
    public var activeIp: String?
    public var activeServer: ServerModel?
    public var lastConnectionRequest: ConnectionRequest?
    public var activeServerType: ServerType
    
    private var _userTier: Int = 0
    
    public func userTier() throws -> Int {
        return _userTier
    }
    
    public func changeActiveServerType(_ serverType: ServerType) {
        self.activeServerType = serverType
    }
    
    public func autoConnect() {

    }
    
    public func quickConnect() {
        
    }
    
    public func quickConnectConnectionRequest() -> ConnectionRequest {
        return ConnectionRequest(serverType: .standard, connectionType: .fastest, connectionProtocol: .smartProtocol, netShieldType: .off, natType: .default, safeMode: true, profileId: nil)
    }
    
    public func connectTo(country countryCode: String, ofType serverType: ServerType) {
        
    }
    
    public func connectTo(server: ServerModel) {
        
    }
    
    public func connectTo(profile: Profile) {
        
    }
    
    public func retryConnection() {
        
    }
    
    public func connect(with request: ConnectionRequest?) {
        
    }

    public func connectTo(country countryCode: String, city: String) {
        
    }
    
    public func stopConnecting(userInitiated: Bool) {
        connection = .disconnected
    }
    
    public func disconnect() {
        connection = .disconnected
    }
    
    public func disconnect(completion: @escaping () -> Void) {
        connection = .disconnected
        completion()
    }
    
    public func reconnect(with netShieldType: NetShieldType) {
        
    }

    public func reconnect(with natType: NATType) {
        
    }
    
    public func reconnect(with connectionProtocol: ConnectionProtocol) {
        
    }

    public func postConnectionInformation() {

    }
}
