//
//  AppController.m
//  Checker File Formatter
//
//  Created by Saad Abbasi on 11/08/2012.
//  Copyright (c) 2012 BEL. All rights reserved.
//

#import "AppController.h"

@implementation AppController
-(IBAction)chooseTSV:(id)sender
{
    NSInteger wireCount;
    NSError *error = nil;
    myFormatter = [[Formatter alloc]init];
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    openPanel.canChooseFiles = YES;
    openPanel.canChooseDirectories = NO;
    
    NSArray *fileTypes = [NSArray arrayWithObject:@"txt"];
    [openPanel setAllowedFileTypes:fileTypes];
    
    NSInteger result = [openPanel runModal];
    
    if(result == NSOKButton)
    {
        [myFormatter verifyFileAtURL:openPanel.URL andReturnWireCount:&wireCount error:&error];
        [wireCountTextField setIntegerValue:wireCount];
//        [NSApp presentError:error];
        //NSLog(@"%@",[[openPanel URLs] objectAtIndex:0]);
    }
    [myView reloadData];    
}

-(IBAction)saveFormattedFile:(id)sender
{
    NSSavePanel *savePanel = [NSSavePanel savePanel];
    
    NSArray *fileTypes = [NSArray arrayWithObject:@"loc"];
    [savePanel setAllowedFileTypes:fileTypes];
    
    NSInteger result = [savePanel runModal];
    
    if(result == NSOKButton)
    {
        [myFormatter saveFormattedFileDataWithHarnessName:[harnessNameTextField stringValue] atURL:[savePanel URL]];
    }
}

-(int)numberOfRowsInTableView:(NSTableView*)tableView
{
    if(myFormatter == nil)
    {
        return 0;
    }
    
    return [myFormatter listCount];
}

-(id)tableView:(NSTableView *)pTableView objectValueForTableColumn:(NSTableColumn *)pTableColumn row:(int)pRow
{

    return [myFormatter objectAtIndex:pRow];
       
}

@end
