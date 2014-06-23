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

#import "PNPrimeHelper.h"

@implementation PNPrimeHelper

+ (BOOL)isPrimeNumber:(NSInteger)num {
  return [PNPrimeHelper whyNotPrimeNumber:num] == nil;
}

+ (NSString *)whyNotPrimeNumber:(NSInteger)num {
  if (num <= 0) {
    return @"Because it is not positive";
  }
  if (num == 1) {
    return @"1 is not prime number";
  }
  
  for (int i = sqrt(num)/1; i > 1; i--) {
    if (num % i == 0) {
      return [NSString stringWithFormat:@"%ld = %ld X %ld", (long)num, (long)i, (long)num/i];
    }
  }
  return nil;
}
@end
