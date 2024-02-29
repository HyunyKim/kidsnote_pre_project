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
    private var textView: UITextView = UITextView()
    
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
        testLabel.text = "sdfasdfasdfasdfasdfasdfasfasd"
        testLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.leading.equalToSuperview().offset(30)
            make.width.equalTo(100)
        }
        
        self.view.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-120)
            make.height.equalTo(100)
            make.top.equalTo(self.testLabel.snp.bottom).offset(100)
            make.centerX.equalTo(self.view)
        }
    }


}

