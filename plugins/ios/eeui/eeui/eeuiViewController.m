//
//  eeuiViewController.m
//  WeexTestDemo
//
//  Created by apple on 2018/5/31.
//  Copyright © 2018年 TomQin. All rights reserved.
//

#import "eeuiViewController.h"
#import "WeexSDK.h"
#import "WeexSDKManager.h"
#import "eeuiNewPageManager.h"
#import "CustomWeexSDKManager.h"
#import "DeviceUtil.h"
#import "Config.h"
#import "SGEasyButton.h"
#import "SDWebImageDownloader.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

#define kCacheUrl @"cache_url"
#define kCacheTime @"cache_time"

#define kLifeCycle @"lifecycle"//生命周期

static int easyNavigationButtonTag = 8000;

@interface eeuiViewController ()<UIWebViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) WXSDKInstance *instance;
@property (nonatomic, strong) UIView *weexView;
@property (nonatomic, assign) CGFloat weexHeight;
@property (nonatomic, strong) NSMutableArray *listenerList;
@property (nonatomic, strong) NSString *renderUrl;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) UIView *statusBar;
@property (nonatomic, assign) NSString *notificationStatus;
@property (nonatomic, assign) NSString *liftCycleLastStatus;
@property (nonatomic, assign) NSString *liftCycleLastStatusChild;
@property (nonatomic, assign) BOOL didWillEnter;

@property (nonatomic, strong) NSMutableDictionary *navigationCallbackDictionary;

@property (nonatomic, strong) UIView *errorView;
@property (nonatomic, strong) UIScrollView *errorInfoView;
@property (nonatomic, strong) NSString *errorContent;
@property (nonatomic, strong) UIColor *navigationBarBarTintColor;

@property (nonatomic, strong) UIView *consoleView;
@property (nonatomic, strong) UIView *consoleWeexView;

@end

@implementation eeuiViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setFd_prefersNavigationBarHidden:YES];
    [self setFd_interactivePopMaxAllowedInitialDistanceToLeftEdge:35.0f];

    if (_isDisSwipeBack) {
        [self setFd_interactivePopDisabled:YES];
    }

    [self.view setClipsToBounds:YES];

    _identify = [NSString stringWithFormat: @"%d", arc4random() % 100000];
    _weexHeight = self.view.frame.size.height - CGRectGetMaxY(self.navigationController.navigationBar.frame);
    _cache = 0;

    _showNavigationBar = YES;
    _statusBarAlpha = 0;

    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [center addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];
    _keyBoardlsVisible = NO;

    [self.navigationController setNavigationBarHidden:_showNavigationBar];

    if (_backgroundColor) {
        self.view.backgroundColor = [WXConvert UIColor:_backgroundColor];
    }

    [self setupUI];

    if ([_pageType isEqualToString:@"auto"]) {
        _pageType = @"web";
        if ([_url hasSuffix:@".bundle.wx"]) {
            _pageType = @"app";
        }else if ([_url containsString:@"?_wx_tpl="]) {
            NSRange range = [_url rangeOfString:@"?_wx_tpl="];
            _pageType = @"app";
            _url = [_url substringToIndex:range.location];
        }else {
            [self setupActivityView];
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *html = [NSString stringWithContentsOfURL:[NSURL URLWithString:self.url] encoding:NSUTF8StringEncoding error:nil];
                NSRange range = [html rangeOfString:@"\n"];
                if (range.location != NSNotFound) {
                    html = [html substringToIndex:range.location];
                    html = [html stringByReplacingOccurrencesOfString:@" " withString:@""];
                }
                if ([html hasPrefix:@"//{\"framework\":\"Vue\""]) {
                    self.pageType = @"app";
                }
                [self loadBegin];
            });
            return;
        }
    }

    [self loadBegin];
}

- (void) loadBegin
{
    if ([_pageType isEqualToString:@"web"]) {
        [self loadWebPage];
    } else {
        [self loadWeexPage];
    }

    [self setupActivityView];

    [self setupNaviBar];

    [self updateStatus:@"create"];

    [CustomWeexSDKManager setKeyBoardlsVisible:_keyBoardlsVisible];
    [CustomWeexSDKManager setSoftInputMode:_softInputMode];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self updateStatus:@"start"];

    if ([_statusBarType isEqualToString:@"fullscreen"]) {
        [UIApplication sharedApplication].statusBarHidden = YES;//状态栏隐藏
    } else {
        [UIApplication sharedApplication].statusBarHidden = NO;
    }

    //状态栏样式
    if ([_statusBarStyleCustom isEqualToString:@"1"]) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }else{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateInstanceState:WeexInstanceAppear];

    if (_navigationBarBarTintColor != nil) {
        self.navigationController.navigationBar.barTintColor = _navigationBarBarTintColor;
    }

    if (_resumeUrl.length > 0) {
        [self setResumeUrl:@""];
        [self refreshPage];
    }

    [self updateStatus:@"resume"];
    [self liftCycleEvent:LifeCycleResume];

    [CustomWeexSDKManager setSoftInputMode:_softInputMode];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    [self updateStatus:@"pause"];
    [self liftCycleEvent:LifeCyclePause];

    //状态栏样式
    if ([_statusBarStyleCustom isEqualToString:@"1"]) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }else{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self updateInstanceState:WeexInstanceDisappear];

    [self updateStatus:@"stop"];
}

