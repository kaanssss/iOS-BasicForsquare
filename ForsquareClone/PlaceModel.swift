//
//  PlaceModel.swift
//  ForsquareClone
//
//  Created by Kaan Yalçınkaya on 22.12.2021.
//

import Foundation
import UIKit

class PlaceModel {
    
    //sharedInstance paylaşılan obje.
    static let sharedInstance = PlaceModel()
    
    var placeName = ""
    var placeType = ""
    var placeAtmosphere = ""
    var placeImage = UIImage()
    var placeLatitude = ""
    var placeLongitude = ""
    
    //private init başka hiçbir yerden initilazation işleminin yapılamıyacağını gösterir.
    private init(){}
    
}
