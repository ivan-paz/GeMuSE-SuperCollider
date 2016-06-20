(
~countClasses = { |data|
	var size, count = 0, classes;
	size = data[0].size;
	(data[0].size).do{
		var count1 = 0, unique = [];
		data.do{|x|
			if(unique.indexOfEqual(x[count]) == nil,{unique = unique.add(x[count]); count1 = count1 + 1});
		};
		classes = classes.add(unique.size);

		count = count + 1;
	};
	classes
}
);
(
~maxParametersRange = {|array|
	var max, min, size, column, difference, range = [];
	if(array.size > 1){
	size = (0 .. array[0].size - 2);
	size.do{|col|
		column = array.slice(nil, col);
		//column.postln;
		min = column.minItem;
		max = column.maxItem;
		difference = max-min;
		range = range.add(difference);
	}};
	range
}
);
//~classDifference = 1; //The numerical difference for consider two distinct values as adjacent classes
(
~findAdjacentValues = { |parameterValues, indexesOfParameterValues|
	var xTemp, yTemp, difference, tempValues = [], tempIndexes = [];
	parameterValues.do { |x, i|
		if(x.class != Array){
		parameterValues.do { |y, j|
				if(y.class != Array){
			xTemp = (x * 1000).asInteger;
			yTemp = (y * 1000).asInteger;
			difference = abs(xTemp - yTemp);
			if( (difference <= (~classDifference * 1000)) && (difference > 0) ){
				if(tempValues.indexOfEqual(x) == nil){tempValues = tempValues.add(x);
					tempIndexes = tempIndexes.add(indexesOfParameterValues[i])};
				if(tempValues.indexOfEqual(y) == nil){tempValues = tempValues.add(y);
					tempIndexes = tempIndexes.add(indexesOfParameterValues[j])
				}
			}
		}
			}
		}
	};

	[tempIndexes,tempValues]
}
);
(
//~differenceOfAdjacentClasses = 1; // The numerical value between adjacent classes
~createSegments = { |array|
var initCount, cont, values, xTemp, yTemp, difference, newArray = [], index, tempIndex=[], indexes = [];
	values = array[1].deepCopy.sort;
	initCount = 0;
	(values.size -1).do{ |i|
		cont = i;
		xTemp = (values[i+1] * 1000).asInteger;
		yTemp = (values[i] * 1000).asInteger;
		difference = xTemp - yTemp;
		if(abs(difference) > (~differenceOfAdjacentClasses * 1000),{
			newArray = newArray.add(values[initCount..cont]);
			initCount = i + 1
		},{
			cont = cont + 1;
		});
	};
	newArray = newArray.add(values[initCount..cont]);
	newArray.do{ |item|
		tempIndex = [];
		item.do{ |x|
			index = array[1].indexOfEqual(x);
			tempIndex = tempIndex.add(array[0][index]);
		};
		indexes = indexes.add(tempIndex)
	};
	[newArray,indexes]
}
);
(
~uncompletedClassesCompression = { |data, classes|
	var sets, collection, compactionOrders, size, subspacesValues;
	size = classes.size;
	sets = [];
	subspacesValues = [];
	collection = (0 .. size - 2); // last item is always classifier
	compactionOrders = (collection.size.factorial).collect {|i|
		collection.permute(i)
	};
	compactionOrders.collect { |order|
		var temporalData = data.deepCopy;
		order.collect { |colToExclude|
			var section, selection, subsets;
			var newRule;
			section = (0..size-1).removing(colToExclude);
			subsets = temporalData.slice(nil, section);
			selection = temporalData.slice(nil, colToExclude);
			subsets.do { |x, i|
				var parameterValues = [ ];
				var indexesOfParameterValues = [ ];
				var count = 0;
				subsets.do { |y,  j |
					count = count + 1;
					if(x==y) {
						if(temporalData.at(j).notNil){
							parameterValues = parameterValues.add(temporalData[j][colToExclude]);
							indexesOfParameterValues = indexesOfParameterValues.add(j);
						};
					};
					if(count == data.size){
						count = 0;
						~classDifference = ~acceptableDifference[colToExclude];
						~differenceOfAdjacentClasses = ~acceptableDifference[colToExclude];
						b = ~createSegments.value(~findAdjacentValues.value(parameterValues,indexesOfParameterValues));
						b = b.unbubble(0,2);
						b[0].do{|z, i|
							[z, b[1][i]];
							if(b[1][i][0]!=nil){
								c = b[1][i][0];
								newRule = temporalData[c].deepCopy;
								if(newRule.notNil) {newRule[colToExclude] = z;
									temporalData = temporalData.add(newRule);
									b[1][i].collect{|w|temporalData[w]= nil}
								};
							}
						}
					}
				}
			}
		};
		sets = sets.add(temporalData);
	};
	sets = sets.collect({ |x| x.reject(_.isNil) });
	sets
}
);
(
~bagOfRules_uncompleted = { |rules|
	var bag = [];
	rules.do{ |x|
		x.do{ |y|
			y.do{|z|
			if(z.class == Array){
				if(bag.indexOfEqual(y)==nil){
					bag = bag.add(y);
					}
				}
			}
		}
	};
	bag
}
);
(
~splitRules_uncompleted = { |rules|
	var last, classes, array, splitedRules;
	if(rules.size != 0){
	last = ~classes.last;
	classes = (1 .. last);
	array = Array.fill2D(classes.size);
	rules.do{ |x|
		var evaluation;
		evaluation = x.last;
		classes.do{ |y, i|
			var temporal = [];
			if( evaluation == y) {
				temporal = array[y-1];
				temporal = temporal.add(x);
				array[ y - 1 ] = temporal
			};
		};
	};
	splitedRules = array;
}}
);