//
//  Created by Marat Alekperov (aka Timur Harleev) (m.alekperov@gmail.com) on 18.11.12.
//  Copyright (c) 2012 Me and Myself. All rights reserved.
//


#import "THChatInput.h"

@interface NSString (THChatInput)
@end

@implementation NSString (THChatInput)

- (CGSize) sizeForFont:(UIFont *)font
{
    if ([self respondsToSelector:@selector(sizeWithAttributes:)])
    {
        NSDictionary* attribs = @{NSFontAttributeName:font};
        return ([self sizeWithAttributes:attribs]);
    }
    return ([self sizeWithFont:font]);
}

- (CGSize) sizeForFont:(UIFont*)font
        constrainedToSize:(CGSize)constraint
            lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    CGSize size;
    if ([self respondsToSelector:@selector(sizeWithAttributes:)])
    {
        NSDictionary *attributes = @{NSFontAttributeName:font};
        
        CGSize boundingBox = [self boundingRectWithSize:constraint options: NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
        
        size = CGSizeMake(ceil(boundingBox.width), ceil(boundingBox.height));
    }
    else
    {
        size = [self sizeWithFont:font constrainedToSize:constraint lineBreakMode:lineBreakMode];
    }
    
    return size;
}

@end

@implementation THChatInput

static BOOL isIos7;

+ (BOOL)isIOS7
{
    return isIos7;
}

