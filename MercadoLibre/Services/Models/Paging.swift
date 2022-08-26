//
//  Paging.swift
//  MercadoLibre
//
//  Created by Carlos Ardila on 25/08/22.
//

import Foundation

struct Paging: Codable {
    var total: Int
    var offset: Int
    var limit: Int
    var primary_results: Int
}
