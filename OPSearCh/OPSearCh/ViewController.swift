//
//  ViewController.swift
//  OPSearCh
//
//  Created by 杨岚清 on 2016/11/30.
//  Copyright © 2016年 Ylqing. All rights reserved.
//

import UIKit

class ViewController: UIViewController,YSearchHeaderDelegate {

    
    @IBOutlet weak var serch: YSearchHeader!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white;
        let params:[serchHeaderParams] = [
            serchHeaderParams.leftNormalTitle("全部地区"),
            serchHeaderParams.rightNormalTitle("全部采购"),
            serchHeaderParams.leftItem(["上海市","北京市","北京市","北京市","北京市","北京市","北京市","北京市","北京市","北京市","北京市","北京市","北京市","北京市","北京市","北京市","北京市","北京市","北京市"]),
            serchHeaderParams.rightItem(["全部采购","已报价","未报价"]),
            serchHeaderParams.tincolor(UIColor.init(hex: "FF7817"))
        ];
        serch.onSetParams(params: params);
        serch.deletage = self;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //切换界面的时候隐藏
        serch.hideMenu();
    }
    
    func YSearchHeader(view: YSearchHeader, type: String, didSelectCell index: Int, title: String) {
        if type == view.KYSearchHeaderLeft {
            //左边按钮
        }else if type == view.KYSearchHeaderRight {
            //右边按钮
        }
    }

}

