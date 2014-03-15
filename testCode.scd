// *******************************************************************************************
//            SOME CODE TO TEST IT ALL
// *******************************************************************************************
(
SynthDef(\test2, {|amp= 2, outbus = 0|
    var a = Resonz.ar(
        Array.fill(4, {Dust.ar(2)}), 1760 * [1, 2, 4, 8], 0.01).sum * 10;
Out.ar(outbus, a*amp)
}).add
)

~monoChannels[0].play(\test2)
Synth(\test2)
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


// *******************************************************************************************
//            more CODE TO TEST IT ALL
// *******************************************************************************************

b = Buffer.read(s, "/Users/macuser/Documents/vox.aif")

b = Buffer.read(s, "/Users/macuser/Music/SuperCollider Recordings/SC_130616_224330.aiff")

/* of course, this patch will produce nothing like the desired effect unless we choose our parameters sensibly. Firstly, you'll find that the barest minimum of modulation is needed. If you can't obtain a low enough modulation level from the Level knob on the LFO, place an attenuator in the modulation signal path to reduce the amplitude even further. In contrast, you have a wide choice of modulation rates. A slow sweep at a fraction of 1Hz will provide a gentle chorus, while a faster rate — say, 5Hz to 7Hz — will result in a more typical 'synth' ensemble. The other vital factor is the delay time. Set this to be too long, and you'll hear a distinct delay. Set it too short, and you'll obtain a version of another effect: flanging. But get it right — somewhere in the range 10ms to 50ms, as your taste dictates — and then mix the two signal paths in equal measure, and you'll obtain a serviceable chorus, reminiscent of the cheapest '70s string synths. Hang on... the cheapest '70s string synths? The individual modules in this patch (or an equivalent software modular synthesis application) could cost a couple of hundred quid, so you've a right to expect something a bit better. What's going on?

*/
(
SynthDef(\blipdrop, { |out, freq, freqdrop, dur, trigStart, trigEnd, bufnum|
   var trig, tfreq, amp, timeScale, osc, pan;
   trig = Impulse.kr((tfreq = XLine.kr(trigStart, trigEnd, dur))
      + LFNoise0.kr(12, tfreq * 0.8, tfreq));
   amp = EnvGen.kr(Env(#[0, 1, 0.8, 0], #[0.01, 4, 4].normalizeSum), 1, timeScale:dur,
      doneAction:2);
   pan = LFNoise1.kr(0.8, 0.8);
   freq = freq * LFNoise1.kr(1.2, 0.2, add: Line.kr(1, freqdrop, dur));
   osc = Osc.ar(bufnum, Latch.kr(freq, trig), 0, amp);
   Out.ar(out, Pan2.ar(Decay2.kr(trig, 0.01, 0.08) * osc, pan));
}).add;
~dlybuf = Buffer.alloc(s, 6.05 * s.sampleRate, 1);
~oscbuf = Buffer.alloc(s, 4096, 1)
   .sine2(({ |i| rrand(3-i, 6-i) + (i+2).reciprocal.rand2 } ! 4), (1..4).reciprocal);
)


(
r = Task({
	{   ~monoChannels[0].play(\blipdrop, [\freq, rrand(1000, 2000), \freqdrop, rrand(0.4, 0.7),
         \dur, rrand(6, 10), \bufnum, ~oscbuf.bufnum,
         \trigStart, rrand(1.1, 1.4), \trigEnd, rrand(7.0, 10)]);
      rrand(5, 12).wait;
   }.loop;
}).play;
)

r.stop
(

SynthDef.new(\temp, {Out.ar(0, Pan2.ar(PlayBuf.ar(1, b.bufnum), 0))}).add;
~monoChannels[0].play(\temp)
)
// 88888888888888888888888888888888888888888  ddw stuff

////////// usage example: kick drum
// load the above definitions before running this example


s.makeGui;

// simple electro kick drum
SynthDef(\kik, { |basefreq = 50, envratio = 3, freqdecay = 0.02, ampdecay = 0.5, outbus = 0|
	var	fenv = EnvGen.kr(Env([envratio, 1], [freqdecay], \exp), 1) * basefreq,
		aenv = EnvGen.kr(Env.perc(0.005, ampdecay), 1, doneAction:2);
	Out.ar(outbus, SinOsc.ar(fenv, 0.5pi, aenv));
}).add;

m = MixerChannel(\kik);
PeakMonitor(m, 5);

r = fork {
	loop {	// the args here are to make sure the sound goes through the mixer
		s.sendBundle(0.1, [\s_new, \kik, -1, 0, m.synthgroup.nodeID, \outbus, m.inbus.index]);
		1.wait;
	}
};

// a method implemented in dewdrop_lib, to list each arg in the Instr with its spec
Instr.at(\busGVerb).listArgs;

// MixerChannel-playfx makes the FxPatch and automatically substitutes the correct bus number
// you could also do
// p = FxPatch([\busfx, \companderd], [m.inbus.index, 1]).play(m.synthgroup, nil, m.inbus.index);

p = m.playfx(Instr.at(#[\busfx, \pingpong]));
p.gui;	// make a control panel for it

// now adjust the settings in the gui
// note that each slider has an appropriate range, as defined in the spec
// I like these, but you should experiment:

// thresh -> 0.337
// slopeBelow -> 1
// slopeAbove -> 0.307	// roughly 3:1 compression
// clampTime -> 0.00269
// relaxTime -> 0.0475
// postGain -> 1.887

// to prove it's doing something, turn the compander on and off
p.run(false);		// off
p.run(true);		// on -- sounds fatter, but the peak level is about the same

// clean up
r.stop;
p.free;
m.free;

// now that the settings are identified, you could use it in a piece like this
// the # button in the patch gui prints out all the values

FxPatch(#[\busfx, \companderd], #[16, 1, 0.33720930232558, 1, 0.30787334695492, 0.0026922339168174, 0.047581692465085, 1.887182729615]);

m.playfx(FxPatch(#[\busfx, \companderd], #[16, .....]));
