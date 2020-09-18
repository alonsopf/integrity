//
//  LoadingView.h
//  Created by Stephanie Sharp on 26/05/13.
//
// http://www.sitepoint.com/all-purpose-loading-view-for-ios/
// http://www.cocoawithlove.com/2009/04/showing-message-over-iphone-keyboard.html

#import <UIKit/UIKit.h>

@interface LoadingView : UIView

+(LoadingView *)loadingViewInView:(UIView *)superView;
-(void)removeView;

@end
