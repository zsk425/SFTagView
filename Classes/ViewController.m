//
//  ViewController.m
//  WrapViewWithAutolayout
//
//  Created by shiweifu on 12/9/14.
//  Copyright (c) 2014 shiweifu. All rights reserved.
//

#import "ViewController.h"
#import "SKTagView.h"
#import <Masonry/Masonry.h>
#import <HexColors/HexColor.h>
#import "SKTagScrollView.h"

@interface ViewController ()
@property (strong, nonatomic) SKTagView *tagView;
@property (nonatomic, strong) NSArray *colorPool;

@property (weak, nonatomic) IBOutlet UITextField *index;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.colorPool = @[@"#7ecef4", @"#84ccc9", @"#88abda",@"#7dc1dd",@"#b6b8de"];
    
    [self setupTagView];
}

- (void)setupTagView
{
    self.tagView = ({
        SKTagView *view = [SKTagView new];
        view.backgroundColor = UIColor.whiteColor;
        view.padding    = UIEdgeInsetsMake(12, 12, 12, 12);
        view.insets    = 15;
        view.lineSpace = 10;
//        view.singleLine = YES;
        __weak SKTagView *weakView = view;
        view.didClickTagAtIndex = ^(NSUInteger index){
            //Remove tag
            [weakView removeTagAtIndex:index];
        };
        view;
    });
    SKTagScrollView *scrollView = ({
        
        SKTagScrollView *view = [[SKTagScrollView alloc] initWithTagView:self.tagView];
        view.backgroundColor = [UIColor greenColor];
        view;
    });
    
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        UIView *superView = self.view;
        make.centerY.equalTo(superView.mas_centerY).with.offset(0);
        make.leading.equalTo(superView.mas_leading).with.offset(0);
        make.trailing.equalTo(superView.mas_trailing);
        make.height.equalTo(@99);
    }];
    
    //Add Tags
    [@[@"Python", @"Javascript", @"Python", @"HTML", @"Go", @"Objective-C",@"C", @"PHP"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
     {
         SKTag *tag = [SKTag tagWithText:obj];
         tag.textColor = [UIColor whiteColor];
         tag.fontSize = 15;
         //tag.font = [UIFont fontWithName:@"Courier" size:15];
         tag.padding = UIEdgeInsetsMake(13.5, 12.5, 13.5, 12.5);
         tag.bgColor = [UIColor colorWithHexString:self.colorPool[idx % self.colorPool.count]];
         tag.cornerRadius = 5;
         
         [self.tagView addTag:tag];
     }];
}

#pragma mark - User interactions
- (IBAction)onAdd:(id)sender
{
    SKTag *tag = [SKTag tagWithText:@"New Lang"];
    tag.textColor = [UIColor whiteColor];
    tag.fontSize = 15;
    tag.padding = UIEdgeInsetsMake(13.5, 12.5, 13.5, 12.5);
    tag.bgColor = [UIColor colorWithHexString:self.colorPool[arc4random() % self.colorPool.count]];
    tag.cornerRadius = 5;
    
    [self.tagView addTag:tag];
}

- (IBAction)onInsert:(id)sender
{
    SKTag *tag = [SKTag tagWithText:[NSString stringWithFormat:@"Insert(%ld)",(long)self.index.text.integerValue]];
    tag.textColor = [UIColor whiteColor];
    tag.fontSize = 15;
    tag.padding = UIEdgeInsetsMake(13.5, 12.5, 13.5, 12.5);
    tag.bgColor = [UIColor colorWithHexString:self.colorPool[arc4random() % self.colorPool.count]];
    tag.cornerRadius = 5;
    
    [self.tagView insertTag:tag atIndex:self.index.text.integerValue];
}

- (IBAction)onRemove:(id)sender
{
    [self.tagView removeTagAtIndex:self.index.text.integerValue];
}

- (IBAction)onRemoveAll:(id)sender
{
    [self.tagView removeAllTags];
}

- (IBAction)onTapBg:(id)sender
{
    [self.view endEditing:YES];
}

@end
