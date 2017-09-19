//
//  DarkstarAuctionHouseServiceApi.swift
//  DarkstarAuctionHouse
//
//  Created by Matthew Cooper on 9/11/17.
//  Copyright © 2017 Darkstar. All rights reserved.
//

import Foundation
import Moya

private func JSONResponseDataFormatter(_ data: Data) -> Data {
    do {
        let dataAsJSON = try JSONSerialization.jsonObject(with: data)
        let prettyData =  try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
        return prettyData
    } catch {
        return data // fallback to original data if it can't be serialized.
    }
}

let darkstarProvider = MoyaProvider<Darkstar>(plugins: [NetworkLoggerPlugin(verbose: true, responseDataFormatter: JSONResponseDataFormatter)])

public enum Darkstar {
    case weapons
    case armors
}

extension Darkstar: TargetType {
    public var baseURL: URL { return URL(string: "http://192.168.0.103:8080/")! }
    public var path: String {
        switch self {
        case .weapons:
            return "/weaponItems"
        case .armors:
            return "/armorItems"
        }
    }
    public var method: Moya.Method {
        return .get
    }
    public var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    public var task: Task {
        return .requestPlain
    }
    public var validate: Bool {
        switch self {
        case .weapons:
            return true
        default:
            return false
        }
    }
    
    public var sampleData: Data {
        switch self {
        case .armors:
                return "[{\"name\": \"cesti\"}]".data(using: String.Encoding.utf8)!
            
        case .weapons:
                return "[{\"name\": \"cesti\"}]".data(using: String.Encoding.utf8)!
            
        }
    }
    
    public var headers: [String: String]? {
        return nil
    }
}
