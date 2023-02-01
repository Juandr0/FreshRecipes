//
//  AsyncImageLoader.swift
//  FreshRecepies
//
//  Created by Alexander Carlsson on 2023-02-01.
//

import Foundation

struct AsyncImageLoader {
    func loadImage(urlString: String) -> UIImage {
        guard let url = URL(string: urlString) else { return completion(UIImage()) }
        
        DispatchQueue.global().async {
            do {
                let data = try Data(contentsOf: url)
                DispatchQueue.main.async {
                    completion(UIImage(data: data) ?? UIImage())
                }
            } catch {
                DispatchQueue.main.async {
                    completion(UIImage())
                }
            }
        }
    }
}
