// ***************************************************************************************
//                  GVERB INSERT EFFECT
// ***************************************************************************************

(
SynthDef(\freeverb2, {|bus, numchannels, mix =  0.33, room=0.5, damp= 0.5|
	var in = In.ar(bus);
	var in2 = In.ar(bus + 1);
	var sig = FreeVerb2.ar(
		in, in2,
		mix, room, damp
	);
	Out.ar(0, sig)
	},
).add;

Instr(\freeverb2, {|bus, numchannels, mix =  0.33, room=0.5, damp= 0.5|
	var in = In.ar(bus, numchannels);
	var in2 = In.ar(bus + 1, 1);
	var sig = FreeVerb.ar(
		/*in,*/ in,
		mix, room, damp
	);
	},
	[
		\audiobus,
		ObjectSpec(2),
		[0, 1, \lin, 0.001, 1], // dry level
		[0, 1, \lin, 0.001, 1], // room size
		[0, 1, \lin, 0.0001, 0.5] // damping
	]
);
// x = Patch(\freeverb2).gui;




//***************************************************************************************
//                  GVERB BUS EFFECT
// ***************************************************************************************
// gVerb
Instr(\busGVerb,
	/*
	this expects audio bus as input
	*/


	{ |bus, numChannels, roomsize, revtime, damping, inputbw, spread = 15, drylevel, earlylevel, taillevel |
		var in = In.ar(bus, numChannels);
		var sig = GVerb.ar(
			in,
			roomsize,
			revtime,
			damping,
			inputbw,
			spread,
			drylevel,
			earlylevel,
			taillevel,
			roomsize, 0.3) + in;
		sig;
	};
	,
	[
		\audiobus,
		ObjectSpec(1),
		[1, 300, \lin, 1, 20], // room size
		[0.0001, 120, \lin, 0.001, 3], // // rev time
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
			drylevel,
			earlylevel,
			taillevel,
			roomsize, 0.3) + in;
		sig*0.3;
	};
	,
	[
		\audio,
		[1, 300, \lin, 1, 20], // room size
		[0.0001, 120, \lin, 0.001, 3], // // rev time
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




// +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

~presets = Dictionary.new;
// bathroom
~presets["bathroom"] = [
	//roomsize,
	5,
	//revtime,
	0.6,
	//damping,
	0.62,
	//inputbw,
	0.48,
	// spread
	15,
	//drylevel
	0.50119, // -6.dbamp,
	//earlylevel,
	0.28184, // -11.dbamp,
	//taillevel,
	0.22387 // -13.dbamp
];

~presets["livingroom"] =  [
	//roomsize,
	16,
	//revtime,
	1.24,
	//damping,
	0.10,
	//inputbw,

	0.95,
	// spread
	15,
	//drylevel -
	0.7079, //-3.dbamp,
	//earlylevel,
	0.17783, //-15.dbamp,
	//taillevel,
	0.14125 //-17.dbamp
];

~presets["church"] =
[
	//roomsize,
	80,
	//revtime,
	4.85,
	//damping,
	0.41,
	//inputbw,
	0.19,
	// spread
	15,
	//drylevel
	0.7079, //-3,
	//earlylevel,
	0.35481, //-9.dbamp,
	//taillevel,
	0.28184 //-11.dbamp
];


~presets["cathedral"] =
[
	//roomsize,
	243,
	//revtime,
	1,
	//damping,
	0.1,
	//inputbw,
	0.34,
	// spread
	15,
	//drylevel
	0.7079, //-3,
	//earlylevel,
	0.28184, //-11,
	//taillevel,
	0.35481 //-9
];

// canyon
~presets["canyon"]= [
	//roomsize:
	300,
	//revtime:
	103,
	//damping:
	0.43,
	//inputbw:
	0.51,
	// spread
	15,
	//drylevel:
	0.56234, //-5.dbamp,
	//earlylevel:
	0.05012, //-26.dbamp,
	//taillevel:
	0.1// -20.dbamp
];

); // file end
// ~viewReverb.set([\roomsize, 243, \revtime, 1, \damping, 0.1, \inputbw, 0.34, \drylevel, -3, \earlylevel, -11, \taillevel, -9])
// ~dict = Dictionary.new;
// // bath
// ~dict["bathroom"]  = (roomsize: 5, revtime: 0.6, damping: 0.62, inputbw: 0.48, drylevel: -6, earlylevel: -11, taillevel: -13);
//
//
// //living room
//
// ~dict["living room"] =  (roomsize: 16, revtime: 1.24, damping: 0.10, inputbw: 0.95, drylevel: -3, earlylevel: -15, taillevel: -17);
//
//
// //church
// ~dict["church"] = (roomsize: 80, revtime: 4.85, damping: 0.41, inputbw: 0.19, drylevel: -3, earlylevel: -9, taillevel: -11);
//
//
// // cathedral
// ~dict["cathedral2"]  = [roomsize, 243, revtime, 1, damping, 0.1, inputbw, 0.34, drylevel, -3, earlylevel, -11, taillevel, -9];
//




