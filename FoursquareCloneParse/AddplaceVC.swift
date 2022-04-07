//
//  AddplaceVC.swift
//  FoursquareCloneParse
//
//  Created by Burak Karagül on 13.03.2022.
//

import UIKit

//Global değişken

//var globalName = ""
//var globalType = ""
//var globalAtmosphere = ""


//  İmagepicker ve navigation controller için kullanım izni veren protokolleri ekliyoruz.

class AddplaceVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var placeNameText: UITextField!
    @IBOutlet weak var placeTypeText: UITextField!
    @IBOutlet weak var atmosphereText: UITextField!
    @IBOutlet weak var placeImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

//                          Görsel yükleme işlemi ve hazırlıkları
        
//        İmageView tıklanabilir hale getirme
        
        placeImageView.isUserInteractionEnabled = true
        
//        Tıklanınca ne olacak
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        
//        tıklandığında yapılacak işlemi imageview ile birleştirme
        
        placeImageView.addGestureRecognizer(gestureRecognizer)
        
        
    }
    @IBAction func nextButtonClicked(_ sender: Any) {
        
//        Verileri depolama bölümü
//        Burada atanan veriler modelde tutuluyor ve diğer sayfalardan da erişilebiliyor. Biz buradaki verilere MapVC bölümünden erişlmeye çalışacağız.
        
        if placeNameText.text != "" && placeTypeText.text != "" && atmosphereText.text != "" && placeImageView.image != UIImage(systemName: "icloud.and.arrow.up.fill") {
            if let chosenImage = placeImageView.image {
                
                let placeModel = PlaceModel.sharedInstance
                placeModel.placeName = placeNameText.text!
                placeModel.placeType = placeTypeText.text!
                placeModel.placeAtmosphere = atmosphereText.text!
                placeModel.placeImage = chosenImage
                
                //        Yeri kaydetmenin sonraki alanına geçiş
                        
                        self.performSegue(withIdentifier: "toMapVC", sender: nil)
            }
           
        }else {
            
            let alert = UIAlertController(title: "Error", message: "Yer hakkındaki bilgileri lütfen eksiksiz girin", preferredStyle: UIAlertController.Style.alert)
                          
                          
                          let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                          alert.addAction(okButton)
                          self.present(alert, animated: true, completion: nil)
            
        }
        
        

        
    }
    
//    image yükleme gesture için işlev fonksiyonu
    
    @objc func chooseImage (){
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true, completion: nil)
    }
    
//    Seçildikten sonra ne olacak
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        placeImageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }

   
}
