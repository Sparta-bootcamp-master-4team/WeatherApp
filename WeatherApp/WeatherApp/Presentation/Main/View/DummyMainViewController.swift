//
//  DummyMainViewController.swift
//  WeatherApp
//
//  Created by shinyoungkim on 5/21/25.
//

import UIKit

// 사용 종료 후 삭제할 예정입니다.
class DummyMainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

struct DummyHourlyWeather {
    let time: String
    let weatherIcon: String
    let temperature: String
}
