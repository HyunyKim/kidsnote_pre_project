//
//  RounedButton.swift
//  GooglePlayBook
//
//  Created by JeongHyun Kim on 3/5/24.
//

import Foundation
import UIKit
import SnapKit

class RoundedButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAction()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupAction()
    }
    
    init(frame: CGRect, bgColor: UIColor) {
        super.init(frame: frame)
        self.bgColor = bgColor
        setupAction()
        
    }
    private var bgColor: UIColor = .clear
    private var animationView: UIView = {
        let view = UIView()
        view.backgroundColor = .brand.withAlphaComponent(0.3)
        view.isUserInteractionEnabled = false
        return view
    }()
    private func setupAction() {
        self.addSubview(animationView)
        
        animationView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        animationView.alpha = 0.0
        
        self.clipsToBounds = true
        layer.cornerRadius = 4.0
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.eGray.cgColor
        backgroundColor = bgColor
        
        addTarget(self, action: #selector(touchDown), for: .touchDown)
        addTarget(self, action: #selector(touchUpInside), for: .touchUpInside)
        addTarget(self, action: #selector(touchDragExit), for: .touchDragExit)
    }
    @objc private func touchDown() {
        animate(isPressed: true)
    }
    @objc private func touchUpInside() {
        animate(isPressed: false)
    }
    @objc private func touchDragExit() {
        animate(isPressed: false)
    }
    private func animate(isPressed: Bool) {
        animationView.center = self.center
        UIView.animate(withDuration: 0.2, delay: 0.0,options: .curveEaseInOut) {
//            self.backgroundColor = isPressed ? .eLightGray.withAlphaComponent(0.7) : .clear
            self.animationView.alpha = isPressed ? 1 : 0.0
//            self.transform = isPressed ? CGAffineTransform(scaleX: 0.96, y: 0.96) : .identity
        }
    }
}
