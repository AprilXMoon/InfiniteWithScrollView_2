//
//  ViewController.m
//  infiniteScrollView
//
//  Created by April Lee on 2016/11/10.
//  Copyright © 2016年 april. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *infiniteScroll;
@property (strong, nonatomic) IBOutlet UILabel *pageNumber;

@property (strong, nonatomic) UIView *firstPageView;
@property (strong, nonatomic) UIView *secondPageView;
@property (strong, nonatomic) UIView *thirdPageView;

@property (copy, nonatomic) NSArray *colors;
@property (nonatomic) NSInteger centerIndex;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _colors = @[[UIColor grayColor],[UIColor greenColor],[UIColor redColor],[UIColor purpleColor],[UIColor brownColor]];
    _centerIndex = 0;
    
    _pageNumber.text = [NSString stringWithFormat:@"No. %li", (long)_centerIndex+1];
    
    _infiniteScroll.delegate = self;
    [self addsubView];
}

- (void)viewDidAppear:(BOOL)animated
{
    CGSize scrollSize = _infiniteScroll.frame.size;
    _infiniteScroll.contentSize = CGSizeMake(scrollSize.width * 3, scrollSize.height);
    _infiniteScroll.contentOffset = CGPointMake(scrollSize.width, 0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addsubView
{
    CGRect viewFrame = _infiniteScroll.frame;
    _firstPageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewFrame.size.width, viewFrame.size.height)];
    _firstPageView.backgroundColor = [_colors lastObject];
    
    _secondPageView = [[UIView alloc] initWithFrame:CGRectMake(viewFrame.size.width, 0, viewFrame.size.width, viewFrame.size.height)];
    _secondPageView.backgroundColor = [_colors firstObject];
    
    _thirdPageView = [[UIView alloc] initWithFrame:CGRectMake(viewFrame.size.width * 2, 0, viewFrame.size.width, viewFrame.size.height)];
    _thirdPageView.backgroundColor = _colors[1];
    
    [_infiniteScroll addSubview:_firstPageView];
    [_infiniteScroll addSubview:_secondPageView];
    [_infiniteScroll addSubview:_thirdPageView];
}

#pragma mark - resetView

- (void)resetViewColor
{
    _secondPageView.backgroundColor = _colors[_centerIndex];
    
    if (_centerIndex == 0) {
        _firstPageView.backgroundColor = [_colors lastObject];
        _thirdPageView.backgroundColor = _colors[_centerIndex + 1];
    } else if (_centerIndex == (_colors.count - 1)) {
        _firstPageView.backgroundColor = _colors[_centerIndex - 1];
        _thirdPageView.backgroundColor = [_colors firstObject];
    } else {
        _firstPageView.backgroundColor = _colors[_centerIndex - 1];
        _thirdPageView.backgroundColor = _colors[_centerIndex + 1];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x > scrollView.frame.size.width) {
        _centerIndex = (_centerIndex >= (_colors.count -1)) ? 0 : _centerIndex + 1;
        [self resetViewColor];
    }
    
    if (scrollView.contentOffset.x < scrollView.frame.size.width) {
        _centerIndex = (_centerIndex == 0) ? (_colors.count - 1) : _centerIndex - 1;
        [self resetViewColor];
    }
    
    NSInteger pageNumber = _centerIndex + 1;

    _pageNumber.text = [NSString stringWithFormat:@"No. %li", (long)pageNumber];

    CGFloat viewWidth = scrollView.frame.size.width;
    
    [scrollView setContentOffset:CGPointMake(viewWidth, 0) animated:NO];
}

@end
