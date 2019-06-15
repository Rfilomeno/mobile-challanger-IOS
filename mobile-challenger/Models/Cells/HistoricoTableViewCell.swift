//
//  HistoricoTableViewCell.swift
//  mobile-challenger
//
//  Created by Rodrigo Filomeno on 01/06/19.
//  Copyright © 2019 Filomeno. All rights reserved.
//

import UIKit

class HistoricoTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nomeUsuarioLabel: UILabel!
    @IBOutlet weak var qntdRepositoriosLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
