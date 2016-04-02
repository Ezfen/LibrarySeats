//
//  VenueSeatsViewController.m
//  LibrarySeats
//
//  Created by 阿澤🍀 on 16/3/26.
//  Copyright © 2016年 阿澤. All rights reserved.
//

#import "VenueSeatsViewController.h"
#import "TipsView.h"
#import "Tip.h"

@interface VenueSeatsViewController ()
@property (strong, nonatomic) TipsView *tipView;
@end

@implementation VenueSeatsViewController

- (TipsView *)tipView {
    if (!_tipView) {
        //添加提示View
        _tipView = [[TipsView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 25)];
        _tipView.backgroundColor = [UIColor whiteColor];
        _tipView.layer.borderWidth = 0.5;
        _tipView.layer.borderColor = [UIColor grayColor].CGColor;
        Tip *green = [[Tip alloc] initWithTipColor:[UIColor greenColor] andTipDetail:@"<20Min"];
        Tip *yellow = [[Tip alloc] initWithTipColor:[UIColor yellowColor] andTipDetail:@"20-40Min"];
        Tip *red = [[Tip alloc] initWithTipColor:[UIColor redColor] andTipDetail:@">40Min"];
        NSDictionary *dic = @{@(1):green,@(2):yellow,@(3):red};
        _tipView.tips = dic;
    }
    return _tipView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tipView];
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
