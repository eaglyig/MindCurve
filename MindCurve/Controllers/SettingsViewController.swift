//
//  SettingsViewController.swift
//  MindCurve
//
//  Created by Ihor Orlenko on 22.08.2023.
//

import UIKit

class SettingsViewController: UIViewController {

    let appearanceLabel = UILabel()
    let appearanceSwitcher = UISwitch()
    let appearanceStack = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setUpAppearanceStack()
    }
    
    func setUpView() {
        view.backgroundColor = .systemBackground
        self.navigationItem.title = "Settings"
    }
    
    func setUpAppearanceStack() {
        appearanceLabel.text = "Dark mode appearance"
        
        appearanceLabel.translatesAutoresizingMaskIntoConstraints = false
        appearanceStack.addArrangedSubview(appearanceLabel)
        
        appearanceSwitcher.translatesAutoresizingMaskIntoConstraints = false
        appearanceSwitcher.addTarget(self, action: #selector(appearanceShouldBeSwitched), for: .valueChanged)
        appearanceStack.addArrangedSubview(appearanceSwitcher)
        
        appearanceStack.axis = .horizontal
        appearanceStack.distribution = .fill
        appearanceStack.alignment = .center
        appearanceStack.spacing = 16
        appearanceStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(appearanceStack)
        
        NSLayoutConstraint.activate([
            appearanceStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            appearanceStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            appearanceStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }
    
    @objc func appearanceShouldBeSwitched() {
        if appearanceSwitcher.isOn {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                windowScene.windows.forEach { window in
                    window.overrideUserInterfaceStyle = .dark
                }
            }
        } else {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                windowScene.windows.forEach { window in
                    window.overrideUserInterfaceStyle = .light
                }
            }
        }
    }

}
