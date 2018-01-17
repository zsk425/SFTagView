//
//  CustomTagButton.m
//  SKTagView
//
//  Created by zhangchong on 2018/1/17.
//  Copyright © 2018年 shiweifu. All rights reserved.
//

#import "CustomTagButton.h"
#import "SKTag.h"

static const CGFloat kLeftOffsetOfImageToTitle = 8.f;
static const CGFloat kLeftOffsetOfTitleToButton = 13.f;
static const CGFloat kRightOffsetOfTitleToButton = 35.f;

@implementation CustomTagButton

+ (nonnull instancetype)buttonWithTag: (nonnull SKTag *)tag {
  CustomTagButton *btn = [super buttonWithType:UIButtonTypeCustom];
  
  if (tag.attributedText) {
    [btn setAttributedTitle: tag.attributedText forState: UIControlStateNormal];
  } else {
    [btn setTitle: tag.text forState:UIControlStateNormal];
    [btn setImage: tag.image forState:UIControlStateNormal];
    [btn setTitleColor: tag.textColor forState: UIControlStateNormal];
    btn.titleLabel.font = tag.font ?: [UIFont systemFontOfSize: tag.fontSize];
  }
  
  btn.backgroundColor = tag.bgColor;
  btn.contentEdgeInsets = tag.padding;
  btn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
  
  if (tag.bgImg) {
    [btn setBackgroundImage: tag.bgImg forState: UIControlStateNormal];
  }
  
  if (tag.borderColor) {
    btn.layer.borderColor = tag.borderColor.CGColor;
  }
  
  if (tag.borderWidth) {
    btn.layer.borderWidth = tag.borderWidth;
  }
  
  btn.userInteractionEnabled = tag.enable;
  if (tag.enable) {
    UIColor *highlightedBgColor = tag.highlightedBgColor ?: [self darkerColor:btn.backgroundColor];
    [btn setBackgroundImage:[self imageWithColor:highlightedBgColor] forState:UIControlStateHighlighted];
  }
  
  btn.layer.cornerRadius = tag.cornerRadius;
  btn.layer.masksToBounds = YES;
  
  return btn;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  
  if (self.imageView) {
//    NSLog(@"imageEdgeInsets: %@", NSStringFromUIEdgeInsets(self.imageEdgeInsets));
//    NSLog(@"titleEdgeInsets: %@", NSStringFromUIEdgeInsets(self.titleEdgeInsets));
    
    self.imageEdgeInsets = UIEdgeInsetsMake(0, (self.titleLabel.frame.size.width + kLeftOffsetOfImageToTitle),
                                            0, -(self.titleLabel.frame.size.width + kLeftOffsetOfImageToTitle));
    self.titleEdgeInsets = UIEdgeInsetsMake(0, -(self.imageView.frame.size.width), 0,
                                            self.imageView.frame.size.width);
    
  }
  
  NSLog(@"line:[%@] bounds:[%@] titleFrame:[%@] imageFrame:[%@]",
        @(__LINE__),
        NSStringFromCGRect(self.bounds),
        NSStringFromCGRect(self.titleLabel.frame),
        NSStringFromCGRect(self.imageView.frame));
}

- (CGSize)intrinsicContentSize {
  CGSize titleSize = [self.titleLabel intrinsicContentSize];
  CGSize imageSize = [self.imageView intrinsicContentSize];
  NSLog(@"line:[%@] titleSize:[%@], imageSize:[%@]",
        @(__LINE__),
        NSStringFromCGSize(titleSize),
        NSStringFromCGSize(imageSize));
  CGSize size = CGSizeMake(kLeftOffsetOfTitleToButton + titleSize.width + kRightOffsetOfTitleToButton, 32);
  return size;
}

@end
