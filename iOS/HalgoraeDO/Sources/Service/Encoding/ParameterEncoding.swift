//
//  ParameterEncoder.swift
//  HalgoraeDO
//
//  Created by woong on 2020/12/04.
//

import Foundation

typealias Parameters = [String: Any]

enum EncodingError : String, Error {
    case parametersNil = "Parameters were nil."
    case encodingFailed = "Parameter encoding failed."
    case missingURL = "URL is nil."
}

protocol ParameterEncoding {
    func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws
}
