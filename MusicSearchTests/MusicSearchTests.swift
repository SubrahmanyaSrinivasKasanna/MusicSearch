//
//  MusicSearchTests.swift
//  MusicSearchTests
//
//  Created by Srinivas Kasanna on 9/17/17.
//  Copyright © 2017 asdf. All rights reserved.
//

import XCTest

@testable import MusicSearch

let musicSearchStoryboard = "Main"

class MusicSearchTests: XCTestCase {
    
    var musicSearchVC:MusicSearchViewController!
    var trackLyricsVC:TrackLyricsViewController!
    var trackItem: TrackItem!

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let storyboard = UIStoryboard(name: musicSearchStoryboard, bundle: Bundle.main)
        

        guard let vc = storyboard.instantiateViewController(withIdentifier: "musicSearchViewControllerID") as? MusicSearchViewController else {
            XCTFail("VC is nil")
            return
        }

        self.musicSearchVC = vc
        let _ = self.musicSearchVC?.view

        
        
         self.trackItem = TrackItem()
        trackItem.albumName = "Closing Time"
        trackItem.artistName = "Tom Waits"
        trackItem.imageOfAlbum = "http://is5.mzstatic.com/image/thumb/Music/v4/f5/08/dd/f508ddf9-bd03-f1d5-6e57-41fc0680005a/source/60x60bb.jpg"
        trackItem.trackName = "I Hope That I Don't Fall In Love With You"
        self.musicSearchVC.trackList?.append(self.trackItem)
        
        guard let vc1 = storyboard.instantiateViewController(withIdentifier: "TrackLyricsViewControllerID") as? TrackLyricsViewController else {
            XCTFail("VC is nil")
            return
        }
        self.trackLyricsVC = vc1
        vc1.selectedTrack = trackItem
        vc1.trackLyricsText = "werteryjtkujfhdfdfgurtyefgnmgytfdgg"
        let _ = self.trackLyricsVC?.view
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testMusicSearchLoadingView(){
        guard let vc = self.musicSearchVC else {
            XCTFail("VC is nil, so failing")
            return
        }
        vc.viewDidLoad()
        vc.didReceiveMemoryWarning()
    }
    
    func testLyricsLoadingView(){
        guard let vc = self.trackLyricsVC else {
            XCTFail("VC is nil, so failing")
            return
        }
        vc.viewDidLoad()
        vc.didReceiveMemoryWarning()
    }
    
    /*func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }*/
    
    // MARK - View loading tests
    func testThatViewLoads(){
        XCTAssertNotNil(self.musicSearchVC.view, "View not initiated properly")
       // XCTAssertNotNil(self.trackLyricsVC.view, "View not initiated properly")
    }
    
    func testParentViewHasTableViewSubview() {
        let subviews = self.musicSearchVC.view.subviews
        XCTAssertTrue(subviews.contains(self.musicSearchVC.tracksTableView), "View does not have a table subview")
    }
    
    func testThatTableViewLoads() {
        XCTAssertNotNil(self.musicSearchVC.tracksTableView, "TableView not initiated")
    }
    
    // MARK - - UITableView tests
    
    func testThatViewConformsToUITableViewDataSource() {
        XCTAssertTrue(self.musicSearchVC.conforms(to: UITableViewDataSource.self), "View does not conform to UITableView datasource protocol")
    }
    
    func testThatTableViewHasDataSource() {
        XCTAssertNotNil(self.musicSearchVC.tracksTableView.dataSource, "Table datasource cannot be nil")
    }
    
    func testThatViewConformsToUITableViewDelegate() {
        XCTAssertTrue(self.musicSearchVC.conforms(to: UITableViewDelegate.self), "View does not conform to UITableView delegate protocol")
    }
    
    func testTableViewIsConnectedToDelegate() {
        XCTAssertNotNil(self.musicSearchVC.tracksTableView?.delegate, "Table delegate cannot be nil")
    }
    
    func testTableViewNumberOfRowsInSection() {
        let expectedRows = 0
        XCTAssertTrue(self.musicSearchVC?.tracksTableView?.numberOfRows(inSection: 0) == expectedRows, "Table has \(String(describing: self.musicSearchVC.tracksTableView?.numberOfRows(inSection: 0))) rows but it should have \(String(describing: expectedRows))")
    }
    
    func testTableViewHeightForRowAtIndexPath() {
        let expectedHeight: CGFloat = 80.0
        let actualHeight: CGFloat = self.musicSearchVC.tracksTableView.estimatedRowHeight
        XCTAssertEqual(expectedHeight, actualHeight, "Cell should have \(expectedHeight) height, but they have \(actualHeight)")
    }
    
    func testTableViewCellCreateCellsWithReuseIdentifier() {
        let indexPath = IndexPath(row: 0, section: 0)
        let cell: UITableViewCell? = self.musicSearchVC.tableView(self.musicSearchVC.tracksTableView, cellForRowAt: indexPath)
        let expectedReuseIdentifier: String = "trackCell"
        XCTAssertTrue((cell?.reuseIdentifier == expectedReuseIdentifier), "Table does not create reusable cells")
    }
    
    func testTableViewCellSelection() {
        let indexPath = IndexPath(row: 0, section: 0)

        XCTAssertNotNil(self.musicSearchVC.tableView(self.musicSearchVC.tracksTableView, didSelectRowAt: indexPath),"Cell Selected failed")
    }

    
    func testSerachBarSearchAction(){
        self.musicSearchVC.tracksSearchBar.text = "Tom awiats"
        self.musicSearchVC.searchBarSearchButtonClicked(self.musicSearchVC.tracksSearchBar)
    }
    
}
