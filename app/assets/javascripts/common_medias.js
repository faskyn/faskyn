$(document).on('page:change', function() {
  //changing between tabs with AJAX on page:change
  $('[href="#filestab"]').tab('show');
});

//infinite scrolling for tasks based on pagination gem with AJAX
$(document).on('scroll', function() {
	var tab_id = $('.tab-content .active').attr('id');
	if (($('#infinite-common-link-scrolling').size() > 0) && (tab_id == "linkstab")) {
    $('#infinite-common-link-scrolling').hide();
    var more_common_links_url;
    more_common_links_url = $('#infinite-common-link-scrolling .pagination .next_page a').attr('href');
    if (more_common_links_url && $(window).scrollTop() > $(document).height() - $(window).height() - 60) {
      $('.pagination').html('<img src="/assets/ajax-loader.gif" alt="Loading..." title="Loading..." />');
      $('#infinite-common-link-scrolling').show();
			$.ajax({
				type: "GET",
			  url: more_common_links_url,
			  data: {scrolling: "linkscroll"},
			  dataType: "script"
			});
    }
  }
});

$(document).on('scroll', function() {
	var tab_id = $('.tab-content .active').attr('id');
	if (($('#infinite-common-file-scrolling').size() > 0) && (tab_id == "filestab")) {
    $('#infinite-common-file-scrolling').hide();
    var more_common_files_url;
    more_common_files_url = $('#infinite-common-file-scrolling .pagination .next_page a').attr('href');
    if (more_common_files_url && $(window).scrollTop() > $(document).height() - $(window).height() - 60) {
      $('.pagination').html('<img src="/assets/ajax-loader.gif" alt="Loading..." title="Loading..." />');
      $('#infinite-common-file-scrolling').show();
      //$.getScript(more_common_files_url);
      $.ajax({
				type: "GET",
			  url: more_common_files_url,
			  data: {scrolling: "filescroll"},
			  dataType: "script"
			});
    }
  }
});

//invoked by page:change or clicking on the tabs
$(document).on('shown.bs.tab', 'a[data-toggle="tab"]', function (e) {
  var target = $(this).data("activetab");
  var href = $(this).data("link");
  $.ajax({
    type: "GET",
    url: href,
    data: {tab: target},
    dataType: "script"
  });
});