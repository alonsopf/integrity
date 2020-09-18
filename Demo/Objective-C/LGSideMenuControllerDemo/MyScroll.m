//
//  MyScroll.m
//  Integrity
//
//  Created by Fernando Alonso Pecina on 31/05/17.
//  Copyright © 2017 Grigory Lutkov. All rights reserved.
//

#import "MyScroll.h"

@implementation MyScroll

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
//- (BOOL)touchesShouldCancelInContentView:(UIView *)view {return NO;}
- (BOOL)touchesShouldCancelInContentView:(UIView *)view
{
    return ![view isKindOfClass:[UIButton class]];
}
@end
