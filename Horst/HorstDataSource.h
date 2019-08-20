//
//  HorstDataSource.h
//  Horst
//
//  Created by Boris Penck on 21.12.11.
//  Copyright (c) 2011 Boris Penck. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HorstSliderCell.h"
#import "HorstTextFieldCell.h"
#import "HorstIndicatorCell.h"
#import "LicenseManager.h"

@interface HorstDataSource : NSObject <NSTableViewDelegate, NSTableViewDataSource, NSTextViewDelegate, NSTextStorageDelegate>
{
  
  NSMutableArray * groups;
  
}

- (void)addSet:(NSString *)caption;
- (void)removeSet:(NSInteger)index;

- (NSString *)dataForSetAtIndex:(NSInteger)index;
- (void)setContent:(NSString *)content forSet:(NSInteger)index;
- (NSInteger)rows;
- (NSString *)config;
- (BOOL)isEnabled:(NSInteger)index;
- (void)toggleIndex:(NSInteger)index;
- (void)enableIndex:(NSInteger)index;
- (void)disableIndex:(NSInteger)index;

@end
