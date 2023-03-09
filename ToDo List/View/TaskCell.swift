//
//  TaskCell.swift
//  ToDo List
//
//  Created by Mac on 03/03/2023.
//  Copyright © 2023 mssvrk. All rights reserved.
//

import UIKit

class TaskCell: UITableViewCell {
    
    // MARK: Properties
    
    lazy var cellContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .powderPink
        view.clipsToBounds = true
        
        return view
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "ProximaNova-Regular", size: 30)
        label.textColor = .azure
        label.numberOfLines = 0
        
        return label
    }()
    
    
    lazy var checkmarkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .neonPink
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .powderPink
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Setting up Views & Constraints
    
    func setupViews() {
        self.contentView.addSubview(cellContainerView)
        
        cellContainerView.addSubview(checkmarkImageView)
        cellContainerView.addSubview(nameLabel)

    }
    
    func setupConstraints() {
        
        cellContainerView.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        cellContainerView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
        cellContainerView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        cellContainerView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
        

        checkmarkImageView.heightAnchor.constraint(equalToConstant: 35).isActive = true
        checkmarkImageView.widthAnchor.constraint(equalToConstant: 35).isActive = true
        checkmarkImageView.centerYAnchor.constraint(equalTo: cellContainerView.centerYAnchor).isActive = true
        checkmarkImageView.leadingAnchor.constraint(equalTo: cellContainerView.leadingAnchor, constant: 30).isActive = true
        checkmarkImageView.trailingAnchor.constraint(equalTo: nameLabel.leadingAnchor, constant: -10).isActive = true
        
        nameLabel.topAnchor.constraint(equalTo: cellContainerView.topAnchor, constant: 20).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: cellContainerView.centerYAnchor).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo: cellContainerView.bottomAnchor, constant: -20).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: cellContainerView.trailingAnchor, constant: -30).isActive = true
        // *nameLabel topAnchor & bottomAnchor constraints set for dynamic cell height
        
    }
}
