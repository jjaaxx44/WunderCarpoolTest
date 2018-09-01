//
//  CarListFetcher.swift
//  WunderCarpoolTest
//
//  Created by Abhishek Chaudhari on 29/08/18.
//  Copyright © 2018 Abhishek Chaudhari. All rights reserved.
//

import Foundation

class CarListFetcher {
    private init(){}
    static let shared = CarListFetcher()

    func FetchCars(completionClosure: @escaping (_ indexes: [PlacemarkViewModel],_ status : Result)-> ()){

        guard let url = URL(string: API.GET_CAR_LIST_API) else{
            return
        }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            do {
                let jsonDecoder = JSONDecoder()
                let responseModel = try jsonDecoder.decode(PlacemarkBase.self, from: data!)
                guard let placemarks = responseModel.placemarks else {
                    completionClosure([], Result.Failed)
                    return
                }
                
                let placemarksViewModels = placemarks.map({return PlacemarkViewModel(placemarkData: $0)})
                
                completionClosure(placemarksViewModels, Result.Success)
                
            }catch let err {
                print(err)
            }
        }
        task.resume()
    }
}
