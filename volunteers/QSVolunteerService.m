// ----------------------------------------------------------------------------
// Copyright (c) Twilio Inc. All rights reserved.
// ----------------------------------------------------------------------------
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "QSVolunteerService.h"
#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>

@interface QSVolunteerService() <MSFilter>

@property (nonatomic, strong) MSTable *table;
@property (nonatomic) NSInteger busyCount;

@end

@implementation QSVolunteerService


+ (QSVolunteerService *)defaultService
{
    // Create a singleton instance of QSTodoService
    static QSVolunteerService* service;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service = [[QSVolunteerService alloc] init];
    });
    
    return service;
}

-(QSVolunteerService *)init
{
    self = [super init];
    
    if (self) {
        // Initialize the Mobile Service client
        MSClient *client = [MSClient clientWithApplicationURLString:@"https://volunteers.azure-mobile.net/"
                                                     applicationKey:@"CHANGE_ME"];
        
        // Add a Mobile Service filter to enable the busy indicator
        self.client = [client clientWithFilter:self];
        
        // Create an MSTable instance
        self.table = [_client tableWithName:@"Volunteer"];
        
        self.volunteers = [[NSMutableArray alloc] init];
        self.busyCount = 0;
    }
    
    return self;
}

- (void)refreshDataOnSuccess:(QSCompletionBlock)completion
{
    // Get a list of all volunteers
    [self.table readWithCompletion:^(NSArray *results, NSInteger totalCount, NSError *error) {
         [self logErrorIfNotNil:error];
         
         self.volunteers = [results mutableCopy];
         
         // Let the caller know that we finished
         completion();
    }];
    
}

-(void)addVolunteer:(NSDictionary *)volunteer completion:(QSCompletionWithIndexBlock)completion
{
    // Insert the item into the TodoItem table and add to the items array on completion
    [self.table insert:volunteer completion:^(NSDictionary *result, NSError *error) {
         [self logErrorIfNotNil:error];
         
         NSUInteger index = [self.volunteers count];
         [(NSMutableArray *)self.volunteers insertObject:result atIndex:index];
         
         completion(index);
     }];
}

- (void)busy:(BOOL)busy
{
    // assumes always executes on UI thread
    if (busy) {
        if (self.busyCount == 0 && self.busyUpdate != nil) {
            self.busyUpdate(YES);
        }
        self.busyCount ++;
    }
    else {
        if (self.busyCount == 1 && self.busyUpdate != nil) {
            self.busyUpdate(FALSE);
        }
        self.busyCount--;
    }
}

- (void)logErrorIfNotNil:(NSError *) error
{
    if (error) {
        NSLog(@"ERROR %@", error);
    }
}


#pragma mark * MSFilter methods


- (void)handleRequest:(NSURLRequest *)request
                 next:(MSFilterNextBlock)next
             response:(MSFilterResponseBlock)response
{
    // A wrapped response block that decrements the busy counter
    MSFilterResponseBlock wrappedResponse = ^(NSHTTPURLResponse *innerResponse, NSData *data, NSError *error) {
        [self busy:NO];
        response(innerResponse, data, error);
    };
    
    // Increment the busy counter before sending the request
    [self busy:YES];
    next(request, wrappedResponse);
}

@end