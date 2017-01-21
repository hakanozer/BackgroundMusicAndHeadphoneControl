//
//  ViewController.swift
//  deneme
//
//  Created by Hakan on 1/19/17.
//  Copyright © 2017 Hakan. All rights reserved.
//

import UIKit
import MediaPlayer

class ViewController: UIViewController {
    
    var player = AVAudioPlayer()
    let path = Bundle.main.path(forResource: "muzik", ofType: "mp3")
    var soundView = MPVolumeView()
    @IBOutlet weak var hiddenView: UIView!
    @IBOutlet weak var lblSes: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            print("AVAudioSession Category Playback OK")
            do {
                try AVAudioSession.sharedInstance().setActive(true)
                print("AVAudioSession is Active")
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        player = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: path!))
        let hx = self.hiddenView.frame.origin.x
        let hy = self.hiddenView.frame.origin.y
        let hw = self.hiddenView.frame.size.width
        let hh = self.hiddenView.frame.size.height
        self.soundView = MPVolumeView(frame: CGRect(x: hx, y: hy, width: hw, height: hh))
        for view in soundView.subviews {
            if view.isKind(of: UIButton.self) {
                let buttonOnVolumeView : UIButton = view as! UIButton
                soundView.setRouteButtonImage(buttonOnVolumeView.currentImage?.withRenderingMode(.alwaysTemplate), for: .normal)
                break;
            }
        }
        self.view.addSubview(soundView)
        soundView.volumeSlider.addTarget(self, action: #selector(ViewController.sliderUpdate), for: UIControlEvents.valueChanged)
        player.play()
    }
    
    
    func sliderUpdate(sender : UISlider) {
        self.lblSes.text = "\(Int(sender.value * 100))"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}


extension MPVolumeView {
    var volumeSlider:UISlider {
        var slider = UISlider()
        for subview in self.subviews {
            if subview is UISlider {
                slider = subview as! UISlider
                slider.tintColor = UIColor.red
                slider.thumbTintColor = UIColor.red
                slider.isContinuous = false
                (subview as! UISlider).value = AVAudioSession.sharedInstance().outputVolume
                return slider
            }
        }
        return slider
    }
}

