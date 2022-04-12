//
//  FeedStyleHelper.h
//  WindDemo
//
//  Created by Codi on 2021/7/21.
//

#import <Foundation/Foundation.h>

@interface FeedStyleHelper : NSObject

+ (NSAttributedString *)titleAttributeText:(NSString *)text;
+ (NSAttributedString *)subtitleAttributeText:(NSString *)text;
+ (NSAttributedString *)infoAttributeText:(NSString *)text;

@end