//TODO get height
- (void)viewDidLayoutSubviews
{
    _weexHeight = self.view.frame.size.height;
    UIEdgeInsets safeArea = UIEdgeInsetsZero;

    CGFloat plusY = 0.0;

    if (@available(iOS 11.0, *)) {
        safeArea = self.view.safeAreaInsets;
    }else if (@available(iOS 9.0, *)) {
        safeArea.top = 20;
        if (![self fd_prefersNavigationBarHidden]) {
            plusY = self.navigationController.navigationBar.frame.size.height;
        }
    }
    if (_safeAreaBottom.length > 0) {
        safeArea.bottom = [_safeAreaBottom integerValue];
    }

    //自定义状态栏
    if ([_statusBarType isEqualToString:@"fullscreen"] || [_statusBarType isEqualToString:@"immersion"]) {
        _statusBar.hidden = YES;
        if ([_pageType isEqualToString:@"web"]) {
            _webView.frame = CGRectMake(safeArea.left, 0 + plusY, self.view.frame.size.width - safeArea.left - safeArea.right, _weexHeight - plusY - safeArea.bottom);
        }else{
            _instance.frame = CGRectMake(safeArea.left, 0 + plusY, self.view.frame.size.width - safeArea.left - safeArea.right, _weexHeight - plusY - safeArea.bottom);
        }
    } else {
        CGFloat top = 0;
        if (!_isChildSubview) {
            top = safeArea.top;
            _statusBar.hidden = NO;
            _statusBar.frame = CGRectMake(0, 0, self.view.frame.size.width, safeArea.top);
        }

        if ([_pageType isEqualToString:@"web"]) {
            _webView.frame = CGRectMake(safeArea.left, top + plusY, self.view.frame.size.width - safeArea.left - safeArea.right, _weexHeight - top - plusY - safeArea.bottom);
        }else{
            _instance.frame = CGRectMake(safeArea.left, top + plusY, self.view.frame.size.width - safeArea.left - safeArea.right, _weexHeight - top - plusY - safeArea.bottom);
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    NSLog(@"gggggggg::dealloc:%@", self.pageName);

    self.identify = @"";
    [self updateStatus:@"destroy"];

    [_instance destroyInstance];
#ifdef DEBUG
    [_instance forceGarbageCollection];
#endif

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didMoveToParentViewController:(UIViewController *)parent
{
    [super didMoveToParentViewController:parent];

    if (parent == nil) {
        [[eeuiNewPageManager sharedIntstance] removePageData:self.pageName];
    }
}


//键盘弹出触发该方法
- (void)keyboardDidShow:(NSNotification *)notification
{
    _keyBoardlsVisible = YES;
    [CustomWeexSDKManager setKeyBoardlsVisible:_keyBoardlsVisible];
}

// 键盘隐藏触发该方法
- (void)keyboardDidHide:(NSNotification *)notification
{
    _keyBoardlsVisible = NO;
    [CustomWeexSDKManager setKeyBoardlsVisible:_keyBoardlsVisible];
}

#pragma mark 生命周期
- (void)liftCycleEvent:(LifeCycleType)type
{
    //页面生命周期:生命周期
    NSString *status = @"";
    switch (type) {
        case LifeCycleReady:
            status = @"ready";
            break;
        case LifeCycleResume:
            status = @"resume";
            break;
        case LifeCyclePause:
            status = @"pause";
            break;
        default:
            return;
    }
    if ([status isEqualToString:_liftCycleLastStatus]) {
        return;
    }
    _liftCycleLastStatus = status;

    for (UIViewController * childViewController in self.childViewControllers) {
        if ([childViewController isKindOfClass:[eeuiViewController class]]) {
            eeuiViewController *vc = (eeuiViewController*) childViewController;
            if ([status isEqualToString:@"pause"]) {
                if ([vc.liftCycleLastStatus isEqualToString:@"resume"]) {
                    [vc liftCycleEvent:type];
                    vc.liftCycleLastStatusChild = status;
                }
            }else if ([status isEqualToString:@"resume"]) {
                if ([vc.liftCycleLastStatusChild isEqualToString:@"pause"]) {
                    [vc liftCycleEvent:type];
                    vc.liftCycleLastStatusChild = status;
                }
            }
        }
    }

    [[WXSDKManager bridgeMgr] fireEvent:_instance.instanceId ref:WX_SDK_ROOT_REF type:kLifeCycle params:@{@"status":status} domChanges:nil];
}

#pragma mark view
- (void)setupUI
{
    self.statusBar = [[UIView alloc] init];
    CGFloat alpha = ((255 - _statusBarAlpha)*1.0/255);
    _statusBar.backgroundColor = [[WXConvert UIColor:_statusBarColor?_statusBarColor : @"#3EB4FF"] colorWithAlphaComponent:alpha];
    [self.view addSubview:_statusBar];
    _statusBar.hidden = YES;
}

- (void)setupActivityView
{
    //加载图
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    self.activityIndicatorView.center = self.view.center;
    [self.activityIndicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:self.activityIndicatorView];

    [self startLoading];
}

- (void)setupNaviBar
{
    if (_pageTitle.length > 0) {
        [self setNavigationTitle:_pageTitle callback:nil];
    }
}

- (void)loadWebPage
{
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.webView.delegate = self;
    NSURL *url = [NSURL URLWithString:_url];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    [self.view addSubview:self.webView];
}

- (void)loadWeexPage
{
    [self readyWeexPage:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self renderView];
        });
    }];
}

