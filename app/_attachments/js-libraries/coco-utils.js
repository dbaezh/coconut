/**
 * Created by vbakalov on 1/25/14.
 */

Object.defineProperty(Array.prototype, "removeByIndex", {
    enumerable: false,
    value: function (item) {
        var removeCounter = 0;

        for (var index = 0; index < this.length; index++) {
            if (this[index] === item) {
                this.splice(index, 1);
                removeCounter++;
                index--;
            }
        }

        return removeCounter;
    }
});

Array.prototype.removeByValue = function() {
    var what, a = arguments, L = a.length, ax;
    while (L && this.length) {
        what = a[--L];
        while ((ax = this.indexOf(what)) !== -1) {
            this.splice(ax, 1);
        }
    }
    return this;
};

/**
 * Saves the document as inactive and also incomplete so it does not show up in any results.
 * 
 *
 * @param result_id - the document id that will be marked as inactive and incomplete
 * @returns {*}
 */
function invalideDocById(result_id){
    Coconut.questionView.result = new Result({
        _id: result_id
    });

    // make inactive the registration
    return Coconut.questionView.result.fetch({
        success: function(model) {
            model.set({inactive:"true"});
            model.set({Completado:"false"});

           return  model.save(null, {success: function(){
                console.log("Successfully inactivated!");

            }});
        }});

}

function sortJSONData(data, key, asc) {
	return data.sort(function(a, b) {
		var x = a.value[key];
		var y = b.value[key];
		if (asc) return (x > y) ? 1 : ((x < y) ? -1 : 0);
		else     return (y > x) ? 1 : ((y < x) ? -1 : 0);
	});
}

// assumes you are sorting strings
function caseInsensitiveSortJSONData(data, key, asc) {
	return data.sort(function(a, b) {
		var x1 = a.value[key];
		var y1 = b.value[key];
		if (x1 == null || y1 == null) {
		  if (asc) {
			return 1;
		  } else {
			return -1;
		  }
		}
		var x = x1.toUpperCase();
		var y = y1.toUpperCase();
		if (asc) return (x > y) ? 1 : ((x < y) ? -1 : 0);
		else     return (y > x) ? 1 : ((y < x) ? -1 : 0);
	});
}

// Add startsWith function
if (typeof String.prototype.startsWith != 'function') {
    // see below for better implementation!
    String.prototype.startsWith = function (str){
        return this.indexOf(str) == 0;
    };
}