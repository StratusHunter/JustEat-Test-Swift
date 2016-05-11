//
// Created by Terence Baker on 11/05/2016.
// Copyright (c) 2016 Bulb Studios Ltd. All rights reserved.
//

import UIKit
import RxSwift
import RxAlamofire
import Alamofire

class JustEatService {

    private static let AUTH_CODE = "VGVjaFRlc3RBUEk6dXNlcjI="
    private static let RESTURANT_URL = "https://public.je-apis.com/restaurants"

    //Create a single instance of the Manager so that we don't need to setup the headers for every request
    static let manager: Manager = {

        var defaultHeaders = Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders ?? [:]
        defaultHeaders["Accept-Tenant"] = "uk"
        defaultHeaders["Accept-Language"] = "en-GB"
        defaultHeaders["Authorization"] = "Basic \(AUTH_CODE)"
        defaultHeaders["Host"] = "public.je-apis.com"

        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.HTTPAdditionalHeaders = defaultHeaders

        return Manager(configuration: configuration)
    }()

    //URL encode the postcode and provide a JSON observerable for the request
    static func resturantSearchObservable(postcode: String) -> Observable<AnyObject>? {

        guard let urlPostcode = postcode.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet()) else {

            print("Error creating URL encoded post code")
            return nil
        }

        let url = "\(JustEatService.RESTURANT_URL)?q=\(urlPostcode)"
        return JustEatService.manager.rx_JSON(.GET, url)
    }
}
