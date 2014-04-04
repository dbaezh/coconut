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