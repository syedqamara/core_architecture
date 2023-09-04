//
//  File.swift
//  
//
//  Created by Apple on 25/07/2023.
//

import Foundation
// TODO: Add Custom Error Option `LocalFileErrorCode`
public enum LocalFileErrorCode: Int {
    case fileNotFound = 404
}
// TODO: Add Custom Error Option for `NetworkErrorCode`
public enum NetworkErrorCode: Int {
    // Client-side errors
    case invalidSwiftModel = 397
    case noNetworkConfigurationFound = 398
    case invalidURL = 399
    case badRequest = 400
    case unauthorized = 401
    case forbidden = 403
    case notFound = 404
    case methodNotAllowed = 405
    case requestTimeout = 408
    case conflict = 409
    case tooManyRequests = 429
    case unsupportedMediaType = 415
    case unprocessableEntity = 422
    case internalServerError = 500
    case badGateway = 502
    case serviceUnavailable = 503
    case gatewayTimeout = 504
    
    // Network-related errors
    case noInternetConnection = -1009
    case notConnectedToInternet = -1004
    
    // SSL/TLS errors
    case sslHandshakeFailed = -1200
    case sslCertificateExpired = -1201
    case sslCertificateRevoked = -1202
    case sslCertificateUntrusted = -1203
    case sslCertificateNotValidYet = -1204
    case sslCertificateChainInvalid = -1205
    case sslClientCertificateRejected = -1206
    case sslServerCertificateHasUnknownRoot = -1207
    case sslServerCertificateNotYetValid = -1208
    case sslServerCertificateHasBadDate = -1209
    case sslServerCertificateUnknown = -1210
    
    // Other custom error codes as needed
}


extension LocalFileErrorCode: Erroring {
    public var code: Int { rawValue }
    private func snakeCase(_ input: String) -> String {
        let parts = input.split(separator: " ").map { $0.lowercased() }
        return parts.joined(separator: "_")
    }
    
    public var identifier: String {
        return snakeCase(message)
    }
    public var message: String {
        switch self {
        case .fileNotFound:
            return "File not found"
        }
    }
}

extension NetworkErrorCode: Erroring {
    public var code: Int { rawValue }
    private func snakeCase(_ input: String) -> String {
        let parts = input.split(separator: " ").map { $0.lowercased() }
        return parts.joined(separator: "_")
    }
    
    public var identifier: String {
        return snakeCase(message)
    }
    public var message: String {
        switch self {
        case .invalidSwiftModel:
            return "Invalid Swift Model for Response"
        case .noNetworkConfigurationFound:
            return "No Network Configuration Found"
        case .invalidURL:
            return "Invalid URL"
        case .badRequest:
            return "Bad Request"
        case .unauthorized:
            return "Unauthorized"
        case .forbidden:
            return "Forbidden"
        case .notFound:
            return "Not Found"
        case .methodNotAllowed:
            return "Method Not Allowed"
        case .requestTimeout:
            return "Request Timeout"
        case .conflict:
            return "Conflict"
        case .tooManyRequests:
            return "Too Many Requests"
        case .unsupportedMediaType:
            return "Unsupported Media Type"
        case .unprocessableEntity:
            return "Unprocessable Entity"
        case .internalServerError:
            return "Internal Server Error"
        case .badGateway:
            return "Bad Gateway"
        case .serviceUnavailable:
            return "Service Unavailable"
        case .gatewayTimeout:
            return "Gateway Timeout"
        case .noInternetConnection:
            return "No Internet Connection"
        case .notConnectedToInternet:
            return "Not Connected To Internet"
        case .sslHandshakeFailed:
            return "SSL Handshake Failed"
        case .sslCertificateExpired:
            return "SSL Certificate Expired"
        case .sslCertificateRevoked:
            return "SSL Certificate Revoked"
        case .sslCertificateUntrusted:
            return "SSL Certificate Untrusted"
        case .sslCertificateNotValidYet:
            return "SSL Certificate Not Valid Yet"
        case .sslCertificateChainInvalid:
            return "SSL Certificate Chain Invalid"
        case .sslClientCertificateRejected:
            return "SSL Client Certificate Rejected"
        case .sslServerCertificateHasUnknownRoot:
            return "SSL Server Certificate Has Unknown Root"
        case .sslServerCertificateNotYetValid:
            return "SSL Server Certificate Not Yet Valid"
        case .sslServerCertificateHasBadDate:
            return "SSL Server Certificate Has Bad Date"
        case .sslServerCertificateUnknown:
            return "SSL Server Certificate Unknown"
        }
    }
    
}
// MARK: Debugging Error Codes
public enum DebuggerErrorCode: Int {
    case noConfigurationFound = -1
}


extension DebuggerErrorCode: Erroring {
    public var code: Int {
        self.rawValue
    }
    
    private func snakeCase(_ input: String) -> String {
        let parts = input.split(separator: " ").map { $0.lowercased() }
        return parts.joined(separator: "_")
    }
    
    public var identifier: String {
        return snakeCase(message)
    }
    
    public var message: String {
        switch self {
        case .noConfigurationFound:
            return "No Debug Configuration Found"
        }
    }
}
// MARK: Registration Error Codes
public enum RegistrationErrorCode: Int {
    case noConfigurationFound = -1
    case unEqualConfigurationProvided
}

extension RegistrationErrorCode: Erroring {
    public var code: Int {
        self.rawValue
    }
    
    private func snakeCase(_ input: String) -> String {
        let parts = input.split(separator: " ").map { $0.lowercased() }
        return parts.joined(separator: "_")
    }
    
    public var identifier: String {
        return snakeCase(message)
    }
    
    public var message: String {
        switch self {
        case .noConfigurationFound:
            return "No Registration Configuration Found"
        case .unEqualConfigurationProvided:
            return "Configuration provided is not complete please check for batch registration method"
        }
    }
}
