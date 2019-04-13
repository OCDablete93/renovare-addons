@import WebKit;




NSString *firstaidpath = @"Applications/Cydia.app/addonicon.png";   ///Make Sure to change the filename
static UINavigationController* replace;

static NSString* tabTitle = @"tabTitle";
static NSString* webpageURL = @"http://iosjailbreak.xyz";

@interface ReplaceWebTabController : UIViewController
{
    WKWebView* webView;
}
@end

@implementation ReplaceWebTabController
-(void)loadView
{
    [super loadView];
    //set the web controller's title
    self.navigationItem.title = tabTitle;

    //create the web controller
    webView = [WKWebView new];
    [self.view addSubview:webView];
    //give the web controller the correct constraints:
    webView.translatesAutoresizingMaskIntoConstraints = NO;
    [webView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [webView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
    [webView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
    [webView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;

    //load the URL:
    NSURL* url = [NSURL URLWithString:webpageURL];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
}
@end

%hook Cydia
//needed to stop it from crashing
-(NSArray*)defaultStartPages
{
    //add another page to cydia's array to avoid an index out of bounds exception
    NSMutableArray* pages = [%orig mutableCopy];
    [pages addObject:@[@""]];
    return [pages copy];
}

//needed because cydia overwrites anything we set in setViewControllers :(
-(void)loadData
{
    %orig;
    //set the nav controller's view controller to our web controller
    ReplaceWebTabController* webVC = [ReplaceWebTabController new];
    [replace setViewControllers:@[webVC]];

}
%end

%hook CydiaTabBarController
-(void)setViewControllers:(NSArray *)arg2
{
    //get a mutable copy of the view controllers
    NSMutableArray* controllers = [arg2 mutableCopy];
    //create the new nav controller
    replace = [[UINavigationController alloc] init];

    //TODO: set this too:
    UIImage* tabImg = [UIImage imageWithContentsOfFile:firstaidpath];

    //set the tab bar item information
    replace.tabBarItem = [[UITabBarItem alloc] initWithTitle:tabTitle image:tabImg tag:0];
    //add the new view controller
    [controllers addObject:replace];
    //run %orig with an immutable copy
    %orig([controllers copy]);
}
%end
