$(function() {
    if(any_filled()) {
	remove_placeholders();
    }

    $('.user-form input[type="text"]').focus(function() {
	 remove_placeholders();
     });
});

function remove_placeholders(){
        $('.user-form input[type="text"]').each(function() {
         $(this).removeAttr('placeholder');
        });
}

function any_filled() {
  var result = false;
  $('.user-form input[type="text"]').each(function(){
    if($(this).val().trim().length != 0) {result = true; return false; }
  });
  return result;
}
