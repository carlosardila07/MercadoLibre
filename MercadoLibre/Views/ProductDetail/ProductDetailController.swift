//
//  ProductDetailController.swift
//  MercadoLibre
//
//  Created by Carlos Ardila on 25/08/22.
//

import UIKit

class ProductDetailController: UIViewController {

    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var soldQuantityLabel: UILabel!
    @IBOutlet weak var detailsStackView: UIStackView!
    
    
    var model: Product?
    
    deinit {
        model = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupModel()
    }
    
    func setupModel() {
        if let model = model,let url = URL(string: model.thumbnail) {
            productImageView.loadUrlImage(url)
            titleLabel.text = model.title
            soldQuantityLabel.text = "\(model.sold_quantity) unidades vendidas"
            statusLabel.text = model.getProductStatusString()
            priceLabel.text = "$ \(model.price.formattedWithSeparator)"
            for attribute in model.attributes {
                let view = FeatureView()
                if let name = attribute.name, let valueName = attribute.value_name {
                    let newString = NSMutableAttributedString()
                    newString.append("\(name): ".attributeString(font: UIFont.boldSystemFont(ofSize: 14)))
                    newString.append(valueName.attributeString(font: UIFont.systemFont(ofSize: 14)))
                    view.featureLabel.attributedText = newString
                }
                view.translatesAutoresizingMaskIntoConstraints = false
                view.heightAnchor.constraint(equalToConstant: view.featureLabel.frame.height + 7).isActive = true
                self.detailsStackView.addArrangedSubview(view)
            }
        }
    }
    
    @IBAction func didTapAddToCarButton(_ sender: Any) {
        self.showAlert()
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Producto añadido", message: "Has añadido este producto al carrito",preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
            alert.dismiss(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}


