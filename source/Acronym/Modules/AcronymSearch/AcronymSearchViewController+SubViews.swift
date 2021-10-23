//
//  AcronymSearchViewController+SubViews.swift
//  Acronym
//
//  Created by Naveen Shan on 10/23/21.
//

import UIKit

extension AcronymSearchViewController {
    final class AcronymSearchCell: UITableViewCell {
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
            
            textLabel?.numberOfLines = 0
            textLabel?.lineBreakMode = .byWordWrapping
            textLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
            
            textLabel?.accessibilityIdentifier = "title-text"
            detailTextLabel?.accessibilityIdentifier = "detail-text"
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func prepareForReuse() {
            super.prepareForReuse()
            textLabel?.text = nil
            detailTextLabel?.text = nil
        }
        
        func customize(_ model: AcronymSearchCellViewModel) {
            textLabel?.text = model.title
            detailTextLabel?.text = model.detail
        }
    }
}
