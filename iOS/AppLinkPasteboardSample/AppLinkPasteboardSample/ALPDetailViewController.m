/*
 * Copyright 2010-present Facebook.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
#import "ALPDetailViewController.h"
#import "FacebookSDK/FacebookSDK.h"
#import "ALPAppDelegate.h"
#import "Bolts/BFAppLinkNavigation.h"
#import "Bolts/BFAppLinkTarget.h"
#import "Bolts/BFAppLink.h"
#import "Bolts/BFTask.h"

@interface ALPDetailViewController ()

- (void)configureView;

@end

@implementation ALPDetailViewController
{
  NSArray * _resolvedTargets;
}
#pragma mark - Managing the detail item

/* This View essentially show some AppLink debugging information,
 * it also shows how to use bolts and facebook graph API to fetch app link details.
 */

- (void)viewDidLoad
{
  [super viewDidLoad];
  // add Boarder to TextView
  self.openGraphAppLinkTextView.layer.borderColor = [[UIColor.grayColor colorWithAlphaComponent:0.4] CGColor];
  self.openGraphAppLinkTextView.layer.borderWidth = 0.5;
  self.openGraphAppLinkTextView.layer.cornerRadius = 5;
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [self configureView];
}

- (IBAction)onOpenRawUrlButtonTap:(id)sender
{
  NSURL * url = [NSURL URLWithString:self.detailUrlStringItem];
  [[UIApplication sharedApplication] openURL:url];
}

- (void)configureView
{
  self.navigationController.toolbarHidden = YES;
  NSURL * url = [NSURL URLWithString:self.detailUrlStringItem];
  self.rawLinkURLTextField.text = self.detailUrlStringItem;
  
  // using bolts to resolve the app link async with built-in webview resolver.
  // see bolts doc for details: https://github.com/BoltsFramework/Bolts-iOS#navigating-to-a-url
  [[BFAppLinkNavigation resolveAppLinkInBackground:url] continueWithBlock:^id(BFTask *task) {
    BFAppLink *link = task.result;
    _resolvedTargets = [link targets];
    self.resolvedTargetsTableView.delegate = self;
    self.resolvedTargetsTableView.dataSource = self;
    [self.resolvedTargetsTableView reloadData];
    return nil;
  }];
  
  // Facebook provide indexing service for app links for better performance.
  // If you want to see the content of the indexing, following Graph API fetch it.
  // For more information see doc: https://developers.facebook.com/docs/graph-api/using-graph-api/v2.0#allookup
  [FBRequestConnection startWithGraphPath:[NSString stringWithFormat:@"?ids=%@&type=al", self.detailUrlStringItem]
                        completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                          if (error) {
                            self.openGraphAppLinkTextView.text = [NSString stringWithFormat:@"%@:%@:%@", error.localizedDescription, error.localizedFailureReason, error.localizedRecoverySuggestion];
                            return;
                          }
                          self.openGraphAppLinkTextView.text = [NSString stringWithFormat:@"%@", result];
                        }
   ];
}

- (IBAction)onDeleteButtonTap:(id)sender
{
  NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
  NSArray * appLinks = (NSArray *) [defaults objectForKey:APP_LINKS];
  NSMutableArray * newAppLinks = [[NSMutableArray alloc] initWithArray:appLinks];
  [newAppLinks removeObject:self.detailUrlStringItem];
  [defaults setObject:newAppLinks forKey:APP_LINKS];
  [self.navigationController popViewControllerAnimated:true];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
  
  BFAppLinkTarget *target = _resolvedTargets[indexPath.row];
  UITextField * urlTextField = (UITextField *) [cell viewWithTag:1];
  urlTextField.text = [target.URL absoluteString];
  [(UILabel *)[cell viewWithTag:2] setText:target.appName];
  [(UILabel *)[cell viewWithTag:3] setText:target.appStoreId];
  [(UIButton *)[cell viewWithTag:4] addTarget:self action:@selector(openTargetButton:) forControlEvents:UIControlEventTouchUpInside];
  return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return _resolvedTargets.count;
}

- (void)openTargetButton:(UIButton *)button
{
  UITableViewCell* cell = (UITableViewCell*)[button superview];
  NSIndexPath* indexPath = [self.resolvedTargetsTableView indexPathForCell:cell];
  BFAppLinkTarget * target  = _resolvedTargets[indexPath.row];
  [UIApplication.sharedApplication openURL:target.URL];
}

@end
