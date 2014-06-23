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

#import "ALPAppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>
#import "ALPLinkListViewController.h"

@implementation ALPAppDelegate


+ (void)initialize
{
  // if you use facebook indexing, you will need to add client token for facebook sdk to make graph api call.
  // you can find your client token on developers.facebook.com/apps/[your-app-id]/settings/advanced/
  // Notice that Application ID is set in plist file.
  [FBSettings setClientToken:@"43d3fa7a6bb7e86cdec7cd4258b633ad"];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  // set debug options:
  // [FBSettings setLoggingBehavior:[NSSet setWithObjects:FBLoggingBehaviorSessionStateTransitions, FBLoggingBehaviorDeveloperErrors, FBLoggingBehaviorCacheErrors, FBLoggingBehaviorFBURLConnections, FBLoggingBehaviorAccessTokens, nil]];
  return YES;
}

@end
