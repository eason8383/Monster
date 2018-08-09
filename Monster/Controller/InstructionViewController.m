//
//  InstructionViewController.m
//  Monster
//
//  Created by CHEN HAO LI on 2018/7/24.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import "InstructionViewController.h"

@interface InstructionViewController ()
@property (nonatomic,strong)IBOutlet UITextView *textView;

@end

@implementation InstructionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithHexString:@"1E222C"]];
    self.navigationController.navigationBar.translucent = NO;
    
    if ([self.nowCoin isEqualToString:@"MON"]) {
        [self.textView setText:LocalizeString(@"MONINFORMATION")];
    } else {
        [self.textView setText:LocalizeString(@"MRINFORMATION")];
    }
}

- (void)viewDidLayoutSubviews {
    [self.textView setContentOffset:CGPointZero animated:NO];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [_textView setContentOffset:CGPointMake(0, 0) animated:YES];
//    
//    CGPoint offset = self.textView.contentOffset;
//    self.textView.attributedText = replace;
//    [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
//        [self.textView setContentOffset: offset];
//    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
