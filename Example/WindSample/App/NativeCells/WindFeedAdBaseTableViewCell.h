//
//  WindFeedAdBaseTableViewCell.h
//  WindDemo
//
//  Created by Codi on 2021/7/26.
//

#import <UIKit/UIKit.h>
#import "NativeAdCustomView.h"
#import <WindSDK/WindSDK.h>


static CGFloat const margin = 15;
static CGSize const logoSize = {15, 15};
static UIEdgeInsets const padding = {10, 15, 10, 15};


@protocol WindFeedCellProtocol <NSObject>

@optional

- (void)refreshUIWithModel:(WindNativeAd *)model rootViewController:(UIViewController *)viewController delegate:(id<WindNativeAdViewDelegate>)delegate;

+ (CGFloat)cellHeightWithModel:(WindNativeAd *)model width:(CGFloat)width;

@end


@interface WindFeedAdBaseTableViewCell : UITableViewCell<WindFeedCellProtocol>
@property (nonatomic, strong) NativeAdCustomView *adView;
@end
