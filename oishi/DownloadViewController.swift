//
//  DownloadViewController.swift
//  oishi
//
//  Created by warinporn khantithamaporn on 8/26/2559 BE.
//  Copyright © 2559 com.rollingneko. All rights reserved.
//

import UIKit
import Alamofire

protocol DownloadViewControllerDelegate {
    func finishedDownloadResources()
    func failedDownloadResources()
    func didCancelDownloadResources()
}

class DownloadViewController: UIViewController {
    
    var backgroundImageView = UIImageView()
    
    var percentageLabel = UILabel()
    
    var progressBar = UIView()
    
    var videoUrlString: String?
    var audioUrlString: String?
    
    var fileURLs = [String]()
    var fileDestinations = [NSURL]()
    var totalBytes: Int64 = 0
    
    var videoDownloaded: Bool = false
    var audioDownloaded: Bool = false
    
    var delegate: DownloadViewControllerDelegate?

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor(hexString: "162915")?.colorWithAlphaComponent(0.95)
        
        self.backgroundImageView.frame = CGRectMake(0.0, 0.0, Otification.rWidth, Otification.rHeight)
        self.backgroundImageView.contentMode = UIViewContentMode.ScaleAspectFill
        self.backgroundImageView.image = UIImage(named: "loading_bg")
        
        let labelSize = CGSizeMake(Otification.calculatedWidthFromRatio(390.0), Otification.calculatedHeightFromRatio(260.0))
        self.percentageLabel.frame = CGRectMake(Otification.calculatedWidthFromRatio(790.0), Otification.calculatedHeightFromRatio(860.0), labelSize.width, labelSize.height)
        self.percentageLabel.font = UIFont(name: Otification.DBHELVETHAICA_X_MEDIUM, size: Otification.calculatedHeightFromRatio(260.0))
        self.percentageLabel.textAlignment = .Center
        self.percentageLabel.textColor = UIColor.whiteColor()
        
        self.percentageLabel.text = "99%"
        
        let progressBarSize = CGSizeMake(Otification.calculatedWidthFromRatio(1052.0), Otification.calculatedHeightFromRatio(85.0))
        self.progressBar.frame = CGRectMake(Otification.calculatedWidthFromRatio(95.0), Otification.calculatedHeightFromRatio(1138.0), progressBarSize.width, progressBarSize.height)
        self.progressBar.layer.cornerRadius = progressBarSize.height / 2.0
        self.progressBar.clipsToBounds = true
        self.progressBar.backgroundColor = UIColor.clearColor()
        self.progressBar.layer.borderColor = UIColor.whiteColor().CGColor
        self.progressBar.layer.borderWidth = Otification.calculatedWidthFromRatio(8.0)
        
        self.view.addSubview(self.backgroundImageView)
        self.backgroundImageView.addSubview(self.percentageLabel)
        self.backgroundImageView.addSubview(self.progressBar)
        