- (void)readyWeexPage:(void(^)(void))callback
{
    NSInteger cache = self.cache;
    if ([_url hasPrefix:@"file://"]) {
        cache = 0;
    }
    NSString *tempUrl = [Config verifyFile:_url];
    NSString *appboard = [DeviceUtil getAppboardContent];
    if (cache >= 1000 || appboard.length > 0) {
        _isCache = YES;
        [DeviceUtil downloadScript:tempUrl appboard:appboard cache:cache callback:^(NSString *path) {
            self.renderUrl = path == nil ? tempUrl : path;
            callback();
        }];
    }else{
        _isCache = NO;
        self.renderUrl = tempUrl;
        callback();
    }
}

- (void)renderView
{
    if (self.errorView != nil) {
        [self.errorView removeFromSuperview];
        self.errorView = nil;
    }
    if (self.errorInfoView != nil) {
        [self.errorInfoView removeFromSuperview];
        self.errorInfoView = nil;
    }

    CGFloat width = self.view.frame.size.width;
    [_instance destroyInstance];
    _instance = [[WXSDKInstance alloc] init];

    if([WXPrerenderManager isTaskExist:self.url]){
        _instance = [WXPrerenderManager instanceFromUrl:self.url];
    }

    _instance.viewController = self;
    UIEdgeInsets safeArea = UIEdgeInsetsZero;

    if (@available(iOS 11.0, *)) {
        safeArea = self.view.safeAreaInsets;
    }else if (@available(iOS 9.0, *)) {
        safeArea.top = 20;
    }

    _instance.frame = CGRectMake(self.view.frame.size.width-width, safeArea.top, width, _weexHeight-safeArea.bottom);

    __weak typeof(self) weakSelf = self;
    _instance.onCreate = ^(UIView *view) {
        [weakSelf.weexView removeFromSuperview];
        weakSelf.weexView = view;
        [weakSelf.view addSubview:weakSelf.weexView];
        UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, weakSelf.weexView);
        if (weakSelf.consoleView != nil) {
            [weakSelf.view bringSubviewToFront:weakSelf.consoleView];
        }

        [weakSelf updateStatus:@"viewCreated"];
    };

    _instance.onJSRuntimeException = ^(WXJSExceptionInfo *jsException) {
        [weakSelf stopLoading];
        [weakSelf updateStatus:@"error"];
        [weakSelf showErrorBox:jsException.errorCode];
        weakSelf.errorContent = jsException.exception;
    };

    _instance.onFailed = ^(NSError *error) {
        [weakSelf stopLoading];
        [weakSelf updateStatus:@"error"];

        if ([[error domain] isEqualToString:@"1"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSMutableString *errMsg=[NSMutableString new];
                [errMsg appendFormat:@"ErrorType:%@\n",[error domain]];
                [errMsg appendFormat:@"ErrorCode:%ld\n",(long)[error code]];
                [errMsg appendFormat:@"ErrorInfo:%@\n", [error userInfo]];
                NSLog(@"%@", errMsg);
            });
        }

        [weakSelf showErrorBox:[NSString stringWithFormat: @"%ld", (long)[error code]]];
        weakSelf.errorContent = [error description];
    };

    _instance.renderFinish = ^(UIView *view) {
        WXLogDebug(@"%@", @"Render Finish...");
        [weakSelf updateInstanceState:WeexInstanceAppear];
        [weakSelf stopLoading];
        [weakSelf updateStatus:@"renderSuccess"];
        [weakSelf liftCycleEvent:LifeCycleReady];
        [weakSelf liftCycleEvent:LifeCycleResume];
    };

    _instance.updateFinish = ^(UIView *view) {
        WXLogDebug(@"%@", @"Update Finish...");
    };

    if (!self.url) {
        WXLogError(@"error: render url is nil");
        return;
    }
    if([WXPrerenderManager isTaskExist:self.url]){
        WX_MONITOR_INSTANCE_PERF_START(WXPTJSDownload, _instance);
        WX_MONITOR_INSTANCE_PERF_END(WXPTJSDownload, _instance);
        WX_MONITOR_INSTANCE_PERF_START(WXPTFirstScreenRender, _instance);
        WX_MONITOR_INSTANCE_PERF_START(WXPTAllRender, _instance);
        [WXPrerenderManager renderFromCache:self.url];
        return;
    }
    _instance.viewController = self;

    [_instance renderWithURL:[NSURL URLWithString:self.renderUrl] options:@{@"params":_params?_params:@""} data:nil];

    if (_didWillEnter == NO) {
        _didWillEnter = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    }
}

