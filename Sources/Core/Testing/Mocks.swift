//
//  Mocks.swift
//  NYTimes
//
//  Created by Apple on 12/01/2024.
//

import Foundation

// MARK: - Mocks


public class MockFunctionArgument<V> {
    public var argumentRecievedCount: Int
    public var isArgumentRecieved: Bool { argumentRecievedCount > 0 }
    public var argumentLastValue: V?
    public var argumentAllValues: [V]
    public var argumentRecievedClouser: ((V?) -> ())?
    public init(argumentRecievedCount: Int = 0, argumentLastValue: V? = nil, argumentAllValues: [V] = [], argumentRecievedClouser: ((V?) -> Void)? = nil) {
        self.argumentRecievedCount = argumentRecievedCount
        self.argumentLastValue = argumentLastValue
        self.argumentAllValues = argumentAllValues
        self.argumentRecievedClouser = argumentRecievedClouser
    }
    func invoked(by argument: V?) {
        argumentRecievedCount += 1
        argumentLastValue = argument
        if let argument {
            argumentAllValues.append(argument)
        }
        argumentRecievedClouser?(argument)
    }
}

/**
 A mock implementation for the MockMindValleyServiceProtocol protocol.
 */

protocol Mockable {
    associatedtype Parameter
    associatedtype Returned
    var parameter: Parameter { get set }
    var returned: Returned { get set }
    init(parameter: Parameter, returned: Returned)
}

public class Mocking<P, R>: Mockable {
    public typealias Parameter = P
    public typealias Returned = R
    public var parameter: P
    public var returned: R
    required public init(parameter: P, returned: R) {
        self.parameter = parameter
        self.returned = returned
    }
}
