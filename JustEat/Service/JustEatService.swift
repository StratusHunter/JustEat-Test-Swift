//
// Created by Terence Baker on 11/05/2016.
// Copyright (c) 2016 Bulb Studios Ltd. All rights reserved.
//

import UIKit
import RxSwift
import RxAlamofire
import Alamofire

class JustEatService {

    //Not happy with this class. Feel like there is a better appraoch.
    private static let AUTH_CODE = "VGVjaFRlc3RBUEk6dXNlcjI="
    private static let BASE_URL = "https://public.je-apis.com"
    private static let RESTURANT_URL = "\(BASE_URL)/restaurants"
    private static let RESTURANT_QUERY = "q"

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

        guard let urlPostcode = postcode.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet()), let components = NSURLComponents(string: JustEatService.RESTURANT_URL) else {

            print("Error creating URL encoded post code")
            return nil
        }

        components.queryItems = [NSURLQueryItem(name: JustEatService.RESTURANT_QUERY, value: urlPostcode)]
        return JustEatService.manager.rx_JSON(.GET, components.URLString)
    }
}
