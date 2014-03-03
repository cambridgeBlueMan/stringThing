(
Instr(\leaStrings2,
	{|freq= 440, det = 5, cutoff=11000, res=0.1, oscCount = 3|
		// dummy env is addressing the issue of fading echo at end, it
		// adds two seconds
		var dummyEnv = EnvGen.ar(Env.new([1,0], [10]), doneAction: 2);
		var envAmp = EnvGen.ar(Env([0,1,1,0], [2,4,2], \squared));
		// in this next block I am using LFNoise to modulate
		// the frequency. I am making several of these and then
		// adding them all together

		var oscs = Array.fill(oscCount, {|i|
			if (i == 0, {
				freq;
				},
				{
					freq + LFNoise1.ar(4, (freq*2.pow(det/1200)-freq));
			}); // end if
		}).postln;


		// then we mix them all together as sawtooth waves with some
		// attempt at stereo

		var split = (oscs.size/2).floor.postn("split");
		var left = Mix.ar(SawDPW.ar(oscs[..split.asInteger].postln));
		var right = Mix.ar(SawDPW.ar(oscs[(split.asInteger+1)..].postln));
		var sig = [left, right];

		// there are various choices of filter
		sig = DFM1.ar(sig, cutoff, res: res);
		//sig = BLowPass4.ar(sig, cutoff, rq: res);
		//sig = BLowShelf.ar(sig, cutoff, rs: res);

		// then we apply the envelope
		sig = sig*envAmp;

		// and then we apply a delay
		sig = (CombL.ar(sig, 0.3, 0.3, 2) + sig)*0.3
	},
	[
		ControlSpec(50, 2000, \exp, 1, 440), // frequency
		ControlSpec(0, 20, \lin, 0.1, 5), // detune
		ControlSpec(200, 22000, \exp, 1, 11000), // cutoff
		ControlSpec(0.0001, 1, \lin, 0.01, 0.1), // res
		// ControlSpec(1,20, \lin, 1, 6) // osccount
		ObjectSpec(5)
	]
); // end Instr
)

Patch(\leaStrings2).gui
Server.local.makeGui

