//
//  Assembler.swift
//  UserProfile
//
//  Created by Hung Nguyen on 09/12/2024.
//

import Foundation

protocol Assembler: AnyObject, 
                    ViewControllerAssembler,
                    ViewModelAssembler,
                    RepositoryAssembler,
                    ServiceAssembler {
    
}

class DefaultAssembler: Assembler {}
