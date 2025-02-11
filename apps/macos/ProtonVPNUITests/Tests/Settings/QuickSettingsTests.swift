//
//  Created on 2022-02-15.
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
import XCTest

class QuickSettingsTests: ProtonVPNUITests {
    
    private let quickSettingsRobot = QuickSettingsRobot()
    
    override func setUp() {
        super.setUp()
    }
    
    func testOpenQuickSettingsDropdown() {
        
        logoutIfNeeded()
        loginAsPlusUser()
        quickSettingsRobot
            .secureCoreDropdown()
            .verify.checkDropdownIsOpen()
            .netShiedlDropdown()
            .verify.checkDropdownIsOpen()
            .killSwitchDropdown()
            .verify.checkDropdownIsOpen()
    }
    
    func testSecureCoreAndNetshieldAreNotAvailableForFreeUser() {
        
        logoutIfNeeded()
        loginAsFreeUser()
        quickSettingsRobot
            .secureCoreDropdown()
            .verify.checkDropdownIsOpen()
            .verify.checkUpgradeRequired()
            .upgradeFeature()
            .verify.checkUpsellModalIsOpen()
            .closeUpsellModal()
            .netShiedlDropdown()
            .verify.checkDropdownIsOpen()
            .verify.checkUpgradeRequired()
            .upgradeFeature()
            .verify.checkUpsellModalIsOpen()
    }
}
