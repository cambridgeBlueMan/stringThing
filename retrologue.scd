// *****************
// first a synth def
(
SynthDef(\retrologue,
	{|freq, cutoff = 11000, res = 0.1|
		var freqs, amps, control, envAmp, env, sig, numOscs = 8;
		freqs = Control.names(\freqs).kr(Array.fill(numOscs, 440));
		amps =  Control.names(\amps).kr(Array.fill(numOscs, numOscs.reciprocal));
		//freqs = [440, 441, 442];
		// ********************
		// now the actual sound
		//envAmp = EnvGen.ar(Env.new([0, 1, 1, 0], [2,4,2], \squared));
		//env = EnvGen.ar(Env.adsr(0, 2, 0, 2));
		sig  =Mix.ar(
			SawDPW.ar(freqs,  mul: amps);
		);
		//sig = DFM1.ar(sig, cutoff, res: res);
				sig = BLowPass4.ar(sig, cutoff, rq: res);
				//sig = BLowShelf.ar(sig, cutoff, rs: res);

		Out.ar(0, sig*0.1);
	}
).add
)



/*
i want to be able to define cutoff, res, detune and number of oscillators
also to start and stop the synth


*/

(
var numOscs= 8;
var win, sliders, amps, freqSetter, detSetter, freq, freqs, det = 5, cutoff;
var retrologue = Synth(\retrologue, [\freqs, [440, 441, 442, 440, 441, 442, 440, 441]]);
win = Window.new("twat", Rect(20, 20, 800, 600)).front;
CmdPeriod.add({win.close});
win.onClose = {retrologue.free; "closed".postln};
sliders = List.new(0);
amps = [0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1];
numOscs.do({|i|
	sliders.add;
	sliders[i] = Slider.new(win, Rect(23*i, 20, 20, 150));
	sliders[i].action = {|slid|
		amps[i] = slid.value;
		amps.postln;
		retrologue.set(\amps, amps);
	};
});

// *************
// set frequency
freqSetter = Slider.new(win, Rect(0, 200, 20, 150));
	freqSetter.action = {|slid|
		freq = ControlSpec(200, 800, \lin, 1, 440,).map(slid.value);
		freqs = Array.fill(numOscs, {|i|
			freq*2.pow(det*i/1200).postln
		}).postln; // end array fill
	retrologue.set(\freqs, freqs);
	}; // end action

// **********
// set cutoff
cutoff = Slider.new(win, Rect(25, 200, 20, 150));
	cutoff.action = {|slid|
	retrologue.set(\cutoff, ControlSpec(200, 16000, \exp, 1, 2000,).map(slid.value).postln);
	}; // end action
)