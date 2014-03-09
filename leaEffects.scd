// ***************************************************************************************
//                  GVERB INSERT EFFECT
// ***************************************************************************************

(
Instr(\gVerb,
	/*
	being an insert effect this expects audio as input
	*/

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
);

// ***************************************************************************************
//                  GVERB BUS EFFECT
// ***************************************************************************************
// gVerb
Instr(\busGVerb,
	/*
	this expects audio bus as input
	*/


	{ |bus, roomsize, revtime, damping, inputbw, spread = 15, drylevel, earlylevel, taillevel |
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
);

/*
Instr(#[\busfx, \pingpong], { arg bus, numChan, bufnum, time, feedback, rotate;
PingPong.ar(bufnum, In.ar(bus, numChan), time, feedback, rotate);
}, [\audiobus, ObjectSpec(1), #[0, 128, \lin, 1, 0], #[0, 20], #[0, 1], #[0, 20, \linear, 1, 1]]);
*/

/*
Instr(#[\busfx,\pingpong], {|delayTime, feedback, maxDelay, outbus, numChan|
	var sig = In.ar(outbus, numChan);
	sig = PingPong.ar(
		LocalBuf(2*maxDelay*44100,2),
		sig,
		delayTime,
		feedback,
		1);
	// Out.ar(outbus, sig);
	},
	[
		#[0.001, 2, \lin, 0.001,0.3], // delayTime
		#[0,1,\lin,0.001, 0.7], // feedback
		#[0.5, 2, \lin, 0.001, 2], // maximum possible delay
		\audiobus,
		#[1,2,\lin,1,2]
	] // end specs array
);
*/
/*
SynthDef(\dubecho2,{|outbus, length = 0.2, fb = 0.7, sep = 0.012|
	var input = In.ar(outbus, 2);
	var output = input + Fb({ |feedback|

		var left, right;
		var magic = LeakDC.ar(feedback*fb + input);
		magic = HPF.ar(magic, 400); // filter's on the feedback path
		magic = LPF.ar(magic, 5000);
		magic = magic.tanh; // and some more non-linearity in the form of distortion
		#left, right = magic; // let's have named variables for the left and right channels
		magic = [DelayC.ar(left, 1, LFNoise2.ar(12).range(0,sep)), DelayC.ar(right, 1, LFNoise2.ar(12).range(sep,0))].reverse;

	},length);

	ReplaceOut.ar(outbus, output);
}).load;
*/
); // file end