//
//  WindHelper.h
//  WindmillSample
//
//  Created by Codi on 2021/12/7.
//

#import <Foundation/Foundation.h>
#import "ChannelItem.h"

@class XLFormSectionDescriptor;

static NSString * const kAdDidLoad = @"kAdDidLoad";
static NSString * const kAdDidLoadError = @"kAdDidLoadError";
static NSString * const kAdWillVisible = @"kAdWillVisible";
static NSString * const kAdDidVisible = @"kAdDidVisible";
static NSString * const kAdDetailViewVisible = @"kAdDetailViewVisible";
static NSString * const kAdDetailViewClose = @"kAdDetailViewClose";
static NSString * const kAdDidRenderSuccess = @"kAdDidRenderSuccess";
static NSString * const kAdDidRenderError = @"kAdDidRenderError";
static NSString * const kAdDislike = @"kAdDislike";
static NSString * const kAdDidClick = @"kAdDidClick";
static NSString * const kAdDidSkip = @"kAdDidSkip";
static NSString * const kAdDidReward = @"kAdDidReward";
static NSString * const kAdWillClose = @"kAdWillClose";
static NSString * const kAdDidClose = @"kAdDidClose";
static NSString * const kAdServerResponse = @"AdServerResponse";
static NSString * const kAdDidPlayFinish = @"kAdDidPlayFinish";
static NSString * const kAdDidPlayStateChange = @"kAdDidPlayStateChange";

@interface WindHelper : NSObject

+ (XLFormSectionDescriptor *)getCallbackRows:(NSArray *)datasource;

@end
