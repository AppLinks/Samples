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


#import "PNExamplesViewController.h"
#import "PNPrimeHelper.h"
#import "PNNumberViewController.h"

@implementation PNExamplesViewController

NSInteger const sectionNumber = 2;
NSInteger const itemsInSection = 8;

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self configView];
}

- (void)configView
{
  NSMutableArray *primes = [[NSMutableArray alloc] init];
  NSMutableArray *nonPrimes = [[NSMutableArray alloc] init];
  BOOL satisfied = false;
  NSInteger num = 2;
  while (!satisfied) {
    if ([PNPrimeHelper isPrimeNumber:num] && [primes count] < itemsInSection) {
      [primes addObject:[NSNumber numberWithInteger:num]];
    } else if ([nonPrimes count] < itemsInSection) {
      [nonPrimes addObject:[NSNumber numberWithInteger:num]];
    }
    if (itemsInSection == [nonPrimes count] && itemsInSection == [primes count]) {
      satisfied = true;
    }
    num = num + 1;
  }
  self.exampleNumbers = [primes arrayByAddingObjectsFromArray:nonPrimes];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
  return sectionNumber;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
  return itemsInSection;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
  UICollectionReusableView *header = nil;
  UILabel *headerLabel = nil;
  if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
    header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                withReuseIdentifier:@"sectionHeader"
                                                       forIndexPath:indexPath];
    headerLabel = (UILabel *)[header viewWithTag:100];
    if (indexPath.section == 0) {
      headerLabel.text = @"Examples of Prime Numbers";
    } else {
      headerLabel.text = @"Examples of Non Prime Numbers";
    }
  }
  
  return header;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
  static NSString *identifier = @"numCell";
  
  UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
  
  UIButton *exampleNumber = (UIButton *)[cell viewWithTag:100];
  NSString *title = [NSString stringWithFormat:@"%@", self.exampleNumbers[indexPath.row + indexPath.section * itemsInSection]];
  [exampleNumber setTitle:title forState:UIControlStateNormal];
  return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if ([[segue identifier] isEqualToString:@"openNumberView"]) {
    UIButton *button = (UIButton *)sender;
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:[self.collectionView convertPoint:button.center fromView:button.superview]];
    NSNumber *num = self.exampleNumbers[indexPath.row + indexPath.section * itemsInSection];
    [segue.destinationViewController setNum:num.integerValue];
  }
}


@end
