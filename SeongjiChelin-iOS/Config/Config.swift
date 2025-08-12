//
//  Config.swift
//  SeongjiChelin-iOS
//
//  Created by 박신영 on 3/28/25.
//

import Foundation

enum Config {
    enum Keys {
        static let baseURL = "BASE_URL"
        static let googleAPIKey = "GOOGLE_API_KEY"
        static let appID = "APPID"
    }
    
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("plist cannot found !!!")
        }
        return dict
    }()
}


extension Config {
    
    static let baseURL: String = {
        guard let key = Config.infoDictionary[Keys.baseURL] as? String else {
            fatalError("BASE_URL is not set in plist for this configuration")
        }
        return key
    }()
    
    static let googleAPIKey: String = {
        guard let key = Config.infoDictionary[Keys.googleAPIKey] as? String else {
            fatalError("GOOGLE_API_KEY is not set in plist for this configuration")
        }
        return key
    }()
    
    static let appID: String = {
        guard let key = Config.infoDictionary[Keys.appID] as? String else {
            fatalError("GOOGLE_API_KEY is not set in plist for this configuration")
        }
        return key
    }()
    
}

