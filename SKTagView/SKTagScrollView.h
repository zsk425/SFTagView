//
//  SKTagScrollView.h
//  SKTagView
//
//  Created by LIYINGPENG on 15/10/29.
//  Copyright © 2015年 shiweifu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKTag.h"
@class SKTagView;
@interface SKTagScrollView : UIScrollView
@property (nonatomic, strong, readonly) SKTagView *tagView;

- (instancetype) initWithTagView:(SKTagView*) tagView;
@end
