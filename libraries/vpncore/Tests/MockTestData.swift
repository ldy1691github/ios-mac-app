//
//  Created on 2022-07-13.
//
//  Copyright (c) 2022 Proton AG
//
//  ProtonVPN is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  ProtonVPN is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with ProtonVPN.  If not, see <https://www.gnu.org/licenses/>.

import Foundation
@testable import vpncore

struct MockTestData {
    struct VPNLocationResponse: Codable, Equatable {
        let ip: String
        let country: String
        let isp: String

        enum CodingKeys: String, CodingKey {
            case ip = "IP"
            case country = "Country"
            case isp = "ISP"
        }
    }

    var vpnLocation = VPNLocationResponse(ip: "123.123.123.123", country: "USA", isp: "GreedyCorp, Inc.")

    /// free server with relatively high latency score and not under maintenance.
    var server1 = ServerModel(id: "abcd",
                              name: "free server",
                              domain: "swiss.protonvpn.ch",
                              load: 15,
                              entryCountryCode: "CH",
                              exitCountryCode: "CH",
                              tier: CoreAppConstants.VpnTiers.free,
                              feature: .zero,
                              city: "Palézieux",
                              ips: [.init(id: "abcd", entryIp: "10.0.0.1", exitIp: "10.0.0.2",
                                          domain: "swiss.protonvpn.ch", status: 1,
                                          x25519PublicKey: "this is a public key".data(using: .utf8)!.base64EncodedString())],
                              score: 50,
                              status: 1, // 0 == under maintenance
                              location: ServerLocation(lat: 46.33, long: 6.5),
                              hostCountry: "Switzerland",
                              translatedCity: "Not The Eyes")

    /// free server with relatively low latency score and not under maintenance.
    var server2 = ServerModel(id: "efgh",
                              name: "other free server",
                              domain: "swiss2.protonvpn.ch",
                              load: 80,
                              entryCountryCode: "CH",
                              exitCountryCode: "CH",
                              tier: CoreAppConstants.VpnTiers.free,
                              feature: .zero,
                              city: "Gland",
                              ips: [.init(id: "efgh", entryIp: "10.0.0.3", exitIp: "10.0.0.4",
                                          domain: "swiss2.protonvpn.ch", status: 1,
                                          x25519PublicKey: "this is another public key".data(using: .utf8)!.base64EncodedString())],
                              score: 15,
                              status: 1,
                              location: ServerLocation(lat: 46.25, long: 6.16),
                              hostCountry: "Switzerland",
                              translatedCity: "Anatomy")

    /// same server as server 2, but placed under maintenance.
    var server2UnderMaintenance = ServerModel(
                              id: "efgh",
                              name: "other free server",
                              domain: "swiss2.protonvpn.ch",
                              load: 80,
                              entryCountryCode: "CH",
                              exitCountryCode: "CH",
                              tier: CoreAppConstants.VpnTiers.free,
                              feature: .zero,
                              city: "Gland",
                              ips: [.init(id: "efgh", entryIp: "10.0.0.3", exitIp: "10.0.0.4",
                                          domain: "swiss2.protonvpn.ch", status: 0,
                                          x25519PublicKey: "this is another public key".data(using: .utf8)!.base64EncodedString())],
                              score: 15,
                              status: 0, // under maintenance
                              location: ServerLocation(lat: 46.25, long: 6.16),
                              hostCountry: "Switzerland",
                              translatedCity: "Anatomy")

    /// plus server with low latency score and p2p feature. not under maintenance.
    var server3 = ServerModel(id: "ijkl",
                              name: "plus server",
                              domain: "swissplus.protonvpn.ch",
                              load: 42,
                              entryCountryCode: "CH",
                              exitCountryCode: "CH",
                              tier: CoreAppConstants.VpnTiers.plus,
                              feature: .zero,
                              city: "Zurich",
                              ips: [.init(id: "ijkl", entryIp: "10.0.0.5", exitIp: "10.0.0.6",
                                          domain: "swissplus.protonvpn.ch", status: 1,
                                          x25519PublicKey: "plus public key".data(using: .utf8)!.base64EncodedString())],
                              score: 10,
                              status: 1,
                              location: .init(lat: 47.22, long: 8.32),
                              hostCountry: "Switzerland",
                              translatedCity: nil)

    var defaultClientConfig = ClientConfig(openVPNConfig: .init(defaultTcpPorts: [1234, 5678],
                                                                defaultUdpPorts: [2345, 6789]),
                                           featureFlags: .allEnabled,
                                           serverRefreshInterval: 2 * 60,
                                           wireGuardConfig: .init(defaultUdpPorts: [12345, 65432],
                                                                  defaultTcpPorts: [12346, 65433]),
                                           smartProtocolConfig: .init(),
                                           ratingSettings: .init())

    lazy var clientConfigNoWireGuardTls = defaultClientConfig.withFeatureFlags(.wireGuardTlsDisabled)
}

extension ClientConfig {
    func withFeatureFlags(_ featureFlags: FeatureFlags) -> ClientConfig {
        return ClientConfig(openVPNConfig: openVPNConfig,
                            featureFlags: featureFlags,
                            serverRefreshInterval: serverRefreshInterval,
                            wireGuardConfig: wireGuardConfig,
                            smartProtocolConfig: smartProtocolConfig,
                            ratingSettings: ratingSettings)
    }
}

extension FeatureFlags {
    static let allEnabled: Self = .init(smartReconnect: true,
                                        vpnAccelerator: true,
                                        netShield: true,
                                        streamingServicesLogos: true,
                                        portForwarding: true,
                                        moderateNAT: true,
                                        pollNotificationAPI: true,
                                        serverRefresh: true,
                                        guestHoles: true,
                                        safeMode: true,
                                        promoCode: true,
                                        wireGuardTls: true)

    static let wireGuardTlsDisabled: Self = .init(smartReconnect: true,
                                                  vpnAccelerator: true,
                                                  netShield: true,
                                                  streamingServicesLogos: true,
                                                  portForwarding: true,
                                                  moderateNAT: true,
                                                  pollNotificationAPI: true,
                                                  serverRefresh: true,
                                                  guestHoles: true,
                                                  safeMode: true,
                                                  promoCode: true,
                                                  wireGuardTls: false)
}
