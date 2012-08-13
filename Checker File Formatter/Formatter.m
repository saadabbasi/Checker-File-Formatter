//
//  Formatter.m
//  Checker File Formatter
//
//  Created by Saad Abbasi on 11/08/2012.
//  Copyright (c) 2012 BEL. All rights reserved.
//

#import "Formatter.h"

@implementation Formatter

-(BOOL)saveFormattedFileDataWithHarnessName:(NSString*)harnessName atURL:(NSURL*)url
{
    NSString *fileID = @"LOC";
    NSString *header = [fileID stringByAppendingString:harnessName];

    [formattedBinaryData replaceBytesInRange:NSMakeRange(0,25) withBytes:[header cStringUsingEncoding:NSUTF8StringEncoding]];
    [formattedBinaryData writeToURL:url atomically:YES];
    
    return YES;
}

-(id)objectAtIndex:(int)index
{
    NSArray *aCol;
    aCol = [formattedStringData objectForKey:@"InputPin"];
    return [aCol objectAtIndex:index];
}

-(NSInteger)listCount
{
    return [[formattedStringData objectForKey:@"SpliceNo"] count];
}

-(id)verifyFileAtURL:(NSURL*)url andReturnWireCount:(NSInteger*)wireCount error:(NSError**)error
{
   
    NSError *ferror;
    
    formattedStringData = [[NSMutableDictionary alloc] init];
    NSMutableArray *SpliceNo = [NSMutableArray array];
    NSMutableArray *InputPin = [NSMutableArray array];
    
    NSString *file = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&ferror];
    NSArray *lines = [file componentsSeparatedByString:@"\n"];
    NSArray *fields = [[lines objectAtIndex:0] componentsSeparatedByString:@"\t"];
    
    if(fields.count == NumberOfColumns)
    {
        NSLog(@"%@",fields);
        if(![[fields objectAtIndex:0] isEqualToString:@"SRL No"])
        {
            NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
            [errorDetail setValue:@"File headers do not match expected values." forKey:NSLocalizedDescriptionKey];
            *error = [NSError errorWithDomain:@"myDomain" code:100 userInfo:errorDetail];
            
            NSLog(@"OK");
            return nil;
        }
        
        int count = fields.count;
        int counter = 0;
        NSScanner *theScanner = [NSScanner scannerWithString:file];
        NSScanner *lineScanner;
        NSCharacterSet *characterSet = [NSCharacterSet decimalDigitCharacterSet];
        NSCharacterSet *skippedCharacters = [NSCharacterSet characterSetWithCharactersInString:@"\n"];
        
        NSString *line;
        NSString *field;
        NSMutableArray *strings = [NSMutableArray array];
        [theScanner scanUpToCharactersFromSet:characterSet intoString:nil];
        [theScanner setCharactersToBeSkipped:skippedCharacters];
        
//        NSMutableData *data = [NSMutableData dataWithLength:0];
        formattedBinaryData = [NSMutableData dataWithLength:0];
        
        //NSString *harnessName = @"Suzuki SB308";
        NSString *fileID = @"LOC";
        //NSString *header = [fileID stringByAppendingString:harnessName];
        
        [formattedBinaryData appendBytes:[fileID cStringUsingEncoding:NSUTF8StringEncoding] length:25];
        uint16_t length[2];
        
        uint16_t line_count = 0;
        while([theScanner isAtEnd] == 0)
        {
            [theScanner scanUpToString:@"\n" intoString:&line];
            if(line!=nil)
            {
                lineScanner = [NSScanner scannerWithString:line];
                counter = 0;
                [strings removeAllObjects];
                for(int i=0;i<count;i++)
                {
                    [lineScanner scanUpToString:@"\t" intoString:&field];
                    [strings addObject:field];
                }
                NSString *locationA = [[[strings objectAtIndex:4] stringByAppendingString:@"/"] stringByAppendingString:[strings objectAtIndex:5]];
                NSString *locationB = [[[strings objectAtIndex:6] stringByAppendingString:@"/"] stringByAppendingString:[strings objectAtIndex:7]];
                NSLog(@"%@",locationA);
                NSLog(@"%@",locationB);
                NSIndexSet *indices = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(4, 4)];
                [strings removeObjectsAtIndexes:indices];
                [strings addObject:locationA];
                [strings addObject:locationB];
                
                uint16_t temp;
                temp = [[strings objectAtIndex:0] intValue];
                [SpliceNo addObject:[strings objectAtIndex:0]];
                [formattedBinaryData appendBytes:&temp  length:sizeof(temp)];
                temp = [[strings objectAtIndex:1] intValue];
                [InputPin addObject:[strings objectAtIndex:0]];
                [formattedBinaryData appendBytes:&temp length:sizeof(temp)];
                
                [formattedBinaryData appendBytes:[[strings objectAtIndex:2] cStringUsingEncoding:NSUTF8StringEncoding] length:6];
                [formattedBinaryData appendBytes:[[strings objectAtIndex:3] cStringUsingEncoding:NSUTF8StringEncoding] length:6];
                
                for(int i=4;i<strings.count;i++)
                {
                    [formattedBinaryData appendBytes:[[strings objectAtIndex:i] cStringUsingEncoding:NSUTF8StringEncoding] length:10];
                }
                line_count++;
            }
        }
        
        length[0] = formattedBinaryData.length;
        [formattedBinaryData replaceBytesInRange:NSMakeRange(20,sizeof(line_count)) withBytes:&line_count];
        *wireCount = line_count;
        [formattedStringData setObject:SpliceNo forKey:@"SpliceNo"];
        [formattedStringData setObject:InputPin forKey:@"InputPin"];
//        [data writeToFile:myfile atomically:YES];
        
    }
    
   

}


@end
