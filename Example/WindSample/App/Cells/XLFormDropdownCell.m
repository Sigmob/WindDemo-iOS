//
//  XLFormDropdownCell.m
//  WindmillSample
//
//  Created by Codi on 2021/12/7.
//

#import "XLFormDropdownCell.h"
#import <Masonry/Masonry.h>

NSString * const XLFormRowDescriptorTypeDropdown = @"XLFormRowDescriptorTypeDropdown";

@implementation XLFormDropdownCell

+ (void)load {
    [XLFormViewController.cellClassesForRowDescriptorTypes setObject:[XLFormDropdownCell class] forKey:XLFormRowDescriptorTypeDropdown];
}

- (void)configure {
    [super configure];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _dropdownView.placeholder = @"下拉选择广告网络";
    [_dropdownView setViewBorder:1 borderColor:[UIColor grayColor] cornerRadius:2];
    __weak typeof(self) weakSelf = self;
    [_dropdownView setDropdownListViewSelectedBlock:^(WindmillDropdownListView *dropdownListView) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.rowDescriptor.value = strongSelf.dropdownView.selectedItem;
    }];
}

- (void)update {
    [super update];
    self.dropdownTitle.text = self.rowDescriptor.title;
    NSArray *datasource = self.rowDescriptor.selectorOptions;
    self.dropdownView.dataSource = datasource;
    self.rowDescriptor.value = self.dropdownView.selectedItem;
}


@end
