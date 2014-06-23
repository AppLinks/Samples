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


#import "PNAppDelegate.h"
#import "PNNumberViewController.h"
#import "PNDefinitionViewController.h"

#import <Bolts/Bolts.h>
#import <Bolts/BFAppLinkReturnToRefererController.h>
#import <FacebookSDK/FacebookSDK.h>

@implementation PNAppDelegate

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
  // Take resolved app link and open the exact resourse view.
  // for more examples of Bolts support for App links, see:
  // https://github.com/BoltsFramework/Bolts-iOS#app-links
  [FBSettings setClientToken:@"43d3fa7a6bb7e86cdec7cd4258b633ad"];
  [FBSettings setDefaultAppID:@"321332404687158"];
  BFURL *parsedUrl = [BFURL URLWithInboundURL:url sourceApplication:sourceApplication];
  
  // Use the target URL from the App Link to locate content.
  
  //  This sample app has two major views.
  //  1. Definition of Prime Number:  a view show what is Prime Number and examples -- static view
  //  2. Single of Number: a view shows a number and whether it is a prime number and if not why -- dynamic view depends on the param "id"
  //    The App link for the view looks like:
  //      There are two links
  //      1. http://primenumber.parseapp.com/definition
  //      2. http://primenumber.parseapp.com/number/?id=xxx
  //      Follow the link in Browser and check the meta tag in html header, where lives the information to resolve the url. And they are the reason these links are App Links.
  
  if ([parsedUrl.targetURL.pathComponents[1] isEqualToString:@"definition"]) {
    UINavigationController *navVC = (UINavigationController *)self.window.rootViewController;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PNDefinitionViewController *vc = (PNDefinitionViewController *)[storyboard instantiateViewControllerWithIdentifier:@"PNDefinitionViewController"];
    vc.refererURL = url;
    [navVC pushViewController:vc animated:YES];
  } else if ([parsedUrl.targetURL.pathComponents[1] isEqualToString:@"number"]) {
    NSString *num = parsedUrl.targetQueryParameters[@"id"];
    if (num) {
      UINavigationController *navVC = (UINavigationController *)self.window.rootViewController;
      UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
      PNNumberViewController *vc = (PNNumberViewController *)[storyboard instantiateViewControllerWithIdentifier:@"PNNumberViewController"];
      vc.num = [num integerValue];
      vc.refererURL = url;
      [navVC pushViewController:vc animated:YES];
    }
  } else  {
    // Do nothing and it will fallback to just open the app in a default way, i.e. open app by tapping the icon.
    // This is a good place to launch webview to target URL if your app haven't implemented the native view, but
    // you do have a corresponding web page for the URL.
  }
  
  return YES;
}

@end
