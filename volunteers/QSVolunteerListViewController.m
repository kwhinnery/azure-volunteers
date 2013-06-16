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

#import "QSVolunteerListViewController.h"
#import "QSCallVolunteerViewController.h"
#import "QSVolunteerService.h"
#import "TWBUIFactory.h"

@interface QSVolunteerListViewController ()
{
    IBOutlet UITextField *volunteerName;
    IBOutlet UITextField *volunteerPhone;
    IBOutlet UIButton *signUpButton;
    IBOutlet UITableView *tableView;
}

@property (strong, nonatomic) QSVolunteerService *volunteerService;

- (IBAction)saveVolunteer:(id)sender;

@end

@implementation QSVolunteerListViewController

- (void)saveVolunteer:(id)sender {
    if (volunteerName.text.length  == 0 || volunteerPhone.text.length  == 0 ) {
        return;
    }
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    NSDictionary *volunteer = @{ @"name": volunteerName.text,
                                 @"phone": volunteerPhone.text };
    UITableView *tv = tableView;
    [self.volunteerService addVolunteer:volunteer completion:^(NSUInteger index) {
         NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
         [tv insertRowsAtIndexPaths:@[ indexPath ]
                          withRowAnimation:UITableViewRowAnimationTop];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
     }];
    
    volunteerName.text = @"";
    volunteerPhone.text = @"";
    [volunteerName resignFirstResponder];
    [volunteerPhone resignFirstResponder];
}

#pragma mark * UITableView methods
- (UITableViewCell *)tableView:(UITableView *)tv
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    // If there is no reusable cell of this type, create a new one
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"UITableViewCell"];
    }
    // that is at the nth index of items, where n = row this cell
    // will appear in on the tableview
    NSDictionary *volunteer = [self.volunteerService.volunteers objectAtIndex:indexPath.row];
    cell.textLabel.text = [volunteer objectForKey:@"name"];
    [cell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Always a single section
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    // Return the number of items in the todoService items array
    return [self.volunteerService.volunteers count];
}

- (void)tableView:(UITableView *)tableView
accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    QSCallVolunteerViewController *vc = [[QSCallVolunteerViewController alloc] init];
    vc.modalPresentationStyle = UIModalPresentationFormSheet;
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    vc.close = ^{
        [self dismissModalViewControllerAnimated:YES];
    };
    vc.volunteer = [self.volunteerService.volunteers objectAtIndex:indexPath.row];
    
    // Present modal view
    [self presentViewController:vc animated:YES completion:nil];
    vc.view.superview.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    vc.view.superview.bounds = CGRectMake(0, 0, 320, 140);
}

#pragma mark lifecycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.volunteerService = [QSVolunteerService defaultService];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self.volunteerService refreshDataOnSuccess:^{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        [tableView reloadData];
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [TWBUIFactory decorateWhiteButton:signUpButton];
    [signUpButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
