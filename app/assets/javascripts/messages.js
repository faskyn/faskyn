

//hiding submit button until file gets ready to be uploaded
//$(".refile_form").find("input[type=submit]").hide();
//$(".removecheck").hide();

//refile JS library: showing the user what is going on + submit button
//gets visible; then available once 100% is uploaded to S3
$(document).on("upload:start", ".refile_form", function(e) {
	$(".refile_form").find("input[type=submit]").show();
  	$(this).find("input[type=submit]").attr("disabled", true);
  	$("#progresspercent").show();
  	$("#progresspercent").text("Uploading...");
	});

$(document).on("upload:progress", ".refile_form", function(e) {
    var detail;
    var percentComplete;
    var filename;
    filename = $('.choosefile').val();
    detail = e.originalEvent.detail;
    percentComplete = Math.round(detail.progress.loaded / detail.progress.total * 100);
    $('#progresspercent').text(percentComplete + "% uploaded " + filename );
});

$(document).on("upload:success", ".refile_form", function(e) {
    if (!$(this).find("input.uploading").length) {
      $(this).find("input[type=submit]").removeAttr("disabled");
      //$(".removecheck").show();
    };
});

//when file upload submitted file form is set back to its default form
//$('.btn-submit-refile').on('click', function(){
$(document).on('click', '.btn-submit-refile', function() {
// 	event.preventDefault();
// 	$(".refile_form").submit();
// 	return false;
	$(".refile_form").find("input[type=submit]").hide();
	$('.choosefile').val("");
	$('#progresspercent').hide();
});

