//
//  RateTableViewCell.swift
//  CryptoRates
//
//  Created by Владимир Беляев on 13.01.2021.
//

import UIKit

class RateTableViewCell: UITableViewCell {

    static let identifier = "rateCell"
    
    @IBOutlet var cryptoImage: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var priceChangesLabel: UILabel!
    
    func configure(rate: Rate) {
        guard let name = rate.name,
              let symbol = rate.symbol,
              let price = rate.price else {
            return
        }
        
        titleLabel.text = name
        subtitleLabel.text = symbol.uppercased()
        priceLabel.text = "\(price) $"
        
        guard let priceChange = rate.priceChangePercentagePerDay else {
            priceChangesLabel.isHidden = true
            return
        }
        
        priceChangesLabel.textColor = priceChange >= 0 ? .systemGreen : .systemRed
        priceChangesLabel.text = "\(priceChange)% 24h"
        
        DispatchQueue.global(qos: .userInteractive).async {
            guard let url = rate.imageURL,
                  let imageURL = URL(string: url),
                  let imageData = try? Data(contentsOf: imageURL) else {
                return
            }
            
            DispatchQueue.main.async {
                self.cryptoImage.image = UIImage(data: imageData)
                UIView.animate(withDuration: 0.3) {
                    self.cryptoImage.alpha = 1
                }
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cryptoImage.alpha = 0
        priceChangesLabel.textColor = .label
        priceChangesLabel.isHidden = false
    }

}

