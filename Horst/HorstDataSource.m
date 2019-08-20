//
//  HorstDataSource.m
//  Horst
//
//  Created by Boris Penck on 21.12.11.
//  Copyright (c) 2011 Boris Penck. All rights reserved.
//

#import "HorstDataSource.h"

@interface HorstDataSource (Private) 

- (NSMutableArray *)load;
- (void)save;
- (NSString *)getActiveLinesFromConfiguration:(NSString *)str;

@end

@implementation HorstDataSource

#pragma mark Datasource

- (id)init
{
  self = [super init];
  if(self) 
  {
    groups = [self load];
  }
  return self;
}

- (NSString *)config
{
  NSString * retval = [NSString string];

  int counter = 0;
  
  for (NSDictionary * dict in groups) 
  {
    counter++;
    
    if(![[BPLicenseManager sharedManager] isValid])
    {
      if(counter > 2) continue;
    }
    
    if([[dict objectForKey:@"enabled"] isEqualToString:@"1"])
    {
      if(![[dict objectForKey:@"content"] isEqualToString:@""])
      {
        NSString * c = [dict objectForKey:@"content"];
        NSString * trimC = [c stringByTrimmingCharactersInSet:
                            [NSCharacterSet whitespaceAndNewlineCharacterSet]];

        NSString * aSet = [self getActiveLinesFromConfiguration:trimC];
        retval = [retval stringByAppendingFormat:@"%@",aSet];
      }
    }
  }
  return [retval stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];;
}

- (BOOL)validConfigurationAtIndex:(NSInteger)index
{
  NSString * c = [[groups objectAtIndex:index] objectForKey:@"content"];
  return [c canBeConvertedToEncoding:NSASCIIStringEncoding];
}

- (NSString *)getActiveLinesFromConfiguration:(NSString *)str
{
  NSArray * lines = [str componentsSeparatedByCharactersInSet: [NSCharacterSet newlineCharacterSet]];
  NSString * retval = @"";
  
  for (NSString * line in lines) {
    
    NSString * trimLine = [line stringByTrimmingCharactersInSet:
                           [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if([trimLine length] > 0) {
      NSRange firstCharRange = NSMakeRange(0,1);
      NSString * firstCharacter = [trimLine substringWithRange:firstCharRange];
    
      if(![firstCharacter isEqualToString:@"#"]) {
        retval = [retval  stringByAppendingFormat:@"%@\n", trimLine];
      }
    }
  }
  
  return retval;
}

- (NSMutableArray *)load
{
  NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
  
  if(defaults && [defaults objectForKey:@"groups"] != nil) {
    NSMutableArray * g = [defaults objectForKey:@"groups"];
    if(g == nil)
    {
      return [NSMutableArray array];
    }
    return g;
  }
  return [NSMutableArray array];
}

- (void)save
{
  NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
  
  [defaults removeObjectForKey:@"groups"];
  [defaults synchronize];
  [defaults setObject:groups forKey:@"groups"];
  [defaults setObject:[NSDate description] forKey:@"lastModified"];
  [defaults synchronize];
}

#pragma mark Public Methods

- (void)addSet:(NSString *)caption
{
  NSMutableDictionary * g = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects: caption, @"", @"0", nil]
                                                 forKeys:[NSArray arrayWithObjects: @"caption", @"content", @"enabled", nil]];
  
  [groups addObject:g];
  [self save];
}

- (void)removeSet:(NSInteger)index
{
  [groups removeObjectAtIndex:index];
  [self save];
}

- (NSInteger)rows
{
  return [groups count];
}

- (NSString *)dataForSetAtIndex:(NSInteger)index
{
  return [[groups objectAtIndex:index] objectForKey:@"content"];
}

- (void)setContent:(NSString *)content forSet:(NSInteger)index
{
  if(content == nil) content = @"";
  [(NSDictionary *)[groups objectAtIndex:index] setValue:content forKey:@"content"];
  [self save];
}

- (BOOL)isEnabled:(NSInteger)index
{
  return [[(NSDictionary *)[groups objectAtIndex:index] objectForKey:@"enabled"] isEqualToString:@"1"];
}

