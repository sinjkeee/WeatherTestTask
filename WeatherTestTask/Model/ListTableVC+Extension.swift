//
//  ListTableVC+Extension.swift
//  WeatherTestTask
//
//  Created by Vladimir Sekerko on 19.10.2022.
//

import UIKit

extension ListTableVC {
    
    func showAlert(name: String, placeholder: String, completionHandler: @escaping (String) -> Void) {
        let alertController = UIAlertController(title: name, message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { action in
            let tfText = alertController.textFields?.first
            guard let text = tfText?.text else { return }
            completionHandler(text)
        }
        
        alertController.addTextField { textField in
            textField.placeholder = placeholder
        }
        
        let cancelAlert = UIAlertAction(title: "Отмена", style: .default)
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAlert)
        
        present(alertController, animated: true)
    }
}
