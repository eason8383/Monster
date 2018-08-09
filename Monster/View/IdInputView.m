//
//  IdInputView.m
//  Monster
//
//  Created by CHEN HAO LI on 2018/8/3.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import "IdInputView.h"

@interface IdInputView()

@property(nonatomic,strong)IBOutlet UILabel *id_label;

@end

@implementation IdInputView

- (void)awakeFromNib {
    [super awakeFromNib];
    [_id_label setText:LocalizeString(@"ID")];
    [self.id_Field setPlaceholder:LocalizeString(@"ICPLACEHOLDER")];
    
    [self.id_Field setValue:[UIColor colorWithWhite:1 alpha:0.3] forKeyPath:@"_placeholderLabel.textColor"];
    
    self.id_Field.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.4].CGColor;
    self.id_Field.layer.borderWidth = 1;
    self.id_Field.layer.cornerRadius = 4;
}

@end
