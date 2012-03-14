$(function(){

      jQuery('.youtube .video').live({
        mouseover: function(){
      
                              $(this).find('.thumb').stop().animate({opacity: 1});
                              $('.youtube .video .thumb').not($(this).find('.thumb')).stop().animate({opacity: 0.5});

                             },
        mouseleave: function(){
 
                              $('.youtube .video .thumb').stop().animate({opacity: 1});

                              }
      })

      $('.multiselect .youtube .video').live("click",function(){

	  if ($(this).find('input[type=checkbox]').attr('checked')) {
	      
              $(this).find('input[type=checkbox]').attr('checked',false)
              $(this).removeClass('active');

	  } else {
      
              $(this).find('input[type=checkbox]').attr('checked',true);
              $(this).addClass('active');

	  }

      });

    $('.singleselect .youtube .video').live("click",function(){

	$('.singleselect .youtube .video input[type=checkbox]').attr('checked',false);
	$('.singleselect .youtube .video').removeClass('active');
	 
	$(this).find('input[type=checkbox]').attr('checked', true);
	$(this).addClass('active');

    })

})