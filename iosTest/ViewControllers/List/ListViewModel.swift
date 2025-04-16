//
//  ViewModel.swift
//  iosTest
//
//  Created by Adrian Aguilar on 15/4/25.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class ListViewModel {
    private let disposeBag = DisposeBag()
    
    var loading = BehaviorRelay<Bool>(value: false)
    var itemList = BehaviorRelay<[Item]>(value: [])
    var paginationData = BehaviorRelay<PaginationResponse?>(value: nil)
    let error = PublishRelay<String>()
    
    private var offset = 0
    private let limit = 10
    private var canFetch = true
    
    
    func fetchData(){
        guard !self.loading.value, canFetch  else { return }
        self.loading.accept(true)
        WServices.shared.getItems(offset: offset, limit: limit, completion: { [weak self] result in
            self?.loading.accept(false)
            switch result {
                case .success(let pagination):
                    var currentItems = self?.itemList.value ?? []
                    currentItems.append(contentsOf: pagination.results)
                    self?.offset += self?.limit ?? 0
                
                    self?.canFetch = pagination.next != nil
                    self?.itemList.accept(currentItems)
                    self?.paginationData.accept(pagination)
                case .failure(let error):
                    print("❌ Error fetching abilities: \(error)")
                    self?.error.accept(error.localizedDescription)
            }
        })
            
    }
}

