
function download2CVSFile(){
	var data = $tblReport.table2CSV({delivery:'value'});

	$('<a></a>')
	.attr('id','downloadFile')
	.attr('href','data:text/csv;charset=utf8,' + encodeURIComponent(data))
	.attr('download','filename.csv')
	.appendTo('body');

	$('#downloadFile').ready(function() {
	$('#downloadFile').get(0).click();
});

}



