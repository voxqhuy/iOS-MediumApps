//
//  CreateOrderInteractor.swift
//  CleanStore
//
//  Created by Vo Huy on 1/3/19.
//  Copyright © 2019 Vo Huy. All rights reserved.
//

import UIKit

protocol CreateOrderBusinessLogic
{
    func doSomething(request: CreateOrder.Something.Request)
    var shippingMethods: [String] { get }
}

protocol CreateOrderDataStore
{
    //var name: String { get set }
}

class CreateOrderInteractor: CreateOrderBusinessLogic, CreateOrderDataStore
{
    var presenter: CreateOrderPresentationLogic?
    var worker: CreateOrderWorker?
    var shippingMethods: [String]?
    
    // MARK: Do something
    
    func doSomething(request: CreateOrder.Something.Request)
    {
        worker = CreateOrderWorker()
        worker?.doSomeWork()
        
        let response = CreateOrder.Something.Response()
        presenter?.presentSomething(response: response)
    }
}
