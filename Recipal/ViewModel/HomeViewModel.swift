//
//  HomeViewModel.swift
//  Recipal
//
//  Created by Soha Ahmed Hamdy on 02/01/2022.
//

import Foundation
import Combine
import SystemConfiguration

protocol HomeViewModelProtocol : ObservableObject{
    func fetchHomeData(tag :String)
}


class HomeViewModel :HomeViewModelProtocol {
 
    var remote :NetworkServicesProtocol?
    @Published var fetchedHomeData:Categories! = Categories(count: 0, results: [])
    @Published var isReqestFailed = false
    @Published var isLoading = false
    private var cancellable : AnyCancellable?
    
    init( remoteDataSource: NetworkServicesProtocol) {
        self.remote = remoteDataSource
    }
    
    func fetchHomeData(tag :String){
        isLoading = true
        fetchedHomeData = Categories(count: 0, results: [])
        cancellable = self.remote?.fetchHomeCategoriesData(tag:tag)?
        .receive(on: DispatchQueue.main)
        .sink { completion in
            switch completion{
            case .failure(let error):
                self.isReqestFailed = true
                print(error)
            case .finished:
                print("finished")
                self.isLoading = false
            }
        } receiveValue: { categories in
            self.isLoading = false
            self.fetchedHomeData = categories
        }
    }
}
    
