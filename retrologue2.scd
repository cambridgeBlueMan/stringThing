// *****************************
// the following composite works
// note that in this case the Gverb is expecting and getting an audio input


(
Instr(\retrologue2,
	{|freq = 220, res = 0.3, cutoff = 7000|
		var cents = 5;
		var envAmp = EnvGen.ar(Env.new([0,1,1,0], [2,4,2], \squared), doneAction: 2);
		var freqs = [
			freq*2.pow(cents/1200.neg),
			freq*2.pow(cents*0.6/1200.neg),
			freq*2.pow(cents*0.3/1200.neg),
			freq,
			freq*2.pow(cents*0.6/1200),
			freq*2.pow(cents*0.3/1200),
			freq*2.pow(cents/1200)
		];
		var pans = [-1, -0.66, -0.3 ,0, 0.3, 0.66, 1];
		var sig = Mix.ar(
			Pan2.ar(VarSaw.ar(freqs, width: (SinOsc.ar([0.1, 0.2, 0.3]).range(0.4, 0.6))), pans)
		);
		BLowPass4.ar(sig, freq: cutoff, rq:0.5)*envAmp*0.3
	},
	[
		ControlSpec(20, 2000, \exp, 1, 440), // freq
		ControlSpec(0.001, 1, \lin, 0.001, 0.3), // res
		ControlSpec(200, 10000, \exp, 1, 7000)

	]
).play
)
(
x = Instr(\retrologue2) <>> Instr("gVerb");
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
y = m.play(Instr.at(\retrologue2));
z = m.playfx(Instr.at(\busGVerb));
z.args = ~bathroom;
z.gui;

)

(
// *******
// repeats
TempoClock.sched(0, {
	y = m.play(Instr.at(\retrologue2));
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

~church = (\bus: m.inbus.index, \roomsize: 80, \revtime: 4.85, \damping: 0.41, \inputbw: 0.19, \spread: 15, \drylevel: -3, \earlylevel: -9, \taillevel: -11);

// cathedral
~cathedral = (\bus: m.inbus.index, \spread: 15, \roomsize: 243, \revtime: 1, \damping: 0.1, \inputbw: 0.34, \drylevel: -3, \earlylevel: -11, \taillevel: -9);

// canyon
~canyon = (\bus: m.inbus.index, \spread: 15, \roomsize: 300, \revtime: 103, \damping: 0.43, \inputbw: 0.51, \drylevel: -5, \earlylevel: -26, \taillevel: -20);