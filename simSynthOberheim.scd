// ==================================================================================
//                                   OBSTRING
// ==================================================================================
(
Instr.new(\ssObString,
	// ********
	// function
	{|freq=220, amp1= 1, amp2 = 1, amp3 = 1, dutyOsc1 = 0.1078, dutyOsc2 = 0.0451, dutyOsc3 = 0.0431, power = 0.0083333333333333, detune = 0.8, gate=1|
		var sig, envAmp, envOsc, osc1, osc2, osc3, lfo;
		envAmp = EnvGen.ar(
			Env.new(
				[0.00001,1,0.00001],
				[0.75, 4.18],
				[\exp, \lin],
				releaseNode:1
		), gate, doneAction:2);
		osc1 = VarSaw.ar(
			[freq, freq + detune ], 0, dutyOsc1)*amp1;
		osc2 = VarSaw.ar(
			[freq*2.pow(power), (freq+detune)*2.pow(power) ], 0, dutyOsc2)*amp2;
		osc3 = VarSaw.ar(
			[freq*2.pow(power.neg), (freq+2)*2.pow(power.neg) ], 0, dutyOsc3)*amp3;
		sig = Pan2.ar(Mix.ar([osc1, osc2, osc3]), 0);
		//Out.ar(0, sig*envAmp)
		sig*envAmp*0.2;
	},
	// ****
	// args
	#[
		nil,  // freq
		[0,1,\linear,0.0001], // amp1
		[0,1,\linear,0.0001], // amp2
		[0,1,\linear,0.0001], // amp3
		[0,0.2,\linear,0.0001], // duty 1
		[0,0.2,\linear,0.0001], // duty 2
		[0,0.2,\linear,0.0001], // duty 3
		[0.0083333333333333, 0.0833333, \exp, 0.0001], // power
		[0, 5, \linear, 0.0001], // detune
		[-1, 1, 'linear', 0.0]

	]
).play;



s.makeGui

)

// (
// Instr(\chorus2band2, { arg bus, numChan, numDelays, predelay, speed, depth,
// 	ph_diff, crossover, xfade;
// 	var in, lo, hi, sig, mods, indexBase;
// 	in = In.ar(bus, 1);
// 	lo = LPF.ar(in, crossover);
// 	hi = HPF.ar(in, crossover);
// 	mods = { |i|
// 	SinOsc.kr(speed * rrand(0.9, 1.1), ph_diff * i, depth, predelay);	} ! (numDelays * numChan);
// 	sig = DelayL.ar(hi, 0.5, mods);
// 	indexBase = (0, numChan .. mods.size-1);
// 	hi = { |i| Mix(sig[indexBase + i]) } ! numChan;
// 	lo = lo + hi;
// 	XFade2.ar(in, lo, xfade.madd(2, -1))
// }, [\audiobus, ObjectSpec(1), ObjectSpec(1), #[0.0001, 0.2, \exponential, 0, 0.001], #[0.001, 10, \exponential], #[0.0001, 0.25, \exponential], #[0, 2pi], \freq, #[0, 1]]);
// )

m.free
(
// **********
// make patch
//p = Patch(\ssObString).gui;
// ********************
// make a mixer channel
m = MixerChannel.new("gobi", s, 2, 2);
p = m.play(Instr.at(\ssObString)).gui;
)
(
// ****************
// apply the effect
q = m.playfx(Instr.at(
	#[\busfx, \rvb_allpass]
)).gui;
// **********************************************
// get rid of the mixer channel on command period
CmdPeriod.add({m.free});
)