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

  //infinite scrolling for products based on pagination gem
  if ($('#infinite-product-scrolling').size() > 0) {
    $(window).on('scroll', function() {
      $('#infinite-product-scrolling').hide();
      var more_products_url;
      more_products_url = $('#infinite-product-scrolling .pagination .next_page a').attr('href');
      if (more_products_url && $(window).scrollTop() > $(document).height() - $(window).height() - 60) {
        $('.pagination').html("<i class='fa fa-circle-o-notch fa-2x fa-spin'></i>");
        $('#infinite-product-scrolling').show();
        $.getScript(more_products_url);
      }
    });
  };

  //showing edit/delete button to owner
  if ($('.product-show-container').length > 0) {
    showProductEditDeleteButtons();
  };

  //cocoon gem inserting behavior
  $(".customer-well a.add_fields").data("association-insertion-method", 'prepend').data("association-insertion-node", '.customer-fields');
  $(".lead-well a.add_fields").data("association-insertion-method", 'prepend').data("association-insertion-node", '.lead-fields');

});

function showProductEditDeleteButtons() {
  if ($('.product-show-container').find('[data-behavior="edit-delete-product-buttons"]').data("product-owner-id") == $('#body-current-user').data('currentuserid')) {
    $('.product-show-container').find('[data-behavior="edit-delete-product-buttons"]').removeClass('hidden');
  };
};

//deleting product user via modal
$(document).on('click', '[data-behavior="open-delete-product-user-modal"]', function (event) {
  var productUserDeleteLink = $(this).data("productuserdeletelink");
  $('[data-behavior="delete-product-user-submit"]').attr("href", productUserDeleteLink);
});

//deleting product invitation via modal
$(document).on('click', '[data-behavior="open-delete-product-invitation-modal"]', function (event) {
  var productInvitationDeleteLink = $(this).data("productinvitationdeletelink");
  $('[data-behavior="delete-product-invitation-submit"]').attr("href", productInvitationDeleteLink);
});