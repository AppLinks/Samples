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

#import "ALPNewLinkViewController.h"
#import "ALPAppDelegate.h"
#import "ALPLinkListViewController.h"

@implementation ALPNewLinkViewController

- (IBAction)onClickPinButton:(id)sender {
  NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
  NSArray * appLinks = (NSArray *)[defaults objectForKey:APP_LINKS];
  NSMutableArray * newAppLinks = [[NSMutableArray alloc] initWithArray:appLinks];
  [newAppLinks addObject:self.editLinkTextField.text];
  [defaults setObject:newAppLinks forKey:APP_LINKS];
  [self.navigationController popViewControllerAnimated:true];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //To make the border look very close to a UITextField
    self.editLinkTextField.layer.borderColor = [[UIColor.grayColor colorWithAlphaComponent:0.4] CGColor];
    self.editLinkTextField.layer.borderWidth = 0.5;
    
    //The rounded corner part, where you specify your view's corner radius:
    self.editLinkTextField.layer.cornerRadius = 5;
    self.editLinkTextField.clipsToBounds = YES;
    self.editLinkTextField.delegate = self;
}

-(BOOL)textFieldShouldReturn: (UITextField *) textField {
    [textField resignFirstResponder];
    return YES;
}

@end
