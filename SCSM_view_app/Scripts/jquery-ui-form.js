/*
	function that will called upon element identity will,
	process that element and add custom css classes to that element,
	and generate newly themed form elements.
*/
$.widget("ui.form",
{
	/*
		widget initialization
	*/
    _init: function ()
	{
		/*
			object hold the current instance
		*/
        var object = this;
		/*
			form will hold form from current instance
			do console.log(this); to see object
		*/
        var form = this.element;
		/*
			finds the form fields and store as array
		*/
        var inputs = form.find("input , select ,textarea");
		/*
			add ui-widget class to our form
		*/
        form.addClass("ui-widget");
		
		/*
			loop through each input element,
			which we have created above
		*/
        $.each(inputs, function ()
		{
			/*
				add class to each fields
			*/
            $(this).addClass('ui-state-default ui-corner-all');
			/*
				wrap them inside label
			*/
            $(this).wrap("<label />");
			
			/*
				checking if element is
				button,checkbox,input,radio etc.
				after identify element call appropriate class method
			*/
            if ($(this).is(":reset ,:submit"))
				/*
					calling class buttons method if element is button
				*/
                object.buttons(this);
            else if ($(this).is(":checkbox"))
				/*
					calling class checkboxes method if element is checkbox
				*/
                object.checkboxes(this);
            else if ($(this).is("input[type='text']") || $(this).is("textarea") || $(this).is("input[type='password']"))
				/*
					calling class textelements method if element is input fields
				*/
                object.textelements(this);
            else if ($(this).is(":radio"))
				/*
					calling class radio method if element is radio button
				*/
                object.radio(this);
            else if ($(this).is("select"))
				/*
					calling class selector method if element is drop down
				*/
                object.selector(this);
			/*
				element has class date then it will create date-picker.
			*/
            if ($(this).hasClass("date"))
                $(this).datepicker();
        });
        
		/*
			hover effect
		*/
		$(".hover").hover(function ()
		{
            $(this).addClass("ui-state-hover");
        },
		function ()
		{
            $(this).removeClass("ui-state-hover");
        });

    },
	/*
		function will be called if element is textarea
	*/
    textelements: function (element)
	{
        $(element).bind(
		{
            focusin: function ()
			{
                $(this).toggleClass('ui-state-focus');
            },
            focusout: function ()
			{
                $(this).toggleClass('ui-state-focus');
            }
        });
    },
	/*
		function will be called if element is button submit,reset etc
	*/
    buttons: function (element)
	{
        if ($(element).is(":submit"))
		{
			/*
				adding class to button element
			*/
            $(element).addClass("ui-priority-primary ui-corner-all ui-state-disabled hover");
			/*
				binding custom click event handler
			*/
            $(element).bind("click", function (event)
			{
                event.preventDefault();
            });
        }
		else if ($(element).is(":reset"))
			// if its reset button add different class then submit button
            $(element).addClass("ui-priority-secondary ui-corner-all hover");
		/*
			mousedown and mouseup event handler for button
		*/
		$(element).bind('mousedown mouseup', function ()
		{
			$(this).toggleClass('ui-state-active');
		});
    },
	/*
		function will be called if element is checkbox
	*/
    checkboxes: function (element)
	{
		/*
			process element,
			converting checkbox into span and label,
			original checkbox will be hide and
			it will be convered into custom themed tags
		*/
		/*
			wrap elements into label and add add span after that
		*/
		$(element).parent("label").after("<span />");
		/*
			storing previouslt wrapped span into parent
		*/
        var parent = $(element).parent("label").next();
		/*
			hide original checkbox
		*/
        $(element).addClass("ui-helper-hidden");
		/*
			add css to parent span
		*/
        parent.css(
		{
            width: 16,
            height: 16,
            display: "block"
        });
		/*
			wrap parent span into new span
		*/
        parent.wrap("<span class='ui-state-default ui-corner-all' style='display:inline-block;width:16px;height:16px;margin-right:5px;'/>");
        parent.parent().addClass('hover');
		/*
			adding event handler for parent span
		*/
        parent.parent("span").click(function (event)
		{
            $(this).toggleClass("ui-state-active");
            parent.toggleClass("ui-icon ui-icon-check");
            $(element).click();

        });
    },
	/*
		function will be called if element is radio button
	*/
    radio: function (element)
	{
		/*
			same as checkbox with differnt class names
		*/
        $(element).parent("label").after("<span />");
        var parent = $(element).parent("label").next();
        $(element).addClass("ui-helper-hidden");
        parent.addClass("ui-icon ui-icon-radio-off");
        parent.wrap("<span class='ui-state-default ui-corner-all' style='display:inline-block;width:16px;height:16px;margin-right:5px;'/>");
        parent.parent().addClass('hover');
        parent.parent("span").click(function (event)
		{
            $(this).toggleClass("ui-state-active");
            parent.toggleClass("ui-icon-radio-off ui-icon-bullet");
            $(element).click(function ()
			{
                $('span.ui-icon').removeClass('ui-icon-bullet').addClass('ui-icon-radio-off');
                $(this).parent().next('span').children().removeClass('ui-icon-radio-off').addClass('ui-icon-bullet');
            });
            $(element).trigger('click');
        });
    },
	/*
		function will be called if element is drop down
	*/
    selector: function (element)
	{
		/*
			same as checkbox with differnt class names
		*/
        var parent = $(element).parent();
        parent.css({
            "display": "block",
            width: 140,
            height: 21
        }).addClass("ui-state-default ui-corner-all");
        $(element).addClass("ui-helper-hidden");
        parent.append("<span id='labeltext' style='float:left;'></span><span style='float:right;display:inline-block' class='ui-icon ui-icon-triangle-1-s' ></span>");
        parent.after("<ul class=' ui-helper-reset ui-widget-content ui-helper-hidden' style='position:absolute;z-index:50;width:140px;' ></ul>");
        $.each($(element).find("option"), function () {
            $(parent).next("ul").append("<li class='hover'>" + $(this).html() + "</li>");
        });
        $(parent).next("ul").find("li").click(function () {
            $("#labeltext").html($(this).html());
            $(element).val($(this).html());
            $(this).parent().slideUp('fast');
        });

        $(parent).click(function (event) {
            $(this).next().slideToggle('fast');
            event.preventDefault();
        });
    }
});