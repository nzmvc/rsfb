//
//  ViewController.swift
//  resfebe
//
//  Created by MacBook on 26/02/16.
//  Copyright © 2016 MacBook. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let img_path_prefix     = "http://resfebe.nazimavci.com/pictures/"
    var img_file            = ""
    var degerArray          = [[String]]()
    var cevap:String        = ""
    var kullaniciCevap:String = ""
    var harfler:String      = ""
    var ilkHarf:Bool        = true
    var harfSayisiGoster:Bool = false
    var harfSayisi:Int      = 0
    var girilenHarf:Int     = 0
    var puan:Int            = 50
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var outPuan: UILabel!
    
    func uyariMesaji(title:String, str : String){
        
        let alert = UIAlertController(title: title, message: str, preferredStyle: UIAlertControllerStyle.Alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        
        // show the alert
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    
    func cevapReset (){
        
        // yeniden deneme yapılacağı için sıfırlanır---------------------
        ilkHarf = true
        girilenHarf = 0
        kullaniciCevap = ""
        outYanit.text = ""
        
        if harfSayisiGoster {   // bu daha önce secilmişse resetlerken aynı secim devam eder
            outYanit.text = "-"
            for var i = 1 ; i < cevap.characters.count ; ++i {
                outYanit.text = outYanit.text! + "  -"
            }
        }
        
   
    }
    func getImage(iPrefix:String, fileName: String) {
        
        let img_url = NSURL(string: iPrefix + fileName )
        print(" aranan \(iPrefix) \(fileName) ")
        
        let task2 = NSURLSession.sharedSession().dataTaskWithURL(img_url!) { (data, response, error) -> Void in
            
            if error != nil {
                print(error)
            } else {
                var documentsDirectory:String?
                var paths:[AnyObject] = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
                
                if paths.count > 0 {
                    documentsDirectory = paths[0] as? String
                    let savePath = documentsDirectory! + fileName
                    NSFileManager.defaultManager().createFileAtPath(savePath, contents: data, attributes: nil)
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.image.image = UIImage(named: savePath)
                    })
                }
                
                print("cevap: \(self.cevap) ")
            }
        }
        
        task2.resume()
        
    }
    @IBAction func btnDununSorusu(sender: AnyObject) {
        
        cevapReset()
    
        self.img_file = self.degerArray[1][0]
        self.cevap = self.degerArray[1][1]
        self.harfSayisi = self.cevap.characters.count
        
        if self.img_file != "" {
            
            self.getImage(self.img_path_prefix, fileName: self.img_file)
        
        }
        
    }
    
    @IBAction func btnHarf(sender: AnyObject) {
        
        if ilkHarf  {
            
            ilkHarf = false                                 //ilk harf ise ekleme yapmıyorum
            kullaniciCevap = (sender.titleLabel?!.text)!        //basılan butonun üzerindeki harfi alıyorum
            harfSayisi = harfSayisi - 1
            
        } else {
            
            kullaniciCevap = kullaniciCevap + (sender.titleLabel?!.text)!
        
        }
        
        girilenHarf += 1
        outYanit.text = kullaniciCevap
        
        
        if harfSayisiGoster {
            for var i = girilenHarf ; i < cevap.characters.count ; ++i {
                outYanit.text = outYanit.text! + "  -"
            }
        }
        
        
        
        
    }
    
    @IBAction func btnHarfSayisi(sender: AnyObject) {
        // TODO: yetki odeme puan vs kontrolü
        
        harfSayisiGoster = true
        
        // yeniden deneme yapılacağı için sıfırlanır---------------------
        //ilkHarf = true
        //girilenHarf = 0
        //kullaniciCevap = ""
        // --------------------------------------------------------------
        
        cevapReset()
        
        outYanit.text = "-" // ilk cizgi başında boşluk olamamsı için burada konur
        
        for var i = 1 ; i < cevap.characters.count ; ++i {
            outYanit.text = outYanit.text! + "  -"
        }
        
        
    }
    
    @IBAction func btnCevap(sender: AnyObject) {
        // TODO: harfgoster true is  cevapdaki harf sayısı kontrol edilerek uyarı çıkartılmalı
        if outYanit.text == cevap {
            print("bildiniz")
            uyariMesaji("Tebrikler :)", str: "Bildiniz ....")
            puan = puan + 10
            
            
        } else {
        
            print("tekrar deneyiniz")
            uyariMesaji("Malesef :( ", str: "Tekrar Deneyiniz")
            
            puan = puan - 1
            
            cevapReset()
        }
        
        outPuan.text = String(puan)
    }

    @IBOutlet weak var outYanit: UILabel!
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
                                self.cevap = self.degerArray[0][1]
                                self.harfler = self.degerArray[0][2]
                                self.harfSayisi = self.cevap.characters.count
                                    
                                    
                                print("diziden alınan1 \(self.img_file) \(self.cevap)")
                            
                            } else {
                                print("web servisi anlamlı data cevirmedi \(webContent)")
                            }
                            
                            //--------------------------------------------------------------------
                            //--------------------image alınacak
                            //--------------------------------------------------------------------
                            
                            //TODO: image alınamadıysa uyarı vermeli ve buttonlara basılamamalı.
                            
                            self.getImage(self.img_path_prefix, fileName: self.img_file)
                            
//                            let img_url = NSURL(string: self.img_path_prefix + self.img_file)
//                            print(" aranan \(self.img_path_prefix) \(self.img_file) ")
//        
//                            let task2 = NSURLSession.sharedSession().dataTaskWithURL(img_url!) { (data, response, error) -> Void in
//                
//                                if error != nil {
//                                    print(error)
//                                } else {
//                                    var documentsDirectory:String?
//                                    var paths:[AnyObject] = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
//                    
//                                    if paths.count > 0 {
//                                        documentsDirectory = paths[0] as? String
//                                        let savePath = documentsDirectory! + self.img_file
//                                        NSFileManager.defaultManager().createFileAtPath(savePath, contents: data, attributes: nil)
//                                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                                            self.image.image = UIImage(named: savePath)
//                                        })
//                                    }
//                                    
//                                    print("cevap: \(self.cevap) harfler : \(self.harfler)")
//                                }
//                            }
//        
//                            task2.resume()
                            
                            
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

