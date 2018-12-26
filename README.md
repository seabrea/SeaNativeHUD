<center>

![](https://raw.githubusercontent.com/seabrea/SeaNativeHUD/master/logo.png)

</center>

# SeaNativeHUD

![](https://img.shields.io/badge/platform-iOS%209%2B-orange.svg)
![](https://img.shields.io/badge/language-objective--c-blue.svg)
![](https://img.shields.io/badge/license-MIT-ff69b4.svg)

SeaNativeHUD是对一组封装了原生风格的HUD组件。

## Demo

[Demo项目](https://github.com/seabrea/SeaNativeHUD)


## Usage

具体使用可参考Demo项目

SeaNativeHUD主要封住了Alert，ActionSheet，Loading和Toast组件

#### Alert的使用

Alert的常见使用方式，显示一个提示框。

```
[SeaNativeHUD systemAlertTitle:@"这是标题" Content:@"这时内容" Confirm:^{
            NSLog(@"点击确定按钮");
        }];

```

#### ActionSheet的使用

ActionSheet需要传入一个字符串数组用于列表的数据源，字符串为列表的显示内容。在用于处理点击的Block里面，获取点击的索引值来确定被点击的选项。

```
NSArray<NSString *> *list = @[@"这时选择项0",@"这时选择项1",@"这时选择项2",@"这时选择项3",@"这时选择项4",@"这时选择项5",@"这时选择项6"];
        [SeaNativeHUD systemPopActionSheetList:list CloseTitle:@"这时关闭按钮" SelectAction:^(NSUInteger selectIndex) {
            NSLog(@"这时选择项%lu",selectIndex);
        }];

```

#### Loading的使用

可简单使用Loading像如下方式

```
[SeaNativeHUD showLoding];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SeaNativeHUD dismissLoading];
        });

```

#### Toast的使用

使用下面两个方法可处理Toast显示问题

```
[SeaNativeHUD showToast:@"这是提示"];
[SeaNativeHUD showToast:@"这是提示 显示时间:5" Interval:5];

```

## Author

[SeaBrea](https://seabrea.xyz)

有什么问题或者好的建议可以联系我 <hgdigm@gmail.com>

## License

SeaNativeHUD is available under the MIT license. See the LICENSE file for more info.
