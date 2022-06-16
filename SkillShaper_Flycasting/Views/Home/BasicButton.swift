//
//  BasicButton.swift
//  SkillShaper_Flycasting
//
//  Created by user on 5/16/21.
//  Copyright © 2021 skillshaper.us. All rights reserved.
//

import UIKit

struct BasicBtnViewModel {
    let basicBtnText: String
}

final class BasicButton: UIButton {
    private let basicBtnLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        label.textColor = .white
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(basicBtnLabel)
        clipsToBounds = true
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = UIColor.secondarySystemBackground.cgColor
        backgroundColor = .systemGreen
    }
    
    required init?(coder: NSCoder){
        fatalError()
    }

    func configure(with viewModel: BasicBtnViewModel) {
        basicBtnLabel.text = viewModel.basicBtnText
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        basicBtnLabel.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height/2)  //  ??
    }
}
