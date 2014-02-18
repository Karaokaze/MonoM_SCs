/*

ArcKnobAbsolute fills leds incrementally up to the current position
(think of a stack of lit leds) and decrements respectively, returns led position 0-63.

https://github.com/nthhisst


*/

ArcKnobAbsolute : ArcKnobIncremental{


    *new { | your_arc, sensitivity_level |

        ^super.new.initArcKnobAbsolute(your_arc, sensitivity_level);
    }

    initArcKnobAbsolute { | your_arc, sensitivity_level |

        /*
        arc = arc;
        sensitivity = sensitvity_level;
        arc_map = Array.fill(64, 0);

        gathered_delta = 0;
        current_led = 0;
        */

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

    }

    spin { | knob_n, delta |

        if(delta.isStrictlyPositive)
        {
            if(current_led[knob_n] < 63)
            {
                gathered_delta[knob_n] = gathered_delta[knob_n] + delta;

                while{ (gathered_delta[knob_n] >= sensitivity[knob_n]) && (current_led[knob_n] < 63) }
                {
                    current_led[knob_n] = current_led[knob_n] + 1;
                    arc_map[knob_n][current_led @ knob_n] = 15;
                    gathered_delta[knob_n] = gathered_delta[knob_n] - sensitivity[knob_n];

                };

                arc.ringmap(knob_n, arc_map[knob_n]);

                if(current_led[knob_n] >= 63)
                {
                    current_led[knob_n] = 63;

                    // constant array for efficiency
                    arc.ringmap(knob_n, #[
                        15, 15, 15, 15, 15, 15, 15, 15,
                        15, 15, 15, 15, 15, 15, 15, 15,
                        15, 15, 15, 15, 15, 15, 15, 15,
                        15, 15, 15, 15, 15, 15, 15, 15,
                        15, 15, 15, 15, 15, 15, 15, 15,
                        15, 15, 15, 15, 15, 15, 15, 15,
                        15, 15, 15, 15, 15, 15, 15, 15,
                        15, 15, 15, 15, 15, 15, 15, 15 ]);

                    gathered_delta[knob_n] = 0;

                    ^ current_led[knob_n];
                };

            };
        };

        if(delta.isNegative)
        {
            if(current_led[knob_n] == 0)
            {
                gathered_delta[knob_n] = 0;
                current_led[knob_n] = 0;

                arc.ringmap(knob_n, #[
                    0, 0, 0, 0, 0, 0, 0, 0,
                    0, 0, 0, 0, 0, 0, 0, 0,
                    0, 0, 0, 0, 0, 0, 0, 0,
                    0, 0, 0, 0, 0, 0, 0, 0,
                    0, 0, 0, 0, 0, 0, 0, 0,
                    0, 0, 0, 0, 0, 0, 0, 0,
                    0, 0, 0, 0, 0, 0, 0, 0,
                    0, 0, 0, 0, 0, 0, 0, 0]);

                ^ current_led[knob_n];
            };


            if(current_led[knob_n] > 0)
            {
                gathered_delta[knob_n] = gathered_delta[knob_n] + delta.abs;

                while{ (gathered_delta[knob_n] >= sensitivity[knob_n]) && (current_led[knob_n] >= 0) }
                {
                    arc_map[knob_n][current_led @ knob_n] = 0;
                    current_led[knob_n] = current_led[knob_n] - 1;
                    gathered_delta[knob_n] = gathered_delta[knob_n] - sensitivity[knob_n];
                };

                arc.ringmap(knob_n, arc_map[knob_n]);
            };

        };

        ^current_led;
    }

}