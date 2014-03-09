/*
There should be a number of channels with mono input and a number of channels with stereo
input. All channels should have stereo output. There should be a channel for reverb and a channel for chorus. These should each have insert effects applied to them. Appropriate send levels will be placed on the individual channels.
The whole lot should be visible if required, but I no longer think that that is as big a deal as I once thought.

s.makeGui
MixerChannel.freeAll
*/
(
var numberOfMonoChannels = 4;
var numberOfStereoChannels = 4;

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

// now do rest
~mixingBoard = MixingBoard.new("Rupert Neve");
~monoChannels = List.new(0);
~stereoChannels = List.new(0);
~masters = Dictionary.new;


// *******************************************************************************************
//              NOW MAKE THE MIXER
// *******************************************************************************************

// ******************
// add masters channel
~masters["master"] = MixerChannel.newFromDef("master", \mix2x2, s);
// ~masters["master"].level = 1;
// ************************************************************
// add destination channels and functionaility for send effects
~masters["reverb"] = MixerChannel(\rvb, s, 2, 2, level:1,
	outbus:~masters["master"],
	completionFunc: { |chan|
		"creating reverb synth".postln;
		chan.playfx({ |outbus|
			var	sig = In.ar(outbus, 2);  // read from channel's bus
			FreeVerb2.ar(sig[0], sig[1], 1, 0.6, 0.5)
		});
});
~masters["chorus"] = MixerChannel.new("chorus", s,2,2,outbus:~masters["master"]
);
~masters["chorus"].playfx(Instr.at(#[\busfx, \chorus2]));

// ********************************************************
//          MAKE THE MONO CHANNELS
// ********************************************************
numberOfMonoChannels.do ({|i|
	var name = "mono " + i.asString;
	// first make the channel
	~monoChannels.add(MixerChannel.newFromDef(name, \eir, s, outbus:~masters["master"]));
	// then add the postFade sends, note that it would be very easy to add more
	~monoChannels[i].newPostSend(~masters["reverb"], 0.5);
	~monoChannels[i].newPostSend(~masters["chorus"], 0.1);
	//
	~mixingBoard.add(~monoChannels[i]);
});
// ********************************************************
//          MAKE THE STEREO CHANNELS
// ********************************************************

numberOfStereoChannels.do ({|i|
	var name = "stereo " + i.asString.postln;
	~stereoChannels.add(MixerChannel.newFromDef(name, \eir2, s, outbus:~masters["master"]));
	~stereoChannels[i].newPostSend(~masters["reverb"], 0.5);
	~stereoChannels[i].newPostSend(~masters["chorus"], 0.1);
	~mixingBoard.add(~stereoChannels[i]);
});

// *****************************
// add these to the mixing board
~mixingBoard.add(~masters["chorus"]);
~mixingBoard.add(~masters["reverb"]);
~mixingBoard.add(~masters["master"]);


// stuff to get rid of it all on CmdPeriod
CmdPeriod.add {
	AppClock.sched(0.5,
		{	MixerChannel.freeAll(s);
			~monoChannels.do({|item, i| item.free; });
			//	~stereoChannels.do({|item, i| item.free; });

	});

	AppClock.sched(0.5,
		{	MixerChannel.freeAll(s);
			//	~monoChannels.do({|item, i| item.free; });
			~stereoChannels.do({|item, i| item.free; });

	});
}; // end CmdPeriod
)




// *******************************************************************************************
//            SOME CODE TO TEST IT ALL
// *******************************************************************************************

(

//s.boot;

// simple electro kick drum
SynthDef(\kik, { |basefreq = 50, envratio = 3, freqdecay = 0.02, ampdecay = 0.5, outbus = 0|
	var   fenv = EnvGen.kr(Env([envratio, 1], [freqdecay], \exp), 1) * basefreq,
	aenv = EnvGen.kr(Env.perc(0.005, ampdecay), 1, doneAction:2);
	Out.ar(outbus, SinOsc.ar(fenv, 0.5pi, aenv));
}).send(s);

// m = MixerChannel(\kik);
PeakMonitor(~monoChannels[0], 5);

r = fork {
	loop {   // the args here are to make sure the sound goes through the mixer
		s.sendBundle(0.1, [\s_new, \kik, -1, 0, ~monoChannels[0].synthgroup.nodeID, \outbus, ~monoChannels[0].inbus.index]);
		0.5.wait;
	}
};
)

