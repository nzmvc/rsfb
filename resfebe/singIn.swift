//
//  singIn.swift
//  resfebe
//
//  Created by MacBook on 01/03/16.
//  Copyright © 2016 MacBook. All rights reserved.
//

import UIKit

class singIn: UIViewController {

    @IBOutlet weak var ad: UITextField!
    @IBOutlet weak var soyad: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var takmaAd: UITextField!
    @IBOutlet weak var sifre: UITextField!
    
    
    @IBAction func emailKontrol(sender: AnyObject) {
        //TODO: email daha önce girilmiş mi ve geçerli bir adres mi kontrol edilir
    }
    @IBAction func takmaAdKontrol(sender: AnyObject) {
        //TODO: email daha önce girilmiş mi kontrol edilir

    }
    @IBAction func kayit(sender: AnyObject) {
        //TODO: db kaydı ve email doğrulama
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
