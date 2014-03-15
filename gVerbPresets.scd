


// +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
(
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
	-6.dbamp,
	//earlylevel,
	-11.dbamp,
	//taillevel,
	-13.dbamp
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
	3.dbamp,
	//earlylevel,
	-15.dbamp,
	//taillevel,
	-17.dbamp
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
	-3.dbamp,
	//earlylevel,
	-9.dbamp,
	//taillevel,
	-11.dbamp
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
	-3.dbamp,
	//earlylevel,
	-11.dbamp,
	//taillevel,
	-9.dbamp
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
	-5.dbamp,
	//earlylevel:
	-26.dbamp,
	//taillevel:
	-20.dbamp];
)

// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//            CODE TO LOAD PRESETS
// *************************************************************************
(
var theThing = "canyon";
[2,3,4,5,6,7,8,9].do({|item, i|
	item.postln; i.postln;
	~viewReverb.set(item, ~presets[theThing].at(i.asInteger).postln);

}); // end do
)
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
