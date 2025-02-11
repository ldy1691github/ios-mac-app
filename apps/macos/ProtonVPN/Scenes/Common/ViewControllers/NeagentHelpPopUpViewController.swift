//
//  PopUpViewController.swift
//  ProtonVPN - Created on 27.06.19.
//
//  Copyright (c) 2019 Proton Technologies AG
//
//  This file is part of ProtonVPN.
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
//

import Cocoa
import vpncore

class NeagentHelpPopUpViewController: NSViewController {
    
    @IBOutlet weak var bodyView: NSView!
    @IBOutlet weak var descriptionLabel: NSTextField!
    @IBOutlet weak var footerView: NSView!
    @IBOutlet weak var confirmationButton: PrimaryActionButton!
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported initializer")
    }
    
    required init() {
        super.init(nibName: NSNib.Name("NeagentHelpPopUp"), bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBody()
        setupFooter()
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        view.window?.applyWarningAppearance(withTitle: LocalizedString.protonvpnMacos)
    }
    
    private func setupBody() {
        bodyView.wantsLayer = true
        bodyView.layer?.backgroundColor = .cgColor(.background, .weak)
        
        let fontSize: CGFloat = 21
        let lightFont = NSFont.systemFont(ofSize: fontSize, weight: .light)
        let semiboldFont = NSFont.systemFont(ofSize: fontSize, weight: .semibold)
        let interactiveColor: NSColor = .color(.text, [.interactive, .active])
        
        let text = LocalizedString.neagentDescription(
                          LocalizedString.neagentPassword,
                          LocalizedString.macPassword,
                          LocalizedString.neagentFirstStep,
                          LocalizedString.neagentAlwaysAllow,
                          LocalizedString.neagentSecondStep)
        let description: NSMutableAttributedString = NSMutableAttributedString(attributedString: text.styled(font: lightFont))
        
        let fullRange = (text as NSString).range(of: text)
        let passwordRange = (text as NSString).range(of: LocalizedString.neagentPassword)
        let passwordStepRange = (text as NSString).range(of: LocalizedString.macPassword, options: .backwards)
        let firstStepRange = (text as NSString).range(of: LocalizedString.neagentFirstStep)
        let alwaysAllowRange = (text as NSString).range(of: LocalizedString.neagentAlwaysAllow)
        let secondStepRange = (text as NSString).range(of: LocalizedString.neagentSecondStep)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineSpacing = 10
        
        description.addAttribute(.paragraphStyle, value: paragraphStyle, range: fullRange)
        description.addAttribute(.font, value: semiboldFont, range: passwordRange)
        description.addAttribute(.foregroundColor, value: interactiveColor, range: passwordStepRange)
        description.addAttribute(.font, value: semiboldFont, range: passwordStepRange)
        description.addAttribute(.foregroundColor, value: interactiveColor, range: firstStepRange)
        description.addAttribute(.foregroundColor, value: interactiveColor, range: alwaysAllowRange)
        description.addAttribute(.font, value: semiboldFont, range: alwaysAllowRange)
        description.addAttribute(.foregroundColor, value: interactiveColor, range: secondStepRange)
        
        descriptionLabel.attributedStringValue = description
    }
    
    private func setupFooter() {
        footerView.wantsLayer = true
        footerView.layer?.backgroundColor = .cgColor(.background, .weak)
        
        confirmationButton.title = LocalizedString.gotIt
        confirmationButton.fontSize = .paragraph
    }
    
    @IBAction func confirmButtonAction(_ sender: Any) {
        dismiss(nil)
    }
}
