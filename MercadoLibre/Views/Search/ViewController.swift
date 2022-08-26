//
//  ViewController.swift
//  MercadoLibre
//
//  Created by Carlos Ardila on 23/08/22.
//

import UIKit
import RxSwift
import Toast_Swift

class ViewController: UIViewController {
    
    var searchText = ""
    var isFiltered = false
    var viewModel : MainViewModel? = MainViewModel()
    let disposeBag = DisposeBag()
    var arrayProducts = [Product]()
    var categories = [Category]()
    
    
    @IBOutlet weak var filterCategoryView: FilterCategoryView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBarHeightConstraint: NSLayoutConstraint!
    
    deinit {
        viewModel = nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let search = UISearchController(searchResultsController: nil)
        search.delegate = self
        search.searchBar.delegate = self
        search.searchBar.searchTextField.backgroundColor = .white
        search.searchBar.placeholder = "Buscar"
        self.navigationItem.searchController = search
        initUIComponents()
    }
    
    //initialize UI components of view controller
    func initUIComponents() {
        filterCategoryView.showSpinner()
        filterCategoryView.delegate = self
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        addObservers()
        self.viewModel?.loadCategories()
    }
    
    func addObservers() {
        //result of load categories observer
        viewModel?.categoriesResult.subscribe(onNext: { [weak self] result in
            guard let self = self else { return }
            self.filterCategoryView.stopSpinner()
            self.categories = result
            var listTextCategories = [String]()
            self.categories.forEach { (category) in
                listTextCategories.append(category.name)
            }
            self.filterCategoryView.setCategoryFilter(categoryTextArray: listTextCategories)
        }).disposed(by: disposeBag)
        
        //Result of products
        viewModel?.productsResult.subscribe(onNext: { [weak self] result in
            guard let self = self else { return }
            self.arrayProducts = result
            self.tableView.reloadData()
        }).disposed(by: disposeBag)
        
        //toast message observer
        viewModel?.toastMessage.subscribe(onNext: { [weak self] result in
            guard let self = self else { return }
            self.view.makeToast(result)
        }).disposed(by: disposeBag)
    }
}
extension ViewController: UISearchControllerDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchText = ""
        self.searchBarHeightConstraint.constant = 50
        self.filterCategoryView.activateFilter()
        self.view.layoutIfNeeded()
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchText = searchBar.text ?? ""
        guard !searchText.isEmpty else {
            self.searchText = ""
            isFiltered = false
            self.tableView.reloadData()
            return
        }
        self.filterCategoryView.desactivateFilter()
        self.viewModel?.getProductsByText(text: searchText)
        self.searchBarHeightConstraint.constant = 0
        self.view.layoutIfNeeded()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath) as? SearchTableViewCell {
            let model = arrayProducts[indexPath.row]
            cell.productTitleLabel.text = model.title
            cell.productSubtitleLabel.text = "\(model.price.formattedWithSeparator) \(model.currency_id)"
            cell.freeShippingLabel.isHidden = !model.shipping.free_shipping
            if let url = URL(string: model.thumbnail) {
                cell.productImageView.loadUrlImage(url)
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = arrayProducts[indexPath.row]
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "detail") as? ProductDetailController
        if let nextVC = vc {
            nextVC.model = model
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
}

//MARK: -selectCategoryDelegate
extension ViewController: selectCategoryDelegate {
    func selectIndexCategory(index: Int, categoryText: String) {
        tableView.setContentOffset(.zero, animated: true)
        viewModel?.getProductsByCategory(categoryID: self.categories[index].id)
    }
}

