//
//  DebugConfigurationUI.swift
//  
//
//  Created by Apple on 04/09/2023.
//

import Foundation
import SwiftUI
import Debugger
import core_architecture


public typealias ConfigurationMenuInput<T: CustomStringConvertible> = GeneralMenuInput<GeneralSubMenu<T>>

public typealias ConfigurationCommands<T: CustomStringConvertible> = AppCommands<ConfigurationMenuInput<T>>
public typealias ConfigurationToolbar<T: CustomStringConvertible> = AppToolbar<ConfigurationMenuInput<T>>