//显示错误页面
-(void)showErrorBox:(NSString *)errCode
{
    if (self.errorView == nil) {
        self.errorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [self.errorView setBackgroundColor:[UIColor whiteColor]];

        NSInteger top = 80;
        UILabel * label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, top, self.view.frame.size.width, 50)];
        label1.text = @"bibi~ 出错啦！";
        label1.textColor = [WXConvert UIColor:@"#3EB4FF"];
        label1.font = [UIFont systemFontOfSize:30.f];
        label1.textAlignment = NSTextAlignmentCenter;
        [self.errorView addSubview:label1];

        top += 50;
        UILabel * label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, top, self.view.frame.size.width, 30)];
        label2.text = [@"错误代码：" stringByAppendingString:errCode];
        label2.textColor = [WXConvert UIColor:@"#c6c6c6"];
        label2.font = [UIFont systemFontOfSize:13.f];
        label2.textAlignment = NSTextAlignmentCenter;
        [self.errorView addSubview:label2];

        top += 30;
        UILabel * label3 = [[UILabel alloc] initWithFrame:CGRectMake(0, top, self.view.frame.size.width, 30)];
        label3.tag = 1000;
        #if DEBUG
            label3.text = @"页面打不开！查看详情";
        #else
            label3.text = @"抱歉！页面出现错误了";
        #endif
        label3.textColor = [WXConvert UIColor:@"#3EB4FF"];
        label3.font = [UIFont systemFontOfSize:13.f];
        label3.textAlignment = NSTextAlignmentCenter;
        #if DEBUG
            label3.userInteractionEnabled = YES;
            [label3 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(errorTabGesture:)]];
        #endif
        [self.errorView addSubview:label3];

        top += 50;
        CGFloat w = self.view.frame.size.width / 24;
        UIButton * button1 = [[UIButton alloc] initWithFrame:CGRectMake(w * 5, top, w * 6, 36)];
        button1.tag = 2000;
        button1.titleLabel.font = [UIFont systemFontOfSize: 13.0];
        button1.layer.cornerRadius = 3;
        [button1 setTitle:@"刷新一下" forState:UIControlStateNormal];
        [button1 setTitleColor:[WXConvert UIColor:@"#ffffff"] forState:UIControlStateNormal];
        [button1 setBackgroundColor:[WXConvert UIColor:@"#327AE2"]];
        [button1 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(errorTabGesture:)]];
        [self.errorView addSubview:button1];

        if (self.isChildSubview) {
            [button1 setFrame:CGRectMake(w * 9, top, w * 6, 36)];
        }else{
            UIButton * button2 = [[UIButton alloc] initWithFrame:CGRectMake(w * 13, top, w * 6, 36)];
            button2.tag = 3000;
            button2.titleLabel.font = [UIFont systemFontOfSize: 13.0];
            button2.layer.cornerRadius = 3;
            [button2 setTitle:@"退后一步" forState:UIControlStateNormal];
            [button2 setTitleColor:[WXConvert UIColor:@"#ffffff"] forState:UIControlStateNormal];
            [button2 setBackgroundColor:[WXConvert UIColor:@"#3497E2"]];
            [button2 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(errorTabGesture:)]];
            [self.errorView addSubview:button2];
        }

        [self.view addSubview:self.errorView];
    }else{
        [self.view bringSubviewToFront:self.errorView];
    }
}

-(void)errorTabGesture:(UITapGestureRecognizer *)tapGesture
{
    if (tapGesture.view.tag == 1000) {
        [self showFixedInfo:_errorContent];
    }else if (tapGesture.view.tag == 1001) {
        if (self.errorInfoView != nil) {
            [self.errorInfoView removeFromSuperview];
            self.errorInfoView = nil;
        }
    }else if (tapGesture.view.tag == 1002) {
        if (self.consoleView != nil) {
            [self.consoleView removeFromSuperview];
            self.consoleView = nil;
        }
    }else if (tapGesture.view.tag == 2000) {
        [self refreshPage];
    }else if (tapGesture.view.tag == 3000) {
        [[eeuiNewPageManager sharedIntstance] closePage:nil];
    }
}

