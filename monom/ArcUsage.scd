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
    ~arcKnobberRotary = ArcRotary(~arc, 8);
    ~arcKnobberEncoder = ArcEncoder(~arc, 2);

    OSCFunc.newMatching({ | message |

        var knob_n = message[1];  // reports which knob is rotating
        var delta = message[2];   // delta coming from rotating knob

        if(knob_n == 0) {
            // will report position of led (0-63)
            "encoder knob#0: % \n".postf(~arcKnobberEncoder.spin(knob_n, delta));
        };

        if(knob_n == 1) {
            // will report delta from arc
            "rotary knob#1: % \n".postf(~arcKnobberRotary.spin(knob_n, delta));
        };
    }, '/arc/enc/delta');
});
)

// turn off your device here if you'd like
~arc.darkness;