//
//  TWBUIFactory.m
//  Brews
//
//  Created by Kevin Whinnery on 5/28/13.
//  Copyright (c) 2013 Twilio Inc. All rights reserved.
//

#import "TWBUIFactory.h"

@implementation TWBUIFactory
+ (UIImage*)defaultButtonImage:(NSString*)color
{
    return [[UIImage imageNamed:[NSString stringWithFormat:@"%@Button.png", color]]
            resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
}

+ (UIImage*)highlightButtonImage:(NSString*)color
{
    return [[UIImage imageNamed:[NSString stringWithFormat:@"%@ButtonHighlight.png", color]]
            resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
}

#pragma mark Custom UI Decorators
+ (void)decorateButton:(UIButton*)btn forColor:(NSString*)color
{
    UIImage *buttonImage = [TWBUIFactory defaultButtonImage:color];
    UIImage *buttonImageHighlight = [TWBUIFactory highlightButtonImage:color];
    
    [btn setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [btn setBackgroundImage:buttonImageHighlight forState:UIControlStateHighlighted];
}

+ (void)decorateGrayButton:(UIButton*)btn
{
    [TWBUIFactory decorateButton:btn forColor:@"grey"];
}

+ (void)decorateWhiteButton:(UIButton*)btn
{
    [TWBUIFactory decorateButton:btn forColor:@"white"];
}

+ (void)decorateBlackButton:(UIButton*)btn
{
    [TWBUIFactory decorateButton:btn forColor:@"black"];
}

+ (void)decorateOrangeButton:(UIButton*)btn
{
    [TWBUIFactory decorateButton:btn forColor:@"orange"];
}

+ (void)decorateWithLinenBackground:(UIView *)view
{
    [view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"linen.png"]]];
}

#pragma mark Custom UI Builders
+ (UILabel*)headerLabel:(NSString*)header width:(int)width x:(int)x
{
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(x, 2, width, 44)];
    lbl.font = [UIFont fontWithName:@"ChunkFive" size:24];
    lbl.textColor = [UIColor whiteColor];
    lbl.adjustsFontSizeToFitWidth = YES;
    lbl.text = header;
    lbl.backgroundColor = [UIColor clearColor];
    
    return lbl;
}

+ (UIView*)headerView:(NSString*)header width:(int)width
{
    CGRect frame = CGRectMake(0, 0, width, 44);
    UIView *v = [[UIView alloc] initWithFrame:frame];
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, width, 32)];
    [v addSubview:lbl];
    [lbl setBackgroundColor:[UIColor clearColor]];
    [lbl setTextColor:[UIColor blackColor]];
    [lbl setTextAlignment:NSTextAlignmentCenter];
    [lbl setText:header];
    [lbl setFont:[UIFont fontWithName:@"ChunkFive" size:24]];
    
    return v;
}

#pragma mark String formatters
+ (NSString*)formatPhone:(NSString *)phone
{
    if ([phone length] == 10) {
        return [NSString stringWithFormat:@"(%@) %@-%@",[phone substringToIndex:3],[[phone substringFromIndex:3] substringToIndex:3], [phone substringFromIndex:6]];
    }
    else {
        return [NSString stringWithFormat:@"+%@", phone];
    }
}

#pragma mark Utilities
+ (UIColor*)colorForHex:(NSString*) hex {
    float red, green, blue, alpha;
    
    NSString *cleanString = [hex stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if([cleanString length] == 3) {
        cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                       [cleanString substringWithRange:NSMakeRange(0, 1)],
                       [cleanString substringWithRange:NSMakeRange(0, 1)],
                       [cleanString substringWithRange:NSMakeRange(1, 1)],
                       [cleanString substringWithRange:NSMakeRange(1, 1)],
                       [cleanString substringWithRange:NSMakeRange(2, 1)],
                       [cleanString substringWithRange:NSMakeRange(2, 1)]];
    }
    if([cleanString length] == 6) {
        cleanString = [cleanString stringByAppendingString:@"ff"];
    }
    
    unsigned int baseValue;
    [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];
    
    red = ((baseValue >> 24) & 0xFF)/255.0f;
    green = ((baseValue >> 16) & 0xFF)/255.0f;
    blue = ((baseValue >> 8) & 0xFF)/255.0f;
    alpha = ((baseValue >> 0) & 0xFF)/255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+ (void)alert:(NSString *)header detail:(NSString *)detail
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:header
                                                    message:detail
                                                   delegate:nil
                                          cancelButtonTitle: @"OK"
                                          otherButtonTitles: nil];
    [alert show];
}

// String just numbers out of phone number
+(NSString*)numberFromString:(NSString *)input
{
    return [input stringByReplacingOccurrencesOfString:@"[^0-9]"
                                            withString:@""
                                               options:NSRegularExpressionSearch
                                                 range:NSMakeRange(0, [input length])];
}

@end
