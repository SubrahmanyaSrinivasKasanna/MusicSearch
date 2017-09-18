//
//  TrackCell.swift
//  MusicSearch
//
//  Created by Srinivas Kasanna on 9/15/17.
//  Copyright © 2017 asdf. All rights reserved.
//

import UIKit

class TrackCell: UITableViewCell {

    @IBOutlet weak var albumImage: UIImageView!
    @IBOutlet weak var albumName: UILabel!
    @IBOutlet weak var trackName: UILabel!
    @IBOutlet weak var artistName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
