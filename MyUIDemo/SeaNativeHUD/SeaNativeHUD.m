//
//  SeaNativeHUD.m
//  MyUIDemo
//
//  Created by Bob on 2018/12/26.
//  Copyright © 2018年 seabrea. All rights reserved.
//

#import "SeaNativeHUD.h"

@interface SeaNativeHUD()

@property (strong, nonatomic) UIView *toastView;
@property (strong, nonatomic) UIView *loadingView;

@end

@implementation SeaNativeHUD

+ (void)systemAlertTitle:(NSString *)titleStr Content:(NSString *)contentStr Confirm:(void(^)(void))confirmHandler {
    [[SeaNativeHUD shareInstance] alertTitle:titleStr Content:contentStr CancelTitle:@"取消" CancelAction:nil ConfirmTitle:@"确定" Confirm:confirmHandler];
}

+ (void)systemPopActionSheetList:(NSArray<NSString *> *)list CloseTitle:(NSString * _Nullable)closeTitle SelectAction:(void(^)(NSUInteger selectIndex))handler {
    [[SeaNativeHUD shareInstance] popActionSheetList:list Title:nil Content:nil CloseTitle:closeTitle SelectAction:handler];
}

+ (void)showLoding {
    
    SeaNativeHUD *hud = [SeaNativeHUD shareInstance];
    [[hud curKeyViewController].view addSubview:hud.loadingView];
    UIActivityIndicatorView *indicatorView = [hud.loadingView viewWithTag:10001];
    [indicatorView startAnimating];
}

+ (void)dismissLoading {
    
    SeaNativeHUD *hud = [SeaNativeHUD shareInstance];
    UIActivityIndicatorView *indicatorView = [hud.loadingView viewWithTag:10001];
    [indicatorView stopAnimating];
    [hud.loadingView removeFromSuperview];
}

+ (void)showToast:(NSString *)msg {
    [SeaNativeHUD showToast:msg Interval:2];
}

+ (void)showToast:(NSString *)msg Interval:(NSTimeInterval)time {
    
    SeaNativeHUD *hud = [SeaNativeHUD shareInstance];
    [[hud curKeyWindow] addSubview:hud.toastView];
    
    UILabel *msgLabel = [hud.toastView viewWithTag:10000];
    msgLabel.text = msg;
    CGFloat viewWidth = [hud curKeyWindow].bounds.size.width - 120;
    
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14.0]};
    CGSize textRect = CGSizeMake(viewWidth - 30, MAXFLOAT);
    CGFloat textHeight = [msg boundingRectWithSize: textRect options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attributes context:nil].size.height;
    msgLabel.bounds = CGRectMake(0, 0, viewWidth, textHeight + 50);
    
    // 设置计时器
    __block NSTimeInterval timeInterval = 0;
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        
        if(timeInterval >= time) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                dispatch_source_cancel(timer);
                [hud removeToastWithAnimation];
            });
        }
        ++timeInterval;
    });
    
    // 设置弹出动画
    hud.toastView.alpha = 0.1f;
    msgLabel.transform = CGAffineTransformMakeScale(1.2, 1.2);
    
    [UIView animateWithDuration:0.2f animations:^{
        
        hud.toastView.alpha = 1.0f;
        msgLabel.transform = CGAffineTransformMakeScale(1, 1);
    } completion:^(BOOL finished) {
        //动画结束后开始计时器
        dispatch_resume(timer);
    }];
}


#pragma mark - singleton

static SeaNativeHUD *instance = nil;
+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[SeaNativeHUD alloc] init];
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
    });
    return instance;
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    return instance;
}

- (nonnull id)mutableCopyWithZone:(nullable NSZone *)zone {
    return instance;
}


#pragma mark - Private Methods

- (void)alertTitle:(NSString *)titleStr Content:(NSString *)contentStr CancelTitle:(NSString *)cancelStr CancelAction:(void(^)(void))cancelHandler ConfirmTitle:(NSString *)confirmStr Confirm:(void(^)(void))confirmHandler {
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:titleStr message:contentStr preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        confirmHandler();
    }];
    
    [alertVC addAction:cancelAction];
    [alertVC addAction:okAction];
    [[self curKeyViewController] presentViewController:alertVC animated:YES completion:nil];
}

