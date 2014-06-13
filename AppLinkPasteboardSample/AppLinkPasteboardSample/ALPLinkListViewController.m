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

#import "ALPLinkListViewController.h"
#import "ALPAppDelegate.h"
#import "ALPDetailViewController.h"
#import "ALPNewLinkViewController.h"
#import "ALPDetailViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "FacebookSDK/FBAppLinkResolver.h"
#import "Bolts/BFAppLinkNavigation.h"
#import <Bolts/Bolts.h>



@interface ALPLinkListViewController () {
  NSMutableArray *_appLinkUrls;
}
@end

@implementation ALPLinkListViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  if (!_appLinkUrls) {
    _appLinkUrls = [[NSMutableArray alloc] init];
  }
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  NSArray *app_links = [defaults objectForKey:APP_LINKS];
  
  [_appLinkUrls removeAllObjects];
  [_appLinkUrls addObjectsFromArray:app_links];
  [self.tableView reloadData];
  
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return _appLinkUrls.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
  NSURL * url = [NSURL URLWithString:_appLinkUrls[indexPath.row]];
  cell.textLabel.text = [url host];
  cell.detailTextLabel.text = [url path];
  if ([url query].length) {
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@?%@", [url path], [url query]];
  }
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  // navigate to the native app.
  NSString *url = _appLinkUrls[indexPath.row];
  // Navigate to a link with help of Bolts SDK.
  // https://github.com/BoltsFramework/Bolts-iOS#adding-app-and-navigation-data
  // For better performance,  instead of using the default hidden webview to resolve app links
  // we set the resolver to use Facebook indexing which scrapes the page and cache the meta data on Facebook servers.
  // see https://developers.facebook.com/docs/reference/ios/current/class/FBAppLinkResolver/ for details.
  
  [BFAppLinkNavigation setDefaultResolver:[[FBAppLinkResolver alloc] init]];
  
  // If you just want to navigate to the target app,  you can just use the single commented line.
  // [BFAppLinkNavigation navigateToURLInBackground:[NSURL URLWithString:url]];
  
  // But if you want to let the target apps to show a navigate back banner bar on top of their app, like what facebook app does.
  // You will need to provide URL your (this) app will be opened with.
  // The referer information has to be set before it navigates away.
  BFTask * resolveLink = [BFAppLinkNavigation resolveAppLinkInBackground:[NSURL URLWithString:url]];
  [resolveLink continueWithSuccessBlock:^id(BFTask *task) {
    BFAppLink *link = task.result;
    NSDictionary * referer_data = @{@"url": @"appLinkPinboard-sample-app://",
                                    @"app_name": @"AppLinkPinboard Sample App"};
    BFAppLinkNavigation *navigation = [BFAppLinkNavigation navigationWithAppLink:link
                                                                          extras:@{}
                                                                     appLinkData:@{@"referer_app_link": referer_data}];
    [navigation navigate:nil];
    return nil;
  }];
  
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if ([[segue identifier] isEqualToString:@"showDetail"]) {
    NSIndexPath * indexPath = [self.tableView indexPathForCell:sender];
    [segue.destinationViewController setDetailUrlStringItem:_appLinkUrls[indexPath.row]];
  }
}

@end
