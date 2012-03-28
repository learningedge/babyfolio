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

    $('.youtube-container .header a.upload-link').live('click',function(){

      $(this).parents('.youtube-container').find('.upload').css({height: 0}).show().animate({height: 200});
      $(this).hide();
      $(this).parents('.youtube-container').find('.header .close-btn').show();
      return false;

    })

    $('.close-btn').live('click',function(){
        $(this).parents('.youtube-container').find('.upload').stop().animate({height: 0}, function(){$(this).hide(); })
        $(this).hide();
        $(this).parents('.youtube-container').find('.header .upload-link').show();
        return false;
    })

})