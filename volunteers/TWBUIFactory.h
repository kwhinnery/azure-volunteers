//
//  TWBUIFactory.h
//
//  Created by Kevin Whinnery on 5/28/13.
//  Copyright (c) 2013 Twilio Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TWBUIFactory : NSObject
// Decorate existing objects
+ (void)decorateGrayButton:(UIButton*)btn;
+ (void)decorateWhiteButton:(UIButton*)btn;
+ (void)decorateBlackButton:(UIButton*)btn;
+ (void)decorateOrangeButton:(UIButton*)btn;
+ (void)decorateWithLinenBackground:(UIView*)view;

// String formatters
+ (NSString*)formatPhone:(NSString*)phone;

// Create pre-styled objects
+ (UILabel*)headerLabel:(NSString*)header width:(int)width x:(int)x;
+ (UIView*)headerView:(NSString*)header width:(int)width;

// Other utilities
+ (UIColor*)colorForHex:(NSString*)hex;
+ (void)alert:(NSString*)header detail:(NSString*)detail;
+ (NSString*)numberFromString:(NSString*)input;
@end
