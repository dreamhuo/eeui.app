//
//  eeuiBridge.m
//  eeuiProject
//
//  Created by 高一 on 2019/1/2.
//

#import "eeuiBridge.h"

#import "eeuiAdDialogManager.h"
#import "eeuiAjaxManager.h"
#import "eeuiAlertManager.h"
#import "eeuiCachesManager.h"
#import "eeuiCaptchaManager.h"
#import "eeuiLoadingManager.h"
#import "eeuiSaveImageManager.h"
#import "eeuiShareManager.h"
#import "eeuiStorageManager.h"
#import "eeuiToastManager.h"
#import "eeuiNewPageManager.h"
#import "eeuiVersion.h"
#import "DeviceUtil.h"
#import "Config.h"
#import "scanViewController.h"
#import <AdSupport/AdSupport.h>
#import "CustomWeexSDKManager.h"

#define iPhoneXSeries (([[UIApplication sharedApplication] statusBarFrame].size.height == 44.0f) ? (YES):(NO))

@implementation eeuiBridge

- (void)initialize
{

}

#pragma mark 广告弹窗

- (void)adDialog:(id)params callback:(WXModuleKeepAliveCallback)callback
{
    [[eeuiAdDialogManager sharedIntstance] adDialog:params callback:callback];
}

- (void)adDialogClose:(NSString*)dialogName
{
    [[eeuiAdDialogManager sharedIntstance] adDialogClose:dialogName];
}

#pragma mark 跨域异步请求

- (void)ajax:(id)params callback:(WXModuleKeepAliveCallback)callback
{
    [[eeuiAjaxManager sharedIntstance] ajax:params callback:callback];
}

- (void)ajaxCancel:(NSString*)name
{
    [[eeuiAjaxManager sharedIntstance] ajaxCancel:name];
}

- (void)getCacheSizeAjax:(WXModuleKeepAliveCallback)callback
{
    [[eeuiAjaxManager sharedIntstance] getCacheSizeAjax:callback];
}

- (void)clearCacheAjax
{
    [[eeuiAjaxManager sharedIntstance] clearCacheAjax];
}

#pragma mark 确认对话框

- (void)alert:(id)params callback:(WXModuleKeepAliveCallback)callback
{
    [[eeuiAlertManager sharedIntstance] alert:params callback:callback];
}

- (void)confirm:(id)params callback:(WXModuleKeepAliveCallback)callback
{
    [[eeuiAlertManager sharedIntstance] confirm:params callback:callback];
}

- (void)input:(id)params callback:(WXModuleKeepAliveCallback)callback
{
    [[eeuiAlertManager sharedIntstance] input:params callback:callback];
}

#pragma mark 缓存管理

- (void)getCacheSizeDir:(WXModuleKeepAliveCallback)callback;
{
    [[eeuiCachesManager sharedIntstance] getCacheSizeDir:callback];
}

- (void)clearCacheDir:(WXModuleKeepAliveCallback)callback;
{
    [[eeuiCachesManager sharedIntstance] clearCacheDir:callback];
}
- (void)getCacheSizeFiles:(WXModuleKeepAliveCallback)callback;
{
    [[eeuiCachesManager sharedIntstance] getCacheSizeFiles:callback];
}
- (void)clearCacheFiles:(WXModuleKeepAliveCallback)callback;
{
    [[eeuiCachesManager sharedIntstance] clearCacheFiles:callback];
}
- (void)getCacheSizeDbs:(WXModuleKeepAliveCallback)callback;
{
    [[eeuiCachesManager sharedIntstance] getCacheSizeDir:callback];
}
- (void)clearCacheDbs:(WXModuleKeepAliveCallback)callback;
{
    [[eeuiCachesManager sharedIntstance] clearCacheDbs:callback];
}

#pragma mark 验证弹窗

- (void)swipeCaptcha:(NSString*)imgUrl callback:(WXModuleKeepAliveCallback)callback
{
    [[eeuiCaptchaManager sharedIntstance] swipeCaptcha:imgUrl callback:callback];
}

#pragma mark 等待弹窗

- (NSString*)loading:(id)params callback:(WXModuleKeepAliveCallback)callback
{
    NSString *str = [[eeuiLoadingManager sharedIntstance] loading:params callback:callback];
    return str;
}

- (void)loadingClose:(NSString*)name
{
    [[eeuiLoadingManager sharedIntstance] loadingClose:name];
}


#pragma mark 页面功能

- (void)openPage:(NSDictionary*)params callback:(WXModuleKeepAliveCallback)callback
{
    [eeuiNewPageManager sharedIntstance].weexInstance = [[WXSDKManager bridgeMgr] topInstance];
    [[eeuiNewPageManager sharedIntstance] openPage:params callback:callback];
}

- (NSDictionary*)getPageInfo:(id)params
{
    return [[eeuiNewPageManager sharedIntstance] getPageInfo:params];
}

