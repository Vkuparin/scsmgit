﻿<%@ Page Language="C#" CodeBehind="TicketFill.aspx.cs" Inherits="TicketFill" AutoEventWireup="True" %>

<!DOCTYPE html>
<html>
    <head runat="server">
    <title>Tikettitoveri: Luo työpyyntö</title>
    <!-- main css -->
    <link rel="stylesheet" type="text/css" media="screen" href="Content/TicketFill.css" />
     <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
     <script src="Scripts/jquery.json.min.js" type="text/javascript"></script>
     <script src="http://thecodeplayer.com/uploads/js/jquery.easing.min.js" type="text/javascript"></script>
     <script src="Scripts/jquery.validate.js" type="text/javascript"></script>
     <script src="Scripts/additional-methods.js" type="text/javascript"></script>
     <script src="Scripts/messages_fi.js" type="text/javascript"></script>
     <script>
        //muuttuja koontikentälle
        var $koontidata;
         //document.ready
        $(function () {

            //Määritteet liitealueen piilottamiseksi (default) ja toggle nappulalle, joka tuo sen esiin tarvittaessa
            $(".liiteshowdiv").hide();
            $("#liitenappi").click(function () {
                $(".liiteshowdiv").toggle(500)
                if ($("#liitenappi").val() === "+") {
                    $("#liitenappi").val("-")
                }
                else if ($("#liitenappi").val() === "-") {
                    $("#liitenappi").val("+")
                }
            });


            /*
            * Funktiot lomakkeen toiminnallisuudelle, navigoimiselle ja
            * animoinnille
            */
            //Validaation custom metodit
            $.validator.addMethod("trvalinta", function (value, element) {
                if (!($("#tukiryhmä option:selected").text() == "Valitse sopiva vaihtoehto")){
                    return true;
                }
            }, "Valitse tukiryhmä, jota työpyyntösi koskee");
            //Muuttujia formiin
            var current_fs, next_fs, previous_fs; //fieldsets
            var left, opacity, scale; //fieldset properties which we will animate
            var animating; //flag to prevent quick multi-click glitches

            $(".next").click(function () {

                if (animating) return false;
                animating = true;

                var form = $("#msform");
                form.validate({
                    rules: {
                        tukiryhmä: {
                            trvalinta: true,
                        },
                        ongelmaotsikko: {
                            required: true,
                        },
                        sähköposti: {
                            required: true,
                            email: true,
                        },
                        nimi: {
                            required: true,
                        },
                   },
                });
                if ((form.valid() == false)) { //animaatiota ei käynnistetty
                    animating = false;
                };
                if (form.valid() == true) {
                    current_fs = $(this).parent();
                    next_fs = $(this).parent().next();

                    //activate next step on progressbar using the index of next_fs
                    $("#progressbar li").eq($("fieldset").index(next_fs)).addClass("active");

                    //show the next fieldset
                    next_fs.show();
                    //hide the current fieldset with style
                    current_fs.animate({ opacity: 0 }, {
                        step: function (now, mx) {
                            //as the opacity of current_fs reduces to 0 - stored in "now"
                            //1. scale current_fs down to 80%
                            scale = 1 - (1 - now) * 0.2;
                            //2. bring next_fs from the right(50%)
                            left = (now * 50) + "%";
                            //3. increase opacity of next_fs to 1 as it moves in
                            opacity = 1 - now;
                            current_fs.css({ 'transform': 'scale(' + scale + ')' });
                            next_fs.css({ 'left': left, 'opacity': opacity });
                        },
                        duration: 800,
                        complete: function () {
                            current_fs.hide();
                            animating = false;
                        },
                        //this comes from the custom easing plugin
                        easing: 'easeInOutBack'
                    });
                };
            });

            $(".previous").click(function () {
                if (animating) return false;
                animating = true;

                current_fs = $(this).parent();
                previous_fs = $(this).parent().prev();

                //Tyhjennetään koontikenttä, jos on painettu previous-nappia
                var koonti = $('#koonti');
                koonti.val('');

                //de-activate current step on progressbar
                $("#progressbar li").eq($("fieldset").index(current_fs)).removeClass("active");

                //show the previous fieldset
                previous_fs.show();
                //hide the current fieldset with style
                current_fs.animate({ opacity: 0 }, {
                    step: function (now, mx) {
                        //as the opacity of current_fs reduces to 0 - stored in "now"
                        //1. scale previous_fs from 80% to 100%
                        scale = 0.8 + (1 - now) * 0.2;
                        //2. take current_fs to the right(50%) - from 0%
                        left = ((1 - now) * 50) + "%";
                        //3. increase opacity of previous_fs to 1 as it moves in
                        opacity = 1 - now;
                        current_fs.css({ 'left': left });
                        previous_fs.css({ 'transform': 'scale(' + scale + ')', 'opacity': opacity });
                    },
                    duration: 800,
                    complete: function () {
                        current_fs.hide();
                        animating = false;
                    },
                    //this comes from the custom easing plugin
                    easing: 'easeInOutBack'

                });
            });

            $(".submit").click(function () {
                return false;
            });
            $("span.question").hover(function () {
                var tooltipText = $(this).attr('value');
                $(this).append('<div class="tooltip"><p>' + tooltipText + '</p></div>');
            }, function () {
                $("div.tooltip").remove();
            });
            $("span#questionHankala").hover(function () {
                var tooltipText2 = $(this).attr('value');
                $(this).append('<div class="tooltip"><p>' + tooltipText2 + '</p></div>');
            }, function () {
                $("div.tooltip").remove();
            });
            /*
            *Seuraavat asiat tapahtuvat, kun painetaan 2. "seuraava" -nappia lomakkeessa.
            *Kootaan tiedot viimeisen sivun tekstikenttään ja annetaan arvot muuttujille mailin lähetystä varten
            */
            $('#tokanappi').on('click', function () {
                //muuttuja koontikentälle
                var koonti = $('#koonti');
                //Päivitetään koontikentän arvoa
                koonti.val(koonti.val() + '---------- Työpyynnön tiedot ----------');
                koonti.val(koonti.val() + '\n\n');
                koonti.val(koonti.val() + 'Asiani koskee: ' + $( "#tukiryhmä option:selected" ).text());
                koonti.val(koonti.val() + '\n\n');
                koonti.val(koonti.val() + 'Työpyynnön otsikko: ' + document.getElementById("ongelmaotsikko").value);
                koonti.val(koonti.val() + '\n\n');
                koonti.val(koonti.val() + 'Työpyynnön kuvaus: ' + document.getElementById("ongelmakuvaus").value);
                koonti.val(koonti.val() + '\n\n');
                koonti.val(koonti.val() + '---------- Perustiedot ----------');
                koonti.val(koonti.val() + '\n\n');
                koonti.val(koonti.val() + 'Toimiala: ' + document.getElementById("toimiala").value);
                koonti.val(koonti.val() + '\n\n');
                koonti.val(koonti.val() + 'Osasto: ' + document.getElementById("osasto").value);
                koonti.val(koonti.val() + '\n\n');
                koonti.val(koonti.val() + 'Toimipisteen nimi: ' + document.getElementById("yksikkö").value);
                koonti.val(koonti.val() + '\n\n');
                koonti.val(koonti.val() + 'Toimipisteen osoite: ' + document.getElementById("osoite").value);
                koonti.val(koonti.val() + '\n\n');
                koonti.val(koonti.val() + 'Henkilö, jota työpyyntö koskee: ' + document.getElementById("nimi").value);
                koonti.val(koonti.val() + '\n\n');
                koonti.val(koonti.val() + 'Sähköpostiosoite: ' + document.getElementById("sähköposti").value);
                koonti.val(koonti.val() + '\n\n');
                koonti.val(koonti.val() + 'Puhelinnumero: ' + document.getElementById("puhelinnumero").value);
                koonti.val(koonti.val() + '\n\n');
                koonti.val(koonti.val() + 'Tietokone, jota työpyyntö koskee: ' + document.getElementById("tietokoneenNimi").value);
                koonti.val(koonti.val() + '\n\n');

                //Sijoitetaan koontikentän tiedot koontidata-muuttujaan
                $koontidata = koonti.val();

            });
        });

        //Tapahtuu painettaessa lähetä-nappia, jos käyttäjä painaa OK niin lähetetään maili, muuten takaisin
        function confirmFunction() {
            if (confirm("Lähetä työpyyntö?") == true) {
                alert("Työpyyntö lähetetty!");
                document.getElementById("SendButton").click();

            } else {
                return;
            }
        }
      
    </script>

    </head>
    
    <body>   
        <div class="topcontainer">     
            <img src="Content/images/tkulogo2.svg" class="logo" />
            <span class="nav">
                <!-- linkit relevantteihin sivuihin -->
                   <a href="https://it-itsepalvelu.turku.fi/smportal/SitePages/Service%20Catalog.aspx">Itsepalveluportaali</a>
                    <a>&nbsp;&nbsp;|&nbsp;&nbsp;</a>
                    <a href="incidentGrid.aspx">Omat työpyynnöt</a>
            </span>
        </div>

