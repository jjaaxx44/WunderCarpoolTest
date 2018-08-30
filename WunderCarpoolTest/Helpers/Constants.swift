//
//  Constants.swift
//  WunderCarpoolTest
//
//  Created by Abhishek Chaudhari on 29/08/18.
//  Copyright © 2018 Abhishek Chaudhari. All rights reserved.
//

import Foundation

enum Result {
    case Success 
    case Failed
}

struct API {
    static let GET_CAR_LIST_API = "https://s3-us-west-2.amazonaws.com/wunderbucket/locations.json"
}