- (void)getPageInfoAsync:(id)params callback:(WXModuleCallback)callback
{
    [[eeuiNewPageManager sharedIntstance] getPageInfoAsync:params callback:callback];
}

- (void)reloadPage:(id)params
{
    [[eeuiNewPageManager sharedIntstance] reloadPage:params];
}

- (void)setSoftInputMode:(id)params modo:(NSString*)modo
{
    [[eeuiNewPageManager sharedIntstance] setSoftInputMode:params modo:modo];
}

- (void)setStatusBarStyle:(BOOL)isLight
{
    [[eeuiNewPageManager sharedIntstance] setStatusBarStyle:isLight];
}

- (void)statusBarStyle:(BOOL)isLight
{
    [[eeuiNewPageManager sharedIntstance] setStatusBarStyle:isLight];
}

- (void)setPageBackPressed:(id)params callback:(WXModuleKeepAliveCallback)callback
{
    [[eeuiNewPageManager sharedIntstance] setPageBackPressed:params callback:callback];
}

- (void)setOnRefreshListener:(id)params callback:(WXModuleKeepAliveCallback)callback
{
    [[eeuiNewPageManager sharedIntstance] setOnRefreshListener:params callback:callback];
}

- (void)setRefreshing:(id)params refreshing:(BOOL)refreshing
{
    [[eeuiNewPageManager sharedIntstance] setRefreshing:params refreshing:refreshing];
}

- (void)setPageStatusListener:(id)params callback:(WXModuleKeepAliveCallback)callback
{
    [[eeuiNewPageManager sharedIntstance] setPageStatusListener:params callback:callback];
}

- (void)clearPageStatusListener:(id)params
{
    [[eeuiNewPageManager sharedIntstance] clearPageStatusListener:params];
}

- (void)onPageStatusListener:(id)params status:(NSString*)status
{
    [[eeuiNewPageManager sharedIntstance] onPageStatusListener:params status:status];
}

- (void)getCacheSizePage:(WXModuleKeepAliveCallback)callback
{
    [[eeuiNewPageManager sharedIntstance] getCacheSizePage:callback];
}

- (void)clearCachePage
{
    [[eeuiNewPageManager sharedIntstance] clearCachePage];
}

- (void)closePage:(id)params
{
    [[eeuiNewPageManager sharedIntstance] closePage:params];
}

- (void)closePageTo:(id)params
{
    [[eeuiNewPageManager sharedIntstance] closePageTo:params];
}

- (void)openWeb:(NSString*)url
{
    [[eeuiNewPageManager sharedIntstance] openWeb:url];
}

- (void)goDesktop
{
    [[eeuiNewPageManager sharedIntstance] goDesktop];
}

- (NSString*)getConfigString:(NSString*)key
{
    return [Config getString:key defaultVal:@""];
}

- (NSString*)realUrl:(NSString*)url
{
    return [DeviceUtil realUrl:url];
}

- (NSString*)rewriteUrl:(NSString*)url
{
    return [DeviceUtil rewriteUrl:url];
}

#pragma mark 打开其他APP

- (void)openOtherApp:(NSString*)type
{
    NSString *ali = [NSString stringWithFormat:@"ali%@", @"pay"];//防止检测被拒

    NSString *app = @"";
    if ([type isEqualToString:@"wx"]) {
        app = @"weixin";
    } else if ([type isEqualToString:@"qq"]) {
        app = @"mqq";
    } else if ([type isEqualToString:ali]) {
        app = ali;
    } else if ([type isEqualToString:@"jd"]) {
        app = @"jd";
    }
    #warning ssss 京东开不开
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@://", app]];

    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
}

#pragma mark 复制粘贴

- (void)copyText:(NSString*)text
{
    UIPasteboard * pastboard = [UIPasteboard generalPasteboard];
    pastboard.string = text;
}

- (NSString*)pasteText
{
    UIPasteboard * pastboard = [UIPasteboard generalPasteboard];
    return pastboard.string;
}

#pragma mark 二维码

- (void)openScaner:(id)params callback:(WXModuleKeepAliveCallback)callback
{
    NSString *desc = @"";
    BOOL successClose = YES;
    if ([params isKindOfClass:[NSDictionary class]]) {
        desc = params[@"desc"] ? [WXConvert NSString:params[@"desc"]] : @"";
        successClose = params[@"successClose"] ? [WXConvert BOOL:params[@"successClose"]] : YES;
    } else if ([params isKindOfClass:[NSString class]]){
        desc = (NSString*)params;
    }


    scanViewController *scan = [[scanViewController alloc]init];
    scan.desc = desc;
    scan.successClose = successClose;

    int tag =(arc4random() % 100) + 1000;//返回随机数
    NSString *pageName = [NSString stringWithFormat:@"scaner-%d", tag];

    scan.scanerBlock = ^(NSDictionary *dic) {
        NSDictionary *result = @{@"status":dic[@"status"], @"pageName":pageName, @"source":dic[@"source"], @"result":@"", @"format":@"", @"text":dic[@"url"]};
        WXModuleKeepAliveCallback callback_ = callback;
        callback_(result, NO);
    };
    [[[DeviceUtil getTopviewControler] navigationController] pushViewController:scan animated:YES];
}

