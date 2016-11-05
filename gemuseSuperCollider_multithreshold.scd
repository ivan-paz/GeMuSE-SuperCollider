// Algorithmic system to be explored
s.boot
(
Ndef(\x,{
	arg freq, freq2, amp;
	var sig;
	sig = Saw.ar(freq) + Saw.ar(freq - 1);
	sig = sig + ( Saw.ar(freq2) + Saw.ar(freq2) );
	sig = sig + Impulse.ar(20, amp/4);
	sig = sig!2;
	sig = FreeVerb.ar(sig, 0.33, 0.5, 0.5, 1) * amp;
})
)
Ndef(\x).play


~data = []; // Array in which the classified parameter sets will be stored



// Comunicate with processing via OSC
(
~osc = OSCresponder(n,"/parametres", {|...msg|
	~parametres = msg[2];
	Ndef(\x).set(
		\freq,  ~parametres[1].round(0.0001).linlin(0, 1,   0, 400),
		\freq2, ~parametres[2].round(0.0001).linlin(0,1, 0, 400),
		\amp,   ~parametres[3].round(0.0001).linlin(0,1,   0, 1));
	Ndef(\x).getKeysValues.postln
}).add;
~osc1 = OSCresponder(n, "/data", {|...msg|
	~instance = msg[2];
	~instance[1] = ~instance[1].round(0.0001).linlin(0,1, 0, 400);
	~instance[2] = ~instance[2].round(0.0001).linlin(0,1 ,0, 400);
	~instance[3] = ~instance[3].round(0.0001).linlin(0,1, 0,1);
	if(~data.indexOfEqual(~instance).isNil){~data = ~data.add(~instance)}
	{'already salved!'.postln}
}).add
)

// Stop data acquisition process and Ndef
(
~osc.remove;
~osc1.remove;
Ndef(\x).stop
)




//_________________________________________________________

//__________        rule extraction process     ___________


// Check the data
~data.do{ arg item; item.postln}


//  Save data session
//  dir = " /location/to/store/the/data"

//a = ~data.writeArchive("dir/dataFile");


//  Read session
//   ~data = Object.readArchive("dir/dataFile");


//  import compression functions
"/home/ivan/documents/ia/par_by_par_compression_algorithm/GeMuSE-SuperCollider/rule_extraction_function.scd".load;

//"/home/ivan/documents/ia/par_by_par_compression_algorithm/GeMuSE-SuperCollider/extra_functions.scd".load;


//--------------------------------------------------
//             set intervals and threshold for
//                     each parameter
//-------------------------------------------------
(~intervals_and_distances = [
      [
              [ [0,inf],  1000 ]
      ],
      [
              [ [0,inf],  1000 ]
      ],
	  [
		  [ [0, inf],  1]
	  ]
])


//  Extract rules
(
~cleanedData = ~cleanProcessingData.value(~data);
~rules = ~subsetsCompression.value(~cleanedData,~intervals_and_distances);
~bag = ~bagOfRules_uncompleted.value(~rules);
~split = ~splitRules_uncompleted.value(~bag);
)


//   Rules for each class are stored in ~split

//   Check the extracted rules
(
~split.do{ arg class;
	class.do{arg rule; rule.postln}
})


//------------------------------------------------------------------------
//  Play the rules and send the used patterns back to processing for visualization



~host = NetAddr("localhost", 12000); // Processing adress


Ndef(\x).set(\amp, 0);
Ndef(\x).play


(
Tdef(\sending,{
	arg values, cont = -1, rule;
	1.do{
		10.do{
			rule = ~selectRule.value(~split,0);
			rule.postln;
			Ndef(\x).set(\freq, rule[0], \freq2, rule[1], \amp, rule[2]- 0.25);
			rule[0] = rule[0].linlin(0,400, 0,1.0);
			rule[1] = rule[1].linlin(0,400, 0,1.0);
			rule[2] = rule[2].linlin(0,1.0, 0,1.0);
			rule[3] = rule[3].asFloat;
			cont = cont + 1;
			values = rule;
			o = OSCFunc(~host.sendMsg("/trigger", *values), s.addr);
			10.wait;
		};
		10.do{
			rule = ~selectRule.value(~split,1);
			rule.postln;
			Ndef(\x).set(\freq, rule[0], \freq2, rule[1], \amp, rule[2]-0.25);
			rule[0] = rule[0].linlin(0,400, 0,1.0);
			rule[1] = rule[1].linlin(0,400, 0,1.0);
			rule[2] = rule[2].linlin(0,1.0, 0,1.0);
			rule[3] = rule[3].asFloat;
			cont = cont + 1;
			values = rule;
			o = OSCFunc(~host.sendMsg("/trigger", *values), s.addr);
			10.wait;
		};
	};
})
)
Tdef(\sending).play

Tdef(\sending).stop

Ndef(\x).stop


