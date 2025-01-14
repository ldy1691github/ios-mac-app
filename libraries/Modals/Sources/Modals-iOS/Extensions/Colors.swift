//
//  Created on 2/8/22.
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

import UIKit

var colors: ModalsColors!

public protocol ModalsColors {
    var background: UIColor { get }
    var secondaryBackground: UIColor { get }
    var text: UIColor { get }
    var textAccent: UIColor { get }
    var brand: UIColor { get }
    var weakText: UIColor { get }
    var weakInteraction: UIColor { get }
}

public struct Colors {
    public let background: UIColor
    public let secondaryBackground: UIColor
    public let text: UIColor
    public let textAccent: UIColor
    public let brand: UIColor
    public let weakText: UIColor
    public let weakInteraction: UIColor

    public init(background: UIColor, secondaryBackground: UIColor, text: UIColor, textAccent: UIColor, brand: UIColor, weakText: UIColor, weakInteraction: UIColor) {
        self.background = background
        self.secondaryBackground = secondaryBackground
        self.text = text
        self.textAccent = textAccent
        self.brand = brand
        self.weakText = weakText
        self.weakInteraction = weakInteraction
    }
}

extension Colors: ModalsColors { }
