//
//  FeedNormalModel.m
//  WindDemo
//
//  Created by Codi on 2021/7/21.
//

#import "FeedNormalModel.h"
#import <UIKit/UIKit.h>

@implementation FeedNormalModel
- (float)cellHeight {
    if ([self.type isEqualToString: @"title"]) {
        _cellHeight = 100;
    }else if ([self.type isEqualToString: @"titleImg"]){
        _cellHeight = 130;
    }else if ([self.type isEqualToString: @"bigImg"]){
        _cellHeight = 100+[UIScreen mainScreen].bounds.size.width*0.6;
    }else if ([self.type isEqualToString: @"threeImgs"]){
        _cellHeight = 196;
    }else{
        _cellHeight = 0;
    }
    return _cellHeight;
}

- (NSString *)tableViewCellForClassName {
    if ([self.type isEqualToString: @"title"]) {
        return @"WindFeedNormalTitleTableViewCell";
    }else if ([self.type isEqualToString: @"titleImg"]){
        return @"WindFeedNormalTitleImgTableViewCell";
    }else if ([self.type isEqualToString: @"bigImg"]){
        return @"WindFeedNormalBigImgTableViewCell";
    }else if ([self.type isEqualToString: @"threeImgs"]){
        return @"WindFeedNormalthreeImgTableViewCell";
    }else{
        return @"unkownCell";
    }
}

- (NSString *)collectionViewCellForClassName {
    if ([self.type isEqualToString: @"title"]) {
        return @"WindFeedNormalTitleCollectionViewCell";
    }else if ([self.type isEqualToString: @"titleImg"]){
        return @"WindFeedNormalTitleImgCollectionViewCell";
    }else if ([self.type isEqualToString: @"bigImg"]){
        return @"WindFeedNormalBigImgCollectionViewCell";
    }else if ([self.type isEqualToString: @"threeImgs"]){
        return @"WindFeedNormalthreeImgCollectionViewCell";
    }else{
        return @"unkownCell";
    }
}



@end
