//
//  EditVideoViewController.swift
//  Gif
//
//  Created by Liya Wu-17 on 7/21/16.
//  Copyright © 2016 ms. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class EditVideoViewController: AVPlayerViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let label = UILabel(frame: CGRect(x: 50.0, y: 100.0, width: 100.0, height: 50.0))
        label.text = "AAAUGH I'M A LABEL!"
        self.contentOverlayView?.insertSubview(label, atIndex: 2)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
