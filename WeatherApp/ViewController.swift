//
//  ViewController.swift
//  WeatherApp
//
//  Created by ポロリア on 2016/11/13.
//  Copyright © 2016年 nakamura. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage

class ViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var todayLabel: UILabel!
    @IBOutlet weak var todayImage: UIImageView!
    @IBOutlet weak var todayWeatherLabel: UILabel!
    @IBOutlet weak var todayTemperatureLabel: UILabel!
    
    @IBOutlet weak var tomorrowLabel: UILabel!
    @IBOutlet weak var tomorrowImage: UIImageView!
    @IBOutlet weak var tomorrowWeatherLabel: UILabel!
    @IBOutlet weak var tomorrowTemperatureLabel: UILabel!
    
    @IBOutlet weak var afterTomorrowLabel: UILabel!
    @IBOutlet weak var afterTomorrowImage: UIImageView!
    @IBOutlet weak var afterTomorrowWeatherLabel: UILabel!
    @IBOutlet weak var afterTomorrowTemperatureLabel: UILabel!
    

//    let resultTextArray: [String] = [
//        "todayWeather",
//        "tomorrowWeather",
//        "afterTomorrowWeather"
//            ]
//    
//    let resultNum = Int(resultTextArray.count)
//    self todayLabe1(resultTextArray.count).text = resultTextArray[resultNum]
//    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Alamofireを利用して通信を行います。
        Alamofire.request("http://weather.livedoor.com/forecast/webservice/json/v1?city=030010").responseJSON { (response: DataResponse<Any>) in
            
            
            if response.result.isFailure {
               self.simpleAlert(title: "通信エラー", message: "通信に失敗しました")
                return
            }
            // "guard let 変数 〜 else" で変数の中身がnilの場合のみの処理が書けます。
            // ただし最後に必ずreturnで関数を終了させなければいけません。
            // 変数は以後の関数内でも利用できます。
            guard let val = response.result.value as? [String: Any] else {
                self.simpleAlert(title: "通信エラー", message: "通信結果がJSONではありませんでした")
                return
            }
            // responseJSONを使うと辞書形式でも扱えますが、今回はより簡単に扱うためにSwiftyJSONを利用します。
            let json = JSON(val)
            
            // タイトル部分
            if let title = json["title"].string {
                self.titleLabel.text = title
            }
        
            // 天気の情報
            if let forecasts = json["forecasts"].array {
                
                
                
            
                // 今日の天気
                var box = forecasts[0]
                self.todayLabel.text = box["dateLabel"].stringValue + " " + box["telop"].stringValue + " " + self.generateTemperatureText(box["temperature"])
                if let imgUrl = box["image"]["url"].string {
                    self.todayImage.sd_setImage(with: URL(string: imgUrl))
                }
                
                // 明日の天気
                var box1 = forecasts[1]
                
                self.tomorrowLabel.text = box1["dateLabel"].stringValue + " " + box["telop"].stringValue + " " + self.generateTemperatureText(box1["temperature"])
                if let imgUrl = box1["image"]["url"].string {
                    self.tomorrowImage.sd_setImage(with: URL(string: imgUrl))
                }

                
                
                // 明後日の天気
                // 気象情報の更新が入るまで明後日の天気情報が存在しない場合があるので要素数をチェックします
                if forecasts.count >= 3 {
                    let afterTomorrowWeather = forecasts[2]
                    
                    self.afterTomorrowLabel.text = afterTomorrowWeather["dateLabel"].stringValue
                    if let imgUrl = afterTomorrowWeather["image"]["url"].string {
                        self.afterTomorrowImage.sd_setImage(with: URL(string: imgUrl))
                    }
                    self.afterTomorrowWeatherLabel.text = afterTomorrowWeather["telop"].stringValue
                    self.afterTomorrowTemperatureLabel.text = self.generateTemperatureText(afterTomorrowWeather["temperature"])
                }
            
            }
    }
    }
    
    // 気温のラベル用テキストを生成します。
    func generateTemperatureText(_ temperature: JSON) -> String {
        
        var resultText = ""
        
        if let min = temperature["min"]["celsius"].string {
            resultText += min + "℃"
        } else {
            resultText += "-"
        }
        
        resultText += " / "
        
        if let max = temperature["max"]["celsius"].string {
            resultText += max + "℃"
        } else {
            resultText += "-"
        }
        
        return resultText
    }
    // 閉じるボタンのみのアラートを表示します。
    func simpleAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "閉じる", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }


}

