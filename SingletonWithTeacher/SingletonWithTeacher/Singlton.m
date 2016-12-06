//
//  Singlton.m
//  SingletonWithTeacher
//
//  Created by 한상욱 on 2016. 11. 2..
//  Copyright © 2016년 HsoCompany. All rights reserved.
//

#import "Singlton.h"

@implementation Singlton

+(instancetype) shareData {
    static  Singlton *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once   (&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
    
}
-(void) printSomething {
    NSLog(@"gogogo");
}
@end
