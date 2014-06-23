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


#import "PNDefinitionViewController.h"
#import "PNShareActionSheetHelper.h"

#import <Bolts/BFAppLinkReturnToRefererController.h>

@implementation PNDefinitionViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.toolbarItems = @[
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                  target:self
                                                  action:@selector(launchActionSheet:)],
  ];
  
  // Consider cases that when navigation from other app to this app via app link,
  // we prepare navigation back banner to let user switch back for better user experiences.
  // More details are about bolts' implementation of this banner view (e.g. integration with navbar):
  // https://github.com/BoltsFramework/Bolts-iOS#app-link-return-to-referer-view
  self.returnToRefererController = [[BFAppLinkReturnToRefererController alloc] init];
  self.returnToRefererController.view = [[BFAppLinkReturnToRefererView alloc] initWithFrame:CGRectZero];
  [self.view addSubview:self.returnToRefererController.view];
}

- (void)viewWillLayoutSubviews
{
  [super viewWillLayoutSubviews];
  if (self.refererURL) {
    // only show the back to referer navigation-banner when refererURL is set.
    // In this version of Bolts, we will need to change the size of this view frame manually to none-zero.
    CGRect frame = self.returnToRefererController.view.frame;
    self.returnToRefererController.view.frame = CGRectMake(frame.origin.x, frame.origin.y, self.view.frame.size.width, frame.size.height);
    [self.returnToRefererController showViewForRefererURL:self.refererURL];
  }
}

- (IBAction)launchActionSheet:(id)sender
{
  self.shareActionSheet = [[PNShareActionSheetHelper alloc] init];
  [self.shareActionSheet setLinkOfCurrentView:@"http://primenumber.parseapp.com/definition"];
  [self.shareActionSheet launchActionList:@"Share Prime Definition"];
}

- (IBAction)showDefinitions:(UIStoryboardSegue *)segue
{
  // no op
}

@end
