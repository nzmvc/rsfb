//
//  ViewController.swift
//  resfebe
//
//  Created by MacBook on 26/02/16.
//  Copyright © 2016 MacBook. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let img_path_prefix = "http://resfebe.nazimavci.com/pictures/"
    var img_file = ""
    var degerArray = [[String]]()
    
    @IBOutlet weak var image: UIImageView!
    @IBAction func btnDununSorusu(sender: AnyObject) {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let url_str = "http://resfebe.nazimavci.com/ws_resfebe.php"

        let attemptedUrl = NSURL(string: url_str)
        // ornek data
        // 1455475025_DSC_0790.jpg:12345::2016-02-20:4:2;;;1455474739_17101641_resfebe2..jpg:kitap::2016-02-18:2:2
        
        if let url = attemptedUrl {
            let task1 = NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) -> Void in
                
                if error != nil {
                    print(error)
                }else {
                    if let urlContent = data {
                        let webContent = NSString(data: urlContent, encoding: NSUTF8StringEncoding)
                        if webContent == "" || webContent == nil {
                            print("bos data")
                        } else {
                        
                            let satirArray = webContent!.componentsSeparatedByString(";;;")
                            print("web servisinden gelen data \(webContent) count \(satirArray.count)")
                            
                            // ----------------------- ???????????????????????????
                            // TODO: burada web servis geç yanıt verirse imajın yuklenmesinde problem olur mu kontrol et
                            
                            
                            if satirArray.count > 1 {
                                for var i=0 ; i<satirArray.count ; i++ {
                                    let tmpArray = satirArray[i].componentsSeparatedByString(":")
                                    self.degerArray.append([tmpArray[0],tmpArray[1],tmpArray[2],tmpArray[3],tmpArray[4],tmpArray[5]])
                                    print ("img_path :" + self.degerArray[i][0])
                                }
                            
                                self.img_file = self.degerArray[0][0]
                                print("diziden alınan1 \(self.img_file)")
                            
                            } else {
                                print("web servisi anlamlı data cevirmedi \(webContent)")
                            }
                            
                            //--------------------------------------------------------------------
                            //--------------------image alınacak
                            //--------------------------------------------------------------------
                            
                        
                            
                            let img_url = NSURL(string: self.img_path_prefix + self.img_file)
                            print(" aranan \(self.img_path_prefix) \(self.img_file) ")
        
                            let task2 = NSURLSession.sharedSession().dataTaskWithURL(img_url!) { (data, response, error) -> Void in
                
                                if error != nil {
                                    print(error)
                                } else {
                                    var documentsDirectory:String?
                                    var paths:[AnyObject] = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
                    
                                    if paths.count > 0 {
                                        documentsDirectory = paths[0] as? String
                                        let savePath = documentsDirectory! + self.img_file
                                        NSFileManager.defaultManager().createFileAtPath(savePath, contents: data, attributes: nil)
                                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                            self.image.image = UIImage(named: savePath)
                                        })
                                    }
                                }
                            }
        
                            task2.resume()
                            
                            
                            //--------------------------------------------------------------------
                            //--------------------------------------------------------------------
                            
                            
                            
                        }
                        
                    } else {
                        print("error : 1001  url connection problem, please check your internet connection ")
                    }
                }
                print("diziden alınan2 \(self.img_file)")
            }
            task1.resume()
        }
        
        //-------------------------------------
        
            

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

