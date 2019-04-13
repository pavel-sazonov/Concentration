//
//  ConcentrationThemeChooserViewController.swift
//  Concentration
//
//  Created by Pavel Sazonov on 13/04/2019.
//  Copyright © 2019 Pavel Sazonov. All rights reserved.
//

import UIKit

class ConcentrationThemeChooserViewController: UIViewController {
    let themes = [
        "Halloween": "👻🎃😱👽💀🧟‍♀️🐲👹🤡☠️",
        "Animals": "😸🐶🐰🦊🐷🐥🐼🦋🐭🐠",
        "Numbers": "1️⃣2️⃣3️⃣4️⃣5️⃣6️⃣7️⃣8️⃣9️⃣🔟",
        "Letters": "АБВГДЕЖЗИКЛМНОПРСТУФХЦШЩЬЪЭЮЯ",
        "Cats": "😹😻😼😽🙀😿😾🐱😸😺"
    ]

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Choose Theme" {
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName] {
                if let cvc = segue.destination as? ConcentrationViewController {
                    cvc.theme = theme
                }
            }
        }
    }

}
