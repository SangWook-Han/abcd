//
//  ViewController.m
//  Dispatch
//
//  Created by 한상욱 on 2016. 11. 11..
//  Copyright © 2016년 HsoCompany. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    dispatch_queue_t queue = dispatch_queue_create("com.wing.test", DISPATCH_QUEUE_CONCURRENT);
//    dispatch_async(queue, ^{
//        NSLog(@"call 1"); });
//    dispatch_async(queue, ^{
//        NSLog(@"call 2"); });
//    dispatch_async(queue, ^{
//        NSLog(@"call 3");
//    });
//dispatch_async(queue, ^{
//    NSLog(@"call 4");
//});
//dispatch_async(queue, ^{
//    NSLog(@"call 5");
//});
//    dispatch_async(queue, ^{
//        NSLog(@"call 6");
//    });
//    dispatch_async(queue, ^{
//        NSLog(@"call 7");
//    });
//    dispatch_async(queue, ^{
//        NSLog(@"call 8");
//    });
//    dispatch_async(queue, ^{
//        NSLog(@"call 9");
//    });
//    dispatch_async(queue, ^{
//        NSLog(@"call 10");
//    });
//    dispatch_async(queue, ^{
//        NSLog(@"call 11");
//    });
//    dispatch_async(queue, ^{
//        NSLog(@"call 12");
//    });
//
    dispatch_queue_t queue = dispatch_queue_create("com.wing.test", DISPATCH_QUEUE_CONCURRENT);
    double delayinSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayinSeconds *NSEC_PER_SEC));
    dispatch_after(popTime, queue, ^{
        NSLog(@"call1");
    });
    dispatch_async(queue, ^{
        NSLog(@"call2");
    });
    dispatch_async(queue, ^{
        NSLog(@"call3");
    });
    dispatch_async(queue, ^{
        NSLog(@"call4");
    }); dispatch_async(queue, ^{
        NSLog(@"call5");
    }); dispatch_async(queue, ^{
        NSLog(@"call6");
    }); dispatch_async(queue, ^{
        NSLog(@"call7");
    });
    
    
    
    
}

    
    
    
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
