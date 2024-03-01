//
//  ViewController.swift
//  GooglePlayBook
//
//  Created by JeongHyun Kim on 2/29/24.
//

import UIKit
import SnapKit

final class ViewController: UIViewController {

    private var testLabel: UILabel = UILabel()
    private var testButton: UIButton = UIButton(type: .custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .blue
        setUI()
    }
    
    private func setUI() {
        
        self.view.addSubview(testLabel)
        testLabel.backgroundColor = .red
        testLabel.numberOfLines = 0
        testLabel.text = "ㅁㄴㅇㅁㄴㅇ"
        testLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.leading.equalToSuperview().offset(30)
            make.width.equalTo(100)
        }
        self.view.addSubview(testButton)
        testButton.backgroundColor = .systemBrown
        testButton.setTitle("Test", for: .normal)
        testButton.addTarget(self, action: #selector(networkTest), for: .touchUpInside)
        
        testButton.snp.makeConstraints { make in
            make.top.equalTo(self.testLabel.snp.bottom).offset(20)
            make.size.equalTo(CGSize(width: 100, height: 40))
            make.leading.equalTo(self.testLabel.snp.leading)
        }
    }
    
    @objc func networkTest(sender: UIResponder) {
        print("test")
    }


}

