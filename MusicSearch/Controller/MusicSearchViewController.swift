//
//  ViewController.swift
//  MusicSearch
//
//  Created by Srinivas Kasanna on 9/14/17.
//  Copyright © 2017 asdf. All rights reserved.
//

import UIKit
import RestAPI

class MusicSearchViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate {
    
    @IBOutlet weak var tracksTableView: UITableView!
    @IBOutlet weak var tracksSearchBar: UISearchBar!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var trackList:[TrackItem]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = MUSICSEARCH_SCREEN_TITLE
        self.tracksTableView?.estimatedRowHeight = 80.0
        self.tracksTableView?.rowHeight = UITableViewAutomaticDimension
        self.tracksTableView?.tableFooterView = UIView()
        if let  indicatorView = self.activityIndicator{
        indicatorView.hidesWhenStopped = true
        }
        self.trackList = Array()
        enableTapEndEditing()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - TableView Data Source Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let trackList = trackList {
            if trackList.count > 0{
                self.tracksTableView.backgroundView = nil
                self.tracksTableView.separatorStyle = .singleLine
                return trackList.count
            }
        }
        let rect = CGRect(x: 0,
                          y: 0,
                          width: self.tracksTableView.bounds.size.width,
                          height: self.tracksTableView.bounds.size.height)
        let noDataLabel: UILabel = UILabel(frame: rect)
        
        noDataLabel.text = NO_TRACK_AVAILABLE
        noDataLabel.textAlignment = .center
        self.tracksTableView.backgroundView = noDataLabel
        self.tracksTableView.separatorStyle = .none
        return 0
            
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return createTrackCell(indexPath: indexPath, trackItem: self.trackList![indexPath.row]) ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let selectedItem = self.trackList![indexPath.row]
        let url = URL(string: "\(LyricsURL)&artist=\(selectedItem.artistName ?? "")&song=\(selectedItem.trackName ?? "")".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        getTrackLyrics(url:url!, indexpath: indexPath )
    }
    
    // MARK: - Custom Cell Methods
    func createTrackCell(indexPath: IndexPath, trackItem: TrackItem) -> TrackCell?{
        if let cell = tracksTableView?.dequeueReusableCell(withIdentifier: "trackCell", for: indexPath) as? TrackCell {
            cell.trackName.text = trackItem.trackName
            cell.artistName.text = trackItem.artistName
            let url = URL(string: trackItem.imageOfAlbum!)
            let data = try? Data(contentsOf: url!)
            cell.albumImage.image = UIImage(data: data!)
            
            return cell
        }
        return nil
    }
    
    // MARK: - SerachBar Delegate Methods
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        searchBar.resignFirstResponder()
        let url = URL(string: "https://itunes.apple.com/search?term=\(searchBar.text?.replacingOccurrences(of: " ", with: "+") ?? "")")
        getTracksData(url: url!)
    }
    
    // MARK: Private methods
    
    /**
     To identify gestures in tableview
     */
    func enableTapEndEditing(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
    }
    
    /**
     To hide keyboard
     */
    func hideKeyboard(){
        tracksSearchBar.resignFirstResponder()
    }
    
    
    /**
     To get Tracks list
     */
    func getTracksData(url: URL){
        self.activityIndicator.startAnimating()
        let serviceManager = WebServiceManager()
        serviceManager.invokeRestAPICall(requestURL: url,requestType: "GET",requestBody: "", completionHandler: { (object, error) -> Void in
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
            }
            if let error = error{
                AppUtils.showAlert(controller: self, title: ERROR, message: error.localizedDescription)
            }
            if object != nil{
                do {
                    if let json = try JSONSerialization.jsonObject(with: object as! Data, options: .allowFragments) as? [String: Any]
                    {
                        let trackList = json["results"] as? [[String:Any]] ?? []
                        if trackList.count > 0{
                            self.trackList?.removeAll()
                            for track in trackList{
                                let trackItem = TrackItem()
                                trackItem.imageOfAlbum = track["artworkUrl60"] as? String ?? ""
                                trackItem.albumName = track["collectionName"] as? String ?? ""
                                trackItem.trackName = track["trackName"] as? String ?? ""
                                trackItem.artistName = track["artistName"] as? String ?? ""
                                self.trackList?.append(trackItem)
                                
                            }
                            DispatchQueue.main.async {
                                self.tracksTableView.reloadData()
                            }
                        }else{
                            DispatchQueue.main.async {
                                AppUtils.showAlert(controller: self, title: ALERT, message: NO_TRACK_FOUND)
                            }
                        }
                    }
                } catch {
                    AppUtils.showAlert(controller: self, title: ERROR, message: PARSE_ERROR)
                }
            }
        })

    }
    
    // MARK: Private methods
    /**
     To get Tracks lyrics info
     */
    func getTrackLyrics(url: URL, indexpath: IndexPath){
        
        self.activityIndicator.startAnimating()
        let serviceManager = WebServiceManager()

        serviceManager.invokeRestAPICall(requestURL: url, requestType: "GET", requestBody: "", completionHandler: { (object, error) -> Void in
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
            }
            if let error = error{
                AppUtils.showAlert(controller: self, title: ERROR, message: error.localizedDescription)
            }
            if object != nil{
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: object as! Data, options: .allowFragments) as? [String: Any]
                    {
                        let trackLyrics = json["result"] as? [String: Any] ?? [:]
                        DispatchQueue.main.async {
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let lyricsViewController = storyboard.instantiateViewController(withIdentifier: LYRICS_VC_ID) as! TrackLyricsViewController
                            lyricsViewController.selectedTrack = self.trackList?[indexpath.row] ?? TrackItem()
                            lyricsViewController.trackLyricsText = trackLyrics["lyrics"] as? String ?? ""
                            self.navigationController?.pushViewController(lyricsViewController, animated: true)
                        }
                    }
                    
                } catch {
                    AppUtils.showAlert(controller: self, title: ERROR, message: PARSE_ERROR)
                }
            }
        })
    }
    
}

