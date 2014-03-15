/*
There should be a number of channels with mono input and a number of channels with stereo
input. All channels should have stereo output. There should be a channel for reverb and a channel for chorus. These should each have insert effects applied to them. Appropriate send levels will be placed on the individual channels.
The whole lot should be visible if required, but I no longer think that that is as big a deal as I once thought.
PeakMonitor(0)
s.makeGui
MixerChannel.freeAll
*/
(
var numberOfMonoChannels = 4;
var numberOfStereoChannels = 4;

/* get an array containing all matching path */
 (thisProcess.nowExecutingPath.dirname  ++ "/eirMixerGuiDef.scd").load;
 (thisProcess.nowExecutingPath.dirname  ++ "/ddwEffects.scd").load;
 (thisProcess.nowExecutingPath.dirname  ++ "/leaEffects.scd").load;

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


// ********************************************************
//          MAKE THE REVERB CHANNEL
// ********************************************************

// ****************
// make the channel
~masters["reverb"] = MixerChannel(\rvb, s, 2, 2, level:1,
	outbus:~masters["master"],
);

// **********************************
// insert the effect into the channel
~viewReverb = ~masters["reverb"].playfx(Instr.at(\busGVerb));

//~viewReverb = ~masters["reverb"].playfx(Instr.at(\freeverb2));
//~viewReverb = ~masters["reverb"].playfx(Synth(\freeverb2));

// ************************
// make a gui for the patch
~viewReverb.gui;


// ********************************************************
//          MAKE THE CHORUS CHANNELS
// ********************************************************

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



)


