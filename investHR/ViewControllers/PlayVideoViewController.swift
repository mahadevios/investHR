//
//  PlayVideoViewController.swift
//  investHR
//
//  Created by mac on 28/06/17.
//  Copyright © 2017 Xanadutec. All rights reserved.
//

import UIKit

import AVFoundation

import AVKit

class PlayVideoViewController: UIViewController {

    var filePath:String = ""
    
    @IBAction func backButtonPressed(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool)
    {
        var savePath:String = self.filePath
        //savePath = savePath.addingPercentEncoding(withAllowedCharacters: .alphanumerics)!
        let videoURL = URL(fileURLWithPath: savePath)
//        
        let player = AVPlayer(url: videoURL)
        let playerViewController = AVPlayerViewController()
        
    playerViewController.view.frame = CGRect(x: 0, y: self.view.frame.size.height*0.2, width: self.view.frame.size.width, height: self.view.frame.size.height*0.5)
                playerViewController.player = player
                self.present(playerViewController, animated: true) {
                    playerViewController.player!.play()
                }
        

//        let asset = AVURLAsset(url: videoURL)
//        let item = AVPlayerItem(asset: asset)
//        
//        
//        let player1 = AVPlayer(playerItem: item)
//        
//        playerViewController.player = player1
        
//        playerViewController.view.frame = CGRect(x: 0, y: self.view.frame.size.height*0.2, width: self.view.frame.size.width, height: self.view.frame.size.height*0.5)

//        playerViewController.view.frame = self.view.bounds
//        
//        playerViewController.showsPlaybackControls = true
//        
//        self.view.addSubview(playerViewController.view)
//        
//        player1.play()

    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
