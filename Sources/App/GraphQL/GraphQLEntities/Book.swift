//
//  Book.swift
//  
//
//  Created by Jani Pasanen on 2024-02-24.
//

import struct Pioneer.ID

struct Book: Identifiable, Codable {
    var id: ID
    var title: String
}
