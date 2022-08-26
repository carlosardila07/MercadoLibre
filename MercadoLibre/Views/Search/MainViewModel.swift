//
//  MainViewModel.swift
//  MercadoLibre
//
//  Created by Carlos Ardila on 24/08/22.
//

import Foundation
import RxSwift

class MainViewModel {
    
    var business: ProductsBusiness? = ProductsBusiness()
    let productsResult = PublishSubject<[Product]>()
    let categoriesResult = PublishSubject<[Category]>()
    let toastMessage = PublishSubject<String>()
    
    deinit {
        self.business = nil
    }
    
    func loadCategories() {
        business?.getCategories().done { result in
            self.categoriesResult.onNext(result)
        }.catch { error in
            if let error = error as? CustomError {
                self.toastMessage.onNext(error.errorDescription)
            }
        }
    }
    
    func getProductsByCategory(categoryID: String) {
        business?.getProductsByCategory(categoryID).done { result in
            self.productsResult.onNext(result.results)
        }.catch { error in
            if let error = error as? CustomError {
                self.toastMessage.onNext(error.errorDescription)
            }
        }
    }
    
    func getProductsByText(text: String) {
        business?.getProductsByText(text).done { result in
            self.productsResult.onNext(result.results)
        }.catch { error in
            if let error = error as? CustomError {
                self.toastMessage.onNext(error.errorDescription)
            }
        }
    }
}
