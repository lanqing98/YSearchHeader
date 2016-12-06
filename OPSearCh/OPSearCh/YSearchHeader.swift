//
//  YSearchHeader.swift
//  OPSearCh
//
//  Created by 杨岚清 on 2016/11/30.
//  Copyright © 2016年 Ylqing. All rights reserved.
//

import UIKit

class YSearchHeader: UIView, UITableViewDelegate, UITableViewDataSource {
    //左按钮标示
    public let KYSearchHeaderLeft:String = "left";
    //右按钮标示
    public let KYSearchHeaderRight:String = "right";
    public var leftNormalTitle:String = "全部地区";
    public var rightNormalTitle:String = "全部采购";
    public var leftItem:[String] = [];
    public var rightItem:[String] = [];
    public var tinColor:UIColor = UIColor.init(hex: "FF7817");
    weak public var deletage:YSearchHeaderDelegate?;
    private var left:LeftT_Button?;
    private var right:LeftT_Button?;
    private var bgView:UIView?;
    private var tableView:UITableView?;
    //记录当前显示的是那个TB
    private var showType:showTBType = .none;
    //记录左边选中的cell
    private var leftIndex:Int = 0;
    //记录右边选中的cell
    private var rightIndex:Int = 0;
    //是否已经展示
    private var isShow:Bool = false;
    
    override func awakeFromNib() {
        super.awakeFromNib();
        self.backgroundColor = UIColor.white;
        onSetView();
    }
    
