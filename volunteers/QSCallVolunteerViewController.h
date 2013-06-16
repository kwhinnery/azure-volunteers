//
//  QSCallVolunteerViewController.h
//  volunteers
//
//  Created by Kevin Whinnery on 6/16/13.
//  Copyright (c) 2013 MobileServices. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCConnectionDelegate.h"

typedef void (^QSCallVolunteerCompletionBlock)();

@interface QSCallVolunteerViewController : UIViewController <TCConnectionDelegate>

@property (nonatomic) NSDictionary* volunteer;
@property (nonatomic, copy) QSCallVolunteerCompletionBlock close;

@end
