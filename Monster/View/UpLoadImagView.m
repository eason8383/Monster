//
//  UpLoadImagView.m
//  Monster
//
//  Created by eason's macbook on 2018/7/6.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import "UpLoadImagView.h"
#import "AppDelegate.h"

@interface UpLoadImagView()


@property(nonatomic,strong)IBOutlet UILabel *uploadLabel;
@property(nonatomic,strong)IBOutlet UILabel *explainLabel;
@property(nonatomic,strong)IBOutlet UIView *backView;
@property(nonatomic,strong)IBOutlet UIImageView *uploadImagView;
@property(nonatomic,strong)IBOutlet UIActivityIndicatorView *loadingView;


@end

@implementation UpLoadImagView

- (void)awakeFromNib {
    [super awakeFromNib];
    [_uploadLabel setText:LocalizeString(@"UPLOADPIC")];
    _backView.layer.cornerRadius = 4;
}

- (void)setIdentityType:(IdentityType)idType{
    switch (idType) {
        case UpLoadID_Front:
            [_explainLabel setText:LocalizeString(@"UPLOADFORONT")];
            break;
            
        case UpLoadID_Back:
            [_explainLabel setText:LocalizeString(@"UPLOADBACK")];
            break;
        case UpLoadID_Hold:
            [_explainLabel setText:LocalizeString(@"UPLOADHANDID")];
            break;
        default:
            [_explainLabel setText:LocalizeString(@"UPLOADFORONT")];
            break;
    }
}

- (void)setImageUrl:(NSString*)urlStr{
    
    _uploadLabel.hidden = YES;
    _uploadImagView.hidden = YES;
    [_loadingView startAnimating];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *baseUrlStr = [[AppDelegate environment] isEqualToString:MREnvironment_TEST]?TEST_STATIC:PUBLIC_STATIC;
        NSURL *urlstring = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",baseUrlStr,urlStr]];
        UIImage *imag = [UIImage imageWithData:[NSData dataWithContentsOfURL:urlstring]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.loadingView stopAnimating];
            [self.picImgView setImage:imag];
        });
        
    });
}

- (void)resetUploadView{
    _uploadLabel.hidden = NO;
    _uploadImagView.hidden = NO;
    [self.picImgView setImage:[UIImage imageNamed:@""]];
}

@end
