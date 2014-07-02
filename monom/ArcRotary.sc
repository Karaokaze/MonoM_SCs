/*

ArcRotary fills leds incrementally up to the current position
and decrements respectively, returns led position 0-63.

https://github.com/nthhisst

*/

ArcRotary : ArcEncoder {

    var total_delta;     // Array storing knob N total delta exerted

    *new { | your_arc, sensitivity_level |
        ^ super.new.initArcRotary(your_arc, sensitivity_level);
    }

    initArcRotary { | your_arc, sensitivity_level |
        arc = your_arc;
        sensitivity = Array.fill(4, sensitivity_level);
        current_led = Array.fill(4, 0);
        gathered_delta = Array.fill(4, 0);
        total_delta = Array.fill(4, 0);
    }

    spin { | knob_n, delta |
        if (delta.isStrictlyPositive and: (current_led[knob_n] <= 64)) {
            gathered_delta[knob_n] = gathered_delta[knob_n] + delta;
            total_delta[knob_n] = total_delta[knob_n] + delta;

            if ((gathered_delta[knob_n] >= sensitivity[knob_n]) and: (current_led[knob_n] < 64)) {
                current_led[knob_n] = current_led[knob_n] + (gathered_delta[knob_n] / sensitivity[knob_n]).asInteger;
                gathered_delta[knob_n] = gathered_delta[knob_n] % sensitivity[knob_n];

                // ringrange description:
                // ringrange(at: knob_n, from: led_n, to: led_m, setBrightNessTo: integer)
                arc.ringrange(knob_n, 0, current_led[knob_n]-1,
                    (current_led[knob_n]-1).linlin(0, 63, 2, 15).asInteger);
            };

            if (current_led[knob_n] >= 64) {
                current_led[knob_n] = 64;
                arc.ringrange(knob_n, 0, 63, 15);
                gathered_delta[knob_n] = 0;
                total_delta[knob_n] = sensitivity[knob_n] * 64;
                ^ total_delta @ knob_n;
            };
        };

        if(delta.isNegative and: (current_led[knob_n] >= 0)) {
            gathered_delta[knob_n] = gathered_delta[knob_n] + delta.abs;
            total_delta[knob_n] = total_delta[knob_n] + delta;

            if ((gathered_delta[knob_n] >= sensitivity[knob_n]) and: (current_led[knob_n] > 0)) {
                current_led[knob_n] = current_led[knob_n] - (gathered_delta[knob_n] / sensitivity[knob_n]).asInteger;
                gathered_delta[knob_n] = gathered_delta[knob_n] % sensitivity[knob_n];
            };

            if (current_led[knob_n] <= 0) {
                gathered_delta[knob_n] = 0;
                current_led[knob_n] = 0;
                arc.ringrange(knob_n, 0, 63, 0);
                total_delta[knob_n] = 0;
                ^ total_delta @ knob_n;
            };

            // turn off the appropriate LEDs
            arc.ringrange(knob_n, current_led[knob_n], 63, 0);

            // turn on appropriate LEDs
            arc.ringrange(knob_n, 0, current_led[knob_n] - 1,
                current_led[knob_n].linlin(0, 63, 2, 15).asInteger);
        };

        ^ total_delta @ knob_n;
    }
}