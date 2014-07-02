/*

ArcEncoder lights one led per position.
Returns delta.

Written by Joseph Rangel:
https://github.com/nthhisst

*/

ArcEncoder {

    var arc;
    var arc_map;
    var current_led;
    var gathered_delta;

    var <>sensitivity;

    *new{ | your_arc, sensitivity_level |
        ^super.new.initArcKnob(your_arc, sensitivity_level);
    }

    initArcKnob { | your_arc, sensitivity_level |

        arc = your_arc;

        sensitivity = Array.fill(4, sensitivity_level);
        current_led = Array.fill(4, 0);
        gathered_delta = Array.fill(4, 0);

        arc_map = [
            Array.fill(64,0),
            Array.fill(64, 0),
            Array.fill(64, 0),
            Array.fill(64, 0)
        ];

        for(0, 3, { arg i; arc_map[i][0] = 15; });
    }

    spin { | knob_n, delta |

        if (delta.isStrictlyPositive)
        { gathered_delta[knob_n] = gathered_delta[knob_n] + delta; }
        { gathered_delta[knob_n] = gathered_delta[knob_n] + delta.abs; };

        if (gathered_delta[knob_n] >= sensitivity[knob_n]) {
            arc_map[knob_n][current_led @ knob_n] = 0;

            if (delta.isStrictlyPositive)
            { current_led[knob_n] = (current_led[knob_n] + (gathered_delta[knob_n] / sensitivity[knob_n]).asInteger).wrap(0, 63); }
            { current_led[knob_n] = (current_led[knob_n] - (gathered_delta[knob_n] / sensitivity[knob_n]).asInteger).wrap(0, 63); };

            arc_map[knob_n][current_led @ knob_n] = 15;
            gathered_delta[knob_n] = gathered_delta[knob_n] % sensitivity[knob_n];
        };

        arc.ringmap(knob_n, arc_map[knob_n])

        ^ delta;
    }

    focusKnob { | knob_n |
        arc.ringmap(knob_n, arc_map[knob_n]);
    }
}