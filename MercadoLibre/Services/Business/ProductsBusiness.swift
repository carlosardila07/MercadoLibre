//
//  ProductsBusiness.swift
//  MercadoLibre
//
//  Created by Carlos Ardila on 23/08/22.
//

import Foundation
import PromiseKit

struct ProductsBusiness {
    let siteID = "MCO"
    
    func getCategories() -> Promise<[Category]> {
        return NetworkManager.shared.arrayRequest("sites/\(siteID)/categories", method: .get)
    }
    
    func getProductsByCategory(_ categoryID: String) -> Promise<ProductResult> {
        return NetworkManager.shared.request("/sites/\(siteID)/search?category=\(categoryID)", method: .get)
    }
    
    func getProductsByText(_ text: String) -> Promise<ProductResult> {
        return NetworkManager.shared.request("/sites/\(siteID)/search?q=\(text)", method: .get)
    }
}