    //设置参数
    public func onSetParams(params:[serchHeaderParams]?) {
        if let p = params {
            for item in p {
                switch item {
                case let .leftNormalTitle(value):
                    leftNormalTitle = value;
                case let .rightNormalTitle(value):
                    rightNormalTitle = value;
                case let .leftItem(value):
                    leftItem = value;
                case let .rightItem(value):
                    rightItem = value;
                case let .tincolor(value):
                    tinColor = value;
                }
            }
        }
    }
    //
    private enum showTBType:Int {
        case none = 0,left,right
    }
    //MARK : - 界面搭建
    private func onSetView() {
        onSetButton();
        onSetBackView();
        onSetTableView();
    }
    //左右按钮
    private func onSetButton () {
        left = onGetButton(title: self.leftNormalTitle);
        left?.frame = CGRect.init(x: 0, y: 0, width: self.frame.width/2, height: self.frame.height);
        left?.addTarget(self, action: #selector(leftClick), for: UIControlEvents.touchUpInside);
        self.addSubview(left!);
        right = onGetButton(title: self.rightNormalTitle);
        right?.addTarget(self, action: #selector(rightClick), for: UIControlEvents.touchUpInside);
        right?.frame = CGRect.init(x: self.frame.width/2, y: 0, width: self.frame.width/2, height: self.frame.height);
        self.addSubview(right!);
    }
    //左按钮点击事件
    @objc private func leftClick() {
        if showType == showTBType.left {
            close();
            return;
        }
        showType = .left;
        show();
    }
    //右按钮点击事件
    @objc private func rightClick() {
        if showType == showTBType.right {
            close();
            return;
        }
        showType = .right;
        show();
    }
    //灰底背景
    private func onSetBackView() {
        bgView = UIView.init(frame: CGRect.init(x: 0, y: self.frame.origin.y + self.frame.height, width: self.superview?.frame.height ?? 0, height: UIScreen.main.bounds.height));
        bgView?.backgroundColor = UIColor.init(hex: "000000", alpha: 0.3);
        bgView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTouch)));
        bgView?.alpha = 0;
        self.superview?.addSubview(bgView!);
    }
    @objc private func onTouch() {
        close();
    }
    //TB self.frame.origin.y + self.frame.height
    private func onSetTableView() {
        
        tableView = UITableView.init(frame: CGRect.init(x: 0, y: -(UIScreen.main.bounds.height * 2/3 - 64 - self.frame.height), width: self.superview?.frame.height ?? 0, height: UIScreen.main.bounds.height * 2/3 - 64 - self.frame.height), style: UITableViewStyle.plain);
        let view = UIView();
        tableView?.backgroundColor = UIColor.clear;
        view.backgroundColor = UIColor.clear;
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTouch)));
        tableView?.backgroundView = view;
        tableView?.register(NSClassFromString("UITableViewCell"), forCellReuseIdentifier: "cell");
        tableView?.tableFooterView = UIView();
        tableView?.separatorColor = UIColor.init(hex: "E9E9E9");
        tableView?.bounces = false;
        tableView?.dataSource = self;
        tableView?.delegate = self;
        self.superview?.addSubview(tableView!);
    }
    //展示TB
    public func show() {
        isShow = true;
        if showType == showTBType.left {
            onSetButtonClickColor(button: left!);
            onSetButtonNormalColor(button: right!)
        }else if showType == showTBType.right {
            onSetButtonClickColor(button: right!);
            onSetButtonNormalColor(button: left!)
        }
//        tableView?.frame.origin.y = -200;
        self.tableView?.reloadData();
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [], animations: {
            self.tableView?.frame.origin.y = self.frame.origin.y + self.frame.height;
            self.bgView?.alpha = 1;
        }, completion: nil)
    }
    //关闭TB
    public func close() {
        isShow = false;
        if showType == showTBType.left {
            onSetButtonNormalColor(button: left!)
        }else if showType == showTBType.right {
            onSetButtonNormalColor(button: right!);
        }
        showType = .none;
        UIView.animate(withDuration: 0.2, animations: {
            self.tableView?.frame.size.height = 0;
            self.bgView?.alpha = 0;
        }, completion: {(a) -> Void in
            self.tableView?.frame.origin.y = -(UIScreen.main.bounds.height * 2/3 - 64 - self.frame.height);
            self.tableView?.frame.size.height = UIScreen.main.bounds.height * 2/3 - 64 - self.frame.height;
        })
    }
    
    //MARK: - tableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if showType == showTBType.left {
            return leftItem.count;
        }else if showType == showTBType.right {
            return rightItem.count;
        }else {
            return 0;
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath);
        cell.selectionStyle = .none;
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14);
        if showType == showTBType.left {
            if indexPath.row == leftIndex {
                cell.textLabel?.textColor = tinColor;
            }else {
                cell.textLabel?.textColor = UIColor.init(hex: "202020");
            }
        }else if showType == showTBType.right {
            if indexPath.row == rightIndex {
                cell.textLabel?.textColor = tinColor;
            }else {
                cell.textLabel?.textColor = UIColor.init(hex: "202020");
            }
        }
        if showType == showTBType.left {
            cell.textLabel?.text = leftItem[indexPath.row];
        }else if showType == showTBType.right {
            cell.textLabel?.text = rightItem[indexPath.row];
        }
        return cell;
    }
    //cell点击
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if showType == showTBType.left {
            leftIndex = indexPath.row;
            onSetButtonTitle(button: left!, title: leftItem[indexPath.row]);
            deletage?.YSearchHeader(view: self, type: KYSearchHeaderLeft, didSelectCell: leftIndex, title: leftItem[indexPath.row]);
        }else if showType == showTBType.right {
            rightIndex = indexPath.row;
            onSetButtonTitle(button: right!, title: rightItem[indexPath.row]);
            deletage?.YSearchHeader(view: self, type: KYSearchHeaderRight, didSelectCell: rightIndex, title: rightItem[indexPath.row]);
        }
        close();
    }
    //
    private func onGetButton(title:String) -> LeftT_Button {
        let button = LeftT_Button();
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13);
        button.setTitle(title, for: UIControlState.normal);
        button.setTitleColor(UIColor(hex:"202020"), for: UIControlState.normal);
        button.setImage(onGetBundlePath(imageStr: "icon-v-g"), for: UIControlState.normal);
        return button;
    }
    //获取图片
    private  func onGetBundlePath(imageStr:String) -> UIImage{
        let url = Bundle.main.path(forResource: "OPSearchPic", ofType: "bundle");
        let path = url?.appending("/" + imageStr) ?? "";
        return UIImage.init(contentsOfFile: path) ?? UIImage();
    }
    
    //设置按钮默认title
    private  func onSetButtonNormalTitle() {
        left?.setTitle(self.leftNormalTitle, for: UIControlState.normal);
        right?.setTitle(self.rightNormalTitle, for: UIControlState.normal);
    }
    private func onSetButtonTitle(button:LeftT_Button,title:String) {
        button.setTitle(title, for: UIControlState.normal);
    }
    //设置按钮颜色
    public func onSetButtonClickColor(button:LeftT_Button) {
        button.setTitleColor(self.tinColor, for: UIControlState.normal);
        button.setImage(onGetBundlePath(imageStr: "icon-v-o"), for: UIControlState.normal);
    }
    public func onSetButtonNormalColor(button:LeftT_Button) {
        button.setTitleColor(UIColor(hex:"202020"), for: UIControlState.normal);
        button.setImage(onGetBundlePath(imageStr: "icon-v-g"), for: UIControlState.normal);
    }
    //MARK: - 划线
    override func draw(_ rect: CGRect) {
        let context:CGContext = UIGraphicsGetCurrentContext()!; //获取画笔上下文
        context.setAllowsAntialiasing(true);
        context.setStrokeColor(UIColor.init(hex: "#E9E9E9").cgColor);
        context.setLineWidth(1);
        context.move(to: CGPoint.init(x: 0, y: 44));
        context.addLine(to: CGPoint.init(x: UIScreen.main.bounds.width, y: 44));
        context.strokePath();
        
        context.move(to: CGPoint.init(x: UIScreen.main.bounds.width/2, y: 13));
        context.addLine(to: CGPoint.init(x: UIScreen.main.bounds.width/2, y: 31));
        context.strokePath();
    }
}
extension YSearchHeader {
    
