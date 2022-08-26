//
//  ProductsResult.swift
//  MercadoLibre
//
//  Created by Carlos Ardila on 24/08/22.
//

import Foundation

struct ProductResult: Codable {
    var site_id: String
    var paging: Paging
    var results: [Product]
}
