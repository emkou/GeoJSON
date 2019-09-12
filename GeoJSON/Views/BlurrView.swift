//
//  BlurrView.swift
//  GeoJSON
//
//  Created by Emil Doychinov on 6/30/19.
//  Copyright © 2019 Emil Doychinov. All rights reserved.
//

import UIKit

class BlurrView: UIView {
    
    let button: UIButton = {
        let button = UIButton(frame: .zero)
        button.addTarget(self, action: #selector(didPressButton), for: .touchUpInside)
        button.setTitleColor(.blue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderColor = UIColor.gray.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 8
        button.isHidden = true
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
        translatesAutoresizingMaskIntoConstraints  = false
    
        //button
        addSubview(button)
        
        //CONSTRAINTS
        //button
        button.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        button.widthAnchor.constraint(equalToConstant: 300).isActive = true
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    func addToView(view: UIView) {
        //blur viea
        let blurEffect = UIBlurEffect(style: .extraLight)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.frame = view.bounds
        addSubview(blurredEffectView)
        
        //superview
        view.addSubview(self)
        
        //CONSTRAINTS
        
        //self
        self.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        self.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    @objc private  func didPressButton() {
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
    }
    
    func hide() {
        isHidden = true
    }
    
    func showError(error: LocationError) {
        button.isHidden = false
        
        switch error {
        case .deniedPermission:
            button.setTitle("Location denied, enable in Settings", for: .normal)
        case .disabledServices:
            button.setTitle("Disabled services, enable in Settings", for: .normal)
        case .failedLocation:
            button.setTitle("Failed location, check services", for: .normal)
        }

    }
}

