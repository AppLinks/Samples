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


#import "PNShareActionSheetHelper.h"

@implementation PNShareActionSheetHelper
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
  switch (buttonIndex) {
    case 0:
      [self copyLinkToClipboard];
      break;
    case 1:
      [self emailLink];
      break;
    default:
      break;
  }
}

- (void)copyLinkToClipboard
{
  UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
  pasteboard.persistent = YES;
  [pasteboard setString:[self linkOfCurrentView]];
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Link Copied to Clipboard"
                                                  message:@"You can paste the link to other app to share this page now."
                                                 delegate:nil
                                        cancelButtonTitle:@"OK"
                                        otherButtonTitles:nil];
  [alert show];
}

- (void)emailLink
{
  NSString *emailtoURL = [NSString stringWithFormat:@"mailto:yourfriend@example.com?subject=%@&body=%@", [self title], [self linkOfCurrentView]];
  emailtoURL = [emailtoURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
  [[UIApplication sharedApplication] openURL:[NSURL URLWithString: emailtoURL]];
}

- (void) launchActionList:(NSString *)title
{
  [self setTitle:title];
  UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:[self title]
                                                      delegate:self
                                             cancelButtonTitle:@"Cancel"
                                        destructiveButtonTitle:nil
                                             otherButtonTitles:@"Copy Link to Clipboard", @"Share Link via E-mail", nil];
  [popup showInView:[UIApplication sharedApplication].keyWindow];
}
@end