- (void) composeView
{
    isIos7 = [[[UIDevice currentDevice] systemVersion] floatValue]>=7;
    
    topGap = isIos7 ? 8 : 12;
   
    CGSize size = self.frame.size;
   
   // Input
	_inputBackgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
	_inputBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
   _inputBackgroundView.contentMode = UIViewContentModeScaleToFill;
	//_inputBackgroundView.userInteractionEnabled = YES;
   //_inputBackgroundView.alpha = .5;
   _inputBackgroundView.backgroundColor = [UIColor clearColor];
   //_inputBackgroundView.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:.5];
	[self addSubview:_inputBackgroundView];
   [_inputBackgroundView release];
   
    _textViewBackgroundView = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    _textViewBackgroundView.borderStyle = UITextBorderStyleRoundedRect;
	_textViewBackgroundView.autoresizingMask = UIViewAutoresizingNone;
    _textViewBackgroundView.userInteractionEnabled = NO;
    _textViewBackgroundView.enabled = NO;
//    _textViewBackgroundView.contentMode = UIViewContentModeScaleToFill;
 //   _textViewBackgroundView.backgroundColor = [UIColor clearColor];
	[self addSubview:_textViewBackgroundView];
    [_textViewBackgroundView release];
    
	// Text field
	_textView = [[UITextView alloc] initWithFrame:CGRectMake(70.0f, topGap, 185, 0)];
   _textView.backgroundColor = [UIColor clearColor];
   //_textView.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:.3];
	_textView.delegate = self;
   _textView.contentInset = UIEdgeInsetsMake(-4, -2, -4, 0);
   _textView.showsVerticalScrollIndicator = NO;
   _textView.showsHorizontalScrollIndicator = NO;
    _textView.returnKeyType = UIReturnKeySend;
	_textView.font = [UIFont systemFontOfSize:15.0f];
	[self addSubview:_textView];
   [_textView release];
   
   [self adjustTextInputHeightForText:@"" animated:NO];
   
   _lblPlaceholder = [[UILabel alloc] initWithFrame:CGRectMake(78.0f, topGap+2, 160, 20)];
   _lblPlaceholder.font = [UIFont systemFontOfSize:15.0f];
   _lblPlaceholder.text = @"Type here...";
   _lblPlaceholder.textColor = [UIColor lightGrayColor];
   _lblPlaceholder.backgroundColor = [UIColor clearColor];
	[self addSubview:_lblPlaceholder];
   [_lblPlaceholder release];
   
	// Attach buttons
	_attachButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _attachButton.hidden = YES;
	_attachButton.frame = CGRectMake(6.0f, topGap, 26.0f, 27.0f);
	_attachButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
   [_attachButton addTarget:self action:@selector(showAttachInput:) forControlEvents:UIControlEventTouchUpInside];
	[self addSubview:_attachButton];
   [_attachButton release];
	
	_emojiButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	_emojiButton.frame = CGRectMake(12.0f + _attachButton.frame.size.width, topGap, 26.0f, 27.0f);
    _emojiButton.hidden = YES;
	_emojiButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
   [_emojiButton addTarget:self action:@selector(showEmojiInput:) forControlEvents:UIControlEventTouchUpInside];
	[self addSubview:_emojiButton];
   [_emojiButton release];
	
	// Send button
	_sendButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	_sendButton.frame = CGRectMake(size.width - 64.0f, 12.0f, 58.0f, 27.0f);
    _sendButton.hidden = YES;
	_sendButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
   //	[_sendButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.4f] forState:UIControlStateNormal];
   //	[_sendButton setTitleShadowColor:[UIColor colorWithRed:0.325f green:0.463f blue:0.675f alpha:1.0f] forState:UIControlStateNormal];
   [_sendButton addTarget:self action:@selector(sendButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	[self addSubview:_sendButton];
   [_sendButton release];
   
   [self sendSubviewToBack:_inputBackgroundView];
    
    if (isIos7)
    {
        self.backgroundColor = [UIColor colorWithRed:(0xD9 / 255.0) green:(0xDC / 255.0) blue:(0xE0 / 255.0) alpha:1.0];
        [_sendButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_sendButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    }
    else
    {
        self.backgroundColor = [UIColor clearColor];
        _inputBackgroundView.image = [[UIImage imageNamed:@"Chat_Footer_BG.png"] stretchableImageWithLeftCapWidth:80 topCapHeight:25];
        
        [_sendButton setBackgroundImage:[UIImage imageNamed:@"Chat_Send_Button.png"] forState:UIControlStateNormal];
        [_sendButton setBackgroundImage:[UIImage imageNamed:@"Chat_Send_Button_Pressed.png"] forState:UIControlStateHighlighted];
        [_sendButton setBackgroundImage:[UIImage imageNamed:@"Chat_Send_Button_Pressed.png"] forState:UIControlStateSelected];
        _sendButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14];
        _sendButton.titleLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
        [_sendButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_sendButton setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];

    }
    
	[_attachButton setBackgroundImage:[UIImage imageNamed:@"Chat_Footer_ArrowUp.png"] forState:UIControlStateNormal];
	[_attachButton setBackgroundImage:[UIImage imageNamed:@"Chat_Footer_ArrowUp_Pressed.png"] forState:UIControlStateHighlighted];
	[_attachButton setBackgroundImage:[UIImage imageNamed:@"Chat_Footer_ArrowUp_Pressed.png"] forState:UIControlStateSelected];
    
	[_emojiButton setBackgroundImage:[UIImage imageNamed:@"Chat_Footer_Smiley_Icon.png"] forState:UIControlStateNormal];
	[_emojiButton setBackgroundImage:[UIImage imageNamed:@"Chat_Footer_Smiley_Icon_Pressed.png"] forState:UIControlStateHighlighted];
	[_emojiButton setBackgroundImage:[UIImage imageNamed:@"Chat_Footer_Smiley_Icon_Pressed.png"] forState:UIControlStateSelected];
    
	[_sendButton setTitle:@"Send" forState:UIControlStateNormal];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat x = 70;
    CGFloat w = self.frame.size.width - _attachButton.frame.size.width - _emojiButton.frame.size.width - 10 - (_sendButton.hidden ? 0 : (_sendButton.frame.size.width+12+3));
    CGFloat d = 0;
    if (_attachButton.hidden) { d = _attachButton.frame.size.width; }
    else d = 0;
    x = x - d; w = w + d;
    if (_emojiButton.hidden) { d = _emojiButton.frame.size.width; }
    else d = 0;
    x = x - d; w = w + d;
    
    if (_attachButton.hidden && _emojiButton.hidden)
        x = 5;
    
    _textView.frame = CGRectMake(x, _textView.frame.origin.y, w, _textView.frame.size.height);
    CGRect f = _textView.frame;
    f.size.height = f.size.height+(isIos7?3:0);
    _textViewBackgroundView.frame = f;
    _lblPlaceholder.frame = CGRectMake(x+8, topGap+2, 160, 20);
    
    _sendButton.frame = CGRectMake(_sendButton.frame.origin.x,topGap,_sendButton.frame.size.width,_sendButton.frame.size.height);
}

- (void) awakeFromNib
{
   _inputHeight = 38.0f;
   _inputHeightWithShadow = 44.0f;
   _autoResizeOnKeyboardVisibilityChanged = YES;

   [self composeView];
}

- (void) adjustTextInputHeightForText:(NSString*)text animated:(BOOL)animated
{
   int h1 = [text sizeForFont:_textView.font].height;
   int h2 = [text sizeForFont:_textView.font constrainedToSize:CGSizeMake(_textView.frame.size.width - 16, 170.0f) lineBreakMode:UILineBreakModeWordWrap].height;
   
   [UIView animateWithDuration:(animated ? .1f : 0) animations:^
    {
       int h = h2 == h1 ? _inputHeightWithShadow : h2 + 24;
       int delta = h - self.frame.size.height;
       CGRect r2 = CGRectMake(0, self.frame.origin.y - delta, self.frame.size.width, h);
       self.frame = r2;
       _inputBackgroundView.frame = CGRectMake(0, 0, self.frame.size.width, h);
       
       CGRect r = _textView.frame;
       r.origin.y = topGap;
       r.size.height = h - 18;
       _textView.frame = r;
       
    } completion:^(BOOL finished)
    {
       //
    }];
}

- (id) initWithFrame:(CGRect)frame
{
   self = [super initWithFrame:frame];
   
   if (self)
   {
      _inputHeight = 38.0f;
      _inputHeightWithShadow = 44.0f;
      _autoResizeOnKeyboardVisibilityChanged = YES;
      
      [self composeView];
   }
   return self;
}

- (void) fitText
{
   [self adjustTextInputHeightForText:_textView.text animated:YES];
}

- (BOOL)resignFirstResponder
{
    if (super.isFirstResponder)
        return [super resignFirstResponder];
    else if ([_textView isFirstResponder])
        return [_textView resignFirstResponder];
    return NO;
}

#pragma mark - Public Methods

- (NSString*)text
{
    return _textView.text;
}

- (void) setText:(NSString*)text
{
    _textView.text = text;
    _lblPlaceholder.hidden = text.length > 0;
    [self fitText];
}

- (void) setPlaceholder:(NSString*)text
{
    _lblPlaceholder.text = text;
}

#pragma mark - UITextFieldDelegate Delegate

- (void) textViewDidBeginEditing:(UITextView*)textView
{
   if (_autoResizeOnKeyboardVisibilityChanged)
   {
      [UIView animateWithDuration:.25f animations:^
       {
         CGRect r = self.frame;
         r.origin.y -= 216;
         [self setFrame:r];
      }];
      [self fitText];
   }
   if ([_delegate respondsToSelector:@selector(textViewDidBeginEditing:)])
      [_delegate performSelector:@selector(textViewDidBeginEditing:) withObject:textView];
}

- (void) textViewDidEndEditing:(UITextView*)textView
{
   if (_autoResizeOnKeyboardVisibilityChanged)
   {
      [UIView animateWithDuration:.25f animations:^{
         CGRect r = self.frame;
         r.origin.y += 216;
         [self setFrame:r];
      }];
      
      [self fitText];
   }
   _lblPlaceholder.hidden = _textView.text.length > 0;
   
   if ([_delegate respondsToSelector:@selector(textViewDidEndEditing:)])
      [_delegate performSelector:@selector(textViewDidEndEditing:) withObject:textView];
}

- (BOOL) textView:(UITextView*)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
   if ([text isEqualToString:@"\n"])
   {
       [self performSelector:@selector(returnButtonPressed:) withObject:nil afterDelay:.1];
       return NO;
   }
   else if (text.length > 0)
   {
      [self adjustTextInputHeightForText:[NSString stringWithFormat:@"%@%@", _textView.text, text] animated:YES];
   }
   return YES;
}

- (void) textViewDidChange:(UITextView*)textView
{
    _lblPlaceholder.hidden = _textView.text.length > 0;
   
   [self fitText];
   
   if ([_delegate respondsToSelector:@selector(textViewDidChange:)])
      [_delegate performSelector:@selector(textViewDidChange:) withObject:textView];
}

#pragma mark THChatInput Delegate

- (void) sendButtonPressed:(id)sender
{
    [_delegate chat:self sendWasPressed:self.text];
}

- (void) showAttachInput:(id)sender
{
   if ([_delegate respondsToSelector:@selector(chatShowAttachInput:)])
      [_delegate performSelector:@selector(chatShowAttachInput:) withObject:self];
}

- (void) showEmojiInput:(id)sender
{
   if ([_delegate respondsToSelector:@selector(chatShowEmojiInput:)])
   {
      if ([_textView isFirstResponder] == NO) [_textView becomeFirstResponder];

      [_delegate performSelector:@selector(chatShowEmojiInput:) withObject:self];
   }
}

- (void)returnButtonPressed:(id)sender
{
    [self sendButtonPressed:sender];
}

@end
