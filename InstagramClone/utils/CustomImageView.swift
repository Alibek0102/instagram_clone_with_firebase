//
//  CustomImageView.swift
//  InstagramClone
//
//  Created by Алибек Аблайулы on 30.09.2023.
//

import UIKit

class CustomImageView: UIImageView {
    private var lastImageUrl: String?
    
    func fetchPhoto(urlString: String){
        self.lastImageUrl = urlString
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, responce, err in
            
            if url.absoluteString != self.lastImageUrl {
                return
            }
            
            guard let data = data else {
                if err != nil {
                    print("err")
                }
                return
            }
            DispatchQueue.main.async {
                self.image = UIImage(data: data)
            }
        }.resume()
    }
}
