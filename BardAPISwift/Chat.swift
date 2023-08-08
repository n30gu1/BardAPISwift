//
//  Chat.swift
//  BardAPISwift
//
//  Created by Sung Park on 7/10/23.
//

import Foundation

enum BardError: Error {
    case urlError
    case sessionError
    case getSNlM0eError
}

class BardChat {
    var apiKey: String = ""
    var language: String?
    var timeout: Int?
    
    init(apiKey: String, language: String?, timeout: Int?) {
        self.apiKey = apiKey
        self.language = language
        self.timeout = timeout
    }
    
    var session = {
        let configuration = URLSessionConfiguration.default
        
        return URLSession(configuration: configuration)
    }()
    
    private func getSNlM0e() async throws -> String {
        let urlRequestSNlM0e = {
            let randomDigits = (1...4).map { _ in Int.random(in: 0...9) }
            let reqid = Int(randomDigits.map(String.init).joined())!
            var urlComponents = URLComponents(string: "https://bard.google.com/")
            let url = urlComponents?.url!
            
            var urlRequest = URLRequest(url: url!)
            urlRequest.httpMethod = "GET"
            urlRequest.addValue("bard.google.com", forHTTPHeaderField: "Host")
            urlRequest.addValue("1", forHTTPHeaderField: "X-Same-Domain")
            urlRequest.addValue("Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.114 Safari/537.36", forHTTPHeaderField: "User-Agent")
            urlRequest.addValue("application/x-www-form-urlencoded;charset=UTF-8", forHTTPHeaderField: "Content-Type")
            urlRequest.addValue("https://bard.google.com", forHTTPHeaderField: "Origin")
            urlRequest.addValue("https://bard.google.com", forHTTPHeaderField: "Referer")
            
            urlRequest.httpShouldHandleCookies = true
            return urlRequest
        }()

        let configuration = URLSessionConfiguration.default

        configuration.httpShouldSetCookies = true
        configuration.httpCookieStorage?.setCookie(HTTPCookie(properties: [
            .domain: "bard.google.com",
            .path: "/",
            .name: "__Secure-1PSID",
            .value: self.apiKey
        ])!)

        let session = URLSession(configuration: configuration)
        let (data, _) = try! await session.data(for: urlRequestSNlM0e)
        
        guard let result = String(data: data, encoding: .utf8)?.firstMatch(of: /SNlM0e\":\"(.*?)\"/)?.output.1 else {
            throw BardError.getSNlM0eError
        }
        
        return String(result)
    }
    
    func ask(_ q: String) async throws {
        let urlRequest = try {
            let randomDigits = (1...4).map { _ in Int.random(in: 0...9) }
            let reqid = Int(randomDigits.map(String.init).joined())!
            var urlComponents = URLComponents(string: "https://bard.google.com/_/BardChatUi/data/assistant.lamda.BardFrontendService/StreamGenerate")
            urlComponents?.queryItems?.append(URLQueryItem(name: "bl", value: "boq_assistant-bard-web-server_20230419.00_p1"))
            urlComponents?.queryItems?.append(URLQueryItem(name: "_reqid", value: "\(reqid)"))
            urlComponents?.queryItems?.append(URLQueryItem(name: "rt", value: "c"))
            
            guard let url = urlComponents?.url else {
                throw BardError.urlError
            }
            
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "POST"
            urlRequest.addValue("bard.google.com", forHTTPHeaderField: "Host")
            urlRequest.addValue("1", forHTTPHeaderField: "X-Same-Domain")
            urlRequest.addValue("Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.114 Safari/537.36", forHTTPHeaderField: "User-Agent")
            urlRequest.addValue("application/x-www-form-urlencoded;charset=UTF-8", forHTTPHeaderField: "Content-Type")
            urlRequest.addValue("https://bard.google.com", forHTTPHeaderField: "Origin")
            urlRequest.addValue("https://bard.google.com", forHTTPHeaderField: "Referer")
            return urlRequest
        }()
        
        let configuration = URLSessionConfiguration.default

        configuration.httpShouldSetCookies = true
        configuration.httpCookieStorage?.setCookie(HTTPCookie(properties: [
            .domain: "bard.google.com",
            .path: "/",
            .name: "__Secure-1PSID",
            .value: self.apiKey
        ])!)
    }
}
