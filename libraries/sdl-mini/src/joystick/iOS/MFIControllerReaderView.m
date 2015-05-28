//  Created by Emufr3ak on 29.05.14.
//
//  iUAE is free software: you may copy, redistribute
//  and/or modify it under the terms of the GNU General Public License as
//  published by the Free Software Foundation, either version 2 of the
//  License, or (at your option) any later version.
//
//  This file is distributed in the hope that it will be useful, but
//  WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
//  General Public License for more details.
//
// You should have received a copy of the GNU General Public License
//along with this program; if not, write to the Free Software
//Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.

#import "MFIControllerReaderView.h"

@implementation MFIControllerReaderView {
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    _hat_state = SDL_HAT_CENTERED;
    _buttonpressed = false;
    
    [self discoverController];
    
    return self;
}

- (void)discoverController {
    
    
    if ([[GCController controllers] count] == 0) {
        [GCController startWirelessControllerDiscoveryWithCompletionHandler:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(controllerDiscovered)
                                                     name:GCControllerDidConnectNotification
                                                   object:nil];
    } else {
        [self controllerDiscovered];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(discoverController)
                                                     name:GCControllerDidDisconnectNotification
                                                   object:nil];
    }
}

- (void)controllerDiscovered {
    
    GCController *controller = [GCController controllers][0];
    
    controller.gamepad.valueChangedHandler = ^(GCGamepad *gamepad, GCControllerElement
                                               *element)
    {
        _buttonpressed = gamepad.buttonA.isPressed != _buttonpressed ? !_buttonpressed : _buttonpressed; //If value for Button pressed changes invert control value;
        
        if(gamepad.dpad.left.pressed)
        {
            if(gamepad.dpad.up.pressed)
            {
                _hat_state = SDL_HAT_LEFTUP;
            }
            else if(gamepad.dpad.down.pressed)
            {
                _hat_state = SDL_HAT_LEFTDOWN;
            }
            else
            {
                _hat_state = SDL_HAT_LEFT;
            }
        }
        else if(gamepad.dpad.right.pressed)
        {
            if(gamepad.dpad.up.pressed)
            {
                _hat_state = SDL_HAT_RIGHTUP;
            }
            else if(gamepad.dpad.down.pressed)
            {
                _hat_state = SDL_HAT_RIGHTDOWN;
            }
            else
            {
                _hat_state = SDL_HAT_RIGHT;
            }
        }
        else if(gamepad.dpad.up.pressed)
        {
            _hat_state = SDL_HAT_UP;
        }
        else if(gamepad.dpad.down.pressed)
        {
            _hat_state = SDL_HAT_DOWN;
        }
        else
        {
            _hat_state = SDL_HAT_CENTERED;
        }
    };
    
    GCControllerDirectionPad *dpad = controller.gamepad.dpad;
    dpad.valueChangedHandler = ^ (GCControllerDirectionPad *directionpad,
                                  float xValue, float yValue) {
        NSLog(@"Changed xValue on dPad = %f yValue = %f" ,xValue, yValue);
    };
    
    dpad.xAxis.valueChangedHandler = ^(GCControllerAxisInput *xAxis,float value) {
        NSLog(@"X Axis changed value %f",value);
    };     
}

@end

