//
//  ViewController.m
//  SystemAllFonts
//
//  Created by Rebecca on 2016/8/31.
//  Copyright © 2016年 Rebecca. All rights reserved.
//

#import "ViewController.h"

#define SCREEN_WIDTH   (getScreenSize().width)
#define SCREEN_HEIGHT  (getScreenSize().height)

#define DEFAULT_NAME    @"Hello！蕾貝卡！"

#define WORD_COLOR(A, B, C) [UIColor colorWithRed:A/255.0 green:B/255.0 blue:C/255.0 alpha:1]

@interface ViewController () <UITableViewDataSource, UITableViewDelegate> {
    UITableView *_mainTableView;
    
    NSArray *_fontFamilyNames;
    NSString *_showTextString;
}

@end

@implementation ViewController

#pragma mark - System Functions
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ([super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    //Test
    [self showAllFonts];
    
    CGRect rect;
    UIView *uiView;
    UIButton *button;
    UILabel *label;
    UIImageView *imageView;
    
    rect = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    imageView = [[UIImageView alloc] initWithFrame:rect];
    [imageView setBackgroundColor:[UIColor whiteColor]];
    [imageView setAlpha:0.1f];
    [[self view] addSubview:imageView];
    
    rect = CGRectMake(0, 0, SCREEN_WIDTH, 60);
    uiView = [[UIView alloc] initWithFrame:rect];
    [uiView setBackgroundColor:[UIColor whiteColor]];
    [[self view] addSubview:uiView];
    
    imageView = [[UIImageView alloc] initWithFrame:rect];
    [imageView setBackgroundColor:[UIColor blackColor]];
    [[self view] addSubview:imageView];
    
    rect.origin.y = rect.size.height - 2;
    rect.size.height = 2;
    label = [[UILabel alloc] initWithFrame:rect];
    [label setBackgroundColor:[UIColor whiteColor]];
    [[self view] addSubview:label];
    
    rect = CGRectMake(0, 15, 50, 30);
    rect.origin.x = SCREEN_WIDTH - rect.size.width - 5;
    label = [[UILabel alloc] initWithFrame:rect];
    [label setText:@"編 輯"];
    [label setTextColor:[UIColor lightTextColor]];
    [label setFont:[UIFont boldSystemFontOfSize:20]];
    [[self view] addSubview:label];
    
    button = [[UIButton alloc] initWithFrame:rect];
    [button setBackgroundColor:[UIColor clearColor]];
    [button addTarget:self action:@selector(onRightNavButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [[self view] addSubview:button];
    
    rect = CGRectMake(button.frame.size.width, 10, SCREEN_WIDTH - 2 * button.frame.size.width, 40);
    label = [[UILabel alloc] initWithFrame:rect];
    [label setText:@"iOS 全部字體兒"];
    [label setFont:[UIFont boldSystemFontOfSize:25]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setTextColor:[UIColor lightGrayColor]];
    [[self view] addSubview:label];
    
    
    //Datas
    _showTextString = DEFAULT_NAME;
    NSArray *arrTemp = [UIFont familyNames];
    _fontFamilyNames = [arrTemp sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2];
    }];
    
    //Views
    _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 60, SCREEN_WIDTH, SCREEN_HEIGHT - 60) style:UITableViewStyleGrouped];
    [_mainTableView setDelegate:self];
    [_mainTableView setDataSource:self];
    [_mainTableView setBackgroundColor:[UIColor clearColor]];
    [_mainTableView setSectionIndexBackgroundColor:[UIColor clearColor]];
    [[self view] addSubview:_mainTableView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Functions
CGSize getScreenSize() {
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    if ((NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_7_1) &&
        UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
        
        return CGSizeMake(screenSize.height, screenSize.width);
    }
    if (screenSize.width > screenSize.height) {
        return CGSizeMake(screenSize.height, screenSize.width);
    }
    return screenSize;
}

- (NSArray *)fontNamesOfSection:(NSInteger)aSection {
    NSArray *ret;
    
    if (_fontFamilyNames && aSection < _fontFamilyNames.count) {
        NSString *familyName = [_fontFamilyNames objectAtIndex:aSection];
        ret = [UIFont fontNamesForFamilyName:familyName];
    }
    
    return ret;
}
- (NSString *)fontNameOfIndexPath:(NSIndexPath *)aIndexPath {
    NSArray *arr = [self fontNamesOfSection:aIndexPath.section];
    if (arr && aIndexPath.row < arr.count) {
        return [arr objectAtIndex:aIndexPath.row];
    } else {
        return nil;
    }
}
- (void)showAllFonts {
    NSArray *familyNames = [UIFont familyNames];
    for(NSString *familyName in familyNames) {
        printf("Family: %s \n",[familyName UTF8String]);
        NSArray *fontNames = [UIFont fontNamesForFamilyName:familyName];
        for(NSString *fontName in fontNames) {
            printf("\tFont: %s \n",[fontName UTF8String]);
        }
    }
}

- (void)onRightNavButtonClick:(UIButton *)aSender {
    UIAlertView *dialog = [[UIAlertView alloc]
                           initWithTitle:@"請輸入文字"
                           message:nil
                           delegate:self
                           cancelButtonTitle:@"取消"
                           otherButtonTitles:@"OK", nil];
    dialog.alertViewStyle = UIAlertViewStylePlainTextInput;
    [dialog textFieldAtIndex:0].text = _showTextString;
    [dialog show];
}

#pragma mark - AlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        _showTextString = [[alertView textFieldAtIndex:0] text];
        [_mainTableView reloadData];
    }
}

#pragma mark - UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_fontFamilyNames count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *arr = [self fontNamesOfSection:section];
    if (arr) {
        return [arr count];
    } else {
        return 0;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellID = @"cellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    
    NSString *fontName = [self fontNameOfIndexPath:indexPath];
    if (_showTextString == nil || _showTextString.length == 0) {
        cell.textLabel.text = DEFAULT_NAME;
    } else {
        cell.textLabel.text = _showTextString;
    }
    cell.textLabel.font = [UIFont fontWithName:fontName size:28];
    
    cell.detailTextLabel.text = fontName;
    
    [[cell textLabel] setTextColor:[UIColor blackColor]];
    [[cell detailTextLabel] setTextColor:[UIColor blackColor]];
    
    [cell.contentView setBackgroundColor:[UIColor clearColor]];
    [cell setBackgroundColor:[UIColor lightTextColor]];
    [cell setAlpha:0.96f];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [_fontFamilyNames objectAtIndex:section];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *fontName = [_fontFamilyNames objectAtIndex:[indexPath section]];
    if (fontName && [fontName isEqualToString:@"Zapfino"]) {
        return 120;
    } else {
        return 80;
    }
}

@end