- (void)popActionSheetList:(NSArray<NSString *> *)contentlist Title:(NSString *)titleStr Content:(NSString *)contentStr CloseTitle:(NSString *)colseStr SelectAction:(void(^)(NSUInteger selectIndex))handler {
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:titleStr message:contentStr preferredStyle:UIAlertControllerStyleActionSheet];
    
    if(colseStr) {
        UIAlertAction *closeAction = [UIAlertAction actionWithTitle:colseStr style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
        [alertVC addAction:closeAction];
    }
    
    [contentlist enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIAlertAction *itemAction = [UIAlertAction actionWithTitle:obj style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            handler(idx);
        }];
        [alertVC addAction:itemAction];
    }];
    
    [[self curKeyViewController] presentViewController:alertVC animated:YES completion:nil];
}

- (UIWindow *)curKeyWindow {
    
    UIWindow *window = nil;
    UIApplication *app = [UIApplication sharedApplication];
    if([app.delegate respondsToSelector:@selector(window)]) {
        window = app.delegate.window;
    }
    else {
        window = app.keyWindow;
    }
    
    return window;
}

- (UIViewController *)curKeyViewController {
    
    UIViewController* currentViewController = [self curKeyWindow].rootViewController;
    
    BOOL runLoopFind = YES;
    while (runLoopFind) {
        if (currentViewController.presentedViewController) {
            
            currentViewController = currentViewController.presentedViewController;
        }
        else if ([currentViewController isKindOfClass:[UINavigationController class]]) {
            
            UINavigationController* navigationController = (UINavigationController* )currentViewController;
            currentViewController = [navigationController.childViewControllers lastObject];
        }
        else if ([currentViewController isKindOfClass:[UITabBarController class]]) {
            
            UITabBarController* tabBarController = (UITabBarController* )currentViewController;
            currentViewController = tabBarController.selectedViewController;
        }
        else {
            
            NSUInteger childViewControllerCount = currentViewController.childViewControllers.count;
            if (childViewControllerCount > 0) {
                
                currentViewController = currentViewController.childViewControllers.lastObject;
                return currentViewController;
            }
            else {
                
                return currentViewController;
            }
        }
    }
    return currentViewController;
}

- (void)removeToastWithAnimation {
    
    UILabel *msgLabel = [self.toastView viewWithTag:10000];
    [UIView animateWithDuration:0.2f animations:^{
        
        self.toastView.alpha = 0.1f;
        msgLabel.transform = CGAffineTransformMakeScale(1.1, 1.1);
    } completion:^(BOOL finished) {
        [self.toastView removeFromSuperview];
    }];
}


#pragma mark - Getter

- (UIView *)toastView {
    
    if(!_toastView) {
        
        CGSize windowSize = [self curKeyWindow].bounds.size;
        _toastView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, windowSize.width, windowSize.height)];
        _toastView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        
        UIButton *bgViewButton = [UIButton buttonWithType:UIButtonTypeCustom];
        bgViewButton.frame = _toastView.bounds;
        [_toastView addSubview:bgViewButton];
        
        UILabel *msgLabel = [[UILabel alloc] init];
        msgLabel.numberOfLines = 0;
        msgLabel.textAlignment = NSTextAlignmentCenter;
        msgLabel.backgroundColor = [UIColor colorWithWhite:1 alpha:0.9];
        msgLabel.layer.anchorPoint = CGPointMake(0.5, 0.5);
        msgLabel.tag = 10000;
        msgLabel.center = _toastView.center;
        msgLabel.layer.cornerRadius = 10.0;
        msgLabel.layer.masksToBounds = YES;
        [_toastView addSubview:msgLabel];
    }
    return _toastView;
}

- (UIView *)loadingView {
    
    if(!_loadingView) {
        UIView *keyView = [self curKeyViewController].view;
        _loadingView = [[UIView alloc] initWithFrame:keyView.bounds];
        
        UIView *bgView = [[UIView alloc] initWithFrame:keyView.bounds];
        bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        [_loadingView addSubview:bgView];
        
        UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        indicatorView.tag = 10001;
        indicatorView.hidesWhenStopped = YES;
        indicatorView.center = bgView.center;
        [bgView addSubview:indicatorView];
    }
    return _loadingView;
}

@end
