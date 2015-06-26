//
//  WHUSliderView.m
//  WHUSliderViewSample
//
//  Created by SuperNova on 15/6/14.
//  Copyright (c) 2015年 taivex2. All rights reserved.
//

#import "WHUSliderView.h"
static CGFloat kWHUTopScrollViewHeight=40.0f;
static CGFloat kWHUTopScrollViewBtnPadding=5.0f;
static CGFloat kWHUSelectedLabelHeight=2.0f;
@interface WHUSliderView()<UIScrollViewDelegate>
@property(nonatomic,strong) UIScrollView* topScrollView;
@property(nonatomic,strong) UIScrollView* bottomScrollView;
@property(nonatomic,strong) UIView* topConView;
@property(nonatomic,strong) UIView* bottomConView;
@property(nonatomic,strong) NSLayoutConstraint* topWidthCts;
@property(nonatomic,strong) NSLayoutConstraint* bottomWidthCts;
@property(nonatomic,strong) NSLayoutConstraint* selectPosCts;
@property(nonatomic,assign) CGFloat maxBtnWidth;
@property(nonatomic,strong) NSArray* titelArray;
@property(nonatomic,strong) UIButton* firstBtn;
@property(nonatomic,strong) UIButton* selectedBtn;
@property(nonatomic,strong) UILabel* selectLbl;
@property(nonatomic,assign) BOOL isConstructed;
@end
@implementation WHUSliderView
-(void)setupViewComponts{
    self.topBtnWidth=-1;
    self.isConstructed=NO;
    self.topScrollView=[[UIScrollView alloc] init];
    _topScrollView.showsHorizontalScrollIndicator=NO;
    _topScrollView.showsVerticalScrollIndicator=NO;
    _topScrollView.translatesAutoresizingMaskIntoConstraints=NO;
    [self addSubview:_topScrollView];
    self.bottomScrollView=[[UIScrollView alloc] init];
    _bottomScrollView.showsVerticalScrollIndicator=NO;
    _bottomScrollView.showsHorizontalScrollIndicator=NO;
    _bottomScrollView.pagingEnabled=YES;
    _bottomScrollView.delegate=self;
    _bottomScrollView.translatesAutoresizingMaskIntoConstraints=NO;
    UILabel* line=[[UILabel alloc] init];
    line.translatesAutoresizingMaskIntoConstraints=NO;
    line.backgroundColor=[UIColor lightGrayColor];
    [self addSubview:line];
    NSDictionary* viewDic=@{@"topScroll":_topScrollView,@"contentScroll":_bottomScrollView,@"line":line};
    [self addSubview:_bottomScrollView];
    NSDictionary* mertircs=@{@"topScrollHeight":@(kWHUTopScrollViewHeight)};
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[topScroll]|" options:0 metrics:nil views:viewDic]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[topScroll(==topScrollHeight)]" options:0 metrics:mertircs views:viewDic]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[contentScroll]|" options:0 metrics:nil views:viewDic]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[topScroll]-1-[contentScroll]|" options:0 metrics:mertircs views:viewDic]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[line]|" options:0 metrics:nil views:viewDic]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[topScroll]-0-[line(==1)]" options:0 metrics:mertircs views:viewDic]];
    
    [self addContentViewWith:_topScrollView];
    [self addContentViewWith:_bottomScrollView];
}



-(void)layoutSubviews{
    [super layoutSubviews];
    if(!self.isConstructed)
    {
        [self p_constructUI];
    }
    
    if(_controllerArray!=nil){
        _bottomWidthCts.constant=(_controllerArray.count-1)*self.bounds.size.width;
    }
    
    if(_selectedBtn!=nil){
        CGPoint p=_bottomScrollView.contentOffset;
        p.x=(_selectedBtn.tag-1000)*self.bounds.size.width;
        _bottomScrollView.contentOffset=p;
        [self adjustTopScrollViewBtnPos:_selectedBtn];
    }
    [super layoutSubviews];
}

