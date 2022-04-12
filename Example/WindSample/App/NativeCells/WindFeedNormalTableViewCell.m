//
//  WindFeedNormalTableViewCell.m
//  WindDemo
//
//  Created by Codi on 2021/7/21.
//

#import "WindFeedNormalTableViewCell.h"
#import "FeedStyleHelper.h"
#import <Masonry.h>

#define GlobleHeight (self.contentView.frame.size.height)
#define GlobleWidth (self.contentView.frame.size.width)
#define imgBgColor Wind_RGB(0xf0, 0xf0, 0xf0)
#define edge 15

@implementation WindFeedNormalTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self buildupView];
    }
    return self;
}
- (void)buildupView {
    _backView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_backView];
    [_backView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.contentView).offset(0);
        make.height.mas_equalTo(0);
    }];
    
    
    _separatorLine = [[UIView alloc] initWithFrame:CGRectMake(edge, 0, GlobleWidth-edge*2, 0.5)];
    _separatorLine.backgroundColor = Wind_RGB(0xd9, 0xd9, 0xd9);
    [self.backView addSubview:_separatorLine];
    
    _titleLabel = [UILabel new];
    _titleLabel.numberOfLines = 2;
    _titleLabel.font = [UIFont systemFontOfSize:18];
    _titleLabel.textColor = [UIColor blackColor];
    [self.backView addSubview:_titleLabel];
    
    _sourceLable = [[UILabel alloc] init];
    _sourceLable.font = [UIFont systemFontOfSize:12];
    _sourceLable.textColor = [UIColor blackColor];
    [self.backView addSubview:_sourceLable];
    
    _inconLable = [[UILabel alloc] init];
    _inconLable.font = [UIFont systemFontOfSize:10];
    _inconLable.textColor = [UIColor redColor];
    _inconLable.textAlignment = NSTextAlignmentCenter;
    _inconLable.clipsToBounds = YES;
    _inconLable.layer.cornerRadius = 3;
    _inconLable.layer.borderWidth = 0.5;
    _inconLable.layer.borderColor = [UIColor redColor].CGColor;
    [self.backView addSubview:_inconLable];
    
    _closeIncon = [[UIImageView alloc] init];
    [_closeIncon setImage:[UIImage imageNamed:@"feedClose.png"]];
    [self.backView addSubview:_closeIncon];
}

- (void)refreshUIWithModel:(FeedNormalModel *)model {
    self.model = model;
    _titleLabel.attributedText = [FeedStyleHelper titleAttributeText:model.title];
    _sourceLable.attributedText = [FeedStyleHelper subtitleAttributeText:model.source];
    _inconLable.text = model.incon;
    
    _inconLable.frame = CGRectMake(edge, model.cellHeight - 12 - edge, 27, 14);
    if (model.incon && model.incon.length!=0) {
        _inconLable.hidden = NO;
        _sourceLable.frame = CGRectMake(self.inconLable.frame.origin.x+self.inconLable.frame.size.width + edge, self.inconLable.frame.origin.y+1, 200, 12);
    }else{
        _inconLable.hidden = YES;
        _sourceLable.frame = CGRectMake(edge, self.inconLable.frame.origin.y, 200, 12);
    }
    _closeIncon.frame = CGRectMake(GlobleWidth - 10 - edge, model.cellHeight - 10 - edge, 10, 10);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.separatorLine.frame = CGRectMake(edge, 0, GlobleWidth-edge*2, 0.5);
    self.closeIncon.frame = CGRectMake(GlobleWidth - 10 - edge,GlobleHeight - 10 - edge, 10, 10);
}



@end



@implementation WindFeedNormalTitleTableViewCell
- (void)buildupView {
    [super buildupView];
    self.titleLabel.frame = CGRectMake(edge, edge, GlobleWidth-edge*2, 50);
}

-(void)refreshUIWithModel:(FeedNormalModel *)model {
    [super refreshUIWithModel:model];
    [self.backView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.contentView).offset(0);
        make.height.mas_equalTo(100);
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.titleLabel.frame = CGRectMake(edge, edge, GlobleWidth-edge*2, 50);
}
@end

