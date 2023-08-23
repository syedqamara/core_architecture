//
//  File.swift
//  
//
//  Created by Apple on 19/08/2023.
//

import Foundation
import core_architecture
public struct Address: DataModel {
    public let street: String
    public let city: String
}

public struct Education: DataModel {
    public let degree: String
    public let major: String
}

public struct Friend: DataModel {
    public let name: String
    public let age: Int
}

public struct Person: DataModel {
    public let name: String
    public let age: Int
    public let address: Address
    public let hobbies: [String]
    public let education: [Education]
    public let friends: [Friend]
}

public struct RootObject: DataModel {
    let person: Person
}

extension RootObject {
    public static func example() -> RootObject {
        RootObject(
            person: Person(
                name: "Qammar Abbas",
                age: 31,
                address: Address(
                    street: "Main Bazar",
                    city: "Sheikhupura"
                ),
                hobbies: [
                    "poetry",
                    "singing",
                    "programming"
                ],
                education: [
                    Education(
                        degree: "BSCS",
                        major: "Computer Science"
                    )
                ],
                friends: [
                    Friend(
                        name: "Ali Mohsin",
                        age: 30
                    )
                ]
            )
        )

    }
    public static func exampleRequest() -> URLRequest {
        var request = URLRequest(url: .init(string: "https://www.something.com")!)
        request.httpMethod = "POST"
        return request
    }
}
