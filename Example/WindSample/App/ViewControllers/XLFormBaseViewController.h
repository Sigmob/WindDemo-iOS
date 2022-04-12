//
//  XLFormBaseViewController.h
//  WindmillSample
//
//  Created by Codi on 2021/12/9.
//

#import <XLForm/XLForm.h>

@interface XLFormBaseViewController : XLFormViewController

- (void)clearRowState:(NSArray *)datasource;

- (void)updateFromRowDisableWithTag:(NSString *)tag error:(NSError *)error;

@end
