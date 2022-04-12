//
//  WindNativeAdViewController.m
//  WindmillSample
//
//  Created by Codi on 2021/12/6.
//

#import "WindNativeAdViewController.h"
#import <WindSDK/WindSDK.h>
#import <Masonry/Masonry.h>
#import <UIView+Toast.h>
#import "WindHelper.h"
#import "NativeAdCustomView.h"
#import "WindmillDropdownListView.h"
#import "XLFormSliderValueCell.h"
#import "XLFormDropdownCell.h"
#import "XLFormInlineLabelCell.h"
#import "WindNativeTableViewController.h"
#import "WindFeedAdViewStyle.h"

static NSString *const kSliderWidth = @"slider-W";
static NSString *const kSliderHeight = @"slider-H";

@interface WindNativeAdViewController ()<WindNativeAdsManagerDelegate, WindNativeAdViewDelegate>
@property (nonatomic, strong) WindNativeAdsManager *nativeAdsManager;
@property (nonatomic, strong) NativeAdCustomView *adView;
@property (nonatomic, strong) UIView *contentView;//广告父容器
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@end

@implementation WindNativeAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.whiteColor;
    [self initializeForm];
}

- (void)initializeForm {
    XLFormDescriptor * form = [XLFormDescriptor formDescriptorWithTitle:@"RewardVideoAd"];;
    XLFormSectionDescriptor *section;
    XLFormRowDescriptor *row;
    //********************************************************************************
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"INFO" rowType:XLFormRowDescriptorTypeInfo title:@"广告位Id"];
    row.value = NativeAdPlacementId;
    [section addFormRow:row];
    //********************************************************************************
    section = [XLFormSectionDescriptor formSectionWithTitle:@"设置广告位宽高"];
    section.footerTitle = @"高度设置为0，表示根据宽度自适应高度(仅针对模版渲染)";
    [form addFormSection:section];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kSliderWidth rowType:XLFormRowDescriptorTypeSliderValue title:@"广告位宽"];
    row.value = @(UIScreen.mainScreen.bounds.size.width);
    [row.cellConfigAtConfigure setObject:@(UIScreen.mainScreen.bounds.size.width) forKey:@"slider.maximumValue"];
    [row.cellConfigAtConfigure setObject:@(0) forKey:@"slider.minimumValue"];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kSliderHeight rowType:XLFormRowDescriptorTypeSliderValue title:@"广告位高"];
    row.value = @(0);
    [row.cellConfigAtConfigure setObject:@(UIScreen.mainScreen.bounds.size.height) forKey:@"slider.maximumValue"];
    [row.cellConfigAtConfigure setObject:@(0) forKey:@"slider.minimumValue"];
    [section addFormRow:row];
    
    //********************************************************************************
    section = [XLFormSectionDescriptor formSection];
    section.title = @"广告示例";
    [form addFormSection:section];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"kloadAd" rowType:XLFormRowDescriptorTypeButton title:@"简单接入"];
    row.action.formSelector = @selector(showAdNormal:);
    [section addFormRow:row];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"kloadAd" rowType:XLFormRowDescriptorTypeButton title:@"复杂接入(针对TableView)"];
    row.action.formSelector = @selector(showAdTableView:);
    [section addFormRow:row];
    
    //********************************************************************************
    section = [WindHelper getCallbackRows:[self getCallbackTitles]];
    [form addFormSection:section];
    
    self.form = form;
}

- (NSArray *)getCallbackTitles {
    return @[
        @{@"tag":kAdDidLoad, @"title":@"nativeAdsManagerSuccessToLoad:"},
        @{@"tag":kAdDidLoadError, @"rowType": XLFormRowDescriptorTypeLabelInline, @"title":@"nativeAdsManager:didFailWithError:"},
        @{@"tag":kAdDidRenderSuccess, @"title":@"nativeExpressAdViewRenderSuccess:"},
        @{@"tag":kAdDidRenderError, @"title":@"nativeExpressAdViewRenderFail:error:"},
        @{@"tag":kAdWillVisible, @"title":@"nativeAdViewWillExpose:"},
        @{@"tag":kAdDidClick, @"title":@"nativeAdViewDidClick:"},
        @{@"tag":kAdDetailViewVisible, @"title":@"nativeAdDetailViewWillPresentScreen:"},
        @{@"tag":kAdDetailViewClose, @"title":@"nativeAdDetailViewClosed:"},
        @{@"tag":kAdDidPlayStateChange, @"rowType": XLFormRowDescriptorTypeLabelInline, @"title":@"nativeAdView:playerStatusChanged:userInfo:"},
        @{@"tag":kAdDislike, @"title":@"nativeAdView:dislikeWithReason:"},
    ];
}

- (void)showAdNormal:(XLFormRowDescriptor *)row {
    [self clearRowState:[self getCallbackTitles]];
    if (!self.nativeAdsManager) {
        WindAdRequest *request = [WindAdRequest request];
        request.placementId = NativeAdPlacementId;
        request.userId = @"your user id";
        request.options = @{@"test_key_1":@"test_value"};//s2s激励回传自定义参数，可以为nil
        self.nativeAdsManager = [[WindNativeAdsManager alloc] initWithRequest:request];
    }
    self.nativeAdsManager.delegate = self;
    [self.nativeAdsManager loadAdDataWithCount:1];
}
- (void)showAdTableView:(XLFormRowDescriptor *)row {
    [self clearRowState:[self getCallbackTitles]];
    WindNativeTableViewController *vc = [[WindNativeTableViewController alloc] init];
    vc.width = self.width;
    vc.height = self.height;
    vc.placementId = NativeAdPlacementId;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)renderAdView:(NSArray<WindNativeAd *> *)nativeAdList {
    if (nativeAdList.count == 0) return;
    WindNativeAd *nativeAd = nativeAdList.firstObject;
    self.adView = [NativeAdCustomView new];
    self.adView.delegate = self;
    [self.adView refreshData:nativeAd];
    self.adView.viewController = self;
    [self.view addSubview:self.contentView];
    [self.contentView addSubview:self.adView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.center.equalTo(self.view);
    }];
    [WindFeedAdViewStyle layoutWithModel:nativeAd adView:self.adView];
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1];
        _contentView.clipsToBounds = YES;
    }
    return _contentView;
}

