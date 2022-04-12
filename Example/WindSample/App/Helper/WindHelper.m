//
//  WindHelper.m
//  WindmillSample
//
//  Created by Codi on 2021/12/7.
//

#import "WindHelper.h"
#import <MJExtension/MJExtension.h>
#import <XLForm/XLForm.h>
#import "WindmillDropdownListView.h"

@implementation WindHelper
+ (XLFormSectionDescriptor *)getCallbackRows:(NSArray *)datasource {
    XLFormSectionDescriptor *section = [XLFormSectionDescriptor formSectionWithTitle:@"Dropdown"];
    section.title = @"广告回调信息";
    for (NSDictionary *item in datasource) {
        NSString *rowType = [item objectForKey:@"rowType"];
        XLFormRowDescriptor *row = [XLFormRowDescriptor formRowDescriptorWithTag:item[@"tag"] rowType:rowType?rowType:XLFormRowDescriptorTypeInfo];
        row.title = [item objectForKey:@"title"];
        row.disabled = @YES;
        [section addFormRow:row];
    }
    return section;
}

@end
