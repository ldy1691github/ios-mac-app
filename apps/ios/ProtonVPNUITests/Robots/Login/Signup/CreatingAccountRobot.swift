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

fileprivate let titleId = "CompleteViewController.completeTitleLabel"
fileprivate let subtitle = "CompleteViewController.completeDescriptionLabel"
fileprivate let creatingAccount = "Creating your account"
fileprivate let configuringAccess = "Configuring your VPN access"

class CreatingAccountRobot: CoreElements {
    
    public let verify = Verify()
    
    class Verify: CoreElements {
        
        @discardableResult
        func creatingAccountScreenIsShown() -> SummarySignupRobot {
            staticText(titleId).wait(time:40).checkExists()
            staticText(subtitle).wait(time:40).checkExists()
            staticText(creatingAccount).wait(time:40).checkExists()
            staticText(configuringAccess).wait(time:40).checkExists()
            return SummarySignupRobot()
        }
    }
}
