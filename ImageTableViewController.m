//
//  ImageTableViewController.m
//  NetworkingMiniProject
//
//  Created by 한상욱 on 2016. 11. 16..
//  Copyright © 2016년 HsoCompany. All rights reserved.
//

#import "ImageTableViewController.h"

@interface ImageTableViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>


@end

@implementation ImageTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self.tableView
selector:@selector(reloadData)
name:ImageLIstUpdateNotification
                                               object:nil];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ( [[[UserInformation sharedUserInfo] userId] isEqualToString:self.navigationItem.title] == NO) {
        [self showUserIdAlert];
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickRefreshButton:(id)sender {// 사진 리스트 요청
    [RequesetObject requestimageList];
}

- (IBAction)clickAddButton:(id)sender { //이미지 피커를 보여주기
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    [imagePicker setDelegate:self];
    [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    
    [self presentViewController:imagePicker
                       animated:YES
                     completion:nil];
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *image = nil;
    
    if( info[UIImagePickerControllerEditedImage]) {
        image = info[UIImagePickerControllerEditedImage];
    } else {
        image = info[UIImagePickerControllerEditedImage];
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"사진제목"
                                                                   message:@"사진제목을 입력해 주세요"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    id okHandler = ^(UIAlertAction * _Nonnull action) {
        if(alert.textFields.firstObject.text.length == 0) {
        } else {
            NSString *imageTitle = alert.textFields.firstObject.text;
            
            NSLog(@"사진 제목 : %@", imageTitle);
            
            [RequesetObject requestUploadImage:image title:imageTitle];
    }
    
    };
 UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"확인"
                                                    style:UIAlertActionStyleDefault
                                                  handler:okHandler];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"취소"
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    
    [alert addAction:cancelAction];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder=@"사진제목";
    }];
    [alert addAction:okAction];
    [picker dismissViewControllerAnimated:YES
                               completion:^{
                                   [self presentViewController:alert animated:YES completion:nil];
                               }];
}
#pragma mark - Table view data source
-(void) showUserIdAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"유저 ID 입력"
                                                                   message:@"유저 ID를 입력해 주세요"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    id actionHandler = ^(UIAlertAction * _Nonnull action) {
        if (alert.textFields.firstObject.text.length == 0 ||
            [alert.textFields.firstObject.text containsString:@" "] ||
            [alert.textFields.firstObject.text integerValue]==0) {
            [self showUserIdAlert];
        } else {
            [[UserInformation sharedUserInfo] setUserId:alert.textFields.firstObject.text];
            self.navigationItem.title = alert.textFields.firstObject.text;
            
            [RequesetObject requestimageList];
        }
    };
    
    UIAlertAction *okAciton = [UIAlertAction actionWithTitle:@"확인"
                                                       style:UIAlertActionStyleDefault
                                                     handler:actionHandler];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"100~150 사이의 숫자";
        textField.keyboardType = UIKeyboardTypeNumberPad;
    }];
    [alert addAction:okAciton];
    
    [self presentViewController:alert animated:YES
                     completion:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return [[[UserInformation sharedUserInfo] imageInfoList] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ImageCell"
                                                            forIndexPath:indexPath];
    
    NSDictionary *imageInfoDic = [[[UserInformation sharedUserInfo] imageInfoList] objectAtIndex:indexPath.row];
    NSString *imageTitle = [imageInfoDic objectForKey:@"title"];
    NSString *thumbnailURLString = [imageInfoDic objectForKey:@"thumbnail_url"];
    NSURL *thumbnailURL = [NSURL URLWithString:thumbnailURLString];

    id imageTaskHandler = ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        UIImage *image = [UIImage imageWithData:data];
        
        dispatch_async(dispatch_get_main_queue(), ^{
//            cell.imageView.image = image;
            UITableViewCell *cellForUpdate = [tableView cellForRowAtIndexPath:indexPath];
            cellForUpdate.imageView.image = image;
        });
        
        
    };
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:thumbnailURL
                                            completionHandler:imageTaskHandler];

    [dataTask resume];
    
    [[cell textLabel] setText:imageTitle];
    
    
    
    
    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//     Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
