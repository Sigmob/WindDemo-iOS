//
//  WindFeedNormalTableViewCell.h
//  WindDemo
//
//  Created by Codi on 2021/7/21.
//

#import <UIKit/UIKit.h>
#import "FeedNormalModel.h"

@interface WindFeedNormalTableViewCell : UITableViewCell

@property (nonatomic, strong) FeedNormalModel * model;
@property (nonatomic, strong) UIView *separatorLine;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *inconLable;
@property (nonatomic, strong) UILabel *sourceLable;
@property (nonatomic, strong) UIImageView *closeIncon;
@property (nonatomic, strong) UIView *backView;

- (void)refreshUIWithModel:(FeedNormalModel *)model;

@end

@interface WindFeedNormalTitleTableViewCell : WindFeedNormalTableViewCell

@end

@interface WindFeedNormalTitleImgTableViewCell : WindFeedNormalTableViewCell
@property (nonatomic, strong) UIImageView *img;
@end

@interface WindFeedNormalBigImgTableViewCell : WindFeedNormalTableViewCell
@property (nonatomic, strong) UIImageView *bigImg;
@end

@interface WindFeedNormalthreeImgTableViewCell : WindFeedNormalTableViewCell
@property (nonatomic, strong) UIImageView *img1;
@property (nonatomic, strong) UIImageView *img2;
@property (nonatomic, strong) UIImageView *img3;
@end
