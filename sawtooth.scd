{|freq = 440| Mix.ar(SinOsc.ar([freq, freq*2, freq*3, freq*4, freq*5, freq*6, freq*7, freq*8, freq*9], 0, [1, -1/2, 1/3, -1/4, 1/5, -1/6, 1/7, -1/8, 1/9]))}.play


(
Instr(\testOsc,
	{|numPartials = 9, freq = 440, det = 5, numOscs=8, cutoff = 11000, res = 0.3|

// ************************
// make a sawtooth wvetable

var asWt =Signal.sawtooth(512, 16).asWavetable;

// **********************************************
// load it to a buffer so that the Osc can use it

var buffer = Buffer.sendCollection(s, asWt);
var freqs = Array.fill(8, {|i|
	freq*2.pow(det*i/1200).postln
}).postln; // end array fill
// ************************
// now the Osc can play it!

		var osc = Osc.ar(buffer, freqs, 0, 0.5);
//var sig = DFM1.ar(osc, cutoff, res: res);
var sig = BLowPass4.ar(osc, cutoff, rq: res);
//var sig sig = BLowShelf.ar(osc, cutoff, rs: res);

		Mix.ar(sig)

	},
	[
		ControlSpec(1, 20, \lin, 1, 7), // number of partials
		ControlSpec(20, 2000, \exp, 1, 440), // freq
		ControlSpec(0, 10, \lin, 0.1, 5), // detune
		ControlSpec(1, 8, \lin, 1, 4), // number of oscillators
		ControlSpec(200, 22000, \exp, 1, 11000), // cutoff
		ControlSpec(0.001, 1, \lin, 0.001, 0.3)// res
	]
)
)

Patch(\testOsc).gui

(
100.do({|i|
	(440*2.pow(i*5/1200)).postln;
})
)
(
{
	Mix.ar(Saw.ar([440,441.27260666252,442.54889406986,443.82887286778,
		445.11255373285,446.39994737251,447.69106452518,448.98591596033],
		mul:0.1)
)}.play
)

466


var asWt =Signal.sawtooth(512, 16).asWavetable;

// **********************************************
// load it to a buffer so that the Osc can use it

~buffer = Buffer.sendCollection(s, asWt);
var freqs = Array.fill(8, {|i|
	freq*2.pow(det*i/1200).postln
}).postln; // end array fill
// ************************
// now the Osc can play it!
{ COsc.ar(~buffer.bufnum, 440, 1, 0.1) }.plot(0.1); //scope(1, zoom:4);
		var osc = Osc.ar(buffer, freqs, 0, 0.5);


.dup