- (void)showFixedInfo:(NSString *)text
{
    if (self.errorInfoView == nil) {
        UIEdgeInsets safeArea = UIEdgeInsetsZero;
        self.errorInfoView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        self.errorInfoView.tag = 1001;
        if (@available(iOS 11.0, *)) {
            safeArea = self.view.safeAreaInsets;
            self.errorInfoView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [self.errorInfoView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.81f]];
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        label.text = text;
        label.textColor = [WXConvert UIColor:@"#FFFFFF"];
        label.font = [UIFont systemFontOfSize:13.f];
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.numberOfLines = 0;
        [label sizeToFit];
        CGRect temp = label.frame;
        temp.origin.y+= safeArea.top;
        [label setFrame:temp];
        [self.errorInfoView setContentSize:CGSizeMake(label.frame.size.width, label.frame.size.height + safeArea.top + safeArea.bottom)];
        [self.errorInfoView addSubview:label];
        [self.errorInfoView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(errorTabGesture:)]];
        [self.view addSubview:self.errorInfoView];
    }else{
        [self.view bringSubviewToFront:self.errorInfoView];
    }
}

- (void)showFixedConsole
{
    if (self.consoleView == nil) {
        UIEdgeInsets safeArea = UIEdgeInsetsZero;
        self.consoleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        self.consoleView.tag = 1002;
        if (@available(iOS 11.0, *)) {
            safeArea = self.view.safeAreaInsets;
        }
        [self.consoleView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.75f]];
        CGFloat viewY = self.view.frame.size.height / 5.5;
        UIView * myView = [[UIView alloc] initWithFrame:CGRectMake(0, viewY, self.view.frame.size.width, self.view.frame.size.height - viewY)];
        myView.backgroundColor = [WXConvert UIColor:@"#FFFFFF"];
        CGRect temp = myView.frame;
        temp.origin.y+= safeArea.top;
        temp.size.height-= safeArea.top;
        [myView setFrame:temp];
        [self.consoleView addSubview:myView];
        [self.consoleView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(errorTabGesture:)]];
        [self.view addSubview:self.consoleView];
        
        WXSDKInstance *instance = [[WXSDKInstance alloc] init];
        instance.frame = CGRectMake(0, 0, temp.size.width, temp.size.height - safeArea.bottom);
        instance.onCreate = ^(UIView *view) {
            [self->_consoleWeexView removeFromSuperview];
            self->_consoleWeexView = view;
            [myView addSubview:self->_consoleWeexView];
            UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, self->_consoleWeexView);
        };
        NSString *tempUrl = [NSString stringWithFormat:@"file://%@", [Config getResourcePath:@"bundlejs/main-console.js"]];
        NSString *appboard = [DeviceUtil getAppboardContent];
        if (appboard.length > 0) {
            [DeviceUtil downloadScript:tempUrl appboard:appboard cache:0 callback:^(NSString *path) {
                [instance renderWithURL:[NSURL URLWithString:path == nil ? tempUrl : path] options:nil data:nil];
            }];
        }else{
            [instance renderWithURL:[NSURL URLWithString:tempUrl] options:nil data:nil];
        }        
    }else{
        [self.view bringSubviewToFront:self.consoleView];
    }
}

- (void)hideFixedConsole
{
    if (self.consoleView != nil) {
        [self.consoleView removeFromSuperview];
        self.consoleView = nil;
    }
}

- (void)appDidEnterBackground:(NSNotification*)notification
{
    if ([self.liftCycleLastStatus isEqualToString:@"resume"]) {
        [self updateStatus:@"pause"];
        [self liftCycleEvent:LifeCyclePause];
        self.liftCycleLastStatusChild = @"pause";
    }
}

- (void)appWillEnterForeground:(NSNotification*)notification
{
    if ([self.liftCycleLastStatusChild isEqualToString:@"pause"]) {
        [self updateStatus:@"resume"];
        [self liftCycleEvent:LifeCycleResume];
        self.liftCycleLastStatusChild = @"resume";
    }
}

#pragma mark action
//- (void)edgePanGesture:(UIScreenEdgePanGestureRecognizer*)edgePanGestureRecognizer
//{
//    if (self.navigationController && [self.navigationController.viewControllers count] == 1) {
//        return;
//    }
//
//    if (!_isDisSwipeBack) {
//        [self.navigationController popViewControllerAnimated:YES];
//    }
//}

- (void)stopLoading
{
    [self.activityIndicatorView setHidden:YES];
    [self.activityIndicatorView stopAnimating];
}

- (void)startLoading
{
    [self.activityIndicatorView setHidden:NO];
    [self.activityIndicatorView startAnimating];
}

- (void)updateInstanceState:(WXState)state
{
    if (_instance && _instance.state != state) {
        _instance.state = state;

        if (state == WeexInstanceAppear) {
            [[WXSDKManager bridgeMgr] fireEvent:_instance.instanceId ref:WX_SDK_ROOT_REF type:@"viewappear" params:nil domChanges:nil];
        }
        else if (state == WeexInstanceDisappear) {
            [[WXSDKManager bridgeMgr] fireEvent:_instance.instanceId ref:WX_SDK_ROOT_REF type:@"viewdisappear" params:nil domChanges:nil];
        }
    }
}

