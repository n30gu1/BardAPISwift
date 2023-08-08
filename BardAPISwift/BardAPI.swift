//
//  Core.swift
//  BardAPISwift
//
//  Created by Sung Park on 7/10/23.
//

import Foundation

public class BardAPI {
    var apiKey: String = ""
    var language: String?
    var timeout: Int?
    
    init(apiKey: String, language: String?, timeout: Int?) {
        self.apiKey = apiKey
        self.language = language
        self.timeout = timeout
    }
}