-(void)p_constructUI{
    if(_controllerArray==nil||_controllerArray.count==0)
        return;
    self.isConstructed=YES;
    UIView* preView=nil;
    for(int i=0;i<_controllerArray.count;i++){
        UIViewController* itemVc=_controllerArray[i];
        UIView* tempView=itemVc.view;
        tempView.translatesAutoresizingMaskIntoConstraints=NO;
        [_bottomConView addSubview:tempView];
        if(preView==nil){
            NSDictionary* viewDic=@{@"tempView":tempView,@"scrollView":_bottomScrollView};
            [_bottomScrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tempView(==scrollView)]" options:0 metrics:nil views:viewDic]];
            [_bottomScrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[tempView]|" options:0 metrics:nil views:viewDic]];
        }
        else{
            NSDictionary* viewDic=@{@"tempView":tempView,@"scrollView":_bottomScrollView,@"preView":preView};;
            [_bottomScrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[preView]-0-[tempView(==preView)]" options:0 metrics:nil views:viewDic]];
            [_bottomScrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[tempView]|" options:0 metrics:nil views:viewDic]];
        }
        preView=tempView;
    }
    if(_controllerArray!=nil&&_controllerArray.count>0){
        self.titelArray=[_controllerArray valueForKeyPath:@"title"];
    }
    [self makeButtonItems];
    [self setupSelectLbl];
}

-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if(self){
        self.selectedColor=[UIColor blueColor];
        [self setupViewComponts];
    }
    return  self;
}



-(id)initWithCoder:(NSCoder *)aDecoder{
    self=[super initWithCoder:aDecoder];
    if(self){
    self.selectedColor=[UIColor blueColor];
    [self setupViewComponts];
    }
    return self;
}


-(void)addContentViewWith:(UIScrollView*)scrollView{
    UIView* tempConView=[[UIView alloc] init];
    tempConView.translatesAutoresizingMaskIntoConstraints=NO;
    NSDictionary* viewDic=NSDictionaryOfVariableBindings(tempConView,scrollView);
    [scrollView addSubview:tempConView];
    [scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tempConView]|" options:0 metrics:nil views:viewDic]];
    [scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[tempConView]|" options:0 metrics:nil views:viewDic]];
    [scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[tempConView(==scrollView)]" options:0 metrics:nil views:viewDic]];
    if([scrollView isEqual:_topScrollView]){
        self.topConView=tempConView;
        self.topWidthCts=[NSLayoutConstraint constraintWithItem:tempConView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:scrollView attribute:NSLayoutAttributeWidth multiplier:1 constant:0];
        [scrollView addConstraint:self.topWidthCts];
    }
    else{
        self.bottomConView=tempConView;
        self.bottomWidthCts=[NSLayoutConstraint constraintWithItem:tempConView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:scrollView attribute:NSLayoutAttributeWidth multiplier:1 constant:0];
        [scrollView addConstraint:self.bottomWidthCts];
    }
}

-(void)makeButtonItems{
    CGFloat maxWidth=-1.0f;
    NSDictionary* matrics=nil;
    CGFloat btnHeight=kWHUTopScrollViewHeight-kWHUSelectedLabelHeight;
    if(_topBtnWidth<0){
        NSSortDescriptor* sorter=[[NSSortDescriptor alloc] initWithKey:@"length" ascending:NO];
        NSArray* sortedArray=[_titelArray sortedArrayUsingDescriptors:@[sorter]];
        NSString* maxLenString=sortedArray.firstObject;
        CGSize temp=[maxLenString sizeWithFont:[UIFont systemFontOfSize:13.0f] constrainedToSize:CGSizeMake(1000, kWHUTopScrollViewHeight) lineBreakMode:NSLineBreakByCharWrapping];
        maxWidth=temp.width;
        maxWidth+=2*kWHUTopScrollViewBtnPadding;
        matrics=@{@"btnWidth":@(maxWidth),@"btnHeight":@(btnHeight)};
        self.maxBtnWidth=maxWidth;
    }
    else{
        matrics=@{@"btnWidth":@(self.topBtnWidth),@"btnHeight":@(btnHeight)};
        self.maxBtnWidth=_topBtnWidth;
    }
    UIButton* preBtn=nil;
    for(int i=0;i<_titelArray.count;i++){
        UIButton* btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag=1000+i;
        btn.translatesAutoresizingMaskIntoConstraints=NO;
        btn.titleLabel.font=[UIFont systemFontOfSize:13.0f];
        btn.userInteractionEnabled=YES;
        [btn setTitle:_titelArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:_selectedColor forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnSelectedAction:) forControlEvents:UIControlEventTouchUpInside];
        [_topConView addSubview:btn];
        if(preBtn==nil){
            NSDictionary* viewDic=NSDictionaryOfVariableBindings(btn);
            [_topConView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[btn(==btnWidth)]" options:0 metrics:matrics views:viewDic]];
            [_topConView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[btn(==btnHeight)]" options:0 metrics:matrics views:viewDic]];
            self.firstBtn=btn;
        }
        else{
            NSDictionary* viewDic=NSDictionaryOfVariableBindings(btn,preBtn);
            [_topConView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[preBtn]-0-[btn(==btnWidth)]" options:0 metrics:matrics views:viewDic]];
            [_topConView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[btn(==btnHeight)]" options:0 metrics:matrics views:viewDic]];
        }
        preBtn=btn;
    }
    
    CGFloat widthMore=_titelArray.count*maxWidth-_topScrollView.frame.size.width;
    if(widthMore>0){
        _topWidthCts.constant=widthMore;
    }
}

-(void)setupSelectLbl;
{
    if(_selectLbl==nil){
        _selectLbl=[[UILabel alloc] init];
        _selectLbl.translatesAutoresizingMaskIntoConstraints=NO;
        _selectLbl.backgroundColor=_selectedColor;
        [_topConView addSubview:_selectLbl];
    }
    NSDictionary* metrics=@{@"lblHeight":@(kWHUSelectedLabelHeight),@"lblWidth":@(_maxBtnWidth)};
    NSDictionary* viewDic=@{@"selLbl":_selectLbl};
    [_topConView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[selLbl(==lblHeight)]|" options:0 metrics:metrics views:viewDic]];
    [_topConView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[selLbl(==lblWidth)]" options:0 metrics:metrics views:viewDic]];
    self.selectPosCts=[NSLayoutConstraint constraintWithItem:_selectLbl attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_topConView attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
    [_topConView addConstraint:_selectPosCts];
}

-(void)btnSelectedAction:(UIButton*)btn{
    self.selectedBtn=btn;
    _selectPosCts.constant=btn.frame.origin.x;
    for(int i=0;i<_titelArray.count;i++){
        UIButton* b=(UIButton*)[_topConView viewWithTag:1000+i];
        b.selected=NO;
    }
    CGPoint p=_bottomScrollView.contentOffset;
    p.x=(btn.tag-1000)*_bottomScrollView.frame.size.width;
    [UIView animateWithDuration:0.3 animations:^(void){
        [self.topConView setNeedsLayout];
        [self.topConView layoutIfNeeded];
        self.bottomScrollView.contentOffset=p;
        [self adjustTopScrollViewBtnPos:btn];
    } completion:^(BOOL finished){
        btn.selected=YES;
    }];
}

-(void)adjustTopScrollViewBtnPos:(UIButton*)btn{

        CGFloat offset=0;
        CGPoint rp=self.topScrollView.contentOffset;
        CGRect r=[self convertRect:btn.bounds fromView:btn];
        if(r.origin.x<0){
            offset=r.origin.x;
            rp.x+=offset;
            rp.x-=self.maxBtnWidth;
            rp.x=(rp.x<0)?0:rp.x;
            self.topScrollView.contentOffset=rp;
        }
        else{
            offset=(r.origin.x+btn.frame.size.width-self.bounds.size.width);
            if(offset>0){
                rp.x+=offset;
                rp.x+=self.maxBtnWidth;
                CGFloat temp=self.topConView.frame.size.width-self.bounds.size.width;
                rp.x=rp.x>temp?temp:rp.x;
                self.topScrollView.contentOffset=rp;
            }
        }

}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGPoint c=scrollView.contentOffset;
    NSInteger i=c.x/_bottomScrollView.frame.size.width;
    UIButton* b=(UIButton*)[_topConView viewWithTag:1000+i];
    self.selectPosCts.constant=b.frame.origin.x;
    [self btnSelectedAction:b];
}

@end
