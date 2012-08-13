//
//  AppController.h
//  Checker File Formatter
//
//  Created by Saad Abbasi on 11/08/2012.
//  Copyright (c) 2012 BEL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Formatter.h"

@interface AppController : NSObject
{
    Formatter *myFormatter;
    IBOutlet NSTextField *harnessNameTextField;
    IBOutlet NSTextField *wireCountTextField;
    IBOutlet NSTableView *myView;
}
-(IBAction)chooseTSV:(id)sender;
-(IBAction)saveFormattedFile:(id)sender;

-(int)numberOfRowsInTableView:(NSTableView*)tableView;
-(id)tableView:(NSTableView *)pTableView objectValueForTableColumn:(NSTableColumn *)pTableColumn row:(int)pRow;
    
    
    @end
