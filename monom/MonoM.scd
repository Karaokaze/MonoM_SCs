
/*_____Select All Between Parentheses Below and Execute, Then Press On Monome_____*/

(

Server.default = Server.local;

~m1 = MonoM.new("/box1", 270); //<-Create new 'MonoM' object with args: 'prefix' and 'rotation'

/* ~m2 = MonoM.new("/box2", 270);
   ~m3 = MonoM.new("/box3", 270);  <-use these lines(uncommented) with multiple monomes connected*/

s.waitForBoot({

var msgin1 = "/box1/grid/key", msgin2 = "/box2/grid/key", msgin3 = "/box3/grid/key";
var tiltin = "/box1/tilt";

~m1.useDevice(0); //<-Choose which device in a list of connected devices indexed starting from 0
/* ~m2.useDevice(1);
   ~m3.useDevice(2);	<-use these lines(uncommented) with multiple monomes connected*/

/*Due to a short delay in serialosc reporting its ports, '.useDevice' needs to be called after a short period of time separate from initializing with 'MonoM.new'...(i prefer to use "s.waitForBoot" for this, but whatever works for you...)*/

OSCFunc.newMatching(
		{ arg message, time, addr, recvPort;

				~m1.ledset(message[1], message[2], message[3]);

		//Instead of the line above you could embed any set of functions
					//to check for which button is pressed
					//and trigger an individual function/routine/etc.

		}, msgin1);
		
OSCFunc.newMatching(
		{ arg message, time, addr, recvPort;

				message[1].postln;
				message[2].postln;
				message[3].postln;
				message[4].postln;

		//Instead of the line above you could embed any set of functions
					//to check for which button is pressed
					//and trigger an individual function/routine/etc.

		}, tiltin);
		
/*	OSCFunc.newMatching(
		{ arg message, time, addr, recvPort;

				~m2.ledset(message[1], message[2], message[3]);

		//Instead of the line above you could embed any set of functions
					//to check for which button is pressed
					//and trigger an individual function/routine/etc.

		}, msgin2);
		
	OSCFunc.newMatching(
		{ arg message, time, addr, recvPort;

				~m3.ledset(message[1], message[2], message[3]);

		//Instead of the line above you could embed any set of functions
					//to check for which button is pressed
					//and trigger an individual function/routine/etc.

		}, msgin3);
		
		^use the above 2 OSCFuncs(uncommented) only when multiple monomes are connected
*/		

});

)
/* To get monome size, use the methods: .rws, .clsÉ and to get port of a specific device, you can use method: .prtÉ 
For these 3 methods to work properly, .useDevice needs to be called beforehand(to specify the monome device you'd like to speak to, indexed starting from 0). */

~m1.rws;
~m1.cls;
~m1.prt;
~m1.postln;

/* The device list is stored in a class variable, so you can access the same list from any of the MonoM objects you create. But you'd want to create a MonoM object for each Monome connected. From there, you can even switch, on the fly, which MonoM object talks to which Monome(for example, you could live-code button-interaction and led-animation to switch to a different monome from where they were before, perhaps even switching which part of your app runs on which monome, all on the fly). In case you don't like to set which monome to use by index, you can also specify by exact port by using the '.usePort' message(this is useful in case you ever plug your monomes in a different order each time you startup and you need the specific port for a specific monome no matter what order it was plugged in).
If you change your setup while SC is running(unplug/plug monomes), you'll need to refresh the devicelist by using the '.deviceList' method.
Calling '.postln' on a MonoM object will print the port list to the post window(in case you want to see all ports for all devices plugged in).
 */

/*__After executing the code above, execute each line below one by one and watch yer monome__*/

a = [255, 8, 255, 16, 255, 32, 255, 64];

~m1.ledmap(0, 0, a);

~m1.ledall(0);

~m1.intensity(2);

~m1.ledall(1);

~m1.intensity(15);

~m1.ledall(0);

~m1.useDevice(1);  //<-if you have a second device connected, this will connect to it instead of the first, otherwise, skip it.

~m1.ledrow(0, 2, 255, 255);

~m1.ledall(0);

~m1.ledcol(5, 0, 145);

~m1.ledall(0);

~m1.levset(5, 0, 2);

~m1.levset(5, 0, 4);

~m1.levset(5, 0, 15);

~m1.levset(5, 0, 0);

~m1.levall(5);

~m1.levall(15);

~m1.levall(0);

a = Array.series(8, 0, 1);
~m1.levrow(0, 0, a);
~m1.levcol(0, 0, a);

~m1.ledall(0);

a = Array.series(64, 0, 1);
~m1.levmap(0, 0, a);

~m1.tiltnoff(0, 1) //<-turn on tilt (watch post window as you tilt your grid)

~m1.tiltnoff(0, 0) //<-turn off tilt

~m1.darkness;