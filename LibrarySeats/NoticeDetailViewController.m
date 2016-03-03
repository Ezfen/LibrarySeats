//
//  NoticeDetailViewController.m
//  LibrarySeats
//
//  Created by 阿澤🍀 on 16/3/3.
//  Copyright © 2016年 阿澤. All rights reserved.
//

#import "NoticeDetailViewController.h"

@interface NoticeDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@end

@implementation NoticeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.titleLabel.text = self.noticeTitle;
    self.timeLabel.text = self.noticeTime;
    self.authorLabel.text = @"华南师范大学";
    self.contentTextView.text = self.noticeContent;
    [self.contentTextView scrollRangeToVisible:NSMakeRange(0, 1)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
