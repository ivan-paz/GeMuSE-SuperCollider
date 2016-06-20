///---------------------------------------
///----- functions for process the data ---------

~cleanProcessingData = { arg data;
	var instance, size, cleanedData = [];
	size = data[0].size;
	data.do{|x,i|
		instance = data[i];
		instance = instance[1..];
		cleanedData = cleanedData.add(instance);
	};
	cleanedData;
};

(
~maxParametersRange = {|array|
	var max, min, size, column, difference, range = [];
	size = (0 .. array[0].size - 2);
	size.do{|col|
		column = array.slice(nil, col);
		//column.postln;
		min = column.minItem;
		max = column.maxItem;
		difference = max-min;
		range = range.add(difference);
	};
	range
}
);
(
~selectRule = { |splitRules, class|
	var ruleTemp = [], rule = [];
	if(splitRules[class]!=[]){
	ruleTemp = splitRules[class].choose;
	ruleTemp.do{ |x|
			var value;
			if(x.class == Array){value = x.choose; rule = rule.add(value)}{rule = rule.add(x)};
	};
	}{'there are no rules for this class'.postln};
	rule
}
)