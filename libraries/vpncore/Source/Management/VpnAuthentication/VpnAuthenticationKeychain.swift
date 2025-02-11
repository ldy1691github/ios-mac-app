//
//  Created on 2022-04-21.
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
import KeychainAccess

public final class VpnAuthenticationKeychain: VpnAuthenticationStorage {
    private struct KeychainStorageKey {
        static let vpnKeys = "vpnKeys"
        static let vpnCertificate = "vpnCertificate"
    }

    private struct DefaultsStorageKey {
        static let vpnCertificateFeatures = "vpnCertificateFeatures"
    }

    private let appKeychain: KeychainAccess.Keychain
    private var storage: Storage
    public weak var delegate: VpnAuthenticationStorageDelegate?

    public typealias Factory = StorageFactory

    public convenience init(_ factory: Factory, accessGroup: String) {
        self.init(accessGroup: accessGroup,
                  storage: factory.makeStorage())
    }

    public init(accessGroup: String, storage: Storage) {
        appKeychain = KeychainAccess.Keychain(service: KeychainConstants.appKeychain,
                                              accessGroup: accessGroup)
            .accessibility(.afterFirstUnlockThisDeviceOnly)
        self.storage = storage
    }

    public func deleteKeys() {
        log.info("Deleting existing vpn authentication keys", category: .userCert)
        appKeychain[KeychainStorageKey.vpnKeys] = nil
        deleteCertificate()
    }

    public func deleteCertificate() {
        log.info("Deleting existing vpn authentication certificate", category: .userCert)
        appKeychain[KeychainStorageKey.vpnCertificate] = nil
        delegate?.certificateDeleted()
    }

    public func getKeys() -> VpnKeys {
        let keys: VpnKeys
        if let existingKeys = self.getStoredKeys() {
            log.info("Using existing vpn authentication keys", category: .userCert)
            keys = existingKeys
        } else {
            log.info("No vpn auth keys, generating and storing", category: .userCert)
            keys = VpnKeys()
            self.store(keys: keys)
        }

        return keys
    }

    public func getStoredCertificate() -> VpnCertificate? {
       do {
            guard let json = try appKeychain.getData(KeychainStorageKey.vpnCertificate) else {
                return nil
            }

            let certificate = try JSONDecoder().decode(VpnCertificate.self, from: json)
            return certificate
        } catch {
            log.error("Keychain (vpn) read error: \(error)", category: .userCert)
            return nil
        }
    }

    public func getStoredCertificateFeatures() -> VPNConnectionFeatures? {
        return storage.getDecodableValue(VPNConnectionFeatures.self, forKey: DefaultsStorageKey.vpnCertificateFeatures)
    }

    public func getStoredKeys() -> VpnKeys? {
        do {
            guard let json = try appKeychain.getData(KeychainStorageKey.vpnKeys) else {
                return nil
            }

            let keys = try JSONDecoder().decode(VpnKeys.self, from: json)
            return keys
        } catch {
            log.error("Keychain (vpn) read error: \(error)", category: .userCert)
            // If keys are broken then the certificate is also unusable, so just delete everything and start again
            deleteKeys()
            deleteCertificate()
            return nil
        }
    }

    public func store(keys: VpnKeys) {
        do {
            let data = try JSONEncoder().encode(keys)
            try appKeychain.set(data, key: KeychainStorageKey.vpnKeys)
        } catch {
            log.error("Saving generated vpn auth keyes failed \(error)", category: .userCert)
        }
    }

    public func store(certificate: VpnCertificateWithFeatures) {
        do {
            let data = try JSONEncoder().encode(certificate.certificate)
            try appKeychain.set(data, key: KeychainStorageKey.vpnCertificate)
            storage.setEncodableValue(certificate.features, forKey: DefaultsStorageKey.vpnCertificateFeatures)
            log.debug("Cert with features saved: \(String(describing: certificate.features))", category: .userCert)
            delegate?.certificateStored(certificate)
        } catch {
            log.error("Saving generated vpn auth keyes failed \(error)", category: .userCert)
        }
    }
}
