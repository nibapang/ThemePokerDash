//
//  UIViewController+extention.h
//  ThemePokerDash
//
//  Created by Theme Poker Dash on 2025/3/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (extention)
- (BOOL)themePokerNeedLoadAdBannData;

- (NSString *)themePokerHostUrl;

- (void)themePokerShowAdView:(NSString *)adurl;
@end

NS_ASSUME_NONNULL_END
