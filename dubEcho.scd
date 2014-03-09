x = Drums.new
// ================================================================================


m = Array.fill(8, { arg i; MixerChannel("test" ++ (i+1), s) });
n = MixerChannel("essai", s);
z = MixingBoard("test board", nil, m, n);



18
19
20
21
22
(
SynthDef(\dubecho,{|length = 1, fb = 0.8, sep = 0.012|
var input = In.ar(0, 2);
var output = input + Fb({

arg feedback; // this will contain the delayed output from the Fb unit

var left,right;
var magic = LeakDC.ar(feedback*fb + input);
magic = HPF.ar(magic, 400); // filter's on the feedback path
magic = LPF.ar(magic, 5000);
magic = magic.tanh; // and some more non-linearity in the form of distortion
#left, right = magic; // let's have named variables for the left and right channels
magic = [DelayC.ar(left, 1, LFNoise2.ar(12).range(0,sep)), DelayC.ar(right, 1, LFNoise2.ar(12).range(sep,0))]; // In addition to the main delay handled by the feedback quark, this adds separately modulated delays to the left and right channels, which with a small "sep" value creates a bit of spatialization

},length);
ReplaceOut.ar(0, output);
}).add;
)
// Example Usage
(
~echo = Synth(\dubecho, [\length, TempoClock.default.tempo*(3/8), \fb, 0.7, \sep, 0.0012], addAction: \addToTail);
)
~echo.free;
~echo.set(\gate, 0);





// ===============================================================================
(
SynthDef(\dubecho3,{|in, out, length = 1, fb = 0.8, sep = 0.012|
	var input = In.ar(in, 2);
	var output = input + Fb({ |feedback|

		var left, right;
		var magic = LeakDC.ar(feedback*fb + input);
		magic = HPF.ar(magic, 400); // filter's on the feedback path
		magic = LPF.ar(magic, 5000);
		magic = magic.tanh; // and some more non-linearity in the form of distortion
		#left, right = magic; // let's have named variables for the left and right channels
		magic = [DelayC.ar(left, 1, LFNoise2.ar(12).range(0,sep)), DelayC.ar(right, 1, LFNoise2.ar(12).range(sep,0))].reverse;

	},length);

	ReplaceOut.ar(out, output);
}).add;
)
// Example as effecet bus
(
~bus = Bus.audio(s, 2);
~echo = Synth(\dubecho2, [\in, ~bus, \length, TempoClock.default.tempo*(3/8), \fb, 0.7, \sep, 0.0012], addAction: \addToTail);
)

// send something
play{ Out.ar(0, LFGauss.ar(1, 0.1, loop:0, doneAction:2) * Blip.ar(80, 8)) }

// turn it off
~echo.free;




SynthDef(\dubecho,{|length = 1, fb = 0.8, sep = 0.012|
var input = In.ar(0, 2);
var output = input + Fb({

arg feedback; // this will contain the delayed output from the Fb unit

var left,right;
var magic = LeakDC.ar(feedback*fb + input);
magic = HPF.ar(magic, 400); // filter's on the feedback path
magic = LPF.ar(magic, 5000);
magic = magic.tanh; // and some more non-linearity in the form of distortion
#left, right = magic; // let's have named variables for the left and right channels
magic = [DelayC.ar(left, 1, LFNoise2.ar(12).range(0,sep)), DelayC.ar(right, 1, LFNoise2.ar(12).range(sep,0))]; // In addition to the main delay handled by the feedback quark, this adds separately modulated delays to the left and right channels, which with a small "sep" value creates a bit of spatialization

},length);
ReplaceOut.ar(0, output);
}).store;

// Example Usage
~echo = Synth(\dubecho, [\length, TempoClock.default.tempo*(3/8), \fb, 0.7, \sep, 0.0012], addAction: \addToTail);
~echo.free;
~echo.set(\gate, 0);