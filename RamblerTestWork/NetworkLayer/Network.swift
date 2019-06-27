//
//  Network.swift
//  RamblerTestWork
//
//  Created by Влад Калаев on 27/06/2019.
//  Copyright © 2019 Влад Калаев. All rights reserved.
//

import Foundation
import Alamofire

class Network {
    
    static let network = Network()
    
    func getData(completion: @escaping (Comments) -> Void) {
      
         let url = "http://private-db05-jsontest111.apiary-mock.com/androids"
        
        Alamofire.request(url).responseData { response in
        
            if let json = response.result.value {
                let commets = try? JSONDecoder().decode([Comment].self, from: json)
                completion(commets!)
            }
      
        }
        
    }
    
    
    
}
