//
//  FeedAdViewStyle.h
//  WindDemo
//
//  Created by Codi on 2021/8/23.
//

#import <Foundation/Foundation.h>

@class WindNativeAd;
@class NativeAdCustomView;


@interface WindFeedAdViewStyle : NSObject

+ (void)layoutWithModel:(WindNativeAd *)nativeAd adView:(NativeAdCustomView *)adView;

+ (CGFloat)cellHeightWithModel:(WindNativeAd *)model width:(CGFloat)width;

@end
