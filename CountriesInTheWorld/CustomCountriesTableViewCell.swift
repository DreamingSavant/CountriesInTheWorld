//
//  CustomCountriesTableViewCell.swift
//  CountriesInTheWorld
//
//  Created by Roderick Presswood on 12/1/23.
//

import UIKit

class CustomCountriesTableViewCell: UITableViewCell {
    
    private enum Constants {
        static var TopConstriantConstant: CGFloat { 10 }
        static var BottomConstriantConstant: CGFloat { -10 }
        static var LeadingConstraintConstant: CGFloat { 10 }
        static var TrailingCOnstraintConstant: CGFloat { -10 }
    }
    
    static let reuseId = "customCell"
    
    private var countryRegionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var codeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var capitalLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(with country: Country) {
        
        countryRegionLabel.text = "\(country.name), \(country.region)"
        codeLabel.text = country.code
        capitalLabel.text = country.capital
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        addSubview(countryRegionLabel)
        addSubview(codeLabel)
        addSubview(capitalLabel)
        
        NSLayoutConstraint.activate([
            countryRegionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.LeadingConstraintConstant),
            countryRegionLabel.topAnchor.constraint(equalTo: topAnchor, constant: Constants.TopConstriantConstant),
            
            codeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Constants.TrailingCOnstraintConstant),
            codeLabel.leadingAnchor.constraint(equalTo: countryRegionLabel.trailingAnchor),
            codeLabel.topAnchor.constraint(equalTo: countryRegionLabel.topAnchor),
            
            capitalLabel.topAnchor.constraint(equalTo: countryRegionLabel.bottomAnchor, constant: Constants.TopConstriantConstant),
            capitalLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.LeadingConstraintConstant),
            capitalLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: Constants.BottomConstriantConstant)
            
        ])
    }
}