- (void)updateStatus:(NSString*)status
{
    if (self.statusBlock) {
        self.statusBlock(status);
    }

    //通知监听
    if ([status isEqualToString:_notificationStatus]) {
        return;
    }
    _notificationStatus = status;
    for (NSString *key in self.listenerList) {
        [[NSNotificationCenter defaultCenter] postNotificationName:key object:@{@"status":status, @"listenerName":key}];
    }
}

- (void)setHomeUrl:(NSString*)url
{
    self.url = url;
    [[eeuiNewPageManager sharedIntstance] setPageDataValue:self.pageName key:@"url" value:self.url];
    [self refreshPage];
}

- (void)setResumeUrl:(NSString *)url
{
    _resumeUrl = url;
}

- (void)addStatusListener:(NSString*)name
{
    if (!self.listenerList) {
        self.listenerList = [NSMutableArray arrayWithCapacity:5];
    }

    if (![self.listenerList containsObject:name]) {
        [self.listenerList addObject:name];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(listennerEvent:) name:name object:nil];
    }
}

- (void)clearStatusListener:(NSString*)name
{
    if ([self.listenerList containsObject:name]) {
        [self.listenerList removeObject:name];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:name object:nil];
    }
}

- (void)listennerEvent:(NSNotification*)notification
{
    id obj = notification.object;
    if (obj) {
        if (self.listenerBlock) {
            self.listenerBlock(obj);
        }
    }
}

- (void)postStatusListener:(NSString*)name data:(id)data
{
    if (name.length > 0) {
        if ([self.listenerList containsObject:name]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:name object:data];
        }
    } else {
        for (NSString *key in self.listenerList) {
            [[NSNotificationCenter defaultCenter] postNotificationName:key object:data];
        }
    }
}


#pragma mark - refresh
- (void)refreshPage
{
    [self startLoading];
    
    if (_isCache) {
        [self readyWeexPage:^{ [self refreshPageExecution]; }];
    }else{
        [self refreshPageExecution];
    }
}

- (void)refreshPageExecution
{
    self.identify = [NSString stringWithFormat: @"%d", arc4random() % 100000];
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = nil;
    [self hideNavigation];
    
    if ([_pageType isEqualToString:@"web"]) {
        [self.webView reload];
    } else {
        [self renderView];
        [self updateStatus:@"restart"];
    }
}

#pragma mark - notification
- (void)notificationRefreshInstance:(NSNotification *)notification {
    [self refreshPage];
}

#pragma mark- UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.navigationController && [self.navigationController.viewControllers count] == 1) {
        return NO;
    }
    return YES;
}

#pragma mark webDelegate
//是否允许加载网页，也可获取js要打开的url，通过截取此url可与js交互
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

//开始加载网页
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    self.webBlock(@{@"status":@"statusChanged", @"webStatus":@"", @"errCode":@"", @"errMsg":@"", @"errUrl":@"", @"title":@""});
}

//网页加载完成
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self stopLoading];

    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if (![self.title isEqualToString:title]) {
        self.title = title;
        self.webBlock(@{@"status":@"titleChanged", @"webStatus":@"", @"errCode":@"", @"errMsg":@"", @"errUrl":@"", @"title":title});
    }
}

//网页加载错误
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self stopLoading];

    if (error) {
        NSString *code = [NSString stringWithFormat:@"%ld", (long) error.code];
        NSString *msg = [NSString stringWithFormat:@"%@", error.description];
        self.webBlock(@{@"status":@"errorChanged", @"webStatus":@"", @"errCode":code, @"errMsg":msg, @"errUrl":_url, @"title":@""});
    }
}

