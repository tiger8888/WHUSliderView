//
//  WHUSilderView.h
//  WHUSilderViewSample
//
//  Created by SuperNova on 15/6/14.
//  Copyright (c) 2015年 taivex2. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WHUSliderView : UIView
//UIViewController数组
@property(nonatomic,strong) NSArray* controllerArray;
//选中条目的颜色,默认为蓝色
@property(nonatomic,strong) UIColor* selectedColor;
//自定义条目的宽度.用于一些特殊场合.
@property(nonatomic,assign) CGFloat topBtnWidth;
@end
