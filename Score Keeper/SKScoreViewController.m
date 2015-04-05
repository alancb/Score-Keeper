//
//  SKScoreViewController.m
//  Score Keeper
//
//  Created by Alan Barth on 4/1/15.
//  Copyright (c) 2015 DevMountain. All rights reserved.
//

#import "SKScoreViewController.h"



static CGFloat scoreViewHeight = 90;
static CGFloat margin = 20;

@interface SKScoreViewController () <UITextFieldDelegate> //What is this?

@property (nonatomic, strong) NSMutableArray *scoreLabels;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSMutableArray *scoreViews;
@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) UIButton *removeButton;

@end

@implementation SKScoreViewController



-(void) viewDidLoad{
    [super viewDidLoad];
    
    self.title = @"Score Keeper";
    
    self.scoreLabels = [NSMutableArray new];
    self.scoreViews = [NSMutableArray new];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height -64)];
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    for (NSInteger i = 0; i < 4; i++) {
        [self addScoreView:i];
    }
    
}

- (void) addScoreView: (NSInteger) index {
    CGFloat nameWidth = 90;
    CGFloat scoreWidth = 60;
    CGFloat stepperWidth = 90;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, index * scoreViewHeight, self.view.frame.size.width, scoreViewHeight)];
    
    UITextField *name = [[UITextField alloc] initWithFrame:CGRectMake(margin, margin, nameWidth, 44)];
    name.placeholder = @"Name";
    name.tag = -1000; //Figure out what this does.
    name.delegate = self;
    [view addSubview:name];
    
    UILabel *score = [[UILabel alloc] initWithFrame:CGRectMake(margin + nameWidth, margin, scoreWidth, 44)];
    [self.scoreLabels addObject:score];
    [view addSubview:score];
    
    
    UIStepper *stepper = [[UIStepper alloc] initWithFrame:CGRectMake(60 + nameWidth + scoreWidth, 30, stepperWidth, 44)];
    stepper.maximumValue = 1000;
    stepper.minimumValue = -1000;
    stepper.tag = index;
    [stepper addTarget:self action:@selector(stepperChanged:) forControlEvents:UIControlEventValueChanged];
    [view addSubview:stepper];
    
    [self.scoreViews addObject:view];
    [self.scrollView addSubview:view];

}

- (void)stepperChanged:(id)sender {
    
    UIStepper *stepper = sender;
    NSInteger index = stepper.tag;
    double value = [stepper value];
    
    UILabel *scoreLabel = self.scoreLabels[index];
    scoreLabel.text = [NSString stringWithFormat:@"%d", (int)value];

}

- (void) updateButtonView: (id) sender {
    CGFloat buttonWidth = 130;
    
    if (!self.addButton) {
        UIButton *addButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [addButton setTitle:@"Add Score" forState: UIControlStateNormal];
        [addButton addTarget:self action:@selector(addScoreView:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:addButton];
        
        self.addButton = addButton;
    }
    self.addButton.frame = CGRectMake(20, ([self.scoreViews count] * scoreViewHeight) + 23, buttonWidth, 44);
    if (!self.removeButton) {
        UIButton *removeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [removeButton setTitle:@"Remove Score" forState:UIControlStateNormal];
        [removeButton addTarget:self action:@selector (removeLastScore:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:removeButton];
        
        self.removeButton = removeButton;
    }
    self.removeButton.frame = CGRectMake(170, ([self.scoreViews count] * scoreViewHeight +23), buttonWidth, 44);
    
    [self updateScrollViewContentSize];
    
}

- (void) updateScrollViewContentSize {
    self.scrollView.contentSize=CGSizeMake(self.view.frame.size.width, [self scrollViewContentHeight]);
}

-(CGFloat) scrollViewContentHeight {
    return ([self.scoreViews count] + 1 * scoreViewHeight);
}


- (void) removeLastScore: (id)sender {
    UIView *view = self.scoreViews.lastObject;
    [view removeFromSuperview];
    
}

- (BOOL) textFieldShouldReturn: (UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