//设置页面标题栏标题
- (void)setNavigationTitle:(id) params callback:(WXModuleKeepAliveCallback) callback
{
    if ([_statusBarType isEqualToString:@"fullscreen"] || [_statusBarType isEqualToString:@"immersion"]) {
        return;
    }
    if (nil == _navigationCallbackDictionary) {
        _navigationCallbackDictionary = [[NSMutableDictionary alloc] init];
    }

    NSMutableDictionary *item = [[NSMutableDictionary alloc] init];
    if ([params isKindOfClass:[NSString class]]) {
        item[@"title"] = [WXConvert NSString:params];
    } else if ([params isKindOfClass:[NSDictionary class]]) {
        item = [params copy];
    }
    NSString *title = item[@"title"] ? [WXConvert NSString:item[@"title"]] : @"";
    NSString *titleColor = item[@"titleColor"] ? [WXConvert NSString:item[@"titleColor"]] : @"#232323";
    CGFloat titleSize = item[@"titleSize"] ? [WXConvert CGFloat:item[@"titleSize"]] : 32.0;
    NSString *subtitle = item[@"subtitle"] ? [WXConvert NSString:item[@"subtitle"]] : @"";
    NSString *subtitleColor = item[@"subtitleColor"] ? [WXConvert NSString:item[@"subtitleColor"]] : @"#232323";
    CGFloat subtitleSize = item[@"subtitleSize"] ? [WXConvert CGFloat:item[@"subtitleSize"]] : 24.0;
    NSString *backgroundColor = item[@"backgroundColor"] ? [WXConvert NSString:item[@"backgroundColor"]] : (_statusBarColor ? _statusBarColor : @"#3EB4FF");

    //背景色
    CGFloat alpha = (255 - _statusBarAlpha) * 1.0 / 255;
    _navigationBarBarTintColor = [[WXConvert UIColor:backgroundColor] colorWithAlphaComponent:alpha];
    self.navigationController.navigationBar.barTintColor = _navigationBarBarTintColor;
    [self showNavigation];

    //标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setTextColor:[WXConvert UIColor:titleColor]];
    [titleLabel setText:[[NSString alloc] initWithFormat:@"  %@  ", title]];
    [titleLabel setFont:[UIFont systemFontOfSize:[self NAVSCALE:titleSize]]];
    [titleLabel sizeToFit];

    if (subtitle.length > 0) {
        UILabel *subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 19, 0, 0)];
        [subtitleLabel setBackgroundColor:[UIColor clearColor]];
        [subtitleLabel setTextColor:[WXConvert UIColor:subtitleColor]];
        [subtitleLabel setText:[[NSString alloc] initWithFormat:@"  %@  ", subtitle]];
        [subtitleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:[self NAVSCALE:subtitleSize]]];
        [subtitleLabel sizeToFit];

        UIView *twoLineTitleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAX(subtitleLabel.frame.size.width, titleLabel.frame.size.width), 30)];
        [twoLineTitleView addSubview:titleLabel];
        [twoLineTitleView addSubview:subtitleLabel];

        float widthDiff = subtitleLabel.frame.size.width - titleLabel.frame.size.width;
        if (widthDiff > 0) {
            CGRect frame = titleLabel.frame;
            frame.origin.x = widthDiff / 2;
            titleLabel.frame = CGRectIntegral(frame);
        } else{
            CGRect frame = subtitleLabel.frame;
            frame.origin.x = fabs(widthDiff) / 2;
            subtitleLabel.frame = CGRectIntegral(frame);
        }
        if (callback) {
            twoLineTitleView.userInteractionEnabled = YES;
            twoLineTitleView.tag = ++easyNavigationButtonTag;
            UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(navigationTitleClick:)];
            [twoLineTitleView addGestureRecognizer:tapGesture];
            [_navigationCallbackDictionary setObject:@{@"callback":[callback copy], @"params":[item copy]} forKey:@(twoLineTitleView.tag)];
        }
        self.navigationItem.titleView = twoLineTitleView;
    }else{
        if (callback) {
            titleLabel.userInteractionEnabled = YES;
            titleLabel.tag = ++easyNavigationButtonTag;
            UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(navigationTitleClick:)];
            [titleLabel addGestureRecognizer:tapGesture];
            [_navigationCallbackDictionary setObject:@{@"callback":[callback copy], @"params":[item copy]} forKey:@(titleLabel.tag)];
        }
        self.navigationItem.titleView = titleLabel;
    }

    if (!_isFirstPage && self.navigationItem.leftBarButtonItems.count == 0) {
        [self setNavigationItems:@{@"icon":@"tb-back", @"iconSize":@(36)} position:@"left" callback:^(id result, BOOL keepAlive) {
            [[[DeviceUtil getTopviewControler] navigationController] popViewControllerAnimated:YES];
        }];
    }
}

