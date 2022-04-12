//
//  WindmillDropdownListView.h
//  WindmillSample
//
//  Created by Codi on 2021/12/6.
//

#import <UIKit/UIKit.h>

@interface DropdownListItem : NSObject
@property (nonatomic, copy, readonly) NSString *itemId;
@property (nonatomic, copy, readonly) NSString *itemName;

- (instancetype)initWithItem:(NSString*)itemId itemName:(NSString*)itemName;
@end


@class WindmillDropdownListView;

typedef void (^WindmillDropdownListViewSelectedBlock)(WindmillDropdownListView *dropdownListView);

@interface WindmillDropdownListView : UIView
// 字体颜色，默认 blackColor
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) NSString *placeholder;
// 字体默认14
@property (nonatomic, strong) UIFont *font;
// 数据源
@property (nonatomic, strong) NSArray *dataSource;
// 默认选中第一个
@property (nonatomic, assign) NSUInteger selectedIndex;
// 当前选中的DropdownListItem
@property (nonatomic, strong, readonly) DropdownListItem *selectedItem;


- (instancetype)initWithDataSource:(NSArray*)dataSource;

- (void)setViewBorder:(CGFloat)width borderColor:(UIColor*)borderColor cornerRadius:(CGFloat)cornerRadius;

- (void)setDropdownListViewSelectedBlock:(WindmillDropdownListViewSelectedBlock)block;
@end
