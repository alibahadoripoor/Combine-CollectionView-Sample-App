//
//  SectionHeaderView.swift
//  Combine & CollectionView Sample App
//
//  Created by Ali Bahadori on 14.01.21.
//

import Foundation
import UIKit

final class SectionHeaderView: UICollectionReusableView {
    
    // MARK: - Properties
    
    static let reuseIdentifier = "SectionHeaderView"
    private let label = UILabel()
    
    //MARK: - Inits
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    //MARK: - UI Functions
    
    func update(with userName: String){
        label.text = userName
    }
    
    private func configure() {
        backgroundColor = .systemBackground
        
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFont.boldSystemFont(ofSize: 22)
        
        let inset = CGFloat(10)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -inset),
            label.topAnchor.constraint(equalTo: topAnchor, constant: inset),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -inset)
        ])
    }
}