        self.initDownload()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initDownload() {
        if let videoUrlString = self.videoUrlString {
            let splitedString = videoUrlString.characters.split{$0 == "/"}.map(String.init)
            let fileName = splitedString[splitedString.count - 1]
            print("videoFilePath: \(self.getVideoFilePath(fileName))")
            print("videoFileName: \(fileName)")
            
            if (!self.isFileDownloaded(self.getVideoFilePath(fileName))) {
                let directoryURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
                let pathComponent = "video/\(fileName)"
                let localPath: NSURL = directoryURL.URLByAppendingPathComponent(pathComponent)
                self.fileURLs.append(videoUrlString)
                self.fileDestinations.append(localPath)
                
                /*
                Alamofire.download(.GET,
                    videoUrlString,
                    destination: { (temporaryURL, response) in
                        let directoryURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
                        let pathComponent = "video/\(fileName)"
                        
                        localPath = directoryURL.URLByAppendingPathComponent(pathComponent)
                        return localPath!
                })
                    .progress {bytesRead, totalBytesRead, totalBytesExpectedToRead in
                        print(totalBytesRead)
                        
                        // This closure is NOT called on the main queue for performance
                        // reasons. To update your ui, dispatch to the main queue.
                        dispatch_async(dispatch_get_main_queue()) {
                            print("Total bytes read on main queue: \(totalBytesRead)")
                        }
                    }
                    .response { request, response, _, error in
                        if let error = error {
                            print("Failed with error: \(error)")
                        } else {
                            print("Downloaded file successfully at \(localPath!)")
                        }
                } 
                */
            } else {
                print("file \(fileName) downloaded")
                self.videoDownloaded = true
            }
        }
        
        if let audioUrlString = self.audioUrlString {
            let splitedString = audioUrlString.characters.split{$0 == "/"}.map(String.init)
            let fileName = splitedString[splitedString.count - 1]
            print("audioFilePath: \(self.getSoundFilePath(fileName))")
            print("audioFileName: \(fileName)")
            
            if (!self.isFileDownloaded(self.getSoundFilePath(fileName))) {
                let directoryURL = NSFileManager.defaultManager().URLsForDirectory(.LibraryDirectory, inDomains: .UserDomainMask)[0]
                let pathComponent = "Sounds/\(fileName)"
                let localPath = directoryURL.URLByAppendingPathComponent(pathComponent)
                self.fileURLs.append(audioUrlString)
                self.fileDestinations.append(localPath)
                
                /*
                var localPath: NSURL?
                Alamofire.download(.GET,
                    audioUrlString,
                    destination: { (temporaryURL, response) in
                        let directoryURL = NSFileManager.defaultManager().URLsForDirectory(.LibraryDirectory, inDomains: .UserDomainMask)[0]
                        let pathComponent = "Sounds/\(fileName)"
                        
                        localPath = directoryURL.URLByAppendingPathComponent(pathComponent)
                        return localPath!
                })
                    .progress { bytesRead, totalBytesRead, totalBytesExpectedToRead in
                        print(totalBytesRead)
                        
                        // This closure is NOT called on the main queue for performance
                        // reasons. To update your ui, dispatch to the main queue.
                        dispatch_async(dispatch_get_main_queue()) {
                            print("Total bytes read on main queue: \(totalBytesRead)")
                        }
                    }
                    .response { request, response, _, error in
                        if let error = error {
                            print("Failed with error: \(error)")
                        } else {
                            print("Downloaded file successfully at \(localPath!)")
                        }
                } 
                 */
            } else {
                print("file \(fileName) downloaded")
                self.audioDownloaded = true
            }
        }
        
        if (!(self.videoDownloaded && self.audioDownloaded)) {
            self.downloadFile()
        } else {
            self.delegate?.finishedDownloadResources()
        }
    }
    
    func downloadFile() -> Void {
        if let url = self.fileURLs.popLast() {
            Alamofire.download(.GET,
                url,
                destination: { (temporaryURL, response) in
                    let path = self.fileDestinations.popLast()
                    return path!
            })
                .progress { bytesRead, totalBytesRead, totalBytesExpectedToRead in
                    print(totalBytesRead)
                    
                    // This closure is NOT called on the main queue for performance
                    // reasons. To update your ui, dispatch to the main queue.
                    dispatch_async(dispatch_get_main_queue()) {
                        print("Total bytes read on main queue: \(totalBytesRead)")
                    }
                }
                .response { request, response, _, error in
                    if let error = error {
                        print("Failed with error: \(error)")
                    } else {
                        print("Downloaded file successfully")
                        if (self.fileURLs.count > 0) {
                            self.downloadFile()
                        } else {
                            self.delegate?.finishedDownloadResources()
                        }
                    }
            }
        }
    }
    
    func getVideoFilePath(fileName: String) -> String {
        let libraryPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        let soundsPath = libraryPath + "/video"
        let filePath: String = soundsPath + "/\(fileName)"
        
        let fileManager = NSFileManager.defaultManager()
        do {
            if (!fileManager.fileExistsAtPath(soundsPath)) {
                try fileManager.createDirectoryAtPath(soundsPath, withIntermediateDirectories: false, attributes: nil)
            }
        } catch let error1 as NSError {
            print("error" + error1.description)
        }
        
        return filePath
    }
    
    func getSoundFilePath(fileName: String) -> String {
        let libraryPath = NSSearchPathForDirectoriesInDomains(.LibraryDirectory, .UserDomainMask, true)[0]
        let soundsPath = libraryPath + "/Sounds"
        let filePath: String = soundsPath + "/\(fileName)"
        
        let fileManager = NSFileManager.defaultManager()
        do {
            if (!fileManager.fileExistsAtPath(soundsPath)) {
                try fileManager.createDirectoryAtPath(soundsPath, withIntermediateDirectories: false, attributes: nil)
            }
        } catch let error1 as NSError {
            print("error" + error1.description)
        }
        
        return filePath
    }
    
    func isFileDownloaded(path: String) -> Bool {
        let fileManager = NSFileManager.defaultManager()
        if (fileManager.fileExistsAtPath(path)) {
            return true
        } else {
            return false
        }
    }

}