#pragma mark 保存图片至本地

- (void)saveImage:(NSString*)imgUrl callback:(WXKeepAliveCallback)callback
{
    [[eeuiSaveImageManager sharedIntstance] saveImage:imgUrl callback:callback];
}

#pragma mark 分享

- (void)shareText:(NSString*)text
{
    [[eeuiShareManager sharedIntstance] shareText:text];
}

- (void)shareImage:(NSString*)imgUrl
{
    [[eeuiShareManager sharedIntstance] shareImage:imgUrl];
}

#pragma mark 保存数据信息

- (void)setCachesString:(NSString*)key value:(id)value expired:(NSInteger)expired
{
    [[eeuiStorageManager sharedIntstance] setCachesString:key value:value expired:expired];
}

- (id)getCachesString:key defaultVal:(id)defaultVal
{
    return [[eeuiStorageManager sharedIntstance] getCachesString:key defaultVal:defaultVal];
}

- (void)setVariate:(NSString*)key value:(id)value
{
    [[eeuiStorageManager sharedIntstance] setVariate:key value:value];
}

- (id)getVariate:(NSString*)key defaultVal:(id)defaultVal
{
    return [[eeuiStorageManager sharedIntstance] getVariate:key defaultVal:defaultVal];
}

#pragma mark 系统信息

- (NSInteger)getStatusBarHeight
{
    if (iPhoneXSeries) {
        return 44;
    } else {
        return 20;
    }
}

- (NSInteger)getStatusBarHeightPx
{
    return [self weexDp2px:[self getStatusBarHeight]];
}

#warning ssss 与安卓不一致，待解决
- (NSInteger)getNavigationBarHeight
{
    return 0;
}

- (NSInteger)getNavigationBarHeightPx
{
    return 0;
}

- (NSInteger)getVersion
{
    return [[eeuiVersion eeuiVersion] integerValue];
}

- (NSString*)getVersionName
{
    return [eeuiVersion eeuiVersionName];
}

- (NSInteger)getLocalVersion
{
    NSString *version = [[[NSBundle mainBundle] infoDictionary]  objectForKey:@"CFBundleVersion"];

    NSArray *list = [version componentsSeparatedByString:@"."];
    if (list.count > 0) {
        //版本号形式
        return [list.lastObject integerValue];
    } else {
        //数字形式
        return [version integerValue];
    }
}

- (NSString*)getLocalVersionName
{
    return (NSString*)[[[NSBundle mainBundle] infoDictionary]  objectForKey:@"CFBundleShortVersionString"];
}

- (NSInteger)compareVersion:(NSString*)firstVersion secondVersion:(NSString*)secondVersion
{
    NSInteger comp = [firstVersion compare:secondVersion];
    if (comp == NSOrderedAscending) {
        return -1;
    } else if (comp == NSOrderedDescending){
        return 1;
    } else {
        return 0;
    }
}

- (NSString*)getImei
{
    return (NSString*)[[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
}

- (NSString*)getIfa
{
    return (NSString*)[[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
}

- (NSInteger)getSDKVersionCode
{
    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
    NSArray *list = [phoneVersion componentsSeparatedByString:@"."];
    if (list.count > 0) {
        return [list.firstObject integerValue];
    } else {
        return [phoneVersion integerValue];
    }
}

- (NSString*)getSDKVersionName
{
    return (NSString*)[[UIDevice currentDevice] systemVersion];
}

- (Boolean)isIPhoneXType
{
    return iPhoneXSeries;
}

#pragma mark 吐司提示

- (void)toast:(NSDictionary *)param
{
    [[eeuiToastManager sharedIntstance] toast:param];
}

- (void)toastClose
{
    [[eeuiToastManager sharedIntstance] toastClose];
}

#pragma mark px单位转换

//weex px转屏幕像素
- (NSInteger)weexPx2dp:(NSInteger)value
{
    return [UIScreen mainScreen].bounds.size.width * 1.0 / 750 * value;
}

//屏幕像素转weex px
- (NSInteger)weexDp2px:(NSInteger)value
{
    return 750 * 1.0 / [UIScreen mainScreen].bounds.size.width * value;
}

#pragma mark 键盘
- (void) keyboardUtils:(NSString*)key
{
    //动态隐藏软键盘
    if ([key isEqualToString:@"hideSoftInput"]) {
        UIViewController *vc = [DeviceUtil getTopviewControler];
        [vc.view endEditing:YES];
    }
}

//动态隐藏软键盘
- (void) keyboardHide
{
    UIViewController *vc = [DeviceUtil getTopviewControler];
    [vc.view endEditing:YES];
}

//判断软键盘是否可见
- (BOOL) keyboardStatus
{
    return [CustomWeexSDKManager getKeyBoardlsVisible];
}

@end