@implementation WindFeedNormalTitleImgTableViewCell
- (void)buildupView {
    [super buildupView];
    self.img = [[UIImageView alloc] initWithFrame:CGRectMake(GlobleWidth-edge-120, edge, 120, 80)];
    self.img.backgroundColor = imgBgColor;
    [self.backView addSubview:self.img];
    self.titleLabel.frame = CGRectMake(edge, edge, GlobleWidth-120-edge*3, 50);
}

-(void)refreshUIWithModel:(FeedNormalModel *)model {
    [super refreshUIWithModel:model];
    [self.backView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.contentView).offset(0);
        make.height.mas_equalTo(130);
    }];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.img.frame = CGRectMake(GlobleWidth-edge-120, edge, 120, 80);
    self.titleLabel.frame = CGRectMake(edge, edge, GlobleWidth-120-edge*3, 50);
}
@end

@implementation WindFeedNormalBigImgTableViewCell
- (void)buildupView {
    [super buildupView];

    self.titleLabel.frame = CGRectMake(edge, edge, GlobleWidth-edge*2, 50);
    
    self.bigImg = [[UIImageView alloc] initWithFrame:CGRectMake(edge, self.titleLabel.frame.origin.y+self.titleLabel.frame.size.height + edge, GlobleWidth-edge*2, (GlobleWidth-edge*2)*0.6)];
    self.bigImg.backgroundColor = imgBgColor;
    [self.backView addSubview:self.bigImg];
}

-(void)refreshUIWithModel:(FeedNormalModel *)model {
    [super refreshUIWithModel:model];
    [self.backView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.contentView).offset(0);
        make.height.mas_equalTo(100+[UIScreen mainScreen].bounds.size.width*0.6);
    }];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.titleLabel.frame = CGRectMake(edge, edge, GlobleWidth-edge*2, 50);
    self.bigImg.frame = CGRectMake(edge, self.titleLabel.frame.origin.y+self.titleLabel.frame.size.height + edge, GlobleWidth-edge*2, (GlobleWidth-edge*2)*0.6);
}
@end

@implementation WindFeedNormalthreeImgTableViewCell
- (void)buildupView {
    [super buildupView];
    self.titleLabel.frame = CGRectMake(edge, edge, GlobleWidth-edge*2, 50);
    
    self.img1 = [[UIImageView alloc] initWithFrame:CGRectMake(edge, self.titleLabel.frame.origin.y+self.titleLabel.frame.size.height + edge, (GlobleWidth - edge*2-5-5)/3, 80)];
    self.img1.backgroundColor = imgBgColor;
    [self.backView addSubview:self.img1];
    
    self.img2 = [[UIImageView alloc] initWithFrame:CGRectMake(self.img1.frame.size.width+self.img1.frame.origin.x + 5, self.titleLabel.frame.origin.y+self.titleLabel.frame.size.height + edge, (GlobleWidth - edge*2-5-5)/3, 80)];
    self.img2.backgroundColor = imgBgColor;
    [self.backView addSubview:self.img2];
    
    self.img3 = [[UIImageView alloc] initWithFrame:CGRectMake(self.img2.frame.size.width+self.img2.frame.origin.x + 5, self.titleLabel.frame.origin.y+self.titleLabel.frame.size.height + edge, (GlobleWidth - edge*2-5-5)/3, 80)];
    self.img3.backgroundColor = imgBgColor;
    [self.backView addSubview:self.img3];
}

-(void)refreshUIWithModel:(FeedNormalModel *)model {
    [super refreshUIWithModel:model];
    [self.backView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.contentView).offset(0);
        make.height.mas_equalTo(196);
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.titleLabel.frame = CGRectMake(edge, edge, GlobleWidth-edge*2, 50);
    self.img1.frame = CGRectMake(edge, self.titleLabel.frame.origin.y+self.titleLabel.frame.size.height + edge, (GlobleWidth - edge*2-5-5)/3, 80);
    
    self.img2.frame = CGRectMake(self.img1.frame.size.width+self.img1.frame.origin.x + 5, self.titleLabel.frame.origin.y+self.titleLabel.frame.size.height + edge, (GlobleWidth - edge*2-5-5)/3, 80);
    
    self.img3.frame = CGRectMake(self.img2.frame.size.width+self.img2.frame.origin.x + 5, self.titleLabel.frame.origin.y+self.titleLabel.frame.size.height + edge, (GlobleWidth - edge*2-5-5)/3, 80);
}
@end