//设置页面标题栏左右按钮
- (void)setNavigationItems:(id) params position:(NSString *)position callback:(WXModuleKeepAliveCallback) callback
{
    if (nil == _navigationCallbackDictionary) {
        _navigationCallbackDictionary = [[NSMutableDictionary alloc] init];
    }

    NSMutableArray *buttonArray = [[NSMutableArray alloc] init];

    if ([params isKindOfClass:[NSString class]]) {
        [buttonArray addObject:@{@"title": [WXConvert NSString:params]}];
    } else if ([params isKindOfClass:[NSArray class]]) {
        buttonArray = params;
    } else if ([params isKindOfClass:[NSDictionary class]]) {
        [buttonArray addObject:params];
    }

    UIView *buttonItems = [[UIView alloc] init];
    for (NSDictionary *item in buttonArray)
    {
        NSString *title = item[@"title"] ? [WXConvert NSString:item[@"title"]] : @"";
        NSString *titleColor = item[@"titleColor"] ? [WXConvert NSString:item[@"titleColor"]] : @"#232323";
        CGFloat titleSize = item[@"titleSize"] ? [WXConvert CGFloat:item[@"titleSize"]] : 28.0;
        NSString *icon = item[@"icon"] ? [WXConvert NSString:item[@"icon"]] : @"";
        NSString *iconColor = item[@"iconColor"] ? [WXConvert NSString:item[@"iconColor"]] : @"#232323";
        CGFloat iconSize = item[@"iconSize"] ? [WXConvert CGFloat:item[@"iconSize"]] : 28.0;
        NSInteger width = item[@"width"] ? [WXConvert NSInteger:item[@"width"]] : 0;
        NSInteger spacing = item[@"spacing"] ? [WXConvert NSInteger:item[@"spacing"]] : 10;

        UIButton *customButton = [UIButton buttonWithType:UIButtonTypeCustom];
        if (icon.length > 0) {
            if ([icon containsString:@"//"] || [icon hasPrefix:@"data:"]) {
                [SDWebImageDownloader.sharedDownloader downloadImageWithURL:[NSURL URLWithString:icon] options:SDWebImageDownloaderLowPriority progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                    if (image) {
                        WXPerformBlockOnMainThread(^{
                            [customButton setImage:[DeviceUtil imageResize:image andResizeTo:CGSizeMake([self NAVSCALE:iconSize], [self NAVSCALE:iconSize]) icon:nil] forState:UIControlStateNormal];
                            [customButton SG_imagePositionStyle:(SGImagePositionStyleDefault) spacing: (icon.length > 0 && title.length > 0) ? [self NAVSCALE:spacing] : 0];
                        });
                    }
                }];
            } else {
                [customButton setImage:[DeviceUtil getIconText:icon font:[self NAVSCALE:iconSize] color:iconColor] forState:UIControlStateNormal];
            }
        }
        if (title.length > 0){
            customButton.titleLabel.font = [UIFont systemFontOfSize:[self NAVSCALE:titleSize]];
            [customButton setTitle:title forState:UIControlStateNormal];
            [customButton setTitleColor:[WXConvert UIColor:titleColor] forState:UIControlStateNormal];
            [customButton.titleLabel sizeToFit];
        }
        [customButton SG_imagePositionStyle:(SGImagePositionStyleDefault) spacing: (icon.length > 0 && title.length > 0) ? [self NAVSCALE:spacing] : 0];
        if (callback) {
            customButton.tag = ++easyNavigationButtonTag;
            [customButton addTarget:self action:@selector(navigationItemClick:) forControlEvents:UIControlEventTouchUpInside];
            [_navigationCallbackDictionary setObject:@{@"callback":[callback copy], @"params":[item copy]} forKey:@(customButton.tag)];
        }
        [customButton sizeToFit];
        if (width > 0) {
            CGRect customCGRect = customButton.frame;
            customCGRect.size.width = [self NAVSCALE:width];
            [customButton setFrame:customCGRect];
        }
        CGFloat bWitdh = buttonItems.frame.size.width;
        CGFloat cWitdh = MAX(self.navigationController.navigationBar.frame.size.height, customButton.frame.size.width);
        CGFloat cHeight = self.navigationController.navigationBar.frame.size.height;
        [customButton setFrame:CGRectMake(bWitdh, 0, cWitdh, cHeight)];
        [buttonItems setFrame:CGRectMake(0, 0, bWitdh + cWitdh, cHeight)];
        [buttonItems addSubview:customButton];
    }

    if ([position isEqualToString:@"right"]) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonItems];
    }else{
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonItems];
    }

    if (_navigationBarBarTintColor == nil) {
        [self setNavigationTitle:@" " callback:nil];
    }else{
        [self showNavigation];
    }
}

//标题栏标题点击回调
- (void)navigationTitleClick:(UITapGestureRecognizer *)tapGesture
{
    id item = [_navigationCallbackDictionary objectForKey:@(tapGesture.view.tag)];
    if ([item isKindOfClass:[NSDictionary class]]) {
        WXModuleKeepAliveCallback callback = item[@"callback"];
        if (callback) {
            callback([item[@"params"] isKindOfClass:[NSDictionary class]] ? item[@"params"] : @{}, YES);
        }
    }
}

//标题栏菜单点击回调
-(void)navigationItemClick:(UIButton *) button
{
    id item = [_navigationCallbackDictionary objectForKey:@(button.tag)];
    if ([item isKindOfClass:[NSDictionary class]]) {
        WXModuleKeepAliveCallback callback = item[@"callback"];
        if (callback) {
            callback([item[@"params"] isKindOfClass:[NSDictionary class]] ? item[@"params"] : @{}, YES);
        }
    }
}

//标题栏显示
- (void)showNavigation
{
    if ([_statusBarType isEqualToString:@"fullscreen"] || [_statusBarType isEqualToString:@"immersion"]) {
        return;
    }
    [self setFd_prefersNavigationBarHidden:NO];
    [self.navigationController setNavigationBarHidden:NO];
    [self.view setNeedsLayout];
}

//标题栏隐藏
- (void)hideNavigation
{
    if ([_statusBarType isEqualToString:@"fullscreen"] || [_statusBarType isEqualToString:@"immersion"]) {
        return;
    }
    [self setFd_prefersNavigationBarHidden:YES];
    [self.navigationController setNavigationBarHidden:YES];
    [self.view setNeedsLayout];
}

- (CGFloat)NAVSCALE:(CGFloat)size
{
    return MIN([UIScreen mainScreen].bounds.size.width, 375) * 1.0f/750 * size;
}

@end