- (void)toggleIndex:(NSInteger)index
{
  NSString * enabled = [(NSDictionary *)[groups objectAtIndex:index] objectForKey:@"enabled"];

  if([enabled isEqualToString:@"1"]) {
    [(NSDictionary *)[groups objectAtIndex:index] setValue:@"0" forKey:@"enabled"];
  } else {
    [(NSDictionary *)[groups objectAtIndex:index] setValue:@"1" forKey:@"enabled"];
  }
  [self save];
}

- (void)enableIndex:(NSInteger)index
{
  [(NSDictionary *)[groups objectAtIndex:index] setValue:@"1" forKey:@"enabled"];
  [self save];
}

- (void)disableIndex:(NSInteger)index
{
  [(NSDictionary *)[groups objectAtIndex:index] setValue:@"0" forKey:@"enabled"];  
  [self save];
}


#pragma mark NSTableView Delegate & DataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
  return [groups count];
}

-(void)tableViewSelectionDidChange:(NSNotification *)notification
{
  [[NSNotificationCenter defaultCenter] postNotificationName:@"selectionDidChange" object:self];
}

-(id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
  NSDictionary * group = [groups objectAtIndex:row];

  if([[tableColumn dataCell] class] == [HorstSliderCell class])
  {
    if(![[BPLicenseManager sharedManager] isValid])
    {
      if(row > 1) {
        return @"0";
      }
    }
    
    return [group objectForKey:@"enabled"];
  } 
  else if([[tableColumn dataCell] class] == [HorstIndicatorCell class])
  {
    NSString * c = [[groups objectAtIndex:row] objectForKey:@"content"];

    if(![c canBeConvertedToEncoding:NSASCIIStringEncoding]) {
      return @"E";
    }

    NSString * trimmed = [self getActiveLinesFromConfiguration:[group objectForKey:@"content"]];
    
    if([trimmed isEqualToString:@""]) {
      return @"0";
    }
    
    NSMutableArray * parts = [NSMutableArray arrayWithArray:[trimmed componentsSeparatedByString:@"\n"]];
    [parts removeObject:@""];
    
    long count = [parts count];
    
    parts = nil;
    trimmed = nil;
    
    return [NSString stringWithFormat:@"%ld", count];
  }
  
  return [group objectForKey:@"caption"];
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
  return 26.0;
}

-(void)tableView:(NSTableView *)tableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{ 
  BOOL save = NO;
  
  if([[tableColumn identifier] isEqualToString:@"caption"])
  {
    [(NSDictionary*)[groups objectAtIndex:row] setValue:object forKey:@"caption"];
    save = YES;
  }
  else if ([[tableColumn identifier] isEqualToString:@"enabled"])
  {
    if(![[BPLicenseManager sharedManager] isValid])
    {
      if(row > 1 && [[NSString stringWithFormat:@"%@", object] isEqualToString:@"1"]) {
        NSBeep();
        return;
      }
    }

    [(NSDictionary*)[groups objectAtIndex:row] setValue:[NSString stringWithFormat:@"%@", object] forKey:@"enabled"];
    save = YES;
  }
  
  if(save) {
    [self save];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"saveConfiguration" object:self];
  }
}

#pragma mark NSTextView Delegate

-(NSCell *)tableView:(NSTableView *)tableView dataCellForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
  NSCell * cell = [tableColumn dataCellForRow:row];
  if(![[BPLicenseManager sharedManager] isValid] && row > 1 && [[tableColumn identifier] isEqualToString:@"enabled"])
  {
    [cell setEnabled:NO];
  } else {
    [cell setEnabled:YES];
  }
  
  return cell;
}

-(void)textDidChange:(NSNotification *)notification
{
  [[NSNotificationCenter defaultCenter] postNotificationName:@"contentDidChange" object:self];
}

- (void)textStorageDidProcessEditing:(NSNotification *)notification
{
	NSTextStorage *textStorage = [notification object];
	NSString *string = [textStorage string];
  
  if(![string canBeConvertedToEncoding:NSASCIIStringEncoding]) {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"nonASCIICharacter" object:self];
  }
}


@end
