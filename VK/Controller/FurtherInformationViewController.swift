//
//  FurtherInformationViewController.swift
//  VK
//
//  Created by Эля Корельская on 14.08.2023.
//

import UIKit

class FurtherInformationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(named: "backarrow"), for: .normal)
        backButton.tintColor = UIColor(named: "Orange")
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        view.backgroundColor = .systemBackground
        navigationItem.title = "Подробная информация"
    }
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
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
