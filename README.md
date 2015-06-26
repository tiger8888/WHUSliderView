####项目中常用到的带标签的滚动视图
---
1. 支持IOS6+
2. 支持xib
3. 支持屏幕旋转
4. 用法简单:
```objc
    WHUSliderView* hv=[[WHUSliderView alloc] init];
    hv.translatesAutoresizingMaskIntoConstraints=NO;
    [self.view addSubview:hv];
    NSDictionary* viewDic=NSDictionaryOfVariableBindings(hv);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[hv]|" options:0 metrics:nil views:viewDic]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[hv]|" options:0 metrics:nil views:viewDic]];
    hv.controllerArray=@[vc1,vc2,vc3,vc4,vc5,vc6]; //UIViewController 数组.
    hv.selectedColor=[UIColor redColor];
```
 ![image](https://github.com/tiger8888/WHUSliderView/blob/master/demo.png)
