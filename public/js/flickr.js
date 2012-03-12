$(function(){

      jQuery('.flickr .image').live({
        mouseover: function(){
      
                              $(this).find('.thumb').stop().animate({opacity: 1});
                              $('.flickr .image .thumb').not($(this).find('.thumb')).stop().animate({opacity: 0.5});

                             },
        mouseleave: function(){
 
                              $('.flickr .image .thumb').stop().animate({opacity: 1});

                              }
      })

      $('.flickr.multiselect .image').live("click",function(){

	  if ($(this).find('input[type=checkbox]').attr('checked')) {
	      
              $(this).find('input[type=checkbox]').attr('checked',false)
              $(this).removeClass('active');

	  } else {
      
              $(this).find('input[type=checkbox]').attr('checked',true);
              $(this).addClass('active');

	  }

      });

    $('.flickr.singleselect .image').live("click",function(){
         if (!$(this).find('input[type=radio]').attr('checked')) {
	     $('.flickr.singleselect .image input[type=radio]').attr('checked',false);
	     $('.flickr.singleselect .image').removeClass('active');

	     $(this).find('input[type=radio]').attr('checked', true);
	     $(this).addClass('active');
	 }

    })

})