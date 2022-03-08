//
//  Created on 10/02/2022.
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

import Modals
import Modals_iOS
import UIKit

class ViewController: UITableViewController {
    
    let upsells: [(type: UpsellType, title: String)] = [(.allCountries(numberOfDevices: 10, numberOfServers: 1300, numberOfCountries: 61), "All countries"),
                                                        (.secureCore, "Secure Core"),
                                                        (.netShield, "Net Shield"),
                                                        (.safeMode, "Safe Mode"),
                                                        (.moderateNAT, "Moderate NAT")]

    let modalsFactory = ModalsFactory(colors: Colors())

    override func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return upsells.count
        case 1:
            return 1
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ModalTableViewCell", for: indexPath)

        let title: String
        if indexPath.section == 0 {
            title = upsells[indexPath.row].title
        } else {
            title = "Discourage Secure Core"
        }

        if let modalCell = cell as? ModalTableViewCell {
            modalCell.modalTitle.text = title
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController: UIViewController
        if indexPath.section == 0 {
            let modalVC = modalsFactory.upsellViewController(upsellType: upsells[indexPath.row].type)
            modalVC.delegate = self
            viewController = modalVC
        } else {
            let modalVC = modalsFactory.discourageSecureCoreViewController(onDontShowAgain: nil,
                                                                           onActivate: nil,
                                                                           onCancel: nil,
                                                                           onLearnMore: nil)
            viewController = modalVC
        }

        present(viewController, animated: true, completion: nil)
    }
}

extension ViewController: UpsellViewControllerDelegate {
    func userDidRequestPlus() {
        dismiss(animated: true, completion: nil)
    }
    
    func userDidDismissUpsell() {
        dismiss(animated: true, completion: nil)
    }
}

struct Colors: ModalsColors {
    var background: UIColor
    var text: UIColor
    var brand: UIColor
    var weakText: UIColor
    
    init() {
        background = UIColor(red: 23/255, green: 24/255, blue: 28/255, alpha: 1)
        text = .white
        brand = UIColor(red: 77/255, green: 163/255, blue: 88/255, alpha: 1)
        weakText = UIColor(red: 156/255, green: 160/255, blue: 170/255, alpha: 1)
    }
}
