//
//  ViewController.m
//  WindmillSample
//
//  Created by Codi on 2021/12/6.
//

#import "ViewController.h"
#import "XLFormRowLeftIconAndTitleCell.h"
#import <WindSDK/WindSDK.h>
#import "WindRewardVideoAdViewController.h"
#import "WindNewIntersititialAdViewController.h"
#import "WindIntersititialAdViewController.h"
#import "WindNativeAdViewController.h"
#import "WindSplashAdViewController.h"
#import "WindToolViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Wind Demo";
    [self initializeForm];
}

- (void)initializeForm {
    XLFormDescriptor * form;
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    form = [XLFormDescriptor formDescriptorWithTitle:@"HomePage"];

    //********************************************************************************
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"SplashAd" rowType:XLFormRowDescriptorTypeLeftIconAndTitle title:@"开屏广告"];
    row.required = YES;
    [row.cellConfigAtConfigure setValue:[UIImage imageNamed:@"demo_normal"] forKey:@"image"];
    row.action.formSelector = @selector(splashAdAction:);
    [section addFormRow:row];
    
    //********************************************************************************
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"RewardVideoAd" rowType:XLFormRowDescriptorTypeLeftIconAndTitle title:@"激励视频"];
    row.required = YES;
    [row.cellConfigAtConfigure setValue:[UIImage imageNamed:@"demo_play"] forKey:@"image"];
    row.action.formSelector = @selector(rewardVideoAdAction:);
    [section addFormRow:row];
    
    //****************************************************
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"InterstitialAd" rowType:XLFormRowDescriptorTypeLeftIconAndTitle title:@"全屏插屏广告"];
    row.required = YES;
    [row.cellConfigAtConfigure setValue:[UIImage imageNamed:@"demo_play"] forKey:@"image"];
    row.action.formSelector = @selector(interstitialAdAction:);
    [section addFormRow:row];
    
    //****************************************************
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"InterstitialAd" rowType:XLFormRowDescriptorTypeLeftIconAndTitle title:@"新插屏广告"];
    row.required = YES;
    [row.cellConfigAtConfigure setValue:[UIImage imageNamed:@"demo_play"] forKey:@"image"];
    row.action.formSelector = @selector(newInterstitialAdAction:);
    [section addFormRow:row];
    
    //*****************************************************
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"NativeAd" rowType:XLFormRowDescriptorTypeLeftIconAndTitle title:@"原生广告"];
    row.required = YES;
    [row.cellConfigAtConfigure setValue:[UIImage imageNamed:@"demo_normal"] forKey:@"image"];
    row.action.formSelector = @selector(nativeAdAction:);
    [section addFormRow:row];

    //********************************************************************************
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"Tools" rowType:XLFormRowDescriptorTypeLeftIconAndTitle title:@"工具"];
    row.required = YES;
    [row.cellConfigAtConfigure setValue:[UIImage imageNamed:@"demo_setting"] forKey:@"image"];
    row.action.formSelector = @selector(toolsAction:);
    [section addFormRow:row];
    
    //********************************************************************************
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"info" rowType:XLFormRowDescriptorTypeInfo title:@"Version"];
    row.value = [WindAds sdkVersion];
    [section addFormRow:row];
    
    self.form = form;
}


#pragma mark -Actions
- (void)splashAdAction:(XLFormRowDescriptor *)sender {
    WindSplashAdViewController *vc = [WindSplashAdViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)rewardVideoAdAction:(XLFormRowDescriptor *)sender {
    WindRewardVideoAdViewController *vc = [WindRewardVideoAdViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)interstitialAdAction:(XLFormRowDescriptor *)sender {
    WindIntersititialAdViewController *vc = [WindIntersititialAdViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)newInterstitialAdAction:(XLFormRowDescriptor *)sender {
    WindNewIntersititialAdViewController *vc = [WindNewIntersititialAdViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)nativeAdAction:(XLFormRowDescriptor *)sender {
    WindNativeAdViewController *vc = [WindNativeAdViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)toolsAction:(XLFormRowDescriptor *)sender {
    WindToolViewController *vc = [WindToolViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
