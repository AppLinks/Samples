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



#import "PNNumberViewController.h"
#import "PNPrimeHelper.h"
#import "PNShareActionSheetHelper.h"

#import <Bolts/BFAppLinkReturnToRefererController.h>

@implementation PNNumberViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  if (![self num]) {
    [self setNum:arc4random() % 100];
  }
  self.returnToRefererController = [[BFAppLinkReturnToRefererController alloc] init];
  self.returnToRefererController.view = [[BFAppLinkReturnToRefererView alloc] initWithFrame:CGRectZero];
  [self.view addSubview:self.returnToRefererController.view];

  self.toolbarItems = @[
                        [[UIBarButtonItem alloc]
                         initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                         target:self
                         action:@selector(launchActionSheet:)],
                        ];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [self updateView];
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [self updateView];
}

- (IBAction)onClickOfPrevious:(id)sender
{
  self.num = self.num - 1;
  [self updateView];
}

- (IBAction)onClickOfNext:(id)sender
{
  self.num = self.num + 1;
  [self updateView];
}

- (void)updateView
{
  if (self.refererURL) {
      // only show the back to referer navigation-banner when refererURL is set.
      // In this version of Bolts, we will need to change the size of this view frame manually to none-zero.
    CGRect frame = self.returnToRefererController.view.frame;
    self.returnToRefererController.view.frame = CGRectMake(frame.origin.x, frame.origin.y, self.view.frame.size.width, frame.size.height);
    [self.returnToRefererController showViewForRefererURL:self.refererURL];
  }
  
  self.currentNumberLabel.text = [NSString stringWithFormat:@"%ld", (long)self.num];

  NSString *reasonForNotBeingPrime = [PNPrimeHelper whyNotPrimeNumber:self.num];
  if (reasonForNotBeingPrime == nil) {
    self.isPrimeLabel.text = @"is a Prime Number";
    self.whyNotPrimeLabel.hidden = YES;
  } else {
    self.isPrimeLabel.text = @"is NOT a Prime Number";
    self.whyNotPrimeLabel.text = reasonForNotBeingPrime;
    self.whyNotPrimeLabel.hidden = NO;
  }
}

- (void)launchActionSheet:(id)sender
{
  self.shareActionSheet = [[PNShareActionSheetHelper alloc] init];
  NSString *urlFormat = @"http://primenumber.parseapp.com/number/?id=%d";
  [self.shareActionSheet setLinkOfCurrentView:[NSString stringWithFormat:urlFormat, self.num]];
  [self.shareActionSheet launchActionList:@"Share this Number"];
}

@end
