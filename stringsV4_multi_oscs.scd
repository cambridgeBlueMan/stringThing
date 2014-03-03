// 24 db/octave filters:

BLowPass4.ar(freq:, rq:)
BMoog.ar(freq:, q:)
IIRFilter.ar(freq: rq:)
SVF.ar(freq: res:)


// also

LPF.ar(freq:)
HPF.ar(freq:)
BBandPass.ar(freq: bw:)





(
Instr(\retrologue2,
	{|freq = 440, res = 0.3, cutoff = 7000|
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
		BLowPass4.ar(sig, freq: cutoff, rq:0.5)*envAmp*0.1
	},
	[
		ControlSpec(20, 2000, \exp, 1, 440), // freq
		ControlSpec(0.001, 1, \lin, 0.001, 0.3), // res
		ControlSpec(200, 10000, \exp, 1, 7000)

	]
).play

)

p = Patch(Instr.at(\retrologue2)).gui

(
m = MixerChannel.new("twat", s, 2, 2);
p = m.play(Instr.at(\retrologue2));
CmdPeriod.add({m.free});
)

s.makeGui

(
x = Instr(\retrologue2) <>> Instr(\chorus2);
x.gui

)
(
Instr(\retrologue3,
{|freq = 440, res = 0.3, cutoff = 7000, numOscs=7, cents=5, widthLow=0.4, widthHigh=0.6
		attack = 2, sustain = 4, release = 2, filterClass|
	var sig, freqs;
	var envAmp = EnvGen.ar(Env.new([0,1,1,0], [attack, sustain, release], \squared), doneAction: 2);
	// var cents = 5;

	// ****************************
	// divide total oscilators by 2
	var oscs = (numOscs/2).floor.asInteger.postln;

	// ******************
	// make positive pans
	var pans = Array.fill(oscs, {|i|
		(i+1)/oscs;
	}); // end array fill
	pans.postln;

	// *****************
	// add negative pans
	pans = pans ++ pans.neg;

	// ****************************************
	// if numOscs is odd then add an extra zero
	if (numOscs.odd, {
		pans = pans ++ [0];
	},
		// else replace the


	); // end if

	// **************
	// sort ascending
	pans.sort.postln;

	// *******************************************
	// use the pans array to build the freqs array
	freqs = pans.collect({|item, i|
		(freq*2.pow(cents*item/1200)).postln;

	}); // end collect

	freqs.postln;

	// *****************
	// now do the signal
	sig = Mix.ar(
		Pan2.ar(VarSaw.ar(freqs, width: (SinOsc.ar([0.1, 0.2, 0.3]).range(widthLow, widthHigh))), pans)
	)*envAmp;
	filterClass.ar(sig, freq: cutoff, rq: res)*0.1
},
	[
		ControlSpec(20, 2000, \exp, 1, 440), // freq
		ControlSpec(0.001, 1, \lin, 0.001, 0.3), // res
		ControlSpec(200, 10000, \exp, 1, 7000), // cutoff
		ObjectSpec(7), // number of oscillators
		#[0, 15, \lin, 0.001, 5], // detune in cents
		#[0.1, 0.9, \lin, 0.01, 0.4], // width low
		#[0.1, 0.9, \lin, 0.01, 0.4], // width high
		#[0.01, 4, \lin, 0.01, 2], // attack
		#[0.0001, 10, \lin, 0.01, 4], // sustain
		#[0.01, 4, \lin, 0.01, 2], // release
		ObjectSpec(BLowPass4)
	]
)
)

p = Patch(\retrologue3, (numOscs: 7, filterClass: IIRFilter)).gui

p = Patch(\retrologue3, (freq: [55], numOscs: 7, filterClass: IIRFilter)).play;
p = Patch(\retrologue3, (freq: [221], numOscs: 7, filterClass: IIRFilter)).play



















