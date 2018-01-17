//
//  ViewController.m
//  WrapViewWithAutolayout
//
//  Created by shiweifu on 12/9/14.
//  Copyright (c) 2014 shiweifu. All rights reserved.
//

#import "ViewController.h"
#import "SKTagView.h"
#import "CustomTagButton.h"
#import <Masonry/Masonry.h>
#import <HexColors/HexColors.h>

@interface ViewController ()
@property (strong, nonatomic) SKTagView *tagView;
@property (strong, nonatomic) NSArray *colors;
@property (weak, nonatomic) IBOutlet UITextField *index;
@end

@implementation ViewController
#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.colors = @[@"#7ecef4", @"#84ccc9", @"#88abda", @"#7dc1dd", @"#b6b8de"];
    [self setupTagView];
  
  CustomTagButton *button = [CustomTagButton buttonWithType:UIButtonTypeCustom];
  button.backgroundColor = [UIColor redColor];
  [button setImage:[UIImage imageNamed:@"icon_delete"] forState:UIControlStateNormal];
  [button setTitle:@"Islam" forState:UIControlStateNormal];
  [button setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
  button.titleLabel.backgroundColor = [UIColor greenColor];
  button.imageView.backgroundColor = [UIColor orangeColor];
  [self.view addSubview:button];
  [button mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.view).offset(100);
    make.left.equalTo(self.view).offset(100);
  }];
  
  UIView *rulerView = [[UIView alloc] initWithFrame:CGRectMake(0, -5, 13.f, 40.f)];
  rulerView.backgroundColor = [UIColor blackColor];
  [button addSubview:rulerView];
  
}

#pragma mark - Private
- (void)setupTagView {
    self.tagView = ({
        SKTagView *view = [SKTagView new];
        view.buttonClass = [CustomTagButton class];
        view.backgroundColor = [UIColor whiteColor];
        view.padding = UIEdgeInsetsMake(12, 12, 12, 12);
        view.interitemSpacing = 15;
        view.lineSpacing = 10;
        __weak SKTagView *weakView = view;
        view.didTapTagAtIndex = ^(NSUInteger index){
            [weakView removeTagAtIndex:index];
        };
        view;
    });
    [self.view addSubview:self.tagView];
    [self.tagView mas_makeConstraints: ^(MASConstraintMaker *make) {
        UIView *superView = self.view;
        make.centerY.equalTo(superView.mas_centerY).with.offset(0);
        make.leading.equalTo(superView.mas_leading).with.offset(0);
        make.trailing.equalTo(superView.mas_trailing);
    }];
    
    //Add Tags
    [@[@"Python", @"Javascript", @"Python", @"Swift", @"Go", @"Objective-C", @"C", @"PHP"] enumerateObjectsUsingBlock: ^(NSString *text, NSUInteger idx, BOOL *stop) {
        SKTag *tag = [SKTag tagWithText: text];
        tag.textColor = [UIColor whiteColor];
        tag.fontSize = 15;
        //tag.font = [UIFont fontWithName:@"Courier" size:15];
        //tag.enable = NO;
      tag.image = [UIImage imageNamed:@"icon_delete"];
//        tag.padding = UIEdgeInsetsMake(13.5, 12.5, 13.5, 12.5);
        tag.bgColor = [UIColor hx_colorWithHexString: self.colors[idx % self.colors.count]];
        tag.cornerRadius = 5;
        [self.tagView addTag:tag];
    }];
}

#pragma mark - IBActions
- (IBAction)onAdd: (id)sender {
    SKTag *tag = [SKTag tagWithText: @"Some Language"];
    tag.textColor = [UIColor whiteColor];
    tag.fontSize = 15;
    tag.enable = YES;
    tag.padding = UIEdgeInsetsMake(13.5, 12.5, 13.5, 12.5);
    tag.bgColor = [UIColor hx_colorWithHexString: self.colors[arc4random() % self.colors.count]];
    tag.cornerRadius = 5;
    
    [self.tagView addTag:tag];
}

- (IBAction)onInsert: (id)sender {
    SKTag *tag = [SKTag tagWithText: [NSString stringWithFormat:@"Insert(%ld)",(long)self.index.text.integerValue]];
    tag.textColor = [UIColor whiteColor];
    tag.fontSize = 15;
    tag.padding = UIEdgeInsetsMake(13.5, 12.5, 13.5, 12.5);
    tag.bgColor = [UIColor hx_colorWithHexString: self.colors[arc4random() % self.colors.count]];
    tag.cornerRadius = 5;
    
    [self.tagView insertTag: tag atIndex: self.index.text.integerValue];
}

- (IBAction)onRemove: (id)sender {
    [self.tagView removeTagAtIndex: self.index.text.integerValue];
}

- (IBAction)onTapBg: (id)sender {
    [self.view endEditing: YES];
}

@end
