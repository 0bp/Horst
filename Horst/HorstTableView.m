//
//  HorstTableView.m
//  Horst
//
//  Created by Boris Penck on 21.12.11.
//  Copyright (c) 2011 Boris Penck. All rights reserved.
//

#import "HorstTableView.h"

@implementation HorstTableView

- (NSCell *)preparedCellAtColumn:(NSInteger)column row:(NSInteger)row
{
  NSCell* cell = [super preparedCellAtColumn:column row:row];
  
  [cell setHighlighted:(row == [self selectedRow])];
  
  return cell;
}



@end
