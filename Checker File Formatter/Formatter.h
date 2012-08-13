//
//  Formatter.h
//  Checker File Formatter
//
//  Created by Saad Abbasi on 11/08/2012.
//  Copyright (c) 2012 BEL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@interface Formatter : NSObject
{
    NSMutableData *formattedBinaryData;
    NSMutableArray *parsedStrings;
    NSMutableDictionary *formattedStringData;
}

-(id)verifyFileAtURL:(NSURL*)url andReturnWireCount:(NSInteger*)wireCount error:(NSError**)error;
-(BOOL)saveFormattedFileDataWithHarnessName:(NSString*)harnessName atURL:(NSURL*)url;
-(id)objectAtIndex:(int)index;
-(NSInteger)listCount;
@end
