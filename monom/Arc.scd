
/*_____Select All Between Parentheses Below and Execute, Then Press On Monome_____*/

(

Server.default = Server.local;

~arc1 = MonoM.new("/arctest", 0); //<-Create new 'MonoM' object with args: 'prefix' and 'rotation'

s.waitForBoot({

var arcin1 = "/arctest/enc/delta", arcin2 = "/arctest/enc/key";

~arc1.useDevice(0);

OSCFunc.newMatching(
		{ arg message, time, addr, recvPort;

				~arc1.ringset(message[1], message[2].wrap(0,63));

		//Instead of the line above you could embed any set of functions
					//to check and respond to position change on encoder
		}, arcin1);
		
OSCFunc.newMatching(
		{ arg message, time, addr, recvPort;

				message[1].postln;
				message[2].postln;

		//Instead of the line above you could embed any set of functions
					//to check and respond to arc key state
		}, arcin2);
		
});

)

/* The device list is stored in a class variable, so you can access the same list from any of the MonoM objects you create. But you'd want to create a MonoM object for each Arc connected. From there, you can even switch, on the fly, which MonoM object talks to which Arc(for example, you could live-code switching which part of your app runs on which arc, all on the fly). In case you don't like to set which arc to use by index, you can also specify by exact port by using the '.usePort' message(this is useful in case you ever plug your arcs in a different order each time you startup and you need the specific port for a specific arc no matter what order it was plugged in).
If you change your setup while SC is running(unplug/plug arcs), you'll need to refresh the devicelist by using the '.deviceList' method.
Calling '.postln' on a MonoM object will print the port list to the post window(in case you want to see all ports for all devices plugged in).
 */

/*__After executing the code above, execute the code below and watch yer arc__*/

(
//execute all code within these parentheses together
~tst = r { 
	inf.do{ |i|
	~arc1.ringall(0, 0);
	~arc1.ringrange(0, ((i%4)*16).wrap(0,63), (((i%4)*16)+16).wrap(0,63), i*4 );
	0.5.wait;
	}
};
)

//execute lines below individually 

~tst.play //<-plays 'ring/range' example

~tst.stop //<-stops 'ring/range' example

~arc1.ringall(0, 0);

a = Array.series(64, 0, 1).wrap(0,15);

~arc1.ringmap(0, a);

~arc1.ringall(0, 0);

~arc1.darkness;

