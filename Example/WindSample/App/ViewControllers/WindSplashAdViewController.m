//
//  WindSplashAdViewController.m
//  WindmillSample
//
//  Created by Codi on 2021/12/6.
//

#import "WindSplashAdViewController.h"
#import <WindSDK/WindSDK.h>
#import <MJExtension/MJExtension.h>
#import "WindHelper.h"
#import "XLFormDropdownCell.h"
#import "XLFormInlineLabelCell.h"
#import <UIView+Toast.h>

@interface WindSplashAdViewController ()<WindSplashAdViewDelegate>
@property (nonatomic, strong) WindSplashAdView *splashAdView;
@property (nonatomic, strong) UIView *logoView;

@end

@implementation WindSplashAdViewController

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
    row.value = SplashAdPlacementId;
    [section addFormRow:row];
    //********************************************************************************
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"klogo" rowType:XLFormRowDescriptorTypeSelectorSegmentedControl title:@"是否展示品牌区域"];
    row.selectorOptions = @[@"展示", @"不展示"];
    row.value = @"展示";
    [section addFormRow:row];

    //********************************************************************************
    section = [XLFormSectionDescriptor formSection];
    section.title = @"预加载模式";
    [form addFormSection:section];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"kloadAd" rowType:XLFormRowDescriptorTypeButton title:@"loadAdData"];
    row.action.formSelector = @selector(loadAd:);
    [section addFormRow:row];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"kshowAd" rowType:XLFormRowDescriptorTypeButton title:@"showAd"];
    row.action.formSelector = @selector(showAd:);
    [section addFormRow:row];
    
    //********************************************************************************
    section = [WindHelper getCallbackRows:[self getCallbackTitles]];
    [form addFormSection:section];

    self.form = form;
}

- (NSArray *)getCallbackTitles {
    return @[
        @{@"tag":kAdDidLoad, @"title":@"onSplashAdDidLoad:"},
        @{@"tag":kAdDidLoadError, @"rowType": XLFormRowDescriptorTypeLabelInline, @"title":@"onSplashAdLoadFail:error:"},
        @{@"tag":kAdDidVisible, @"title":@"onSplashAdSuccessPresentScreen:"},
        @{@"tag":kAdDidRenderError, @"title":@"onSplashAdFailToPresent:withError:"},
        @{@"tag":kAdDidClick, @"title":@"onSplashAdClicked:"},
        @{@"tag":kAdDidSkip, @"title":@"onSplashAdSkiped:"},
        @{@"tag":kAdDidClose, @"title":@"onSplashAdClosed:"},
    ];
}

- (BOOL)hasLogo {
    XLFormRowDescriptor *row = [self.form formRowWithTag:@"klogo"];
    return [row.value isEqualToString:@"展示"];
}

#pragma mark -Actions
- (void)loadAd:(XLFormRowDescriptor *)row {
    [self clearRowState:[self getCallbackTitles]];
    CGFloat logoHeight = 0;
    if ([self hasLogo]) {
        logoHeight = 150;
    }
    if (!self.splashAdView) {
        WindAdRequest *request = [WindAdRequest request];
        request.placementId = SplashAdPlacementId;
        request.userId = @"your user id";
        WindSplashAdView *splashAdView = [[WindSplashAdView alloc] initWithRequest:request];
        splashAdView.delegate = self;
        splashAdView.rootViewController = self;
        self.splashAdView = splashAdView;
    }
    [self.splashAdView loadAdData];
    
}
- (void)showAd:(XLFormRowDescriptor *)row {
    if (!self.splashAdView.isAdValid) {
        [self.view makeToast:@"not ready!" duration:1 position:CSToastPositionCenter];
        return;
    }
    UIView *supView = self.navigationController ? self.navigationController.view : self.view;
    if ([self hasLogo]) {
        UIView *logoView = [self getLogoView];
        self.logoView = logoView;
        CGRect supFrame = supView.bounds;
        CGRect adFrame = CGRectMake(0, 0, supFrame.size.width, supFrame.size.height - logoView.bounds.size.height);
        logoView.frame = CGRectMake(0,
                                      supFrame.size.height - CGRectGetHeight(logoView.frame),
                                      CGRectGetWidth(logoView.frame),
                                      CGRectGetHeight(logoView.frame)
                                      );
        self.splashAdView.frame = adFrame;
        [supView addSubview:logoView];
        [supView addSubview:self.splashAdView];
    }else {
        self.splashAdView.frame = supView.bounds;
        [supView addSubview:self.splashAdView];
    }
}


