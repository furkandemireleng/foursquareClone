//
//  PlaceModel.swift
//  FoursquareClone
//
//  Created by MacxbookPro on 11.12.2019.
//  Copyright © 2019 MacxbookPro. All rights reserved.
//

import Foundation
import UIKit

class PlaceModel{
    //burada bir singlethon yapisi var
    
    
    static let sharedInstance = PlaceModel()
    
    var placeName = ""
    var placeType = ""
    var placeAtmosphere = ""
    var placeImage = UIImage()
    var placeLatitude = ""
    var placeLongitude = ""
    
    private init(){}
    
}
