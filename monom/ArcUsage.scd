/*_____Select All Between Parentheses Below and Execute, Then Turn a Knob_____*/
(
Server.default = Server.local;

// Create new 'Arc' object with args: 'prefix' and 'rotation'
~arc = Arc.new("/arc", 270);

s.waitForBoot({

    // Due to a short delay in serialosc reporting its ports, '.useDevice'
    // needs to be called after a short period of time separate from initializing
    // with 'Arc.new'...(i prefer to use "s.waitForBoot" for this, but whatever works for you...)

    // so choose your appropriate device:
    // if multiple devices are plugged in, make sure that the right device is chosen
    // when sc is started (and serialosc is running) it will list the order of your devices
    ~arc.useDevice(0);

    // first argument is your arc object, second sets sensitivity:
    // ArcRotary begins at the north position relative to rotation
    // it's behavior is to fill an led ring at knob n: from x1 to xn (e.g from 0 to 32)
    ~arcKnobberRotary = ArcRotary(~arc, 8);
    // ArcEncoder begins at the north position relative to rotation
    // it's behavior is to have a single led travel at a given position
    ~arcKnobberEncoder = ArcEncoder(~arc, 8);

    OSCFunc.newMatching({ | message |

        var knob_n = message[1];  // reports which knob is rotating
        var delta = message[2];   // delta coming from rotating knob

        if(knob_n == 0) {
            // will report the total amount of delta exerted on the knob
            "encoder knob#0: % \n".postf(~arcKnobberEncoder.spin(knob_n, delta));
        };

        if(knob_n == 1) {
            // will report delta per individual turn
            "rotary knob#1: % \n".postf(~arcKnobberRotary.spin(knob_n, delta));
        };
    }, '/arc/enc/delta');
});
)

// turn off your device here if you'd like
~arc.darkness;
~arc.getPrefix;