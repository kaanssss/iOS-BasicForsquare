//
//  MapVC.swift
//  ForsquareClone
//
//  Created by Kaan Yalçınkaya on 21.12.2021.
//

import UIKit
import MapKit
import Parse

class MapVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager = CLLocationManager()
    //parsa latitude longitude kaydetmek için.(Place model içerisine latitude longitude ekledik gerek kalmadı.)
    //var choosenLatitude = ""
    //var choosenLongitude = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //pars işlemi. Yukarıda sağ ve sol tarafta "save ve back" butonu çıkartmak için yaptık.
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(title: "Save", style: UIBarButtonItem.Style.plain, target: self, action: #selector(saveButtonClicked))
        
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "< Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(backButtonClicked))
        
        //Burada haritada kullanıcının yerini bulucaz, kullanıcının yerine zoom yapıcaz, kullanıcı istediği yeri seçip oradan bir yer eklemeye çalışıcak.(ilk olarak mkdelegate CLLocationdelegate ekle. Location manager oluştur)
        
        mapView.delegate = self
        locationManager.delegate = self
        //Kullanıcı ne kadar doğru bulsun konumu.
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //Sadece kullandığı zaman göstermesi için.
        locationManager.requestWhenInUseAuthorization()
        //Gerçekte kullanıcının bulunduğu lokasyonu update etmesi için.
        locationManager.startUpdatingLocation()
        //Bunlardan sonra info plistten privacy eklemesi yapmak zorundayız.
        
        
        
        //konuma pin eklemek için
        let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(chooseLocation(gestureRecognizer:)))
        recognizer.minimumPressDuration = 3
        mapView.addGestureRecognizer(recognizer)
    }
    
    @objc func chooseLocation(gestureRecognizer: UIGestureRecognizer){
        
        //gesture algılandığında ne olacak ?
        if gestureRecognizer.state == UIGestureRecognizer.State.began{
            
            //tıklanılan noktaları alıyoruz.
            let touches = gestureRecognizer.location(in: self.mapView)
            //tıklanılan yeri kordinatlara çevirmek için.
            let coordinates = self.mapView.convert(touches, toCoordinateFrom: self.mapView)
            //Dipnot için.
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinates
            annotation.title = PlaceModel.sharedInstance.placeName
            annotation.subtitle = PlaceModel.sharedInstance.placeType
            
            //oluşturduğumuz annotation u eklemek için.
            self.mapView.addAnnotation(annotation)
            
            //pars işlemleri en yukarıda oluşturduğumuz işlemlerin devamı (var long,lati.)
            PlaceModel.sharedInstance.placeLatitude = String(coordinates.latitude)
            PlaceModel.sharedInstance.placeLongitude = String(coordinates.longitude)
            
        }
        
    }
    
    
    
    //Gerçekten kullancının yeri update olduğunda ne olacak?
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        //haritada eski yerine dönüp zoom yapmaması için. Lokasyonu 1 kere günceller.
        //locationManager.stopUpdatingLocation()
        let location = CLLocationCoordinate2D (latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        
        //span = enlem ve boylam deltasını ne kadar zoomlu göstereceğini belirten obje. Haritanın width ve heightını gösteriyo.
        let span = MKCoordinateSpan(latitudeDelta: 0.35, longitudeDelta: 0.35)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    @objc func saveButtonClicked(){
        
        //Parse Save işlemleri.
        
        let placeModel = PlaceModel.sharedInstance
        let object = PFObject(className: "Places")
        //oluşturduğumuz obje içerisinde neler olacak ?
        object["name"] = placeModel.placeName
        object["type"] = placeModel.placeType
        object["atmosphere"] = placeModel.placeAtmosphere
        //latitude longitude place model içerisine koymadık.
        object["latitude"] = placeModel.placeLatitude
        object["longitude"] = placeModel.placeLongitude
        
        //Görselleri dataya çevirmek için bunu yapmak zorundayız. (Önemli.)
        
        if let imageData = placeModel.placeImage.jpegData(compressionQuality: 0.5){
            object["image"] = PFFileObject(name: "image.jpg", data: imageData)
        }
        
        //yukarıdaki image data işleminden sonra.(block kullan asenkron olması için)
        object.saveInBackground { success, error in
            if error != nil{
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }
            else{
                self.performSegue(withIdentifier: "fromMapVCtoPlacesVC", sender: nil)
            }
        }
    }
    
    @objc func backButtonClicked(){
        
        //geri gelmesi için. Aşağıdaki komutu kullanamayız çünkü ekstradan navigation controller ekledik.
        //navigationController?.popViewController(animated: <#T##Bool#>)
        self.dismiss(animated: true, completion: nil)
        
    }


}
