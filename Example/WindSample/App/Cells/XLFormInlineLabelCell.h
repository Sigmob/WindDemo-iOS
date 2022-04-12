//
//  XLFormInlineLabelCell.h
//  WindmillSample
//
//  Created by Codi on 2021/12/8.
//

#import <XLForm/XLForm.h>

extern NSString * const XLFormRowDescriptorTypeLabelInline;

@interface XLFormInlineLabelCell : XLFormBaseCell

@end


@interface XLFormInlineLabelControl : XLFormBaseCell<XLFormInlineRowDescriptorCell>

@property (strong, nonatomic) UILabel* descLabel;

@end
