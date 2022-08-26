//
//  Product.swift
//  MercadoLibre
//
//  Created by Carlos Ardila on 24/08/22.
//

import Foundation

enum productCondition: String, Codable {
    case new //= "Nuevo"
    case used //= "Usado"
}

struct Product: Codable {
    var id: String
    var title: String
    var thumbnail: String
    var condition: productCondition
    var attributes: [ProductAttribute]
    var price: Int
    var currency_id: String
    var available_quantity: Int
    var sold_quantity: Int
    var shipping: ProductShipping
    
    func getProductStatusString() -> String {
        return self.condition == .new ? "Nuevo" : "Usado"
    }
}
