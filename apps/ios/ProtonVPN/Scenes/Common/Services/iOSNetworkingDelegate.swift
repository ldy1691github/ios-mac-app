//
//  iOSNetworkingDelegate.swift
//  ProtonVPN
//
//  Created by Igor Kulman on 24.08.2021.
//  Copyright © 2021 Proton Technologies AG. All rights reserved.
//

import Foundation
import vpncore
import Crypto_VPN
import ProtonCore_DataModel
import ProtonCore_Networking
import ProtonCore_Services
import ProtonCore_ForceUpgrade
import ProtonCore_HumanVerification

final class iOSNetworkingDelegate: NetworkingDelegate {
    private let forceUpgradeService: ForceUpgradeDelegate
    private var humanVerify: HumanVerifyDelegate?
    private let alertingService: CoreAlertService

    init(alertingService: CoreAlertService) {
        self.forceUpgradeService = ForceUpgradeHelper(config: .mobile(URL(string: URLConstants.appStoreUrl)!))
        self.alertingService = alertingService
    }

    func set(apiService: APIService) {
        humanVerify = HumanCheckHelper(apiService: apiService, supportURL: getSupportURL(), clientApp: ClientApp.vpn, versionToBeUsed: version)
    }

    func onLogout() {
        alertingService.push(alert: RefreshTokenExpiredAlert())
    }
}

extension iOSNetworkingDelegate {
    func onHumanVerify(parameters: HumanVerifyParameters, currentURL: URL?, error: NSError, completion: (@escaping (HumanVerifyFinishReason) -> Void)) {
        humanVerify?.onHumanVerify(parameters: parameters, currentURL: currentURL, error: error, completion: completion)
    }

    func getSupportURL() -> URL {
        return URL(string: CoreAppConstants.ProtonVpnLinks.support)!
    }
}

extension iOSNetworkingDelegate {
    func onForceUpgrade(message: String) {
        forceUpgradeService.onForceUpgrade(message: message)
    }
}
