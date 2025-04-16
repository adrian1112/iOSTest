//
//  ViewController.swift
//  iosTest
//
//  Created by Adrian Aguilar on 15/4/25.
//

import UIKit
import RxCocoa
import RxSwift

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private let viewModel = ListViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindViewModel()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.fetchData()
    }
    
    private func bindViewModel(){
        self.tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        let loadingIndicator = UIActivityIndicatorView(style: .large)
        loadingIndicator.startAnimating()
        tableView.backgroundView = loadingIndicator
        
        viewModel.itemList.bind(to: tableView.rx.items(cellIdentifier: "cell")) { _, item, cell in
            cell.textLabel?.text = item.name
        }.disposed(by: disposeBag)
        
        viewModel.itemList
            .asObservable()
            .subscribe(onNext: { items in
                self.tableView.backgroundView = nil
            }).disposed(by: disposeBag)
    
        viewModel.error.subscribe(onNext: { [weak self] error in
            showAlert(vc: self!, title: "Alerta", message: error)
        }).disposed(by: disposeBag)
        
    }
}

extension ViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedItem = viewModel.itemList.value[indexPath.row]
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PokemonDetailViewController") as! PokemonDetailViewController
        vc.pokemonUrl = selectedItem.url
        let nvc = UINavigationController(rootViewController: vc)
        nvc.modalPresentationStyle = .fullScreen
        self.present(nvc, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let tableViewHeight = scrollView.frame.size.height
        if position > (contentHeight - tableViewHeight - 100) {
            viewModel.fetchData()
        }
    }
}
