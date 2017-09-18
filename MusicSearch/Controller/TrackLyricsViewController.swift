//
//  TrackLyricsViewController.swift
//  MusicSearch
//
//  Created by Srinivas Kasanna on 9/15/17.
//  Copyright © 2017 asdf. All rights reserved.
//

import UIKit

class TrackLyricsViewController: UIViewController {

    @IBOutlet weak var trackLyrics: UITextView!
    @IBOutlet weak var albumImage: UIImageView!
    @IBOutlet weak var albumName: UILabel!
    @IBOutlet weak var trackName: UILabel!
    @IBOutlet weak var artistName: UILabel!
    
    var selectedTrack: TrackItem!
    var trackLyricsText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.loadInitialData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     To assign data to all elements in screen
     */
    func loadInitialData(){
        let url = URL(string: selectedTrack?.imageOfAlbum ?? "")
        let data = try? Data(contentsOf: url!)
        self.albumImage.image = UIImage(data: data!)
        if !(self.selectedTrack.albumName ?? "").isEmpty{
            self.title = "\(String(describing: selectedTrack.albumName ?? ""))"
        }else{
            self.title = LYRICS_SCREEN_TITLE

        }
        if let lyrics = trackLyricsText, trackLyricsText != ""{
            self.trackLyrics.text = lyrics
        }else{
            self.trackLyrics.text = NO_LYRICS_TEXT
        }
        self.trackName.text = "\(String(describing: selectedTrack.trackName ?? ""))"

        self.artistName.text = selectedTrack?.artistName
    }
}
