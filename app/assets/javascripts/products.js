$(document).on("page:change", function() {
	
	//making collection select act as if command button always were held down
	$('#product_industry_ids').each(function(){
		var select = $(this), values = {};    
    $('option',select).each(function(i, option){
      values[option.value] = option.selected;        
    }).click(function(event){        
      values[this.value] = !values[this.value];
      $('option',select).each(function(i, option){            
          option.selected = values[option.value];        
      });    
    });
	});

  //making whole row clickable
  // $(".product-index-row").click(function() {
  //     window.document.location = $(this).data("url");
  // });
});

$(document).on("upload:start", ".product-refile-form", function(e) {
  $(".product-refile-form").find("input[type=submit]").show();
    $(this).find("input[type=submit]").attr("disabled", true);
    $("#product-progresspercent").show();
    $("#product-progresspercent").text("Uploading...");
  });

//showing progress to users
$(document).on("upload:progress", ".product-refile-form", function(e) {
    var detail;
    var percentComplete;
    var filename;
    filename = $('.choose-product-file').val();
    detail = e.originalEvent.detail;
    percentComplete = Math.round(detail.progress.loaded / detail.progress.total * 100);
    $('#product-progresspercent').text(percentComplete + "% uploaded ");
});

//when upload is reday user gets allowed to submit the message
$(document).on("upload:success", ".product-refile-form", function(e) {
    if (!$(this).find("input.uploading").length) {
      $(this).find("input[type=submit]").removeAttr("disabled");
      //$('#product-progresspercent').hide();
      // var new_image_input = $('.btn-product-image input:first-child').val();
      // var product_data = JSON.parse(new_image_input.replace(/'/g, '"'));
      // var product_image_id =  product_data.id;
      // var product_image_name = product_data.filename;
      // var product_image_token = $('.btn-product-image input:first-child').data('reference');
      // $("#new-image").html($("<img />").attr({src: "/attachments/" + product_image_token + "/store/fill/80/80/" + product_image_id + "/" + product_image_name }));
    };
});
