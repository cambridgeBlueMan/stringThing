(
PeakMonitor(0);
Instr(\leaStrings1,
{|freq= 440, det = 5, cutoff=11000, res=0.1|

//dummyenv is addressing the issue of fading echo at the end
    var dummyEnv = EnvGen.ar(Env.new([1,0], [10]), doneAction: 2);
    var envAmp = EnvGen.ar(Env([0,1,1,0], [2,4,2], \squared));

		// in this next block I am using LFNoise to modulat the frequency. I am making several of these and then adding them all together. In essence each of these creates a shifting, altered freq. It sounds extremely like a violin, but not like an ensemble
    var altered = freq + LFNoise1.ar(4, (freq*2.pow(det/1200)-freq));
    var altered2 = freq + LFNoise2.ar(4, (freq*2.pow(det/1200)-freq));
    var altered3 = freq + LFNoise2.ar(4, (freq*2.pow(det*2/1200)-freq));
    var altered4 = freq + LFNoise2.ar(4, (freq*2.pow(det*2/1200)-freq));

//then we mix them all together as sawtooth waves
    var sig = Mix.ar(SawDPW.ar([freq, altered, altered2, altered3, altered4]));

//there are various choices of filter
  sig = DFM1.ar(sig, cutoff, res: res);
    sig = BLowPass4.ar(sig, cutoff, rq: res);
    sig = BLowShelf.ar(sig, cutoff, rs: res);

//then we apply the envelope
	 sig = sig*envAmp;

//and then we apply the delay
   	 sig = (CombL.ar(sig, 0.3, 0.3, 2) + sig)*0.1
},
    [
   	 ControlSpec(50, 2000, \exp, 1, 440), // frequency
   	 ControlSpec(0, 20, \lin, 0.1, 5), // detune
   	 ControlSpec(200, 22000, \exp, 1, 11000), // cutoff
   	 ControlSpec(0.0001, 1, \lin, 0.01, 0.1) // res
]
).play; // end Instr
)