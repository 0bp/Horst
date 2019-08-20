//
//  Helper.m
//  Horst
//
//  Created by Boris Penck on 19.12.11.
//  Copyright (c) 2011 Boris Penck. All rights reserved.
//

#import "Helper.h"

@interface Helper (Private)

- (BOOL)hasHorstBlock;
- (BOOL)addBlankHorstBlock;
- (NSString *)getContentsOfFile;
- (BOOL)setContentsOfFile:(NSString *)content;
- (NSString *)getHorstBlock;
- (void)setHorstBlock:(NSString *)content;

@end

@implementation Helper

#pragma mark - Public Methods

- (id)initWithName:(NSString *)name
{
  if ((self = [super init]))
  {
    
  }
  return self;
}

- (NSString *)hosts
{
  if(![self hasHorstBlock]) {
    [self addBlankHorstBlock];
  }
  
  return [self getHorstBlock];
}

- (BOOL)hosts:(NSString *)hosts hash:(NSString *)hash
{
  if(![self hasHorstBlock]) {
    [self addBlankHorstBlock];
  }
  
  [self setHorstBlock:hosts];
  return YES;
}

#pragma mark - Private Methods

- (NSString *)getHorstBlock
{
  NSString * content = [self getContentsOfFile];
  NSRange   startRange = [content rangeOfString: @"###HORSTSTART"];
  NSRange   endRange = [content rangeOfString: @"###HORSTEND"];
  NSInteger length = endRange.location - (startRange.location+startRange.length);
  NSRange   blockRange = NSMakeRange(startRange.location+startRange.length, length);
 
  if((int)startRange.location >= 0 && startRange.location < endRange.location) {
    NSString * retval = [content substringWithRange:blockRange];
    return retval;
  }
  return nil;
  
}

- (void)setHorstBlock:(NSString *)newContent
{
  NSString * content = [self getContentsOfFile];
  
  NSRange startRange = [content rangeOfString: @"###HORSTSTART"];
  NSRange endRange = [content rangeOfString: @"###HORSTEND"];
  
  NSRange firstPartRange = NSMakeRange(0, startRange.location+startRange.length);
  NSRange lastPartRange = NSMakeRange(endRange.location, [content length]-endRange.location);
  
  NSString * newBlock = [NSString stringWithFormat:@"%@\n%@\n%@",
                         [content substringWithRange:firstPartRange],
                         newContent,
                         [content substringWithRange:lastPartRange]];
  
  
  [self setContentsOfFile:newBlock];
  
  content = nil;
  newBlock = nil;
}

- (BOOL)hasHorstBlock
{
  if([[self getHorstBlock] isNotEqualTo:nil]) {
    return YES;
  }
  return NO;
}

- (BOOL)addBlankHorstBlock
{
  NSString * content = [self getContentsOfFile];
  content = [content stringByAppendingString:@"\n\n###HORSTSTART\n###HORSTEND"];
  BOOL ok = [self setContentsOfFile:content];
  return ok;
  
}

- (NSString *)getContentsOfFile
{
  NSError * error = nil;
  NSString * content = [NSString stringWithContentsOfFile:@"/etc/hosts" 
                                                 encoding:NSASCIIStringEncoding 
                                                    error:&error];
  return content; 
}

- (BOOL)setContentsOfFile:(NSString *)content
{
  NSError * error = nil;
  BOOL ok = [content writeToFile:@"/etc/hosts" atomically:YES
                        encoding:NSASCIIStringEncoding error:&error];
  
  if(!ok || error != nil) {
    return NO;
  }
  return YES;
}

@end
