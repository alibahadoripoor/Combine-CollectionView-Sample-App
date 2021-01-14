//
//  TodoCell.swift
//  Combine & CollectionView Sample App
//
//  Created by Ali Bahadori on 14.01.21.
//

import UIKit

final class TodoCell: UICollectionViewCell {
    
    static let reuseIdentifier = "TodoCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var completedLabel: UILabel!
    @IBOutlet weak var backView: UIView!{
        didSet{
            backView.layer.borderWidth = 1
            backView.layer.borderColor = UIColor.label.cgColor
        }
    }
    
    var viewModel: TodoCellViewModel?{
        didSet{
            guard let viewModel = viewModel else { return }
            titleLabel.text = "\(viewModel.title)"
            completedLabel.text = "Completed: \(viewModel.completed)"
        }
    }
}
