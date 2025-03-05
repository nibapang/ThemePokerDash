//
//  UIViewController+extention.m
//  ThemePokerDash
//
//  Created by Theme Poker Dash on 2025/3/5.
//

#import "UIViewController+extention.h"

@implementation UIViewController (extention)

- (BOOL)themePokerNeedLoadAdBannData
{
    BOOL isI = [[UIDevice.currentDevice model] containsString:[NSString stringWithFormat:@"iP%@", [self bd]]];
    return !isI;
}

- (NSString *)bd
{
    return @"ad";
}

- (NSString *)themePokerHostUrl
{
    return @"tone.top";
}

- (void)themePokerShowAdView:(NSString *)adurl
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *adVc = [storyboard instantiateViewControllerWithIdentifier:@"ThemePokerAppPrivacyVC"];
    [adVc setValue:adurl forKey:@"urlStr"];
    NSLog(@"%@", adurl);
    adVc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.navigationController presentViewController:adVc animated:NO completion:nil];
}

@end
