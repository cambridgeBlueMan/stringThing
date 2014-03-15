// *******************************************************************************************
// first define a MIxerGuiDef
// this has two post fader entries
// *******************************************************************************************
/*
I have played around with scaling, but the postSend widgets don't scale. Need to look at this
at some point
*/
var vertFact = 1;
var horizFact = 1;
var twoPostSends = MixerGUIDef(Point(50*horizFact, 325*vertFact),
	[
		MixerMuteWidget,
		MixerRecordWidget,
		MixerPresendWidget,
		MixerPanWidget,
		MixerLevelSlider,
		MixerLevelNumber,
		MixerPostsendWidget,
		MixerPostsendWidget,
		MixerNameWidget,
		MixerOutbusWidget],
	[
		Rect(0, 0, 20*horizFact, 20*vertFact),
		Rect(30*horizFact, 0, 20*horizFact, 20*vertFact),
		Rect(0, 25*vertFact, 50*horizFact, 30*vertFact), // presend
		Rect(0, 65*vertFact, 50*horizFact, 15*vertFact),
		Rect(10*horizFact, 85*vertFact, 30*horizFact, 100*vertFact),
		Rect(0, 190*vertFact, 50*horizFact, 15*vertFact),
		Rect(0, 210*vertFact, 50*horizFact, 30*vertFact), // post send
		Rect(0, 245*vertFact, 50*horizFact, 30*vertFact), // post send
		Rect(0, 280*vertFact, 50*horizFact, 20*vertFact),
		Rect(0, 305*vertFact, 50*horizFact, 20*vertFact)]);

// *******************************************************************************************
// now define 2 Mixer Channel defs
// they are  standard other than that they  uses our
// custom gui to display the two post sends
// *******************************************************************************************

MixerChannelDef(\eir, 1, 2,
	fader: SynthDef("mixers/eir", {
		arg busin, busout, level, pan;
		var l, r, out;
		#l, r = In.ar(busin, 2);
		out = Balance2.ar(l, r, pan, level);
		ReplaceOut.ar(busin, out);
		Out.ar(busout, out);
	}),
	controls: (level: (spec: \amp, value: 0.75),
		pan: \bipolar
	),
	guidef: twoPostSends
);
MixerChannelDef(\eir2, 2, 2,
	fader: SynthDef("mixers/eir", {
		arg busin, busout, level, pan;
		var l, r, out;
		#l, r = In.ar(busin, 2);
		out = Balance2.ar(l, r, pan, level);
		ReplaceOut.ar(busin, out);
		Out.ar(busout, out);
	}),
	controls: (level: (spec: \amp, value: 0.75),
		pan: \bipolar
	),
	guidef: twoPostSends
);