- (UIView *)getLogoView {
    UIView *bottomView = [UIView new];
    bottomView.backgroundColor = [UIColor whiteColor];
    CGFloat w = MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    bottomView.frame = CGRectMake(0, 0, w, 150);
    
    NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];
    NSString *icon = [[infoPlist valueForKeyPath:@"CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles"] lastObject];
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    imgView.frame = bottomView.bounds;
    imgView.image = [UIImage imageNamed:icon];
    [bottomView addSubview:imgView];
    return bottomView;
}

- (void)removeSplashAdView {
    [self.logoView removeFromSuperview];
    self.logoView = nil;
    [self.splashAdView removeFromSuperview];
    self.splashAdView.delegate = nil;
    self.splashAdView = nil;
}


#pragma mark - WindMillSplashAdDelegate
- (void)onSplashAdDidLoad:(WindSplashAdView *)splashAdView {
    DDLogDebug(@"%@ -- %@", NSStringFromSelector(_cmd), splashAdView.placementId);
    [self.view.window makeToast:NSStringFromSelector(_cmd) duration:1 position:CSToastPositionBottom];
    [self updateFromRowDisableWithTag:kAdDidLoad error:nil];
}

- (void)onSplashAdLoadFail:(WindSplashAdView *)splashAdView error:(NSError *)error {
    DDLogDebug(@"%@ -- %@", NSStringFromSelector(_cmd), splashAdView.placementId);
    DDLogError(@"%@", error);
    [self.view.window makeToast:NSStringFromSelector(_cmd) duration:1 position:CSToastPositionBottom];
    [self updateFromRowDisableWithTag:kAdDidLoadError error:error];
    [self removeSplashAdView];
}

- (void)onSplashAdSuccessPresentScreen:(WindSplashAdView *)splashAdView {
    DDLogDebug(@"%@ -- %@", NSStringFromSelector(_cmd), splashAdView.placementId);
    [self.view.window makeToast:NSStringFromSelector(_cmd) duration:1 position:CSToastPositionBottom];
    [self updateFromRowDisableWithTag:kAdDidVisible error:nil];
}

- (void)onSplashAdFailToPresent:(WindSplashAdView *)splashAdView withError:(NSError *)error {
    DDLogDebug(@"%@ -- %@", NSStringFromSelector(_cmd), splashAdView.placementId);
    DDLogError(@"%@", error);
    [self.view.window makeToast:NSStringFromSelector(_cmd) duration:1 position:CSToastPositionBottom];
    [self updateFromRowDisableWithTag:kAdDidRenderError error:nil];
    [self removeSplashAdView];
}

- (void)onSplashAdClicked:(WindSplashAdView *)splashAdView {
    DDLogDebug(@"%@ -- %@", NSStringFromSelector(_cmd), splashAdView.placementId);
    [self.view.window makeToast:NSStringFromSelector(_cmd) duration:1 position:CSToastPositionBottom];
    [self updateFromRowDisableWithTag:kAdDidClick error:nil];
}

- (void)onSplashAdSkiped:(WindSplashAdView *)splashAdView {
    DDLogDebug(@"%@ -- %@", NSStringFromSelector(_cmd), splashAdView.placementId);
    [self.view.window makeToast:NSStringFromSelector(_cmd) duration:1 position:CSToastPositionBottom];
    [self updateFromRowDisableWithTag:kAdDidSkip error:nil];
}

- (void)onSplashAdClosed:(WindSplashAdView *)splashAdView {
    DDLogDebug(@"%@ -- %@", NSStringFromSelector(_cmd), splashAdView.placementId);
    [self.view.window makeToast:NSStringFromSelector(_cmd) duration:1 position:CSToastPositionBottom];
    [self updateFromRowDisableWithTag:kAdDidClose error:nil];
    [self removeSplashAdView];
}
@end
