//
//  XLFormDropdownCell.h
//  WindmillSample
//
//  Created by Codi on 2021/12/7.
//

#import <XLForm/XLForm.h>
#import "WindmillDropdownListView.h"

NS_ASSUME_NONNULL_BEGIN

extern NSString * const XLFormRowDescriptorTypeDropdown;

@interface XLFormDropdownCell : XLFormBaseCell
@property (weak, nonatomic) IBOutlet UILabel *dropdownTitle;
@property (weak, nonatomic) IBOutlet WindmillDropdownListView *dropdownView;

@end

NS_ASSUME_NONNULL_END
