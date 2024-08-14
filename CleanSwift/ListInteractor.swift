//
//  ListInteractor.swift
//  CleanSwift
//
//  Created by vaishanavi.sasane on 13/08/24.
//  Copyright (c) 2024 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol ListBusinessLogic {
    func fetchUserData(request: List.ListEntities.Request)
}

class ListInteractor: ListBusinessLogic {
    var presenter: ListPresentationLogic?
    
    // MARK: Do something (and send response to ListPresenter)
    
    func fetchUserData(request: List.ListEntities.Request) {
        
        guard let url = URL(string: URLs.usersURL) else {return}
        let task = URLSession.shared.dataTask(with: url) { [weak self]data, _, error in
            guard let data = data,error == nil else {
                let error = List.ListEntities.ViewModelFailure(errorMessage: "")
                self?.presenter?.presentError(error: error)
                return
            }
            do {
                let entites = try JSONDecoder().decode([User].self, from: data)
                self?.presenter?.presentListData(response: entites)
            } catch {
                let error = List.ListEntities.ViewModelFailure(errorMessage: error.localizedDescription)
                self?.presenter?.presentError(error: error)
            }
        }
        task.resume()
    }
}
