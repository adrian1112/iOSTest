//
//  ItemDetailViewController.swift
//  iosTest
//
//  Created by Adrian Aguilar on 15/4/25.
//

import UIKit
import RxSwift
import RxCocoa

class PokemonDetailViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var pokemonUrl: String = ""
    private let viewModel = PokemonViewModel()
    private let disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let customBackButton = UIBarButtonItem(title: "Volver", style: .plain, target: self, action: #selector(back))
            navigationItem.leftBarButtonItem = customBackButton
        
        self.bindViewModel()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.fetchData(url: self.pokemonUrl)
    }
    
    private func bindViewModel(){
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        let loadingIndicator = UIActivityIndicatorView(style: .large)
        loadingIndicator.startAnimating()
        tableView.backgroundView = loadingIndicator
        
        viewModel.pokemonData
            .asObservable()
            .subscribe(onNext: { items in
                self.tableView.backgroundView = nil
                self.tableView.reloadData()
            }).disposed(by: disposeBag)
        
        viewModel.error.subscribe(onNext: { [weak self] error in
            showAlert(vc: self!, title: "Alerta", message: error)
        }).disposed(by: disposeBag)
    }
    
    @objc func back() {
        self.dismiss(animated: true)
    }

}

extension PokemonDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.pokemonData.value.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.pokemonData.value[section].title
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.pokemonData.value[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let item = viewModel.pokemonData.value[indexPath.section].items[indexPath.row]
        cell.textLabel?.text = item
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
