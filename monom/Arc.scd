
/*_____Select All Between Parentheses Below and Execute, Then Press On Monome_____*/

(

Server.default = Server.local;

s.waitForBoot({

    // create your arc object
    ~arc = Arc.new("/arc", 270);

    // choose your appropriate device
    // if you have a grid device plugged in
    // make sure the right device is chosen
    ~arc.useDevice(0);

    // first argument is your arc object, second sets sensitivity
    ~arcKnobberInc = ArcRotary(~arc, 4);
    ~arcKnobberAbs = ArcEncoder(~arc, 6);

    OSCFunc.newMatching({ | message |

        var knob_n = message[1];  // reports which knob is rotating
        var delta = message[2];   // delta coming from rotating knob

        if(knob_n == 0){
            // will report position of led (0-63)
            "encoder knob: % \n".postf(~arcKnobberAbs.spin(knob_n, delta));
        };

        if(knob_n == 1){
            // will report -1 if negative and 1 if positive
            "rotary knob: % \n".postf(~arcKnobberInc.spin(knob_n, delta));
        };

    }, '/arc/enc/delta');

});

)


/* The device list is stored in a class variable, so you can access the same list from any of the MonoM objects you create. But you'd want to create a MonoM object for each Arc connected. From there, you can even switch, on the fly, which MonoM object talks to which Arc(for example, you could live-code switching which part of your app runs on which arc, all on the fly). In case you don't like to set which arc to use by index, you can also specify by exact port by using the '.usePort' message(this is useful in case you ever plug your arcs in a different order each time you startup and you need the specific port for a specific arc no matter what order it was plugged in).
If you change your setup while SC is running(unplug/plug arcs), you'll need to refresh the devicelist by using the '.deviceList' method.
Calling '.postln' on a MonoM object will print the port list to the post window(in case you want to see all ports for all devices plugged in).
 */

// turn off your device here if you'd like
~arc.darkness;

