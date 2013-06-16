//
//  QSCallVolunteerViewController.m
//  volunteers
//
//  Created by Kevin Whinnery on 6/16/13.
//  Copyright (c) 2013 MobileServices. All rights reserved.
//

#import "QSCallVolunteerViewController.h"
#import "TWBUIFactory.h"
#import "TCDevice.h"

@interface QSCallVolunteerViewController ()
{
    IBOutlet UIButton *endCall;
    IBOutlet UILabel *name;
    TCDevice *phone;
}

- (IBAction)endCall:(id)sender;

@end

@implementation QSCallVolunteerViewController

// Connection Delegate
- (void)connection:(TCConnection *)connection didFailWithError:(NSError *)error
{
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        self.close();
    });
}

- (void)connectionDidConnect:(TCConnection *)connection
{
    // nothing yet
}

- (void)connectionDidDisconnect:(TCConnection *)connection
{
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        self.close();
    });
}

- (void)connectionDidStartConnecting:(TCConnection *)connection
{
    // nothing yet
}

- (void)endCall:(id)sender
{
    [phone disconnectAll];
    self.close();
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSURL* url = [NSURL URLWithString:@"https://twilionode.azurewebsites.net/capability"];
        NSURLResponse* response = nil;
        NSError* error = nil;
        NSData* data = [NSURLConnection sendSynchronousRequest: [NSURLRequest requestWithURL:url]
                                             returningResponse:&response
                                                         error:&error];
        if (data) {
            NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
            
            if (httpResponse.statusCode == 200)
            {
                NSString* capabilityToken = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                
                phone = [[TCDevice alloc] initWithCapabilityToken:capabilityToken delegate:nil];
            }
            else
            {
                NSString*  errorString = [NSString stringWithFormat: @"HTTP status code %d", httpResponse.statusCode];
                NSLog(@"Error logging in: %@", errorString);
            }
        }
        else
        {
            NSLog(@"Error logging in: %@", [error localizedDescription]);
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Populate UI from volunteer data
    name.text = [self.volunteer objectForKey:@"name"];
    
    // Decorate button
    [TWBUIFactory decorateOrangeButton:endCall];
    
    // Begin calling the volunteer
    [phone connect:@{@"PhoneNumber":[self.volunteer objectForKey:@"phone"], @"CallerId":@"+16513046537"}
          delegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
