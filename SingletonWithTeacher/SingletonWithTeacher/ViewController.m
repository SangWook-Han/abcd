//
//  ViewController.m
//  SingletonWithTeacher
//
//  Created by 한상욱 on 2016. 11. 2..
//  Copyright © 2016년 HsoCompany. All rights reserved.
//

#import "ViewController.h"
#import "Singlton.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[Singlton shareData] printSomething];
}

    
    

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
