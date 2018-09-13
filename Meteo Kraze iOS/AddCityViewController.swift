//
//  AddCityViewController.swift
//  Meteo Kraze iOS
//
//  Created by Guillaume Fourrier on 13/09/2018.
//  Copyright © 2018 Guillaume Fourrier. All rights reserved.
//

import UIKit

class AddCityViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var addCityTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.addCityTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        guard let cityName = textField.text else {
            self.navigationController?.popViewController(animated: true)
            return true
        }
        MeteoService.shared.getWeather(city: cityName)
        self.navigationController?.popViewController(animated: true)
        return true
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
