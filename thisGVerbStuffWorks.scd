(
// gVerb
Instr(#[\busfx, \busGVerb], { |bus, roomsize, revtime, damping, inputbw, spread = 15, drylevel, earlylevel, taillevel |
	var in = In.ar(bus, 1);
	var sig = GVerb.ar(
		in,
		roomsize,
		revtime,
		damping,
		inputbw,
		spread,
		drylevel.dbamp,
		earlylevel.dbamp,
		taillevel.dbamp,
		roomsize, 0.3) + in;
	sig;
	};
	,
	[
		\audiobus,
		[1, 300, \lin, 1, 20], // room size
		[0.0001, 10, \lin, 0.001, 3], // // rev time
		[0, 1, \lin, 0.0001, 0.5], // damping
		[0, 1, \lin, 0.0001, 0.5], // input bw same as damping, but on in
		[0, 30, \lin, 1, 15], // spread
		[0, 1, \lin, 0.001, 1], // dry level
		[0, 1, \lin, 0.001, 0.7], // early reflection level
		[0, 1, \lin, 0.001, 0.5] // tail level
		//[1, 300, \lin, 1, 20] // max room size
		//nil, // mul
		//nil // add
	]
).play;
// =================================================================================
// none bus
// this version expects audio as an input, and i suspect mono audio at that

Instr(#[\gVerb],


	{|in, roomsize, revtime, damping, inputbw, spread = 15, drylevel, earlylevel, taillevel |
	//var in = In.ar(bus, 1);
	var sig = GVerb.ar(
		in,
		roomsize,
		revtime,
		damping,
		inputbw,
		spread,
		drylevel.dbamp,
		earlylevel.dbamp,
		taillevel.dbamp,
		roomsize, 0.3) + in;
	sig*0.3;
	};
	,
	[
		\audio,
		[1, 300, \lin, 1, 20], // room size
		[0.0001, 10, \lin, 0.001, 3], // // rev time
		[0, 1, \lin, 0.0001, 0.5], // damping
		[0, 1, \lin, 0.0001, 0.5], // input bw same as damping, but on in
		[0, 30, \lin, 1, 15], // spread
		[-30, 1, \lin, 0.001, 1], // dry level
		[-30, 1, \lin, 0.001, 0.7], // early reflection level
		[-30, 1, \lin, 0.001, 0.5] // tail level
		//[1, 300, \lin, 1, 20] // max room size
		//nil, // mul
		//nil // add
	]
).play;

)

Instr(\chorus2, { arg bus, numInChan, numOutChan, numDelays, predelay, speed, depth, ph_diff;
	var in, sig, mods;
	in = In.ar(bus, numInChan);
	mods = { |i|
		SinOsc.kr(speed * rrand(0.9, 1.1), ph_diff * i, depth, predelay);
	} ! (numDelays * numOutChan);
	sig = DelayL.ar(in, 0.5, mods);
	Mix(sig.clump(numOutChan))
}, [\audiobus, ObjectSpec(1), ObjectSpec(1), ObjectSpec(4), #[0.0001, 0.2, \exponential, 0, 0.001], #[0.001, 10, \exponential], #[0.0001, 0.25, \exponential], #[0, 2pi], #[0, 1]]);

// *****************************
// the following composite works
// note that in this case the Gverb is expecting and getting an audio input
(
x = Instr(\leaStrings2) <>> Instr(\gVerb);
//x.args = ~church;
x.gui
)

// **********************
// heres a different game. This time the gverb expects a bus input
// and indeed gets one!
// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
// there may be some mono stereo issues
// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

(
m = MixerChannel.new("test gVerb", s, 2, 2);
CmdPeriod.add({m.free});
)

(
// ***********
// single shot
y = m.play(Instr.at(\leaStrings2));
z = m.playfx(Instr.at(\chorus2));
//z.args = ~church;
z.gui;

)

(
// *******
// repeats
TempoClock.sched(0, {
	y = m.play(Instr.at(\leaStrings2));
	18
}); // end clock
)

// =============================================================================
//                                PRESETS
// ================================================================================

|bus, roomsize, revtime, damping, inputbw, spread = 15, drylevel, earlylevel, taillevel |

// bathroom
~bathroom =  (\bus: m.inbus.index, \spread: 15, \roomsize: 5, \revtime: 0.6, \damping: 0.62, \inputbw: 0.48, \drylevel: -6, \earlylevel: -11, \taillevel: -13);

//living room
~livingroom = (\bus: m.inbus.index, \spread: 15, \roomsize: 16, \revtime: 1.24, \damping: 0.10, \inputbw: 0.95, \drylevel: -3, \earlylevel: -15, \taillevel: -17);

//church
~church = (\bus: m.inbus.index, \roomsize: 80, \revtime: 4.85, \damping: 0.41, \inputbw: 0.19, \spread: 15, \drylevel: -3, \earlylevel: -9, \taillevel: -11);

// cathedral
~cathedral = (\bus: m.inbus.index, \spread: 15, \roomsize: 243, \revtime: 1, \damping: 0.1, \inputbw: 0.34, \drylevel: -3, \earlylevel: -11, \taillevel: -9);

// canyon
~canyon = (\bus: m.inbus.index, \spread: 15, \roomsize: 300, \revtime: 103, \damping: 0.43, \inputbw: 0.51, \drylevel: -5, \earlylevel: -26, \taillevel: -20);