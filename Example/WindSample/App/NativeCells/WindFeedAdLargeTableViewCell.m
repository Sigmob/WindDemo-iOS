//
//  WindFeedAdLargeTableViewCell.m
//  WindDemo
//
//  Created by Codi on 2021/7/26.
//

#import "WindFeedAdLargeTableViewCell.h"
#import "FeedStyleHelper.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/SDWebImage.h>
#import "WindFeedAdViewStyle.h"


@implementation WindFeedAdLargeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = UIColor.clearColor;
        [self buildupView];
    }
    return self;
}

- (void)buildupView {
    [self.adView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.adView.superview).offset(0);
        make.height.mas_equalTo(0);
    }];
}

- (void)refreshUIWithModel:(WindNativeAd *)model rootViewController:(UIViewController *)viewController delegate:(id<WindNativeAdViewDelegate>)delegate {
    self.adView.delegate = delegate;
    [self.adView refreshData:model];
    self.adView.viewController = viewController;
    [WindFeedAdViewStyle layoutWithModel:model adView:self.adView];
}

@end


