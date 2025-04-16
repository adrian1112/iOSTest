//
//  Services.swift
//  iosTest
//
//  Created by Adrian Aguilar on 15/4/25.
//

import Foundation
import Alamofire

class WServices{
    static let shared = WServices()
    
    enum nameService: String{
        case ITEMS_LIST = "/api/v2/ability/"
    }
    
    func getItems(offset: Int, limit: Int = 10, completion: @escaping (Result<PaginationResponse, Error>) -> Void) {
        var  url = BASEURL + nameService.ITEMS_LIST.rawValue
        if offset != 0 { url = url + "?offset=\(offset)" }
        url = url + "?limit=\(limit)"
        
        AF.request(url)
            .validate()
            .responseDecodable(of: PaginationResponse.self) { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func getPokemon( url: String, completion: @escaping (Result<Pokemon, Error>) -> Void) {
        
        AF.request(url)
            .validate()
            .responseDecodable(of: Pokemon.self) { response in
//                print("termina: ", response)
                switch response.result {
                case .success(let data):
                    print(data)
                    completion(.success(data))
                case .failure(let error):
                    print("error: ",error.localizedDescription)
                    completion(.failure(error))
                }
            }
    }
}
