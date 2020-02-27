//
//  EnumFiles.swift
//  Kwento
//
//  Created by Art John on 27/02/2020.
//  Copyright © 2020 Richtone Hangad. All rights reserved.
//

import Foundation

enum NavItem {
    case dashboard
    case profile
    case how
    case location
    case visit
    case support
}

struct SelectedNav {
    static var item : NavItem = .dashboard
}
