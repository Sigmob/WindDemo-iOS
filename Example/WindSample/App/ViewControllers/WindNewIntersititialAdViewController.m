//
//  WindNewIntersititialAdViewController.m
//  WindmillSample
//
//  Created by Codi on 2023/5/22.
//

#import "WindNewIntersititialAdViewController.h"
#import <WindSDK/WindSDK.h>
#import <UIView+Toast.h>
#import "WindHelper.h"
#import "XLFormDropdownCell.h"
#import "XLFormInlineLabelCell.h"

@interface WindNewIntersititialAdViewController ()<WindNewIntersititialAdDelegate>
@property (nonatomic, strong) WindNewIntersititialAd *intersititialAd;
@end

@implementation WindNewIntersititialAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.whiteColor;
    [self initializeForm];
}

- (void)loadAd:(XLFormRowDescriptor *)row {
    [self clearRowState:[self getCallbackTitles]];
    WindAdRequest *request = [WindAdRequest request];
    request.userId = @"your user id";
    request.placementId = InterstitialAdPlacementId;
    request.options = @{@"test_key":@"test_value"};
    if (!self.intersititialAd) {
        self.intersititialAd = [[WindNewIntersititialAd alloc] initWithRequest:request];
    }
    self.intersititialAd.delegate = self;
    [self.intersititialAd loadAdData];
}
- (void)showAd:(XLFormRowDescriptor *)row {
    if (!self.intersititialAd.isAdReady) {
        [self.view makeToast:@"not ready!" duration:1 position:CSToastPositionBottom];
        return;
    }
    //当多场景使用同一个广告位是，可以通过WindMillAdSceneId来区分某个场景的广告播放数据
    //不需要统计可以设置为options=nil
    [self.intersititialAd showAdFromRootViewController:self options:@{
        WindAdSceneDesc: @"测试场景",
        WindAdSceneId: @"1"
    }];
}


- (void)initializeForm {
    XLFormDescriptor * form = [XLFormDescriptor formDescriptorWithTitle:@"RewardVideoAd"];;
    XLFormSectionDescriptor *section;
    XLFormRowDescriptor *row;
    //*****************************************************
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"INFO" rowType:XLFormRowDescriptorTypeInfo title:@"广告位Id"];
    row.value = FullScreenVideoAdPlacementId;
    [section addFormRow:row];
    //****************************************************
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"ktype" rowType:XLFormRowDescriptorTypeSelectorSegmentedControl title:@"播放模式"];
    row.selectorOptions = @[@"全屏播放", @"非全屏播放"];
    row.value = @"全屏播放";
    [section addFormRow:row];
    //******************************************************
    section = [XLFormSectionDescriptor formSection];
    section.title = @"广告示例";
    [form addFormSection:section];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"kloadAd" rowType:XLFormRowDescriptorTypeButton title:@"load广告"];
    row.action.formSelector = @selector(loadAd:);
    [section addFormRow:row];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"kshowAd" rowType:XLFormRowDescriptorTypeButton title:@"观看广告"];
    row.action.formSelector = @selector(showAd:);
    [section addFormRow:row];
    
    // Section
    section = [WindHelper getCallbackRows:[self getCallbackTitles]];
    [form addFormSection:section];

    self.form = form;
}

- (NSArray *)getCallbackTitles {
    return @[
        @{@"tag":kAdServerResponse, @"title":@"intersititialAdServerResponse:isFillAd:"},
        @{@"tag":kAdDidLoad, @"title":@"intersititialAdDidLoad:"},
        @{@"tag":kAdDidLoadError, @"rowType": XLFormRowDescriptorTypeLabelInline, @"title":@"intersititialAdDidLoad:didFailWithError:"},
        @{@"tag":kAdWillVisible, @"title":@"intersititialAdWillVisible:"},
        @{@"tag":kAdDidVisible, @"title":@"intersititialAdDidVisible:"},
        @{@"tag":kAdDidClick, @"title":@"intersititialAdDidClick:"},
        @{@"tag":kAdDidSkip, @"title":@"intersititialAdDidClickSkip:"},
        @{@"tag":kAdDidClose, @"title":@"intersititialAdDidClose:"},
    ];
}

#pragma mark - WindIntersititialAdDelegate
- (void)intersititialAdDidLoad:(WindNewIntersititialAd *)intersititialAd {
    DDLogDebug(@"%@ -- %@", NSStringFromSelector(_cmd), intersititialAd.placementId);
    [self.view.window makeToast:NSStringFromSelector(_cmd) duration:1 position:CSToastPositionBottom];
    [self updateFromRowDisableWithTag:kAdDidLoad error:nil];
}

- (void)intersititialAdDidLoad:(WindNewIntersititialAd *)intersititialAd didFailWithError:(NSError *)error {
    DDLogDebug(@"%@ -- %@", NSStringFromSelector(_cmd), intersititialAd.placementId);
    [self.view.window makeToast:NSStringFromSelector(_cmd) duration:1 position:CSToastPositionBottom];
    [self updateFromRowDisableWithTag:kAdDidLoadError error:error];
}

- (void)intersititialAdWillVisible:(WindNewIntersititialAd *)intersititialAd {
    DDLogDebug(@"%@ -- %@", NSStringFromSelector(_cmd), intersititialAd.placementId);
    [self.view.window makeToast:NSStringFromSelector(_cmd) duration:1 position:CSToastPositionBottom];
    [self updateFromRowDisableWithTag:kAdWillVisible error:nil];
}

- (void)intersititialAdDidVisible:(WindNewIntersititialAd *)intersititialAd {
    DDLogDebug(@"%@ -- %@", NSStringFromSelector(_cmd), intersititialAd.placementId);
    [self.view.window makeToast:NSStringFromSelector(_cmd) duration:1 position:CSToastPositionBottom];
    [self updateFromRowDisableWithTag:kAdDidVisible error:nil];
}

- (void)intersititialAdDidClick:(WindNewIntersititialAd *)intersititialAd {
    DDLogDebug(@"%@ -- %@", NSStringFromSelector(_cmd), intersititialAd.placementId);
    [self.view.window makeToast:NSStringFromSelector(_cmd) duration:1 position:CSToastPositionBottom];
    [self updateFromRowDisableWithTag:kAdDidClick error:nil];
}

- (void)intersititialAdDidClickSkip:(WindNewIntersititialAd *)intersititialAd {
    DDLogDebug(@"%@ -- %@", NSStringFromSelector(_cmd), intersititialAd.placementId);
    [self.view.window makeToast:NSStringFromSelector(_cmd) duration:1 position:CSToastPositionBottom];
    [self updateFromRowDisableWithTag:kAdDidSkip error:nil];
}

- (void)intersititialAdDidClose:(WindNewIntersititialAd *)intersititialAd {
    DDLogDebug(@"%@ -- %@", NSStringFromSelector(_cmd), intersititialAd.placementId);
    [self.view.window makeToast:NSStringFromSelector(_cmd) duration:1 position:CSToastPositionBottom];
    [self updateFromRowDisableWithTag:kAdDidClose error:nil];
}

- (void)intersititialAdServerResponse:(WindNewIntersititialAd *)intersititialAd isFillAd:(BOOL)isFillAd {
    DDLogDebug(@"%@ -- %@", NSStringFromSelector(_cmd), intersititialAd.placementId);
    [self.view.window makeToast:NSStringFromSelector(_cmd) duration:1 position:CSToastPositionBottom];
    [self updateFromRowDisableWithTag:kAdServerResponse error:nil];
}

@end
