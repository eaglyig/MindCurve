//
//  ClientRequest.swift
//  MindCurve
//
//  Created by Ihor Orlenko on 31.08.2023.
//

import Foundation

final class ClientRequest {
    
    private struct Constants {
        static let baseURL = "https://wordsapiv1.p.rapidapi.com/words"
        static let headers = [
            "X-RapidAPI-Key": "43f190ce1emsh4f96da63ce1164ap13bf0djsn8eb8dc01f506",
            "X-RapidAPI-Host": "wordsapiv1.p.rapidapi.com"
        ]
    }
    
    /// Path components for API, if any
    private let pathComponent: [String]
    
    /// Query arguments for API, if any
    private let queryParameters: [URLQueryItem]
    
    /// Constructed url for the api request in string format
    private var urlString: String {
        var string = Constants.baseURL
        
        if !pathComponent.isEmpty {
            pathComponent.forEach({
                string += "/\($0)"
            })
        }
        
        if !queryParameters.isEmpty {
            string += "?"
            let argumentString = queryParameters.compactMap({
                guard let value = $0.value else { return nil }
                return "\($0.name)=\(value)"
            }).joined(separator: "&")
            
            string += argumentString
        }
        
        return string
    }
    
    /// Computed and constructed API url
    public var url: URL? {
        return URL(string: urlString)
    }
    
    public var urlRequest: URLRequest {
        var request = URLRequest(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        request.httpMethod = self.httpMethod
        request.allHTTPHeaderFields = Constants.headers
        return request
    }
    
    /// Http method
    public let httpMethod = "GET"
    
    /// Construct request
    /// - Parameters:
    ///   - pathComponent: Collection of path components
    ///   - queryParameters: Collections of query parameters
    init(
        pathComponent: [String] = [],
        queryParameters: [URLQueryItem] = []
    ) {
        self.pathComponent = pathComponent
        self.queryParameters = queryParameters
    }
}
