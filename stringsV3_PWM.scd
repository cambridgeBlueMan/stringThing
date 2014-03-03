(
// **************************
// true pulse code modulation
{|freq = 440, cutoff = 1000, res = 0.3|
	var sig = Mix.ar([
		Pulse.ar(freq+1, LFNoise1.ar(0.2)),
		Pulse.ar(freq, (SinOsc.ar(0.1).range(0.1, 0.9)))
	]);
		sig = DFM1.ar(sig, cutoff, res: res);
}.play

)


(

{|freq = 440, cutoff = 1000, res = 0.3|
	var sig =
	Mix.ar([
		Pulse.ar(freq, LFTri.ar(0.015)),
		Pulse.ar((freq+LFNoise2.ar(2)), LFTri.ar(0.01))
	])*0.5;
sig = DFM1.ar(sig, cutoff, res: res);
}.play

)

(
// *****************************
// VarSaw duty cycle modulation
{|freq = 440, cutoff=1000, res = 0.3|
	var sig = Mix.ar([
		VarSaw.ar(freq+1, LFNoise1.ar(0.2)),
		VarSaw.ar(freq, width: (SinOsc.ar(0.1).range(0.1, 0.9)))
	]);
	sig = DFM1.ar(sig, cutoff, res: res);
}.play

)


(
// *************************
// the following simuates it
{|freq = 440, cutoff = 3000, res = 0.1, detune = 0.06, lfoFreq = 60|
	var sig = Mix.ar(
		[
			//
			VarSaw.ar(SinOsc.ar(lfoFreq, 0, 0.5, mul: detune, add: freq), width: 1),
			VarSaw.ar(freq+0.1, width:0, iphase: 0.5)
		]*0.1
	);
	sig; // = DFM1.ar(sig, cutoff, res: res);
}.play; //(0.01)
)