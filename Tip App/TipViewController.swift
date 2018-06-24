//
//  TipViewController.swift
//  Tip App
//
//  Created by User01 on 2018/6/24.
//  Copyright © 2018年 isr10132. All rights reserved.
//

import UIKit

class TipViewController: UIViewController {

    @IBOutlet weak var moneyLabel: UITextField!
    @IBOutlet weak var discountLabel: UITextField!
    @IBOutlet weak var tipLabel: UITextField!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var roundingLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet var errorImages: [UIImageView]!
    
    var errorMessage: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // 印出 結果 及 四捨五入後
    func printResult()
    {
        let moneyInt = Int(moneyLabel.text!)
        let discountInt = Int(discountLabel.text!)
        let tipInt = Int(tipLabel.text!)
        // 金額 欄位有值，且折扣及小費輸入無錯誤
        if let moneyInt = moneyInt, let result = calculate(money: moneyInt, discount: discountInt, tip: tipInt){
            totalLabel.text = "\(result)"
            roundingLabel.text = "\(lround(result))"
            errorLabel.text = nil
            for image in errorImages {
                image.isHidden = true
            }
        } else {    // 印出錯誤訊息
            if moneyInt == nil {
                errorMessage = "請重新輸入金額"
            }
            totalLabel.text = "？？？"
            roundingLabel.text = "？？？"
            errorLabel.text = errorMessage
            for image in errorImages {
                image.isHidden = false
            }
        }
    }
    
    // 檢查 折扣 欄位，回傳小數值
    func checkDiscount(_ discount: Int?) -> Double?
    {
        var discountVal: Double?
        // 檢查 折扣 欄位有沒有值
        if let discount = discount {
            if discount == 0 {  // 若為 0 則表示沒有折扣
                discountVal = 1
            } else if discount < 10 && discount > 0 {   // ex. 9 -> 0.9 (九折)
                discountVal = Double(discount) / 10
            } else if discount < 100 {  // ex. 95 -> 0.95 (九五折)
                discountVal = Double(discount) / 100
            }
        } else {    // 沒有值則預設為沒有折扣
            discountVal = 1
        }
        return discountVal
    }
    
    // 檢查 小費 欄位，回傳小數值
    func checkTip(_ tip: Int?) -> Double?
    {
        var tipVal: Double?
        if let tip = tip {
            if tip == 0 {   // 若為 0 則表示沒有小費
                tipVal = 0
            } else if tip > 0 {
                tipVal = Double(tip) / 100
            }
        } else {    // 沒有值則預設為沒有小費
            tipVal = 0
        }
        return tipVal
    }
    
    // 計算結果
    func calculate(money: Int, discount: Int?, tip: Int?) -> Double?
    {
        var total: Double = Double(money)
        // 計算折扣後的金額
        if let discountVal = checkDiscount(discount) {
            total *= discountVal
        } else {    // 折扣輸入有誤 (大於100)
            errorMessage = "請重新輸入折扣 (0~99)"
            return nil
        }
        // 計算加上小費後的金額
        if let tipVal = checkTip(tip) {
            total *= (1 + tipVal)
        } else {    // 小費輸入有誤
            errorMessage = "請重新輸入小費"
            return nil
        }
        
        errorMessage = nil  // 無錯誤，清空錯誤訊息
        return total
    }
    
    @IBAction func viewTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func moneyChange(_ sender: UITextField) {
        printResult()
    }
    @IBAction func discountChange(_ sender: UITextField) {
        printResult()
    }
    @IBAction func tipChange(_ sender: UITextField) {
        printResult()
    }
}
