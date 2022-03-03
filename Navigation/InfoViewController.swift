//
//  InfoViewController.swift
//  Navigation
//
//  Created by mitr on 03.03.2022.
//

import UIKit

class InfoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hue: 0.3, saturation: 0.3, brightness: 1, alpha: 1.0)
        title = "Информация"
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
        button.center = view.center
        button.backgroundColor = .systemBlue
        button.setTitle("Предупреждение", for: .normal)
        button.addTarget(self, action: #selector(tap), for: .touchUpInside)
        view.addSubview(button)
    }
    
    @objc func tap(sender: UIButton) {
            let alert = UIAlertController(title: "Внимание",
                                          message: "Вы уверены?",
                                          preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Нет",
                                       style: .cancel,
                                             handler: {_ in
                print("Не уверен")
            })
            alert.addAction(cancelAction)
            
            let deletelAction = UIAlertAction(title: "Да",
                                       style: .destructive,
                                             handler: {_ in
                print("Уверен")
            })
            alert.addAction(deletelAction)
            present(alert, animated: true, completion: nil)
        }
}
