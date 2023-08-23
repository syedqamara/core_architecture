//
//  File.swift
//  
//
//  Created by Apple on 18/08/2023.
//

import Foundation

public class ViewModuleFactory {
    public func create<M: ViewModuling>(_ input: M.ModuleInput) -> M {
        return M(input: input)
    }
}

