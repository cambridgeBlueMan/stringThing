/* PREAMBLE */
s.makeGui
(

// *************************************
// function to generate a saw tooth wave
{
	var freq = 120;
	Mix.ar(Array.fill(4, {|i|
		var freq = 120;
		SinOsc.ar(
			freq: (freq + (freq*i)),
			mul:(-1.pow(i)/(1+i))*0.5
		)
	}));
}.scope
)

// **********************************************
// function to generate an inverse saw tooth wave
(
{
	var freq = 120;
	Mix.ar(Array.fill(15, {|i|
		var freq = 120;
		SinOsc.ar(
			freq: (freq + (freq*i)),
			mul:(1/(1+i))*0.5
		)
	}));
}.scope
)

// *************************************************
// function to generate the famous "not" a sine wave
(
{
	var freq = 120;
	Mix.ar(Array.fill(50, {|i|
		var freq = 120;
		SinOsc.ar(
			freq: (freq + (2*freq*i)),
			mul:(-1.pow(i)/(1+i).pow(2))*0.5
		)
	}));
}.scope
)


// ************************************
// function to generate a triangle wave
(
{
	var freq = 120;
	Mix.ar(Array.fill(50, {|i|
		var freq = 120;
		SinOsc.ar(
			freq: (freq + (2*freq*i)),
			mul:(-1.pow(i)/(1+(i*2)).pow(2))*0.5
		)
	}));
}.scope
)

// *********************************
// function to generate a pulse wave
(
{
	var freq = 120;
	Mix.ar(Array.fill(50, {|i|
		var freq = 120;
		SinOsc.ar(
			freq: (freq + (freq*i*2)),
			mul:(1/(1+(i*2)))*0.5
		)
	}));
}.scope
)


