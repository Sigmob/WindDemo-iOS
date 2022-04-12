
#import "XLFormSliderValueCell.h"
#import "UIView+XLFormAdditions.h"

NSString *const XLFormRowDescriptorTypeSliderValue = @"XLFormRowDescriptorTypeSliderValue";

@interface XLFormSliderValueCell ()

@property (nonatomic) UISlider * slider;
@property (nonatomic) UILabel * textLabel;
@property (nonatomic) UILabel * subTextLabel;
@property NSUInteger steps;

@end

@implementation XLFormSliderValueCell

@synthesize textLabel = _textLabel;


+ (void)load {
    [XLFormViewController.cellClassesForRowDescriptorTypes setObject:[XLFormSliderValueCell class] forKey:XLFormRowDescriptorTypeSliderValue];
}

- (void)configure
{
	self.steps = 0;
	[self.slider addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
	[self.contentView addSubview:self.slider];
	[self.contentView addSubview:self.textLabel];
    [self.contentView addSubview:self.subTextLabel];
    	self.selectionStyle = UITableViewCellSelectionStyleNone;
	[self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:10]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.subTextLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:10]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.subTextLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1 constant:-15]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.subTextLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.textLabel attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
    
	[self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.slider attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:44]];
	[self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[textLabel]-|" options:0 metrics:0 views:@{@"textLabel": self.textLabel}]];
	[self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[slider]-|" options:0 metrics:0 views:@{@"slider": self.slider}]];
	[self valueChanged:nil];
}

-(void)update {
	
    [super update];
    self.textLabel.text = self.rowDescriptor.title;
    self.slider.value = [self.rowDescriptor.value floatValue];
    self.slider.enabled = !self.rowDescriptor.isDisabled;
    self.subTextLabel.text = [self.rowDescriptor.value stringValue];
    [self valueChanged:nil];
}

-(void)valueChanged:(UISlider*)_slider {
	if(self.steps != 0) {
		self.slider.value = roundf((self.slider.value-self.slider.minimumValue)/(self.slider.maximumValue-self.slider.minimumValue)*self.steps)*(self.slider.maximumValue-self.slider.minimumValue)/self.steps + self.slider.minimumValue;
	}
	self.rowDescriptor.value = @(self.slider.value);
    self.subTextLabel.text = [NSString stringWithFormat:@"%d", [self.rowDescriptor.value intValue]];
}

+(CGFloat)formDescriptorCellHeightForRowDescriptor:(XLFormRowDescriptor *)rowDescriptor {
	return 88;
}


-(UILabel *)textLabel
{
    if (_textLabel) return _textLabel;
    _textLabel = [UILabel autolayoutView];
    return _textLabel;
}

- (UILabel *)subTextLabel {
    if (_subTextLabel) return _subTextLabel;
    _subTextLabel = [UILabel autolayoutView];
    _subTextLabel.textColor = UIColor.grayColor;
    return _subTextLabel;
}

-(UISlider *)slider
{
    if (_slider) return _slider;
    _slider = [UISlider autolayoutView];
    return _slider;
}

@end