#pragma mark - WindNativeAdsManagerDelegate
- (void)nativeAdsManagerSuccessToLoad:(WindNativeAdsManager *)adsManager nativeAds:(NSArray<WindNativeAd *> *)nativeAdDataArray {
    DDLogDebug(@"%@ -- %@", NSStringFromSelector(_cmd), adsManager.placementId);
    [self.view.window makeToast:NSStringFromSelector(_cmd) duration:1 position:CSToastPositionBottom];
    [self updateFromRowDisableWithTag:kAdDidLoad error:nil];
    [self renderAdView:nativeAdDataArray];
}

- (void)nativeAdsManager:(WindNativeAdsManager *)adsManager didFailWithError:(NSError *)error {
    DDLogDebug(@"%@ -- %@", NSStringFromSelector(_cmd), adsManager.placementId);
    [self.view.window makeToast:NSStringFromSelector(_cmd) duration:1 position:CSToastPositionBottom];
    [self updateFromRowDisableWithTag:kAdDidLoadError error:error];
}


#pragma mark - WindNativeAdViewDelegate
/**
 广告曝光回调
 
 @param nativeAdView WindNativeAdView 实例
 */
- (void)nativeAdViewWillExpose:(WindNativeAdView *)nativeAdView {
    DDLogDebug(@"%@", NSStringFromSelector(_cmd));
    [self.view.window makeToast:NSStringFromSelector(_cmd) duration:1 position:CSToastPositionBottom];
    [self updateFromRowDisableWithTag:kAdWillVisible error:nil];
}


/**
 广告点击回调
 
 @param nativeAdView WindNativeAdView 实例
 */
- (void)nativeAdViewDidClick:(WindNativeAdView *)nativeAdView {
    DDLogDebug(@"%@", NSStringFromSelector(_cmd));
    [self.view.window makeToast:NSStringFromSelector(_cmd) duration:1 position:CSToastPositionBottom];
    [self updateFromRowDisableWithTag:kAdDidClick error:nil];
}


/**
 广告详情页关闭回调
 
 @param nativeAdView WindNativeAdView 实例
 */
- (void)nativeAdDetailViewClosed:(WindNativeAdView *)nativeAdView {
    DDLogDebug(@"%@", NSStringFromSelector(_cmd));
    [self.view.window makeToast:NSStringFromSelector(_cmd) duration:1 position:CSToastPositionBottom];
    [self updateFromRowDisableWithTag:kAdDetailViewClose error:nil];
}


/**
 广告详情页面即将展示回调
 
 @param nativeAdView WindNativeAdView 实例
 */
- (void)nativeAdDetailViewWillPresentScreen:(WindNativeAdView *)nativeAdView {
    DDLogDebug(@"%@", NSStringFromSelector(_cmd));
    [self.view.window makeToast:NSStringFromSelector(_cmd) duration:1 position:CSToastPositionBottom];
    [self updateFromRowDisableWithTag:kAdDetailViewVisible error:nil];
}


/**
 视频广告播放状态更改回调
 
 @param nativeAdView WindNativeAdView 实例
 @param status 视频广告播放状态
 @param userInfo 视频广告信息
 */
- (void)nativeAdView:(WindNativeAdView *)nativeAdView playerStatusChanged:(WindMediaPlayerStatus)status userInfo:(NSDictionary *)userInfo {
    DDLogDebug(@"%@", NSStringFromSelector(_cmd));
    [self.view.window makeToast:NSStringFromSelector(_cmd) duration:1 position:CSToastPositionBottom];
    [self updateFromRowDisableWithTag:kAdDidPlayStateChange error:nil];
}


- (void)nativeAdView:(WindNativeAdView *)nativeAdView dislikeWithReason:(NSArray<WindDislikeWords *> *)filterWords {
    DDLogDebug(@"%@", NSStringFromSelector(_cmd));
    [self.view.window makeToast:NSStringFromSelector(_cmd) duration:1 position:CSToastPositionBottom];
    [self updateFromRowDisableWithTag:kAdDislike error:nil];
    //在这个回调中移除视图，否则，会出现用户点击叉无效的情况
    [nativeAdView removeFromSuperview];
    nativeAdView.delegate = nil;
    nativeAdView = nil;
    self.adView = nil;
    [self.contentView removeFromSuperview];
}

#pragma mark - XLFormDescriptorDelegate
-(void)formRowDescriptorValueHasChanged:(XLFormRowDescriptor *)formRow oldValue:(id)oldValue newValue:(id)newValue {
    if ([formRow.tag isEqualToString:kSliderWidth]) {
        self.width = [formRow.value intValue];
        return;
    }
    if ([formRow.tag isEqualToString:kSliderHeight]) {
        self.height = [formRow.value intValue];
        return;
    }
}

@end