<div id="container" style="align-content:center">
	    	<!-- multistep form -->
     <form id="msform" runat="server">
	        <!-- progressbar -->
	        <ul id="progressbar">
	        	<li class="active" style="color:white">Työpyynnön kuvaus</li>
        		<li style="color:white">Perustiedot</li>
        		<li style="color:white">Yhteenveto</li>
        	</ul>
        	<!-- fieldsets -->
           <fieldset>
             <h2 class="fs-title">Uuden työpyynnön lähetys</h2>
             <h3 class="fs-subtitle">Työpyynnön kuvaus</h3>
             <h4 class="formheader1">Asiani koskee<span style="color:#ed0c6e">&ast;</span></h4>
             <asp:DropDownList ID="tukiryhmä" runat="server">
                 <asp:ListItem Text ="Valitse sopiva vaihtoehto" disabled ="disabled" selected="true"/>
                 <asp:ListItem value="servicedesk.dotku@turku.fi" Text = "Dotku-tuki" />
                 <asp:ListItem value="servicedesk.hpk@turku.fi" Text = "Henkilöstöpalvelukeskus" />
                 <asp:ListItem value="servicedesk@turku.fi" Text ="IT-palvelut" />
                 <asp:ListItem value="servicedesk.joutsenet@turku.fi" Text="JoutseNet-tuki" />
                 <asp:ListItem value="servicedesk.pegasos@turku.fi" Text="Pegasos-tuki" />
                 <asp:ListItem value="servicedesk.trimble@turku.fi" Text="Trimble-tuki" />
                 <asp:ListItem value="" id="testiosoite" Text="Testiosoite (oma sähköpostisi)" />
             </asp:DropDownList>
             <span class="question" value="Valitse asiaasi koskeva tukiryhmä">?</span>
             <h4 class="formheader1">Työpyynnön otsikko<span style="color:#ed0c6e">&ast;</span></h4>
             <asp:TextBox runat="server" ID="ongelmaotsikko" placeholder ="--Kirjoita otsikko--" />
             <span class="question" value="Anna työpyynnöllesi kuvaava nimi. Malli: Tietokoneeni ei saa yhteyttä verkkoon">?</span>
             <h4 class="formheader1">Työpyynnön kuvaus</h4>
             <textarea name="kuvaus" id="ongelmakuvaus" placeholder="--Kirjoita kuvaus--"></textarea>
             <span id="questionHankala" value="Kirjoita omin sanoin, mitä työpyyntösi koskee">?</span>
             <h4 class="formheader1">Liitteet</h4>
             <input type="button" name="liitenappi" class="liitenappi" id="liitenappi" value="+"/>
             <div class ="liiteshowdiv">
                <asp:FileUpload runat="server" AllowMultiple="true" ID ="liite1" BackColor="#00aeef"/>
                <span class="question" value="Lisää tarvittavat liitteet tietokoneeltasi. Voit valita useamman kuin yhden tiedoston">?</span>
                <asp:TextBox runat="server" hidden="true" ID="liite1teksti"></asp:TextBox>
            </div>
             <input type="button" id="ekanappi" name="next" class="next action-button" value="Seuraava" />
            <h3 class="fs-subtitle" style="text-align:left; padding-top:2em"><span style="color:#ed0c6e">&ast;</span> = pakollinen kenttä</h3>
         </fieldset>
         <fieldset>
             <h2 class="fs-title">Uuden työpyynnön lähetys</h2>
             <h3 class="fs-subtitle">Perustiedot</h3>
             <h4 class="formheader1">Toimiala</h4>
             <select name="toimiala" id="toimiala" />
                 <option value="<%=userCompany%>" selected><%=userCompany%></option>
                 <option value="hyvinvointitoimiala">Hyvinvointitoimiala</option>
                 <option value="kiinteistötoimiala">Kiinteistötoimiala</option>
                 <option value="ympäristötoimiala">Palvelukeskukset</option>
                 <option value="sivistystoimiala">Sivistystoimiala</option>
                 <option value="vapaa-aikatoimiala">Vapaa-aikatoimiala</option>
                 <option value="yhtiöt">Yhtiöt ja yhtymät</option>
                 <option value="ympäristötoimiala">Ympäristötoimiala</option>
             </select>
             <span class="question" value="Valitse oma toimialasi, mikäli oletus ei täsmää tietojesi kanssa">?</span>
             <h4 class="formheader1">Osasto</h4>
             <input type="text" name="osasto" id="osasto" value="<%=userDepartment%>" />
             <span class="question" value="Kirjoita tähän osastosi, mikäli oletus ei täsmää tietojesi kanssa">?</span>
             <h4 class="formheader1">Toimipisteen nimi</h4>
             <input type="text" name="toimipiste" id="yksikkö" value="<%=userOffice%>" />
             <span class="question" value="Kirjoita tähän yksikkösi nimi, mikäli oletus ei täsmää tietojesi kanssa">?</span>
             <h4 class="formheader1">Toimipisteen osoite</h4>
             <input type="text" name="osoite" id="osoite" placeholder="--Kirjoita toimipisteen osoite--" />
             <span class="question" value="Kirjoita tähän toimipisteesi osoite. Malli: Ruukinkatu 4">?</span>
             <h4 class="formheader1">Henkilö, jota työpyyntö koskee<span style="color:#ed0c6e">&ast;</span></h4>
             <input type="text" name="nimi" id="nimi" value="<%=userFullName%>" />
             <span class="question" value="Kirjoita tähän sen henkilön etu- ja sukunimi, jota työpyyntö koskee. Oletuksena on, että pyyntö koskee kirjautuneena olevaa käyttäjää">?</span>
             <h4 class="formheader1">Sähköpostiosoite<span style="color:#ed0c6e">&ast;</span></h4>
             <asp:TextBox runat="server" ID="sähköposti" Text ="" />
             <span class="question" value="Kirjoita tähän yhteydenpidossa käytettävä sähköpostiosoite. Oletuksena käytetään kirjautuneena olevan käyttäjän sähköpostiosoitetta">?</span>
             <h4 class="formheader1">Puhelinnumero</h4>
             <input type="text" name="puhelinnumero" id="puhelinnumero" placeholder="--Syötä puhelinnumerosi--" value="<%=userPhone%>" />
             <span class="question" value="Kirjoita tähän yhteydenpidossa käytettävä puhelinnumero">?</span>
             <h4 class="formheader1">Tietokone, jota työpyyntö koskee</h4>
             <input type="text" name="tietokoneenNimi" id="tietokoneenNimi" value="<%=computerName%>" />
             <span class="question" value="Tietokoneesi nimi löytyy Käynnistä-valikon Ohjauspaneeli-valinnan yläpuolelta. Malli: VARA11">?</span>
             <input type="button" name="previous" class="previous action-button" value="Edellinen" />
             <input type="button" id ="tokanappi" name="next" class="next action-button" Value="Seuraava" />
             <h3 class="fs-subtitle" style="text-align:left; padding-top:2em"><span style="color:#ed0c6e">&ast;</span> = pakollinen kenttä</h3>
         </fieldset>
         <fieldset>
             <h2 class="fs-title">Uuden työpyynnön lähetys</h2>
             <h3 class="fs-subtitle">Yhteenveto</h3>
             <h3 class="fs-subtitle"><span style="color:#ed0c6e">&ast;</span> = pakollinen kenttä</h3>
             <textarea runat="server" id ="koonti"></textarea>
             <input type="button" name="previous" class="previous action-button" value="Edellinen" />
             <input type="button" class="confirmnappi" onclick="confirmFunction()" value="Seuraava" />
             <asp:Button id="SendButton" class="next action-button" OnClick="SendButton_Click" Text="Lähetä" runat="server" hidden="true" />
         </fieldset>
        </form>
        </div>
        </body>
    </html>