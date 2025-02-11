//
//  ConnectionSettingsViewController.swift
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

final class ConnectionSettingsViewController: NSViewController, ReloadableViewController {
    
    fileprivate enum SwitchButtonOption: Int {
        case killSwitch
    }

    @IBOutlet private weak var autoConnectView: SettingsDropDownView!
    @IBOutlet private weak var quickConnectView: SettingsDropDownView!
    @IBOutlet private weak var protocolView: SettingsDropDownView!

    @IBOutlet private weak var vpnAcceleratorView: SettingsTickboxView!
    @IBOutlet private weak var dnsLeakProtectionView: SettingsTickboxView!
    @IBOutlet private weak var allowLANView: SettingsTickboxView!

    private var viewModel: ConnectionSettingsViewModel
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported initializer")
    }
    
    required init(viewModel: ConnectionSettingsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: NSNib.Name("ConnectionSettings"), bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.reloadNeeded = { [weak self] in
            self?.reloadView()
        }
        reloadView()
    }
    
    private func setupView() {
        view.wantsLayer = true
        view.layer?.backgroundColor = .cgColor(.background, .weak)
    }
    
    private func setupAutoConnectItem() {
        let count = viewModel.autoConnectItemCount
        let menuItems: [NSMenuItem] = (0..<count).map { index in
            let menuItem = NSMenuItem()
            menuItem.attributedTitle = viewModel.autoConnectItem(for: index)
            return menuItem
        }

        let model = SettingsDropDownView.ViewModel(labelText: LocalizedString.autoConnect, toolTip: LocalizedString.autoConnectTooltip, progressIndicatorToolTip: nil, menuItems: menuItems, selectedIndex: viewModel.autoConnectProfileIndex)

        autoConnectView.setupItem(model: model, target: self, action: #selector(autoConnectItemSelected))
    }
    
    private func setupQuickConnectItem() {
        let count = viewModel.quickConnectItemCount
        let menuItems: [NSMenuItem] = (0..<count).map { index in
            let menuItem = NSMenuItem()
            menuItem.attributedTitle = viewModel.quickConnectItem(for: index)
            return menuItem
        }

        let model = SettingsDropDownView.ViewModel(labelText: LocalizedString.quickConnect, toolTip: LocalizedString.quickConnectTooltip, progressIndicatorToolTip: nil, menuItems: menuItems, selectedIndex: viewModel.quickConnectProfileIndex)

        quickConnectView.setupItem(model: model, target: self, action: #selector(quickConnectItemSelected))
    }
    
    private func setupProtocolItem() {
        let count = viewModel.protocolItemCount
        let menuItems: [NSMenuItem] = (0..<count).map { index in
            let menuItem = NSMenuItem()
            menuItem.attributedTitle = viewModel.protocolString(for: viewModel.protocolItem(for: index) ?? .vpnProtocol(.ike))
            return menuItem
        }

        let model = SettingsDropDownView.ViewModel(labelText: LocalizedString.protocol, toolTip: LocalizedString.smartProtocolDescription, progressIndicatorToolTip: LocalizedString.sysexSettingsDescription, menuItems: menuItems, selectedIndex: viewModel.protocolProfileIndex)

        protocolView.setupItem(model: model, target: self, action: #selector(protocolItemSelected))

        refreshPendingEnablement()
    }
    
    private func setupVpnAcceleratorItem() {
        vpnAcceleratorView.isHidden = !viewModel.isAcceleratorFeatureEnabled
        let toolTip = LocalizedString.vpnAcceleratorDescription
            .replacingOccurrences(of: LocalizedString.vpnAcceleratorDescriptionAltLink, with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)

        let model = SettingsTickboxView.ViewModel(labelText: LocalizedString.vpnAcceleratorTitle, buttonState: viewModel.vpnAcceleratorEnabled, toolTip: String(toolTip))
        vpnAcceleratorView.setupItem(model: model, delegate: self)
    }
    
    private func setupDnsLeakProtectionItem() {
        let model = SettingsTickboxView.ViewModel(labelText: LocalizedString.dnsLeakProtection, buttonState: true, buttonEnabled: false, toolTip: LocalizedString.dnsLeakProtectionTooltip)
        dnsLeakProtectionView.setupItem(model: model, delegate: self)
    }

    private func setupAllowLANItem() {
        let model = SettingsTickboxView.ViewModel(labelText: LocalizedString.allowLanTitle, buttonState: viewModel.allowLAN, toolTip: LocalizedString.allowLanInfo)
        allowLANView.setupItem(model: model, delegate: self)
    }

    private func refreshPendingEnablement() {
        if viewModel.shouldShowSysexProgress(for: protocolView.indexOfSelectedItem()) {
            protocolView.startProgressIndicatorAnimation()
        } else {
            protocolView.stopProgressIndicatorAnimation()
        }
    }
    
    // MARK: - ReloadableViewController
    
    func reloadView() {
        setupView()
        setupAutoConnectItem()
        setupQuickConnectItem()
        setupVpnAcceleratorItem()
        setupProtocolItem()
        setupDnsLeakProtectionItem()
        setupAllowLANItem()
    }
    
    // MARK: - Actions
    
    @objc private func autoConnectItemSelected() {
        do {
            try viewModel.setAutoConnect(autoConnectView.indexOfSelectedItem())
        } catch {
            setupAutoConnectItem()
        }
    }
    
    @objc private func quickConnectItemSelected() {
        do {
            try viewModel.setQuickConnect(quickConnectView.indexOfSelectedItem())
        } catch {
            setupQuickConnectItem()
        }
    }
    
    @objc private func protocolItemSelected() {
        guard let protocolItem = viewModel.protocolItem(for: protocolView.indexOfSelectedItem()) else {
            return
        }

        viewModel.refreshSysexPending(for: protocolItem)
        refreshPendingEnablement()

        viewModel.setProtocol(protocolItem) { [weak self] result in
            executeOnUIThread {
                self?.setupProtocolItem()
            }
        }
    }
}

extension ConnectionSettingsViewController: TickboxViewDelegate {
    func toggleTickbox(_ tickboxView: SettingsTickboxView, to value: ButtonState) {
        switch tickboxView {
        case allowLANView:
            viewModel.setAllowLANAccess(value == .on, completion: { [weak self] _ in
                self?.setupAllowLANItem()
            })
        case vpnAcceleratorView:
            viewModel.setVpnAccelerator(value == .on, completion: { [weak self] _ in
                self?.setupVpnAcceleratorItem()
            })
        default:
            break
        }
    }
}
