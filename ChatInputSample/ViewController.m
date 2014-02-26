//
//  ViewController.m
//  AutoGrowingTextInput
//
//  Created by Marat Alekperov (m.alekperov@gmail.com) on 18.11.12.
//  Copyright (c) 2012 Me and Myself. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@end


@implementation ViewController


- (void) viewDidLoad {
   
   [super viewDidLoad];
	
    UITapGestureRecognizer *tapper = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedView:)];
    [self.view addGestureRecognizer:tapper];
}

- (void) didReceiveMemoryWarning {
   
   [super didReceiveMemoryWarning];
}


- (void) viewDidUnload {
   
   [self setTextView:nil];
   [self setChatInput:nil];
   [self setEmojiInputView:nil];
   [super viewDidUnload];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)tappedView:(UITapGestureRecognizer*)tapper
{
    [_chatInput resignFirstResponder];
}

#pragma mark - THChatInputDelegate

- (void)chat:(THChatInput*)input sendWasPressed:(NSString*)text
{
    _textView.text = text;
    [_chatInput setText:@""];
}

- (void)chatShowEmojiInput:(THChatInput*)input
{
    _chatInput.textView.inputView = _chatInput.textView.inputView == nil ? _emojiInputView : nil;
    
    [_chatInput.textView reloadInputViews];
}

- (void)chatShowAttachInput:(THChatInput*)input
{
    
}

@end
