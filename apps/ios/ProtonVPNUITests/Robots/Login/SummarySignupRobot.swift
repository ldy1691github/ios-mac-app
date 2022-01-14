//
//  Created on 2021-12-21.
//
//  Copyright (c) 2021 Proton AG
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

import pmtest

fileprivate let summaryTitle = "SummaryViewController.header"
fileprivate let summaryDescription = "SummaryViewController.descriptionLabel"
fileprivate let summaryWelcome = "SummaryViewController.welcomeLabel"
fileprivate let summaryButton = "Start using ProtonVPN"

class SummarySignupRobot: CoreElements {
    
    public let verify = Verify()
    
    func startUsingProtonVpn() -> MainRobot {
        staticText(summaryButton).tap()
        return MainRobot()
    }
    
    class Verify: CoreElements {
        
        @discardableResult
        func summaryScreenIsShown() -> SummarySignupRobot {
            staticText(summaryTitle).wait(time: 10).checkExists()
            staticText(summaryDescription).wait(time: 10).checkExists()
            staticText(summaryWelcome).wait(time: 10).checkExists()
            return SummarySignupRobot()
        }
    }
}
