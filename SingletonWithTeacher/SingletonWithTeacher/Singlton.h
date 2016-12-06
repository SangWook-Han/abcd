//
//  Singlton.h
//  SingletonWithTeacher
//
//  Created by 한상욱 on 2016. 11. 2..
//  Copyright © 2016년 HsoCompany. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Singlton : NSObject

+(instancetype)shareData;
-(void)printSomething;
@end
