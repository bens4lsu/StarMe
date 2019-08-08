//
//  ViewController.swift
//  StarMe
//
//  Created by Ben Schultz on 8/4/19.
//  Copyright © 2019 com.concordbusinessservicesllc. All rights reserved.
//

import UIKit
import MediaPlayer
import StoreKit

class ViewController: UIViewController {

    @IBOutlet var artist: UILabel!
    @IBOutlet var song: UILabel!
    @IBOutlet var album: UILabel!
    @IBOutlet var albumImageView: UIImageView!
    @IBOutlet var playPauseButton: UIButton!
    @IBOutlet var slider: UISlider!
    @IBOutlet var elapsed: UILabel!
    @IBOutlet var duration: UILabel!
    @IBOutlet var prevButton: UIButton!
    @IBOutlet var nextButton: UIButton!
    @IBOutlet var cosmosView: CosmosView!
    
    /*let cider : CiderClient = {
        let developerToken = "MIGTAgEAMBMGByqGSM49AgEGCCqGSM49AwEHBHkwdwIBAQQgCkPUIy9dIT/L+U1g3Mpc+Mru6VhfyoHUUYuoYyz/i0igCgYIKoZIzj0DAQehRANCAASECa/zp6CPCSKmkoJgBtKHSA8SsDCNjSHQDS38uIbb6QkqlcnxnMH8PUsQaweWsWFW7U/+l0doC4sWbXVUpexj"
        return CiderClient(storefront: .unitedStates, developerToken: developerToken)
    }()*/
    
    let player = MPMusicPlayerController.systemMusicPlayer
    let playImage = UIImage(named: "icons8-play-100")?.resize(toWidth: 35)
    let pauseImage = UIImage(named: "icons8-pause-100")?.resize(toWidth: 35)
    let prevImage = UIImage(named: "icons8-skip-to-start-100")?.resize(toWidth: 35)
    let nextImage = UIImage(named: "icons8-end-100")?.resize(toWidth: 35)
    
    var timer = Timer()
    // MARK: Properties for auto scrolling song, artist, and album labels
    var autoScrollArtist = false
    var autoScrollAlbum = false
    var autoScrollSong = false
    var scrollInterval: Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateSongInfo),
            name: NSNotification.Name.MPMusicPlayerControllerNowPlayingItemDidChange,
            object: nil)
        
        timer = Timer.scheduledTimer(timeInterval: 0.25, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
        self.timer.tolerance = 0.1
        
        updateSongInfo()
        
        if player.playbackState == .playing {
            playPauseButton.setImage(pauseImage, for: .normal)
        }
        else {
            playPauseButton.setImage(playImage, for: .normal)
        }
        prevButton.setImage(prevImage, for: .normal)
        nextButton.setImage(nextImage, for: .normal)
        
        cosmosView.didTouchCosmos = { rating in
            guard let nowPlayingItem = self.player.nowPlayingItem else { return }
            nowPlayingItem.setValue(rating, forKey: "rating")
        }
        

    }
    
    func getAlbumArt(from mediaItem: MPMediaItem) -> UIImage {
        guard let artwork =  mediaItem.artwork,
            let img = artwork.image(at: artwork.bounds.size),
            let resImg = img.resize(toWidth: albumImageView.bounds.width) else
        {
            if let img = UIImage(named: "note-1314941_1280"),
               let rimg = img.resize(toWidth: albumImageView.bounds.width) {
                return rimg
            }
            return UIImage()
        }
        return resImg
    }
    
    @objc func timerFired(){
        elapsed.text = player.currentPlaybackTime.durationText
        slider.value = Float(player.currentPlaybackTime)

    }
    
    
    @objc func updateSongInfo(){
        guard let nowPlayingItem = player.nowPlayingItem else {
            artist.text = ""
            song.text = ""
            album.text = ""
            albumImageView.image = UIImage()
            elapsed.text = "0:00"
            duration.text = "0:00"
            slider.maximumValue = 60
            slider.value = 0
            cosmosView.rating = 0
            artist.sizeToFit()
            album.sizeToFit()
            song.sizeToFit()
            return
        }
        artist.text = nowPlayingItem.artist
        song.text = nowPlayingItem.title
        album.text = nowPlayingItem.albumTitle
        albumImageView.image = getAlbumArt(from: nowPlayingItem)
        elapsed.text = "0:00"
        duration.text = nowPlayingItem.playbackDuration.durationText
        slider.maximumValue = Float(nowPlayingItem.playbackDuration)
        slider.value = 0.0
        cosmosView.rating = Double(nowPlayingItem.rating)
        artist.sizeToFit()
        album.sizeToFit()
        song.sizeToFit()
        
        //cider.search(term: "Michael Jackson", types: [.albums, .songs]) { results, error in
        //    print("&&&&&&& \(String(describing: results))  \(String(describing: error))")
        //}
        
        guard let artistScrollView = artist.superview as? UIScrollView,
            let albumScrollView = album.superview as? UIScrollView,
            let songScrollView = song.superview as? UIScrollView,
            let duration = player.nowPlayingItem?.playbackDuration else { return }
        
        let artistDelta = Double(artist.bounds.width)// - artistScrollView.bounds.width)
        let albumDelta = Double(album.bounds.width)// - albumScrollView.bounds.width)
        let songDelta = Double(song.bounds.width)// - songScrollView.bounds.width)
        let deltas = [0, artistDelta, albumDelta, songDelta]
        print ("\(deltas)")
        autoScrollArtist = artistDelta > 0
        autoScrollSong = songDelta > 0
        autoScrollAlbum = albumDelta > 0
    }
    
    @IBAction func skipBackwards(_ sender: Any) {
        if player.currentPlaybackTime < 1.5 {
            player.skipToPreviousItem()
        }
        else {
            player.skipToBeginning()
        }
    }
    
    @IBAction func playPause(_ sender: Any) {
        if player.playbackState == .playing {
            player.pause()
            playPauseButton.setImage(playImage, for: .normal)
        }
        else if player.nowPlayingItem != nil {
            player.play()
            playPauseButton.setImage(pauseImage, for: .normal)
        }
    }
    
    @IBAction func skipForward(_ sender: Any) {
        player.skipToNextItem()
    }
    
    @IBAction func sliderValueChanged(_ sender: Any) {
        player.currentPlaybackTime = TimeInterval(slider.value)
    }
    
}

