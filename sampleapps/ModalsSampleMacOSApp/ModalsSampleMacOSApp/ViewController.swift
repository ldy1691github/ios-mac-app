//
//  Created on 16/02/2022.
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

import Cocoa
import Modals
import Modals_macOS

class ViewController: NSViewController {

    enum Modal {
        case upsell(UpsellType)
        case discourageSecureCore
        case newBrand
    }

    let modals: [(type: Modal, title: String)] = [(.upsell(.allCountries(numberOfDevices: 10,
                                                                         numberOfServers: 1300,
                                                                         numberOfCountries: 61)), "All countries"),
                                                  (.upsell(.secureCore), "Secure Core"),
                                                  (.upsell(.netShield), "Net Shield"),
                                                  (.upsell(.safeMode), "Safe Mode"),
                                                  (.upsell(.moderateNAT), "Moderate NAT"),
                                                  (.discourageSecureCore, "Discourage Secure Core"),
                                                  (.newBrand, "New Brand")]

    let factory = ModalsFactory(colors: Colors())

    @IBOutlet weak var tableView: NSTableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
}

extension ViewController: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        let modal = modals[row]
        let viewController: NSViewController
        switch modal.type {
        case .upsell(let type):
            viewController = factory.upsellViewController(upsellType: type, upgradeAction: { }, learnMoreAction: { })
        case .discourageSecureCore:
            viewController = factory.discourageSecureCoreViewController(onDontShowAgain: nil, onActivate: nil, onCancel: nil, onLearnMore: nil)
        case .newBrand:
            viewController = factory.newBrandViewController(icons: ModalIcons(), onReadMore: nil)
        }

        presentAsModalWindow(viewController)
        return true
    }
}

extension ViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        modals.count
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let modal = modals[row]

        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "ModalNameCellView"), owner: nil) as? NSTableCellView {
              cell.textField?.stringValue = modal.title
              return cell
            }
        return nil
    }
}

struct Colors: ModalsColors {

    var background: NSColor
    var text: NSColor
    var brand: NSColor
    var hoverBrand: NSColor
    var weakText: NSColor
    var linkNorm: NSColor

    init() {
        background = NSColor(red: 28/255, green: 27/255, blue: 36/255, alpha: 1)
        text = .white
        brand = NSColor(red: 109/255, green: 74/255, blue: 255/255, alpha: 1)
        hoverBrand = NSColor(red: 124/255, green: 92/255, blue: 255/255, alpha: 1)
        weakText = NSColor(red: 167/255, green: 164/255, blue: 181/255, alpha: 1)
        linkNorm = NSColor(red: 124/255, green: 92/255, blue: 255/255, alpha: 1)
    }
}

struct ModalIcons: NewBrandIcons {
    let vpnMain: Image
    let driveMain: Image
    let calendarMain: Image
    let mailMain: Image

    init() {
        vpnMain = NSImage(named: "VPNMain")!
        driveMain = NSImage(named: "DriveMain")!
        calendarMain = NSImage(named: "CalendarMain")!
        mailMain = NSImage(named: "MailMain")!
    }
}
