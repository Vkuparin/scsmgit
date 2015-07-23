<%@ Page Language="C#" CodeBehind="TicketFill.aspx.cs" Inherits="TicketFill" AutoEventWireup="True" %>

<!DOCTYPE html>
<html>
    <head runat="server">
    <title>Uuden työpyynnön luominen</title>
    <link rel="stylesheet" type="text/css" media="screen" href="Content/TicketFill.css" />
    <style type="text/css">
        html, body {
            font-size: 75%;
            padding: 10px;
            text-align: center;
        }
     </style>
     <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
     <script src="Scripts/jquery.json.min.js" type="text/javascript"></script>
     <script src="http://thecodeplayer.com/uploads/js/jquery.easing.min.js" type="text/javascript"></script>

    <script>
        $(function () {
            //jQuery time
            var current_fs, next_fs, previous_fs; //fieldsets
            var left, opacity, scale; //fieldset properties which we will animate
            var animating; //flag to prevent quick multi-click glitches

            $(".next").click(function () {
                if (animating) return false;
                animating = true;

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
            });

            $(".previous").click(function () {
                if (animating) return false;
                animating = true;

                current_fs = $(this).parent();
                previous_fs = $(this).parent().prev();

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
        });
    </script>

    </head>
    
    <body>
        <!-- linkit relevantteihin sivuihin -->
        <h1 id="menu"><a href="https://it-itsepalvelu.turku.fi/smportal/SitePages/Service%20Catalog.aspx">Itsepalveluportaali</a></h1>
        <br />
        <h1 id="menu"><a href="incidentGrid.aspx">Omat työpyynnöt</a></h1>

	    <div id="container" align="center">
	    	<!-- multistep form -->
     <form id="msform" runat="server">
	        <!-- progressbar -->
	        <ul id="progressbar">
	        	<li class="active">Perustiedot</li>
        		<li>Ongelman kuvaus</li>
        		<li>Yhteenveto ja tietojen tarkistus</li>
        	</ul>
        	<!-- fieldsets -->
         <fieldset>
             <h2 class="fs-title">Uuden työpyynnön lähetys</h2>
             <h3 class="fs-subtitle">Perustiedot</h3>
             <p><%=testi%></p> 
             <h4 class="formheader1">Toimiala</h4>
             <select name="toimiala" placeholder="Toimiala" />
                 <option value="" disabled selected>-Valitse toimiala-</option>
                 <option value="hyvinvointitoimiala">Hyvinvointitoimiala</option>
                 <option value="kiinteistötoimiala">Kiinteistötoimiala</option>
                 <option value="sivistystoimiala">Sivistystoimiala</option>
                 <option value="vapaa-aikatoimiala">Vapaa-aikatoimiala</option>
                 <option value="ympäristötoimiala">Ympäristötoimiala</option>
             </select>
             <span class="question" value="Valitse oma toimialasi viiden vaihtoehdon joukosta">?</span>
             <h4 class="formheader1">Henkilö, jota työpyyntö koskee</h4>
             <input type="text" name="nimi" placeholder="Etu- ja sukunimi" required />
             <span class="question" value="Kirjoita tähän sen henkilön etu- ja sukunimi, jota työpyyntö koskee">?</span>
             <h4 class="formheader1">Työpisteen katuosoite</h4>
             <input type="text" name="katuosoite" placeholder="Työpisteen katuosoite" required />
             <span class="question" value="Kirjoita tähän työpisteen katuosoite. Malli: Ruukinkatu 4">?</span>
             <h4 class="formheader1">Työpisteen nimi (vapaaehtoinen)</h4>
             <input type="text" name="työhuone" placeholder="Työpisteen nimi (vapaaehtoinen)" />
             <span class="question" value="Kirjoita tähän työpisteesi nimi. Malli: M1">?</span>
             <h4 class="formheader1">Käyttäjänimi</h4>
             <input type="text" name="käyttäjänimi" value="<%=userAccountName%>" />
             <span class="question" value="Kirjoita tähän käyttäjänimi, jota työpyyntö koskee">?</span>
             <h4 class="formheader1">Tietokone, jota työpyyntö koskee</h4>
             <input type="text" name="tietokoneenNimi" value="<%=computerName%>" required />
             <span class="question" value="Tietokoneesi nimi löytyy Käynnistä-valikkoa painaessa Ohjauspaneeli-valinnan yläpuolelta. Tietokoneet on myös nimetty tarroilla, jotka löytyvät useimmiten näppäimistön yläpäästä. Malli: VARA1">?</span>
             <h4 class="formheader1">Tietokoneen käyttöjärjestelmä</h4>
             <input type="text" name="osNimi" value="<%=osName%>" required />
             <span class="question" value="Käyttöjärjestelmän tiedot löytyvät painamalla tietokoneen nimen kohdalta hiiren oikeaa nappia ja valitsemalla 'Ominaisuudet'">?</span>
             <input type="button" name="next" class="next action-button" value="Seuraava" />
         </fieldset>
         <fieldset>
             <h2 class="fs-title">Uuden työpyynnön lähetys</h2>
             <h3 class="fs-subtitle">Ongelman kuvaus</h3>
             <h4 class="formheader1">Ongelman luokittelu</h4>
             <select name="ongelmanLuokittelu" placeholder="Ongelman luokittelu (vapaaehtoinen)" />
                 <option value="" disabled selected>-Valitse luokka (vapaaehtoinen)-</option>
                 <option value="hyvinvointitoimiala">Hyvinvointitoimiala</option>
                 <option value="kiinteistötoimiala">Kiinteistötoimiala</option>
                 <option value="sivistystoimiala">Sivistystoimiala</option>
                 <option value="vapaa-aikatoimiala">Vapaa-aikatoimiala</option>
                 <option value="ympäristötoimiala">Ympäristötoimiala</option>
             </select>
             <span class="question" value="Valitse ongelmaasi sopiva kategoria. Mikäli et osaa nimetä kategoriaa, voit jättää tämän kentän tyhjäksi">?</span>
             <h4 class="formheader1">Ongelman otsikko</h4>
             <input type="text" name="ongelmanOtsikko" placeholder="Otsikko" />
             <span class="question" value="Anna ongelmallesi kuvaava nimi">?</span>
             <h4 class="formheader1">Ongelman kuvaus</h4>
             <textarea name="kuvaus" id="kuvausk" placeholder="Kuvaus"></textarea>
             <span id="questionHankala" value="Kirjoita omin sanoin, mitä ongelmasi koskee">?</span>
             <input type="button" name="previous" class="previous action-button" value="Edellinen" />
             <input type="button" name="next" class="next action-button" value="Seuraava" />
         </fieldset>
         <fieldset>
             <h2 class="fs-title">Uuden työpyynnön lähetys</h2>
             <h3 class="fs-subtitle">Yhteenveto ja tietojen tarkistus</h3>
             <h4 class="formheader2">Toimiala</h4>
             <select name="toimiala" placeholder="Toimiala" />
                 <option value="" disabled selected>-Valitse toimiala-</option>
                 <option value="hyvinvointitoimiala">Hyvinvointitoimiala</option>
                 <option value="kiinteistötoimiala">Kiinteistötoimiala</option>
                 <option value="sivistystoimiala">Sivistystoimiala</option>
                 <option value="vapaa-aikatoimiala">Vapaa-aikatoimiala</option>
                 <option value="ympäristötoimiala">Ympäristötoimiala</option>
             </select>
             <h4 class="formheader1">Henkilö, jota työpyyntö koskee</h4>
             <input type="text" name="nimi" placeholder="Etu- ja sukunimi" required />
             <h4 class="formheader2">Työpisteen katuosoite</h4>
             <input type="text" name="katuosoite" placeholder="Työpisteen katuosoite" required />
             <h4 class="formheader2">Työpisteen nimi (vapaaehtoinen)</h4>
             <input type="text" name="työhuone" placeholder="Työpisteen nimi (vapaaehtoinen)" />
             <h4 class="formheader1">Käyttäjänimi</h4>
             <input type="text" name="käyttäjänimi" value="<%=userAccountName%>" />
             <h4 class="formheader2">Tietokone, jota työpyyntö koskee</h4>
             <input type="text" name="tietokoneenNimi" placeholder="Tietokoneen nimi" required />
             <h4 class="formheader1">Tietokoneen käyttöjärjestelmä</h4>
             <input type="text" name="osNimi" value="<%=osName%>" required />
             <h4 class="formheader2">Ongelman luokittelu (vapaaehtoinen)</h4>
             <select name="ongelmanLuokittelu" placeholder="Ongelman luokittelu (vapaaehtoinen)" />
                 <option value="" disabled selected>-Valitse luokka (vapaaehtoinen)-</option>
                 <option value="hyvinvointitoimiala">Hyvinvointitoimiala</option>
                 <option value="kiinteistötoimiala">Kiinteistötoimiala</option>
                 <option value="sivistystoimiala">Sivistystoimiala</option>
                 <option value="vapaa-aikatoimiala">Vapaa-aikatoimiala</option>
                 <option value="ympäristötoimiala">Ympäristötoimiala</option>
             </select>
             <h4 class="formheader2">Ongelman otsikko</h4>
             <input type="text" name="ongelmanOtsikko" placeholder="Otsikko" />
             <h4 class="formheader2">Ongelman kuvaus</h4>
             <textarea name="kuvaus" id="kuvausk" placeholder="Kuvaus"></textarea>
             <input type="button" name="previous" class="previous action-button" value="Edellinen" />
             <input type="submit" name="submit" class="submit action-button" value="Lähetä" />
         </fieldset>
        </form>
        </div>
        </body>
    </html>