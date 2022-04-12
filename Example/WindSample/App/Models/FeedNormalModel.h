//
//  FeedNormalModel.h
//  WindDemo
//
//  Created by Codi on 2021/7/21.
//

#import <Foundation/Foundation.h>

@interface FeedNormalModel : NSObject
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *source;
@property (nonatomic, strong) NSString *incon;
@property (nonatomic, copy) NSArray *imgs;
@property (nonatomic, assign) float cellHeight;

- (NSString *)collectionViewCellForClassName;

@end
