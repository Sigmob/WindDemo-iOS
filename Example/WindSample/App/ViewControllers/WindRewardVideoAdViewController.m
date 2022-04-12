//
//  WindRewardVideoAdViewController.m
//  WindSample
//
//  Created by Codi on 2021/12/6.
//

#import "WindRewardVideoAdViewController.h"
#import <WindSDK/WindSDK.h>
#import <UIView+Toast.h>
#import "WindHelper.h"
#import "XLFormDropdownCell.h"
#import "XLFormInlineLabelCell.h"

@interface WindRewardVideoAdViewController ()<WindRewardVideoAdDelegate>
@property (nonatomic, strong) WindRewardVideoAd *rewardVideoAd;
@end

@implementation WindRewardVideoAdViewController

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
    request.placementId = RewardVideoAdPlacementId;
    request.options = @{@"test_key":@"test_value"};
    if (!self.rewardVideoAd) {
        self.rewardVideoAd = [[WindRewardVideoAd alloc] initWithRequest:request];
    }
    self.rewardVideoAd.delegate = self;
    [self.rewardVideoAd loadAdData];
}
- (void)showAd:(XLFormRowDescriptor *)row {
    if (!self.rewardVideoAd.isAdReady) {
        [self.view makeToast:@"not ready!" duration:1 position:CSToastPositionBottom];
        return;
    }
    //当多场景使用同一个广告位是，可以通过WindAdSceneId来区分某个场景的广告播放数据
    //不需要统计可以设置为options=nil
    [self.rewardVideoAd showAdFromRootViewController:self options:@{
        WindAdSceneDesc: @"测试场景",
        WindAdSceneId: @"1"
    }];
}

- (void)initializeForm {
    XLFormDescriptor * form = [XLFormDescriptor formDescriptorWithTitle:@"RewardVideoAd"];;
    XLFormSectionDescriptor *section;
    XLFormRowDescriptor *row;
    //********************************************************************************
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"INFO" rowType:XLFormRowDescriptorTypeInfo title:@"广告位Id"];
    row.value = RewardVideoAdPlacementId;
    [section addFormRow:row];
    //********************************************************************************
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
        @{@"tag":kAdServerResponse, @"title":@"rewardVideoAdServerResponse:isFillAd:"},
        @{@"tag":kAdDidLoad, @"title":@"rewardVideoAdDidLoad:"},
        @{@"tag":kAdDidLoadError, @"rowType": XLFormRowDescriptorTypeLabelInline, @"title":@"rewardVideoAdDidLoad:didFailWithError:"},
        @{@"tag":kAdWillVisible, @"title":@"rewardVideoAdWillVisible:"},
        @{@"tag":kAdDidVisible, @"title":@"rewardVideoAdDidVisible:"},
        @{@"tag":kAdDidClick, @"title":@"rewardVideoAdDidClick:"},
        @{@"tag":kAdDidSkip, @"title":@"rewardVideoAdDidClickSkip:"},
        @{@"tag":kAdDidReward, @"title":@"rewardVideoAd:reward:"},
        @{@"tag":kAdDidPlayFinish, @"rowType": XLFormRowDescriptorTypeLabelInline, @"title":@"rewardVideoAdDidPlayFinish:didFailWithError:"},
        @{@"tag":kAdDidClose, @"title":@"rewardVideoAdDidClose:"},
    ];
}

#pragma mark - WindRewardVideoAdDelegate
- (void)rewardVideoAdDidLoad:(WindRewardVideoAd *)rewardVideoAd {
    DDLogDebug(@"%@ -- %@", NSStringFromSelector(_cmd), rewardVideoAd.placementId);
    [self.view.window makeToast:NSStringFromSelector(_cmd) duration:1 position:CSToastPositionBottom];
    [self updateFromRowDisableWithTag:kAdDidLoad error:nil];
}

