
#import "ZTypewriteEffectLabel.h"

@implementation ZTypewriteEffectLabel
{
    NSTimer*timer;
    int i;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.hasSound = YES;
        self.typewriteTimeInterval = 0.3;
        self.currentIndex=1;
        i=0;
    }
    return self;
}

-(void)startTypewrite
{
    _isTyping=YES;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"click" ofType:@"wav"];
    
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &soundID);

    timer=[NSTimer scheduledTimerWithTimeInterval:self.typewriteTimeInterval target:self selector:@selector(outPutWord) userInfo:nil repeats:YES];
}

-(void)outPutWord
{
    
    if (self.text.length < self.currentIndex) {
       [timer invalidate];
        timer = nil;
        self.typewriteEffectBlock();
    }else{
        
        NSDictionary *dic = @{NSForegroundColorAttributeName: self.typewriteEffectColor};
        NSMutableAttributedString *mutStr = [[NSMutableAttributedString alloc] initWithString:self.text];
        [mutStr addAttributes:dic range:NSMakeRange(0, self.currentIndex)];
        [self setAttributedText:mutStr];
        
        i++;
        int r=rand()%2+2;
        if (i%r==0)
        {
            self.hasSound? AudioServicesPlaySystemSound (soundID):AudioServicesPlaySystemSound (0);
        }
        self.currentIndex+=2;
    }
}

-(void)dealloc
{
    if (timer)
    {
        [timer invalidate];
        timer = nil;
    }
}

-(void)stopAndShowAllText
{
    if (!_isDone)
    {
        [self stop];
        NSDictionary *dic = @{NSForegroundColorAttributeName: self.typewriteEffectColor};
        NSMutableAttributedString *mutStr = [[NSMutableAttributedString alloc] initWithString:self.text];
        [mutStr addAttributes:dic range:NSMakeRange(0, self.text.length)];
        [self setAttributedText:mutStr];
        _currentIndex=self.text.length;
        _isDone=YES;
        self.typewriteEffectBlock();
    }
    
}

-(void)stop
{
    _isTyping=NO;
    if (timer)
    {
        NSLog(@"停止打字计时器");
        [timer invalidate];
        timer = nil;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
