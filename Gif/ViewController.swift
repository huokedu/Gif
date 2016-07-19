//
//  ViewController.swift
//  Gif
//
//  Created by Liya Wu-17 on 7/14/16.
//  Copyright © 2016 ms. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class ViewController: UIViewController, AVCaptureFileOutputRecordingDelegate{
    
    @IBOutlet weak var cameraButton:UIButton!
    
    @IBOutlet weak var frontCamera: UIButton!
    
    let captureSession = AVCaptureSession()
    var currentDevice:AVCaptureDevice?
    var videoFileOutput:AVCaptureMovieFileOutput?
    var cameraPreviewLayer:AVCaptureVideoPreviewLayer?
    
    var isRecording = false
    
    @IBAction func buttonClicked(sender: AnyObject) {
        
        let currentCameraInput: AVCaptureInput = captureSession.inputs[0] as! AVCaptureInput
        
        captureSession.removeInput(currentCameraInput)
        
        let newCamera: AVCaptureDevice?
        let newVideoInput: AVCaptureDeviceInput?
        
        //setting the camera to the front
        if(currentDevice!.position == AVCaptureDevicePosition.Back){
            print("Setting new camera with Front")
            newCamera = self.cameraWithPosition(AVCaptureDevicePosition.Front)
        }
        //setting the camera to the back
        else {
            print("Setting new camera with Back")
            newCamera = self.cameraWithPosition(AVCaptureDevicePosition.Back)
        }
        do {
            newVideoInput = try AVCaptureDeviceInput(device: newCamera!)
        } catch {
            print(error)
            return
        }
        captureSession.addInput(newVideoInput)
        currentDevice = newCamera!
        captureSession.commitConfiguration()
    }
    
    func cameraWithPosition(position: AVCaptureDevicePosition) -> AVCaptureDevice {
        let devices = AVCaptureDevice.devices()
        for device in devices {
            if(device.position == position){
                return device as! AVCaptureDevice
            }
        }
        return AVCaptureDevice()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //swiping to the left 
        let recognizer = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.swipe(_:)))
        recognizer.direction = .Left
        self.view.addGestureRecognizer(recognizer)
        
        cameraButton.layer.cornerRadius = 0.5 * cameraButton.bounds.size.width //make button a circle
        
        // Preset the session for taking photo in full resolution
        captureSession.sessionPreset = AVCaptureSessionPresetHigh
        
        // Get the available devices that is capable of taking video
        let devices = AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo) as! [AVCaptureDevice]
        
        // Get the back-facing camera for taking videos
        for device in devices {
            if device.position == AVCaptureDevicePosition.Back {
                currentDevice = device
            }
        }
        
        let captureDeviceInput:AVCaptureDeviceInput
        do {
            captureDeviceInput = try AVCaptureDeviceInput(device: currentDevice)
        } catch {
            print(error)
            return
        }
        
        // Configure the session with the output for capturing video
        videoFileOutput = AVCaptureMovieFileOutput()
//        let totalSeconds: Double = 10 // 10 minutes max
//        let preferredTimeScale  = 30 //fps
//        let maxDuration = CMTimeMakeWithSeconds(totalSeconds, Int32(preferredTimeScale))
//        videoFileOutput?.maxRecordedDuration = maxDuration
        
        // Configure the session with the input and the output devices
        captureSession.addInput(captureDeviceInput)
        captureSession.addOutput(videoFileOutput)
        
        // Provide a camera preview
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        view.layer.addSublayer(cameraPreviewLayer!)
        cameraPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        cameraPreviewLayer?.frame = view.layer.frame
        
        // Bring the camera button to front
        view.bringSubviewToFront(cameraButton)
        captureSession.startRunning()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - AVCaptureFileOutputRecordingDelegate methods
    
    func captureOutput(captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAtURL outputFileURL: NSURL!, fromConnections connections: [AnyObject]!, error: NSError!) {
        
        if error != nil {
            print(error)
            return
        }

        performSegueWithIdentifier("playVideo", sender: outputFileURL)
        //return
    }
    
    //stop recording after 10 seconds
    func captureOutput(captureOutput: AVCaptureFileOutput!, didStartRecordingToOutputFileAtURL fileURL: NSURL!, fromConnections connections: [AnyObject]!) {
        self.cameraButton.backgroundColor = UIColor.redColor()
        print("recording delgate")
        //captureOutput.maxRecordedDuration = CMTimeMake(10, 1)
        let delayInSeconds = 9.0
        let delayInNanoSeconds = dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSeconds * Double(NSEC_PER_SEC)))
        dispatch_after(delayInNanoSeconds, dispatch_get_main_queue(), {
            print("10 seconds passed")
            captureOutput.stopRecording()
            self.cameraButton.backgroundColor = UIColor.whiteColor()

            
        })
    }
    
    // MARK: - Segue methods
    
    //playing the videos
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "playVideo" {
            let videoPlayerViewController = segue.destinationViewController as! AVPlayerViewController
            let videoFileURL = sender as! NSURL
            videoPlayerViewController.player = AVPlayer(URL: videoFileURL)
        }
    }
    
    // MARK: - Action methods
    
    @IBAction func unwindToCamera(segue:UIStoryboardSegue) {
    }
    
    //capturing the video
    @IBAction func capture(sender: AnyObject) {
        if !isRecording {
            isRecording = true
            
            print("recording")
            UIView.animateWithDuration(0.5, delay: 0.0, options: [.Repeat, .Autoreverse, .AllowUserInteraction], animations: { () -> Void in
                self.cameraButton.transform = CGAffineTransformMakeScale(0.5, 0.5)
                }, completion: nil)
            
            let outputPath = NSTemporaryDirectory() + "output.mov"
            let outputFileURL = NSURL(fileURLWithPath: outputPath)
            videoFileOutput?.startRecordingToOutputFileURL(outputFileURL, recordingDelegate: self)
        }
        
        else {
            isRecording = false
            
            UIView.animateWithDuration(0.5, delay: 1.0, options: [], animations: { () -> Void in
                self.cameraButton.transform = CGAffineTransformMakeScale(1.0, 1.0)
                }, completion: nil)
            cameraButton.layer.removeAllAnimations()
            videoFileOutput?.stopRecording()
        }
    }
    
    //swipe to new view controller
    func swipe(recognizer: UISwipeGestureRecognizer) {
        self.performSegueWithIdentifier("showVideos", sender: self)
    }
}