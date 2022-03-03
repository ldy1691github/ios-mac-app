//
//  Created on 2022-01-12.
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

var window: XCUIElement!

fileprivate let preferencesTitleId = "Preferences"
fileprivate let generalTab = "General"
fileprivate let connectionTab = "Connection"
fileprivate let accountTab = "Account"
fileprivate let modalTitle = "Allow LAN connections"
fileprivate let autoConnectFastest = "  Fastest"
fileprivate let notNowButton = "Not now"
fileprivate let continueButton = "Continue"
fileprivate let modalDescribtion = "In order to allow LAN access, Kill Switch must be turned off.\n\nContinue?"
// Map
fileprivate let showMapButton = "Show map"
fileprivate let hideMapButton = "Hide map"
fileprivate let statusDisconnected = "DISCONNECTED"
fileprivate let homeImage = "home"

class SettingsRobot {
    
    func generalTabClick() -> SettingsRobot {
        app.tabGroups[generalTab].click()
        return SettingsRobot()
    }
    
    @discardableResult
    func connectionTabClick() -> SettingsRobot {
        app.tabGroups[connectionTab].click()
        return SettingsRobot()
    }
    
    @discardableResult
    func accountTabClick() -> SettingsRobot {
        app.tabGroups[accountTab].click()
        return SettingsRobot()
    }
    
    @discardableResult
    func notNowClick() -> SettingsRobot {
        app.buttons[notNowButton].click()
        return SettingsRobot()
    }
    
    @discardableResult
    func continueClick() -> SettingsRobot {
        app.buttons[continueButton].click()
        return SettingsRobot()
    }
    
    func closeSettings() -> MainRobot {
        let preferencesWindow = app.windows["Preferences"]
        preferencesWindow.buttons[XCUIIdentifierCloseWindow].click()
        return MainRobot()
    }
    
    func selectAutoConnect(_ autoConnect: String) -> SettingsRobot {
        app.popUpButtons[autoConnect].click()
        app.popUpButtons[autoConnect].click()
        return SettingsRobot()
    }
    
    func selectQuickConnect(_ qc: String) -> SettingsRobot {
        app.popUpButtons[qc].click()
        return SettingsRobot()
    }
    
    // Map
    func showMapClick() -> SettingsRobot {
        app.buttons[showMapButton].click()
        return SettingsRobot()
    }
    
    func hideMapClick() -> SettingsRobot {
        app.buttons[hideMapButton].click()
        return SettingsRobot()
    }
    
    let verify = Verify()
    
    class Verify {
                    
        @discardableResult
        func checkSettingsIsOpen() -> SettingsRobot {
            XCTAssertTrue(app.staticTexts[preferencesTitleId].exists)
            return SettingsRobot()
        }
        
        @discardableResult
        func checkProfileIsCreated(_ name: String) -> SettingsRobot {
            XCTAssertTrue(app.menuItems[name].exists)
            return SettingsRobot()
        }
        
        @discardableResult
        func checkGeneralTabIsOpen() -> SettingsRobot {
            XCTAssertTrue(app.staticTexts["Start on Boot"].exists)
            return SettingsRobot()
        }
        
        @discardableResult
        func checkConnectionTabIsOpen() -> SettingsRobot {
            XCTAssertTrue(app.staticTexts["Auto Connect"].exists)
            return SettingsRobot()
        }
        
        @discardableResult
        func checkAccountTabIsOpen() -> SettingsRobot {
            XCTAssertTrue(app.staticTexts["Username"].exists)
            return SettingsRobot()
        }
        
        @discardableResult
        func checkModalIsOpen() -> SettingsRobot {
            XCTAssert(app.staticTexts[modalTitle].waitForExistence(timeout: 5))
            XCTAssert(app.staticTexts[modalDescribtion].waitForExistence(timeout: 5))
            return SettingsRobot()
        }
        
        @discardableResult
        func checkLanIsOff() -> SettingsRobot {
            return SettingsRobot()
        }
        
        @discardableResult
        func checkLanIsOn() -> SettingsRobot {
            return SettingsRobot()
        }
        
        // Map
        @discardableResult
        func checkMapIsOpen() -> SettingsRobot {
            XCTAssertTrue(app.buttons[hideMapButton].exists)
            XCTAssertTrue(app.staticTexts[statusDisconnected].waitForExistence(timeout: 2))
            XCTAssertTrue(app.images[homeImage].exists)
            return SettingsRobot()
        }
        
        @discardableResult
        func checkMapIsHidden() -> SettingsRobot {
            XCTAssertTrue(app.buttons[showMapButton].waitForExistence(timeout: 2))
            XCTAssertFalse(app.staticTexts[statusDisconnected].waitForExistence(timeout: 2))
            XCTAssertFalse(app.images[homeImage].exists)
            return SettingsRobot()
        }
    }
}