- (void)rewardVideoAdDidLoad:(WindRewardVideoAd *)rewardVideoAd didFailWithError:(NSError *)error {
    DDLogDebug(@"%@ -- %@", NSStringFromSelector(_cmd), rewardVideoAd.placementId);
    [self.view.window makeToast:NSStringFromSelector(_cmd) duration:1 position:CSToastPositionBottom];
    [self updateFromRowDisableWithTag:kAdDidLoadError error:error];
}

- (void)rewardVideoAdWillVisible:(WindRewardVideoAd *)rewardVideoAd {
    DDLogDebug(@"%@ -- %@", NSStringFromSelector(_cmd), rewardVideoAd.placementId);
    [self.view.window makeToast:NSStringFromSelector(_cmd) duration:1 position:CSToastPositionBottom];
    [self updateFromRowDisableWithTag:kAdWillVisible error:nil];
}

- (void)rewardVideoAdDidVisible:(WindRewardVideoAd *)rewardVideoAd {
    DDLogDebug(@"%@ -- %@", NSStringFromSelector(_cmd), rewardVideoAd.placementId);
    [self.view.window makeToast:NSStringFromSelector(_cmd) duration:1 position:CSToastPositionBottom];
    [self updateFromRowDisableWithTag:kAdDidVisible error:nil];
}

- (void)rewardVideoAdDidClick:(WindRewardVideoAd *)rewardVideoAd {
    DDLogDebug(@"%@ -- %@", NSStringFromSelector(_cmd), rewardVideoAd.placementId);
    [self.view.window makeToast:NSStringFromSelector(_cmd) duration:1 position:CSToastPositionBottom];
    [self updateFromRowDisableWithTag:kAdDidClick error:nil];
}

- (void)rewardVideoAdDidClickSkip:(WindRewardVideoAd *)rewardVideoAd {
    DDLogDebug(@"%@ -- %@", NSStringFromSelector(_cmd), rewardVideoAd.placementId);
    [self.view.window makeToast:NSStringFromSelector(_cmd) duration:1 position:CSToastPositionBottom];
    [self updateFromRowDisableWithTag:kAdDidSkip error:nil];
}

- (void)rewardVideoAd:(WindRewardVideoAd *)rewardVideoAd reward:(WindRewardInfo *)reward {
    DDLogDebug(@"%@ -- %@", NSStringFromSelector(_cmd), rewardVideoAd.placementId);
    [self.view.window makeToast:NSStringFromSelector(_cmd) duration:1 position:CSToastPositionBottom];
    [self updateFromRowDisableWithTag:kAdDidReward error:nil];
}

- (void)rewardVideoAdDidClose:(WindRewardVideoAd *)rewardVideoAd {
    DDLogDebug(@"%@ -- %@", NSStringFromSelector(_cmd), rewardVideoAd.placementId);
    [self.view.window makeToast:NSStringFromSelector(_cmd) duration:1 position:CSToastPositionBottom];
    [self updateFromRowDisableWithTag:kAdDidClose error:nil];
}

- (void)rewardVideoAdDidPlayFinish:(WindRewardVideoAd *)rewardVideoAd didFailWithError:(NSError *)error {
    DDLogDebug(@"%@ -- %@", NSStringFromSelector(_cmd), rewardVideoAd.placementId);
    [self.view.window makeToast:NSStringFromSelector(_cmd) duration:1 position:CSToastPositionBottom];
    [self updateFromRowDisableWithTag:kAdDidPlayFinish error:error];
}

/**
 This method is called when return ads from sigmob ad server.
 */
- (void)rewardVideoAdServerResponse:(WindRewardVideoAd *)rewardVideoAd isFillAd:(BOOL)isFillAd {
    DDLogDebug(@"%@ -- %@", NSStringFromSelector(_cmd), rewardVideoAd.placementId);
    [self.view.window makeToast:NSStringFromSelector(_cmd) duration:1 position:CSToastPositionBottom];
    [self updateFromRowDisableWithTag:kAdServerResponse error:nil];
}



- (void)dealloc {
    self.rewardVideoAd.delegate = nil;
    self.rewardVideoAd = nil;
}

@end

