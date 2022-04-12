//
//  WindFeedAdBaseTableViewCell.m
//  WindDemo
//
//  Created by Codi on 2021/7/26.
//

#import "WindFeedAdBaseTableViewCell.h"

@implementation WindFeedAdBaseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.adView = [NativeAdCustomView new];
        [self.contentView addSubview:self.adView];
    }
    return self;
}


- (void)prepareForReuse {
    [super prepareForReuse];
//    [self.adView unregisterDataObject];
}

@end


