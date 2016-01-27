// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
// by Paul@YellowPencil.com and Scott@YellowPencil.com
// feel free to delete all comments except for the above credit

	Ajax.Responders.register({
	  onCreate: function() {
	    if($('busy') && Ajax.activeRequestCount>0) {
	      Effect.Fade('idle',{duration:0.0,queue:'end'});
	      Effect.Appear('busy',{duration:0.0,queue:'end'});
	      }
	  },
	  onComplete: function() {
	    if($('busy') && Ajax.activeRequestCount==0)	      
	      Effect.Fade('busy',{duration:0.0,queue:'end'});
	      Effect.Appear('idle',{duration:0.0,queue:'end'});
	  }
	}); 
	
    function show_g(el)
    {
        document.getElementById(el).style.display="inline";
    }
    function hide_g(el)
    {
        document.getElementById(el).style.display="none";
    }
    function focus_g(el)
    {
        document.getElementById(el).focus();
    }
    function select_g(el)
    {
        document.getElementById(el).select();
    }
    function show_comment_form()
    {
        show_g("comment_form");
        hide_g("comment_form_showlk");
        select_g("comment_title");  
        focus_g("comment_title");
    }
    function hide_comment_form()
    {
        hide_g("comment_form");
        show_g("comment_form_showlk");
    }
    function hide_reply_form()
    {
        hide_g("reply_form");
        show_g("comment_form_showlk");
    }
    function show_reply_form(comment_id)
    {
        hide_g("comment_form");
        show_g("reply_form");
        document.getElementById("reply_reply").value = comment_id;
        hide_g("comment_form_showlk");            
        select_g("reply_content");   
        focus_g("reply_content");    
        
    }
    
    function show_comment(ele)
    {
        show_g("comment" + ele + "show");
        hide_g("comment" + ele + "showlk");
        show_g("comment" + ele + "hidelk");
    }
    function hide_comment(ele)
    {
        hide_g("comment" + ele + "show");
        hide_g("comment" + ele + "hidelk");
        show_g("comment" + ele + "showlk");
    }	
