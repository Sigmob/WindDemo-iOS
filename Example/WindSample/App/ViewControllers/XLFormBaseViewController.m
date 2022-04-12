//
//  XLFormBaseViewController.m
//  WindmillSample
//
//  Created by Codi on 2021/12/9.
//

#import "XLFormBaseViewController.h"
#import "WindmillDropdownListView.h"


@interface XLFormBaseViewController ()

@end

@implementation XLFormBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)updateFromRowDisableWithTag:(NSString *)tag error:(NSError *)error {
    XLFormRowDescriptor *row = [self.form formRowWithTag:tag];
    row.disabled = @NO;
    if (error) {
        NSString *code = [NSString stringWithFormat:@"code: %ld", (long)error.code];
        NSString *msg = [NSString stringWithFormat:@"message: %@", error.localizedDescription];
        row.selectorOptions = @[code, msg];
    }else {
        row.selectorOptions = @[@"error = nil"];
    }
    [self updateFormRow:row];
}

- (void)clearRowState:(NSArray *)datasource {
    for (NSDictionary *item in datasource) {
        XLFormRowDescriptor *row = [self.form formRowWithTag:item[@"tag"]];
        row.disabled = @YES;
        [self updateFormRow:row];
    }
}


@end
