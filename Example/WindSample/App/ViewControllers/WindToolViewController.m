//
//  WindToolViewController.m
//  WindmillSample
//
//  Created by Codi on 2021/12/6.
//

#import "WindToolViewController.h"
#import <UIView+Toast.h>
#import <WindSDK/WindSDK.h>
#import <AdSupport/AdSupport.h>
#import <WebKit/WebKit.h>
#import <CoreLocation/CoreLocation.h>
#import <AppTrackingTransparency/AppTrackingTransparency.h>

static NSString *const kUid = @"kUid";
static NSString *const kIdfa = @"kIdfa";
static NSString *const kUserAgent = @"kUserAgent";
static NSString *const kIdfaAuth = @"kIdfaAuth";
static NSString *const kLocationAuth = @"kLocationAuth";


@interface WindToolViewController ()<CLLocationManagerDelegate>
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) CLLocationManager *locationManager;
@end

@implementation WindToolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.whiteColor;
    [self initializeForm];
    [self getWebUA];
}

- (void)initializeForm {
    XLFormDescriptor * form = [XLFormDescriptor formDescriptorWithTitle:@"Tools"];;
    XLFormSectionDescriptor *section;
    XLFormRowDescriptor *row;
    //********************************************************************************
    // section
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    section.title = @"设备ID";
    section.footerTitle = @"SigId是Windmill内部ID，开发者技术对接可以使用该ID快速定位问题。";
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kUid rowType:XLFormRowDescriptorTypeButton title:@"SigId"];
    row.cellStyle = UITableViewCellStyleValue1;
    [row.cellConfigAtConfigure setObject:@(NO) forKey:@"useTintColor"];
    [row.cellConfigAtConfigure setObject:@(YES) forKey:@"detailTextLabel.adjustsFontSizeToFitWidth"];
    row.value = [WindAds getUid];
    row.action.formSelector = @selector(copyToPasteboard:);
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kIdfa rowType:XLFormRowDescriptorTypeButton title:@"IDFA"];
    row.cellStyle = UITableViewCellStyleValue1;
    [row.cellConfigAtConfigure setObject:@(NO) forKey:@"useTintColor"];
    [row.cellConfigAtConfigure setObject:@(YES) forKey:@"detailTextLabel.adjustsFontSizeToFitWidth"];
    row.value = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    row.action.formSelector = @selector(copyToPasteboard:);
    [section addFormRow:row];
    
    
    // section
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    section.title = @"设备User-Agent";

    row = [XLFormRowDescriptor formRowDescriptorWithTag:kUserAgent rowType:XLFormRowDescriptorTypeInfo title:@""];
    row.height = 100;
    row.hidden = @YES;
    row.value = @0;
    [row.cellConfigAtConfigure setObject:@(0) forKey:@"detailTextLabel.numberOfLines"];
    [section addFormRow:row];
    
    // section
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    section.title = @"权限";
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kIdfaAuth rowType:XLFormRowDescriptorTypeButton title:@"IDFA授权状态"];
    row.cellStyle = UITableViewCellStyleValue1;
    [row.cellConfigAtConfigure setObject:@(NO) forKey:@"useTintColor"];
    [row.cellConfigAtConfigure setObject:@(YES) forKey:@"detailTextLabel.adjustsFontSizeToFitWidth"];
    row.value = [self getIdfaAuthorizationStatus];
    row.action.formSelector = @selector(requestTrackingAuthorization);
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kLocationAuth rowType:XLFormRowDescriptorTypeButton title:@"定位授权状态"];
    row.cellStyle = UITableViewCellStyleValue1;
    [row.cellConfigAtConfigure setObject:@(NO) forKey:@"useTintColor"];
    row.value = [self getLocationAuthorizationStatus];
    row.action.formSelector = @selector(requestLocationAuthorization);
    [section addFormRow:row];
    

    self.form = form;
}

- (void)getWebUA {
    self.webView = nil;
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:configuration];
    self.webView = webView;
    __weak typeof(self) weakSelf = self;
    [self.webView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(NSString  * _Nullable result, NSError * _Nullable error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        XLFormRowDescriptor *row = [strongSelf.form formRowWithTag:kUserAgent];
        row.value = result;
        row.hidden = @NO;
        [self updateFormRow:row];
    }];
    
}

- (void)requestLocationAuthorization {
    BOOL enable = [CLLocationManager locationServicesEnabled];
    CLAuthorizationStatus state = [CLLocationManager authorizationStatus];
    if (enable && !(state == kCLAuthorizationStatusAuthorizedAlways || state == kCLAuthorizationStatusAuthorizedWhenInUse)) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.distanceFilter = 100;
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 设置定r位精度(精度越高越耗电)
        if (@available(iOS 8.0, *)) {
            [self.locationManager requestWhenInUseAuthorization];
        }
    }
}

- (void)locationManagerDidChangeAuthorization:(CLLocationManager *)manager {
    XLFormRowDescriptor *row = [self.form formRowWithTag:kLocationAuth];
    row.value = [self getLocationAuthorizationStatus];
    [self updateFormRow:row];
}

- (void)requestTrackingAuthorization {
    if (@available(iOS 14.0, *)) {
        [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                XLFormRowDescriptor *row = [self.form formRowWithTag:kIdfaAuth];
                row.value = [self getIdfaAuthorizationStatus];
                [self updateFormRow:row];
            });
        }];
    }
}

- (NSString *)getIdfaAuthorizationStatus {
    NSString *statusMsg = @"";
    if (@available(iOS 14.0, *)) {
        ATTrackingManagerAuthorizationStatus idfaStatus = [ATTrackingManager trackingAuthorizationStatus];
        
        switch (idfaStatus) {
            case ATTrackingManagerAuthorizationStatusRestricted:
                statusMsg = @"开启了限制广告追踪";
                break;
            case ATTrackingManagerAuthorizationStatusDenied:
                statusMsg = @"用户拒绝";
                break;
            case ATTrackingManagerAuthorizationStatusAuthorized:
                statusMsg = @"用户允许";
                break;
            case ATTrackingManagerAuthorizationStatusNotDetermined:
                statusMsg = @"用户未做选择或未弹窗";
                break;
            default:
                statusMsg = @"未知";
                break;
        }
    }
    return statusMsg;
}
- (NSString *)getLocationAuthorizationStatus {
    CLAuthorizationStatus state = [CLLocationManager authorizationStatus];
    NSString *stateMsg;
    switch (state) {
        case kCLAuthorizationStatusNotDetermined:
            stateMsg = @"用户未做选择";
            break;
        case kCLAuthorizationStatusRestricted:
            stateMsg = @"位置服务的限制";
            break;
        case kCLAuthorizationStatusDenied:
            stateMsg = @"用户拒绝授权";
            break;
        case kCLAuthorizationStatusAuthorizedAlways:
            stateMsg = @"授权状态允许在任何状态下";
            break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            stateMsg = @"授权状态仅允许在使用中";
            break;
        default:
            stateMsg = @"未知";
            break;
    }
    return stateMsg;
    
    
}


- (void)copyToPasteboard:(XLFormRowDescriptor *)row {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = row.value;
    [self.view makeToast:@"已复制到粘贴板" duration:2 position:CSToastPositionCenter];
}


- (void)formRowDescriptorValueHasChanged:(XLFormRowDescriptor *)formRow oldValue:(id)oldValue newValue:(id)newValue {
    
}

@end
