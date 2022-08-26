//
//  CustomError.swift
//  MercadoLibre
//
//  Created by Carlos Ardila on 23/08/22.
//

import Foundation

protocol OurErrorProtocol: LocalizedError {
    var title: String? { get }
    var code: Int { get }
}

struct CustomError: OurErrorProtocol {

    var title: String?
    var code: Int
    var errorDescription: String {
        get { return _description }
        set { self._description = newValue }
    }
    
    var failureReason: String? {
        get { return _description }
        set { self._description = newValue ?? "Error de servidor" }
    }

    private var _description: String

    init(title: String?, description: String, code: Int) {
        self.title = title ?? "Error"
        self._description = description
        self.code = code
    }
}
