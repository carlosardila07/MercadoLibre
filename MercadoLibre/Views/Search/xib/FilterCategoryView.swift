//
//  FilterCategoryView.swift
//  MercadoLibre
//
//  Created by Carlos Ardila on 24/08/22.
//

import UIKit
import ABLoaderView

protocol selectCategoryDelegate {
    func selectIndexCategory(index: Int, categoryText: String)
}

class FilterCategoryView: UIView {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var generalScrollView: UIScrollView!
    
    let heightLabelAndView: CGFloat = 32;
    
    private var viewSelect = UIView()
    private var listLabel = [UILabel]()
    private var listButton = [UIButton]()
    private var categoryTextArray = [String]()
    
    private var isFirstCall = false
    
    private var afterFrame = CGRect()
    var delegate:selectCategoryDelegate?
    
    var isDesactivateFilter = false
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewSetup()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        viewSetup()
        
    }
    
    private func loadViewFromNib() -> UIView? {

         let nibName = "FilterCategoryView"
         let bundle = Bundle(for: type(of: self))
         let nib = UINib(nibName: nibName, bundle: bundle)
         return nib.instantiate(withOwner: self, options: nil).first as? UIView
     }
    
    private func viewSetup() {
        
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        if !isFirstCall {
            self.addSubview(view)
            isFirstCall = true
        }
        
        contentView = view
        
    }
    
    func setCategoryFilter(categoryTextArray: [String]) {
        generalScrollView.subviews.forEach({ $0.removeFromSuperview() })
        self.categoryTextArray = categoryTextArray
        listLabel = [UILabel]()
        listButton = [UIButton]()
        createViewFont()
        configureScrollView()
        buttonAction(sender: listButton[0])
    }
    
    func showSpinner() {
        for view in generalScrollView.subviews {
            ABLoader().startShining(view)
        }
    }
    
    func stopSpinner() {
        for view in generalScrollView.subviews {
            ABLoader().stopShining(view)
        }
        
    }
    private func configureScrollView() {

        var xOrigin: CGFloat = 24
        let yOrigen: CGFloat = (generalScrollView.frame.height / 2) - (heightLabelAndView / 2)
        let spacingX: CGFloat = 4
        
        var i = 0
        for category in categoryTextArray {
            let widthLabel = category.uppercased().boundingRect(with: CGSize(width: generalScrollView.frame.width - 10, height: generalScrollView.frame.height), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10)], context: nil).size.width + 8
            let categoryLabel = UILabel(frame: CGRect(x: xOrigin, y: yOrigen, width: widthLabel, height: heightLabelAndView))
            
            categoryLabel.font = UIFont.systemFont(ofSize: 10)
            categoryLabel.text = category
            categoryLabel.backgroundColor = UIColor.clear
            categoryLabel.textAlignment = .center
            categoryLabel.textColor = #colorLiteral(red: 0.2039215686, green: 0.2039215686, blue: 0.2039215686, alpha: 1)
            categoryLabel.layer.cornerRadius = 10
            categoryLabel.layer.borderWidth = 1
            categoryLabel.layer.borderColor = #colorLiteral(red: 0.2039215686, green: 0.2039215686, blue: 0.2039215686, alpha: 1)
            categoryLabel.tag = i
            
            let categoryButton = UIButton(frame: categoryLabel.frame)
            categoryButton.backgroundColor = UIColor.clear
            categoryButton.tag = i
            categoryButton.layer.cornerRadius = 10
            categoryButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
            
            generalScrollView.addSubview(categoryLabel)
            generalScrollView.addSubview(categoryButton)
            listLabel.append(categoryLabel)
            listButton.append(categoryButton)
            i += 1
            xOrigin += categoryLabel.frame.width + spacingX
        }
        
        generalScrollView.contentSize = CGSize(width: xOrigin + 80, height: generalScrollView.frame.height)
    }
    
    @objc func buttonAction(sender: UIButton!) {
        setValue(view: sender)
        delegate?.selectIndexCategory(index: sender.tag, categoryText: categoryTextArray[sender.tag])
    }
    
    private func createViewFont() {
        viewSelect = UIView(frame: CGRect(x: 1, y: 1, width: 100, height: heightLabelAndView))
        viewSelect.backgroundColor = #colorLiteral(red: 0.2039215686, green: 0.2039215686, blue: 0.2039215686, alpha: 1)
        viewSelect.layer.cornerRadius = 10
        generalScrollView.addSubview(viewSelect)
    }
    
    private func setValue(view: UIButton) {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
            self.viewSelect.frame = self.afterFrame
            self.viewSelect.frame = view.frame
            for label in self.listLabel {
                if view.tag == label.tag {
                    label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                } else {
                    label.textColor = #colorLiteral(red: 0.2039215686, green: 0.2039215686, blue: 0.2039215686, alpha: 1)
                }
            }
        }, completion: { finished in
            self.afterFrame = view.frame
        })
    }
    
    func desactivateFilter(){
        isDesactivateFilter = true
    }
    
    func activateFilter() {
        if isDesactivateFilter {
            buttonAction(sender: listButton[0])
        }
    }

}