    func showMenu() {
        show();
    }
    
    func hideMenu() {
        close();
    }
}
@objc protocol YSearchHeaderDelegate {
    func YSearchHeader(view:YSearchHeader,type:String,didSelectCell index:Int,title:String);
}
enum serchHeaderParams {
    case leftNormalTitle(String);
    case rightNormalTitle(String);
    case leftItem([String]);
    case rightItem([String]);
    case tincolor(UIColor);
}
//自定义按钮
class LeftT_Button: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib();
        self.contentMode = UIViewContentMode.center;
        self.titleLabel?.textAlignment = NSTextAlignment.center;
    }
    override func layoutSubviews() {
        super.layoutSubviews();
        self.titleLabel?.textAlignment = NSTextAlignment.center;
        var titleFrame = self.titleLabel?.frame;
        titleFrame?.origin.x = (titleFrame?.origin.x ?? 0) - 6;
        self.titleLabel?.frame = titleFrame!;
        
        var imageFrame = self.imageView?.frame;
        imageFrame?.origin.x = (self.titleLabel?.frame.origin.x ?? 0) + (self.titleLabel?.frame.width ?? 0) + 6.5;
        self.imageView?.frame = imageFrame!;
    }
}

import Foundation
extension UIColor {
    convenience init(hex:String,alpha:CGFloat? = nil){
        let strHex:String = hex.trimmingCharacters(in: .whitespacesAndNewlines);
        let scanner = Scanner( string: strHex )
        if (strHex.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        var color:UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask: UInt32 = 0x000000FF
        let r = UInt32(color >> 16) & mask
        let g = UInt32(color >> 8) & mask
        let b = UInt32(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha ?? 1)
    }
    
    func toHexColor()->String{
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return NSString(format:"#%06x", rgb) as String
    }

}
