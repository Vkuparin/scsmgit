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
        });
    </script>

    </head>
    
    <body>
        <!-- linkit relevantteihin sivuihin -->
        <h1 id="linkki"><a href="https://it-itsepalvelu.turku.fi/smportal/SitePages/Service%20Catalog.aspx">Itsepalveluportaali</a></h1>
        <br />
        <h1 id="linkki"><a href="incidentGrid.aspx">Omat työpyynnöt</a></h1>

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
             <h4 class="formheader1">Toimiala</h4>
             <select name="toimiala" id="toimiala" />
                 <option value="<%=userCompany%>" selected><%=userCompany%></option>
                 <option value="hyvinvointitoimiala">Hyvinvointitoimiala</option>
                 <option value="kiinteistötoimiala">Kiinteistötoimiala</option>
                 <option value="sivistystoimiala">Sivistystoimiala</option>
                 <option value="vapaa-aikatoimiala">Vapaa-aikatoimiala</option>
                 <option value="ympäristötoimiala">Ympäristötoimiala</option>
                 <option value="ympäristötoimiala">Palvelukeskukset</option>
             </select>
             <span class="question" value="Valitse oma toimialasi kuuden vaihtoehdon joukosta, mikäli oletus ei täsmää tietojesi kanssa">?</span>
             <h4 class="formheader1">Osasto</h4>
             <input type="text" name="osasto" id="osasto" value="<%=userDepartment%>" required />
             <span class="question" value="Kirjoita tähän osastosi, mikäli oletus ei täsmää tietojesi kanssa">?</span>
             <h4 class="formheader1">Toimipisteen nimi</h4>
             <input type="text" name="toimipiste" id="yksikkö" value="<%=userOffice%>" required />
             <span class="question" value="Kirjoita tähän yksikkösi nimi, mikäli oletus ei täsmää tietojesi kanssa">?</span>
             <h4 class="formheader1">Toimipisteen osoite</h4>
             <input type="text" name="osoite" id="osoite" placeholder="Toimipisteen osoite" required />
             <span class="question" value="Kirjoita tähän toimipisteesi osoite. Malli: Ruukinkatu 4">?</span>
             <h4 class="formheader1">Henkilö, jota työpyyntö koskee</h4>
             <input type="text" name="nimi" id="nimi" value="<%=userFullName%>" required />
             <span class="question" value="Kirjoita tähän sen henkilön etu- ja sukunimi, jota työpyyntö koskee. Oletuksena on, että pyyntö koskee kirjautuneena olevaa käyttäjää">?</span>
             <h4 class="formheader1">Sähköpostiosoite</h4>
             <input type="text" name="sähköposti" id="sähköposti" value="<%=userEmail%>" />
             <span class="question" value="Kirjoita tähän yhteydenpidossa käytettävä sähköpostiosoite. Oletuksena käytetään kirjautuneena olevan käyttäjän sähköpostiosoitetta">?</span>
             <h4 class="formheader1">Puhelinnumero</h4>
             <input type="text" name="puhelinnumero" id="puhelinnumero" value="<%=userPhone%>" />
             <span class="question" value="Kirjoita tähän yhteydenpidossa käytettävä puhelinnumero">?</span>
             <h4 class="formheader1">Tietokone, jota työpyyntö koskee</h4>
             <input type="text" name="tietokoneenNimi" id="tietokoneenNimi" value="<%=computerName%>" />
             <span class="question" value="Tietokoneesi nimi löytyy Käynnistä-valikkoa painaessa Ohjauspaneeli-valinnan yläpuolelta. Tietokoneet on myös nimetty tarroilla, jotka löytyvät useimmiten näppäimistön yläpäästä. Malli: VARA11">?</span>
             <input type="button" name="next" class="next action-button" value="Seuraava" />
         </fieldset>
         <fieldset>
             <h2 class="fs-title">Uuden työpyynnön lähetys</h2>
             <h3 class="fs-subtitle">Ongelman kuvaus</h3>
             <h4 class="formheader1">Ongelman luokittelu</h4>
             <select id="ongelmaluokka">
               <option selected="selected" disabled="disabled">-Valitse pudotusvalikosta sopiva ongelmatyyppi-</option>
               <optgroup label="Dotku-tuki" class="header1-dropdown">
                   <hr />
                   <option value="Dotku-tuki_Dokumenttikirjastot" class="option">Dokumenttikirjastot</option>
                   <hr />
                   <option value="Dotku-tuki_Extranet" class="option">Extranet</option>
                   <option value="Dotku-tuki_Käyttöoikeudet" class="option">Käyttöoikeudet</option>
                   <option value="Dotku-tuki_Tukipyyntö" class="option">Tukipyyntö</option>
                   <option value="Dotku-tuki_Työtilat" class="option">Työtilat</option>
               </optgroup>
               <optgroup label="HPK-tuki" class="header1-dropdown">
                   <optgroup label="&nbsp;&nbsp;&nbsp;&nbsp;Kuntarekry" class="header2-dropdown">
                       <option value="HPK-tuki_Kuntarekry_Käyttöoikeudet" class="option">&nbsp;&nbsp;&nbsp;&nbsp;Käyttöoikeudet</option>
                       <option value="HPK-tuki_Kuntarekry_Tukipyyntö" class="option">&nbsp;&nbsp;&nbsp;&nbsp;Tukipyyntö</option>
                   </optgroup>
                   <optgroup label="&nbsp;&nbsp;&nbsp;&nbsp;Muut asiat" class="header2-dropdown"> 
                       <option value="HPK-tuki_Muut asiat_Koulutuspyynnöt" class="option">&nbsp;&nbsp;&nbsp;&nbsp;Koulutuspyynnöt</option>
                       <option value="HPK-tuki_Muut asiat_Palaute" class="option">&nbsp;&nbsp;&nbsp;&nbsp;Palaute</option>
                       <option value="HPK-tuki_Muut asiat_Raportti-ja tilastopyynnöt" class="option">&nbsp;&nbsp;&nbsp;&nbsp;Raportti-ja tilastopyynnöt</option>
                       <option value="HPK-tuki_Muut asiat_Yhteydenottopyyntö" class="option">&nbsp;&nbsp;&nbsp;&nbsp;Yhteydenottopyyntö</option>
                   </optgroup>
                   <optgroup label="&nbsp;&nbsp;&nbsp;&nbsp;Palvelussuhdeasiat" class="header2-dropdown"> 
                       <option value="HPK-tuki_Palvelussuhdeasiat_Eläkeasiat" class="option">&nbsp;&nbsp;&nbsp;&nbsp;Eläkeasiat</option>
                       <option value="HPK-tuki_Palvelussuhdeasiat_Muut asiat" class="option">&nbsp;&nbsp;&nbsp;&nbsp;Muut asiat</option>
                       <option value="HPK-tuki_Palvelussuhdeasiat_Palvelu-ja työtodistukset" class="option">&nbsp;&nbsp;&nbsp;&nbsp;Palvelu-ja työtodistukset</option>
                       <option value="HPK-tuki_Palvelussuhdeasiat_Palvelussuhdeneuvonta" class="option">&nbsp;&nbsp;&nbsp;&nbsp;Palvelussuhdeneuvonta</option>
                       <option value="HPK-tuki_Palvelussuhdeasiat_Työkokemuslisät" class="option">&nbsp;&nbsp;&nbsp;&nbsp;Työkokemuslisät</option>
                       <option value="HPK-tuki_Palvelussuhdeasiat_Vuosilomat" class="option">&nbsp;&nbsp;&nbsp;&nbsp;Vuosilomat</option>
                   </optgroup>
                   <optgroup label="&nbsp;&nbsp;&nbsp;&nbsp;Rekrytointi" class="header2-dropdown">
                       <option value="HPK-tuki_Rekrytointi_Rekrytoinnin suunnittelu ja valmistelu" class="option">&nbsp;&nbsp;&nbsp;&nbsp;Rekrytoinnin suunnittelu ja valmistelu</option>
                       <option value="HPK-tuki_Rekrytointi_Rekrytointi" class="option">&nbsp;&nbsp;&nbsp;&nbsp;Rekrytointi</option>
                       <option value="HPK-tuki_Rekrytointi_Sijaistilaus (Hyto)" class="option">&nbsp;&nbsp;&nbsp;&nbsp;Sijaistilaus (Hyto)</option>
                   </optgroup>
                   <optgroup label="&nbsp;&nbsp;&nbsp;&nbsp;SAP HR" class="header2-dropdown">
                       <option value="HPK-tuki_SAP HR_Käyttöoikeudet" class="option">&nbsp;&nbsp;&nbsp;&nbsp;Käyttöoikeudet</option>
                            <optgroup label="&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Tukipyyntö" class="header3-dropdown">
                       <option value="HPK-tuki_SAP HR_Tukipyyntö_Henkilön omat tiedot" class="option">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Henkilön omat tiedot</option>
                       <option value="HPK-tuki_SAP HR_Tukipyyntö_Kehityskeskustelut ja arvioinnit" class="option">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Kehityskeskustelut ja arvioinnit</option>
                       <option value="HPK-tuki_SAP HR_Tukipyyntö_Koulutus ja kurssit" class="option">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Koulutus ja kurssit</option>
                       <option value="HPK-tuki_SAP HR_Tukipyyntö_Matkahallinta" class="option">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Matkahallinta</option>
                       <option value="HPK-tuki_SAP HR_Tukipyyntö_Organisaatio" class="option">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Organisaatio</option>
                       <option value="HPK-tuki_SAP HR_Tukipyyntö_Osaamisen kartoittaminen ja ylläpito" class="option">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Osaamisen kartoittaminen ja ylläpito</option>
                       <option value="HPK-tuki_SAP HR_Tukipyyntö_Palvelussuhteen tiedot" class="option">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Palvelussuhteen tiedot</option>
                       <option value="HPK-tuki_SAP HR_Tukipyyntö_Poissaolot ja vuosilomat" class="option">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Poissaolot ja vuosilomat</option>
                       <option value="HPK-tuki_SAP HR_Tukipyyntö_Tehtäväluettelo" class="option">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Tehtäväluettelo</option>
                            </optgroup>
                   </optgroup>
                   <optgroup label="&nbsp;&nbsp;&nbsp;&nbsp;Vakanssit tai budjetoidut toimet" class="header2-dropdown">
                       <option value="HPK-tuki_Vakanssit tai budjetoidut toimet_Budjetoitujen toimien ylläpito" class="option">&nbsp;&nbsp;&nbsp;&nbsp;Budjetoitujen toimien ylläpito</option>
                       <option value="HPK-tuki_Vakanssit tai budjetoidut toimet_Vakanssien ylläpito päätökseen perustuen" class="option">&nbsp;&nbsp;&nbsp;&nbsp;Vakanssien ylläpito päätökseen perustuen</option>
                       <option value="HPK-tuki_Vakanssit tai budjetoidut toimet_Vakanssitietojen ylläpito" class="option">&nbsp;&nbsp;&nbsp;&nbsp;Vakanssitietojen ylläpito</option>
                   </optgroup>
               </optgroup>
               <optgroup label="JoutseNet-tuki" class="header1-dropdown">
                   <option value="JoutseNet-tuki_Käyttöoikeudet" class="option">Käyttöoikeudet</option>
                   <option value="JoutseNet-tuki_Salasanan palautus" class="option">Salasanan palautus</option>
                   <option value="JoutseNet-tuki_Tukipyyntö" class="option">Tukipyyntö</option>
                   <option value="JoutseNet-tuki_Yhteisöpostilaatikot" class="option">Yhteisöpostilaatikot</option>
               </optgroup>
               <optgroup label="Käyttöopastus" class="header1-dropdown">
                   <option value="Käyttöopastus_Oheislaitteet" class="option">Oheislaitteet</option>
                   <option value="Käyttöopastus_Sovellus" class="option">Sovellus</option>
                   <optgroup label="&nbsp;&nbsp;&nbsp;&nbsp;Tietoliikenne" class="header2-dropdown">
                       <option value="Käyttöopastus_Tietoliikenne_Direct Access" class="option">&nbsp;&nbsp;&nbsp;&nbsp;Direct Access</option>
                       <option value="Käyttöopastus_Tietoliikenne_VPN" class="option">&nbsp;&nbsp;&nbsp;&nbsp;VPN</option>
                   </optgroup>
                   <option value="Käyttöopastus_Toimintatapa" class="option">&nbsp;&nbsp;&nbsp;&nbsp;Toimintatapa</option>
                   <option value="Käyttöopastus_Tulostus" class="option">&nbsp;&nbsp;&nbsp;&nbsp;Tulostus</option>
                   <option value="Käyttöopastus_Työasema" class="option">&nbsp;&nbsp;&nbsp;&nbsp;Työasema</option>
               </optgroup>
               <optgroup label="Pegasos-tuki" class="header1-dropdown">
                   <option value="Pegasos-tuki_Kehitysehdotus" class="option">Kehitysehdotus</option>
                   <option value="Pegasos-tuki_Käyttöoikeus" class="option">Käyttöoikeus</option>
                   <option value="Pegasos-tuki_Käyttöopastus" class="option">Käyttöopastus</option>
                   <option value="Pegasos-tuki_Muu työpyyntö" class="option">Muu työpyyntö</option>
                   <option value="Pegasos-tuki_Ohjelmavirhe" class="option">Ohjelmavirhe</option>
                   <option value="Pegasos-tuki_Ongelma" class="option">Ongelma</option>
                   <option value="Pegasos-tuki_Raportointipyyntö" class="option">Raportointipyyntö</option>
               </optgroup>
               <optgroup label="Puhepalveluongelma" class="header1-dropdown">
                   <option value="Puhepalveluongelma_Lanka-ja mobiililiittymät" class="option">Lanka-ja mobiililiittymät</option>
                   <option value="Puhepalveluongelma_Puhelinvaihde" class="option">Puhelinvaihde</option>
                   <option value="Puhepalveluongelma_TeleQ" class="option">TeleQ</option>
               </optgroup>
               <optgroup label="Roskapostitiketti" class="header1-dropdown">
                   <option value="Roskapostitiketti" class="option">Roskapostitiketti</option>
               </optgroup>
               <optgroup label="Selvityspyyntö" class="header1-dropdown">
                   <option value="Selvityspyyntö_Muu palvelu" class="option">Muu palvelu</option>
                   <optgroup label="&nbsp;&nbsp;&nbsp;&nbsp;Puhepalvelu" class="header2-dropdown">
                       <option value="Selvityspyyntö_Puhepalvelu_Lanka-ja mobiililiittymät" class="option">&nbsp;&nbsp;&nbsp;&nbsp;Lanka-ja mobiililiittymät</option>
                       <option value="Selvityspyyntö_Puhepalvelu_TeleQ" class="option">&nbsp;&nbsp;&nbsp;&nbsp;TeleQ</option>
                   </optgroup>
                   <option value="Selvityspyyntö_Sovellus" class="option">&nbsp;&nbsp;&nbsp;&nbsp;Sovellus</option>
                   <option value="Selvityspyyntö_Tietoliikenne" class="option">&nbsp;&nbsp;&nbsp;&nbsp;Tietoliikenne</option>
                   <option value="Selvityspyyntö_Toimintatapa" class="option">&nbsp;&nbsp;&nbsp;&nbsp;Toimintatapa</option>
                   <option value="Selvityspyyntö_Tulostus" class="option">&nbsp;&nbsp;&nbsp;&nbsp;Tulostus</option>
                   <option value="Selvityspyyntö_Työasema" class="option">&nbsp;&nbsp;&nbsp;&nbsp;Työasema</option>
               </optgroup>
               <optgroup label="Sovellusongelma" class="header1-dropdown">
                   <option value="Sovellusongelma_Paikallinen sovellus" class="option">Paikallinen sovellus</option>
                   <option value="Sovellusongelma_Palvelinsovellus" class="option">Palvelinsovellus</option>
                   <option value="Sovellusongelma_Verkkosovellus" class="option">Verkkosovellus</option>
               </optgroup>
               <optgroup label="Testitiketti" class="header1-dropdown">
                   <option value="Testitiketti" class="option">Testitiketti</option>
               </optgroup>
               <optgroup label="Tietoliikenneongelma" class="header1-dropdown">
                   <optgroup label="&nbsp;&nbsp;&nbsp;&nbsp;Dataliikenne" class="header2-dropdown"></optgroup>
                       <optgroup label="&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Lähiverkko" class="header3-dropdown">
                           <option value="Tietoliikenneongelma_Dataliikenne_Lähiverkko_LAN" class="option">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;LAN</option>
                           <option value="Tietoliikenneongelma_Dataliikenne_Lähiverkko_WLAN" class="option">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;WLAN</option>
                       </optgroup>
                       <optgroup label="&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Runkoverkko" class="header3-dropdown">
                           <option value="Tietoliikenneongelma_Dataliikenne_Runkoverkko_Etätyöyhteydet" class="option">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Etätyöyhteydet</option>
                           <option value="Tietoliikenneongelma_Dataliikenne_Runkoverkko_Mobiililaajakaista" class="option">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Mobiililaajakaista</option>
                           <option value="Tietoliikenneongelma_Dataliikenne_Runkoverkko_Ulkoiset toimijat" class="option">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Ulkoiset toimijat</option>
                       </optgroup>
                       <option value="Tietoliikenneongelma_Dataliikenne_Ulkoiset yhteydet" class="option">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Ulkoiset yhteydet</option>
                   </optgroup>
                   <option value="Tietoliikenneongelma_Puhelinliikenne" class="option">&nbsp;&nbsp;&nbsp;&nbsp;Puhelinliikenne</option>
                   <option value="Tietoliikenneongelma_Tietoliikennepalvelut" class="option">&nbsp;&nbsp;&nbsp;&nbsp;Tietoliikennepalvelut</option>
                   <option value="Tietoliikenneongelma_Tietoturva" class="option">&nbsp;&nbsp;&nbsp;&nbsp;Tietoturva</option>
               </optgroup>
               <optgroup label="Tietoturva" class="header1-dropdown">
                   <option value="Tietoturva_Haittaohjelmat" class="option">Haittaohjelmat</option>
                   <option value="Tietoturva_Muutoshallinta" class="option">Muutoshallinta</option>
                   <option value="Tietoturva_Roskaposti" class="option">Roskaposti</option>
                   <option value="Tietoturva_Virusilmoitukset" class="option">Virusilmoitukset</option>
               </optgroup>
               <optgroup label="Trimble-tuki" class="header1-dropdown">
                   <option value="Trimble-tuki_Käyttöoikeudet" class="option">Käyttöoikeudet</option>
                   <option value="Trimble-tuki_Ongelmatilanne" class="option">Ongelmatilanne</option>
               </optgroup>
               <optgroup label="Tulostusongelma" class="header1-dropdown">
                   <optgroup label="&nbsp;&nbsp;&nbsp;&nbsp;Oheistulostus" class="header2-dropdown">
                       <option value="Tulostusongelma_Oheistulostus_Ajuriongelma" class="option">&nbsp;&nbsp;&nbsp;&nbsp;Ajuriongelma</option>
                       <option value="Tulostusongelma_Oheistulostus_Laiteongelma" class="option">&nbsp;&nbsp;&nbsp;&nbsp;Laiteongelma</option>
                   </optgroup>
                   <optgroup label="&nbsp;&nbsp;&nbsp;&nbsp;Verkkotulostus" class="header2-dropdown">
                       <option value="Tulostusongelma_Verkkotulostus_Laiteongelma" class="option">&nbsp;&nbsp;&nbsp;&nbsp;Laiteongelma</option>
                       <option value="Tulostusongelma_Verkkotulostus_Tulostusjono" class="option">&nbsp;&nbsp;&nbsp;&nbsp;Tulostusjono</option>
                   </optgroup>
               </optgroup>
               <optgroup label="Työasemaongelma" class="header1-dropdown">
                   <option value="Työasemaongelma_Ajuriongelma" class="option">Ajuriongelma</option>
                   <option value="Työasemaongelma_Ajuriongelma (ratkaisuna Lenovo System Update)" class="option">Ajuriongelma (ratkaisuna Lenovo System Update)</option>
                   <option value="Työasemaongelma_Komponenttiongelma" class="option">Komponenttiongelma</option>
                   <option value="Työasemaongelma_Oheislaiteongelma" class="option">Oheislaiteongelma</option>
                   <option value="Työasemaongelma_Muut laitteet_iPad" class="option">Muut laitteet_iPad</option>
                   <option value="Työasemaongelma_Uudelleenasennus" class="option">Uudelleenasennus</option>
                   <option value="Työasemaongelma_Verkko-ongelma" class="option">Verkko-ongelma</option>
                   <option value="Työasemaongelma_Windows-ongelma_Käyttäjän uloskirjaus" class="option">Windows-ongelma, käyttäjän uloskirjaus</option>
               </optgroup>
               <optgroup label="Työpyyntö" class="header1-dropdown">
                   <optgroup label="&nbsp;&nbsp;&nbsp;&nbsp;Asennuspyyntö" class="header2-dropdown">
                       <option value="Työpyyntö_Asennuspyyntö_Oheislaitteen kytkentä" class="option">&nbsp;&nbsp;&nbsp;&nbsp;Oheislaitteen kytkentä</option>
                       <option value="Työpyyntö_Asennuspyyntö_Sovelluksen asennus (asennus käsin)" class="option">&nbsp;&nbsp;&nbsp;&nbsp;Sovelluksen asennus (asennus käsin)</option>
                       <option value="Työpyyntö_Asennuspyyntö_Sovelluksen asennus (SCCM)" class="option">&nbsp;&nbsp;&nbsp;&nbsp;Sovelluksen asennus (SCCM)</option>
                       <option value="Työpyyntö_Asennuspyyntö_Tietoliikennekytkentä" class="option">&nbsp;&nbsp;&nbsp;&nbsp;Tietoliikennekytkentä</option>
                       <option value="Työpyyntö_Asennuspyyntö_Työaseman kytkentä" class="option">&nbsp;&nbsp;&nbsp;&nbsp;Työaseman kytkentä</option>
                   </optgroup>
                   <option value="Työpyyntö_Ilmoitus SD:lle">&nbsp;&nbsp;&nbsp;&nbsp;Ilmoitus SD:lle</option>
                   <optgroup label="&nbsp;&nbsp;&nbsp;&nbsp;Käyttöoikeudet" class="header2-dropdown">
                       <option value="Työpyyntö_Käyttöoikeudet_iPad" class="option">&nbsp;&nbsp;&nbsp;&nbsp;iPad</option>
                       <option value="Työpyyntö_Käyttöoikeudet_Nimenmuutos" class="option">&nbsp;&nbsp;&nbsp;&nbsp;Nimenmuutos</option>
                       <option value="Työpyyntö_Käyttöoikeudet_PUK-koodi" class="option">&nbsp;&nbsp;&nbsp;&nbsp;PUK-koodi</option>
                       <option value="Työpyyntö_Käyttöoikeudet_Salasanan palautus" class="option">&nbsp;&nbsp;&nbsp;&nbsp;Salasanan palautus</option>
                       <option value="Työpyyntö_Käyttöoikeudet_Tunnuksen poisto" class="option">&nbsp;&nbsp;&nbsp;&nbsp;Tunnuksen poisto</option>
                       <option value="Työpyyntö_Käyttöoikeudet_Uusi verkkotunnus" class="option">&nbsp;&nbsp;&nbsp;&nbsp;Uusi verkkotunnus</option>
                       <option value="Työpyyntö_Käyttöoikeudet_Verkko-oikeudet" class="option">&nbsp;&nbsp;&nbsp;&nbsp;Verkko-oikeudet</option>
                       <option value="Työpyyntö_Käyttöoikeudet_Verkkotunnuksen muutos" class="option">&nbsp;&nbsp;&nbsp;&nbsp;Verkkotunnuksen muutos</option>
                       <option value="Työpyyntö_Käyttöoikeudet_VPN" class="option">&nbsp;&nbsp;&nbsp;&nbsp;VPN</option>
                   </optgroup>
                   <optgroup label="&nbsp;&nbsp;&nbsp;&nbsp;Muiden palveluiden tilaukset" class="header2-dropdown">
                       <option value="Työpyyntö_Muiden palveluiden tilaukset_Kaapelointitilaus" class="option">&nbsp;&nbsp;&nbsp;&nbsp;Kaapelointitilaus</option>
                       <option value="Työpyyntö_Muiden palveluiden tilaukset_Laitetilaus (ei työasemaan)" class="option">&nbsp;&nbsp;&nbsp;&nbsp;Laitetilaus (ei työasemaan)</option>
                       <option value="Työpyyntö_Muiden palveluiden tilaukset_Oheistulostintilaus" class="option">&nbsp;&nbsp;&nbsp;&nbsp;Oheistulostintilaus</option>
                       <option value="Työpyyntö_Muiden palveluiden tilaukset_Palvelintilaus" class="option">&nbsp;&nbsp;&nbsp;&nbsp;Palvelintilaus</option>
                       <option value="Työpyyntö_Muiden palveluiden tilaukset_Puhepalvelun tilaus" class="option">&nbsp;&nbsp;&nbsp;&nbsp;Puhepalvelun tilaus</option>
                       <option value="Työpyyntö_Muiden palveluiden tilaukset_Sovellustilaus" class="option">&nbsp;&nbsp;&nbsp;&nbsp;Sovellustilaus</option>
                       <option value="Työpyyntö_Muiden palveluiden tilaukset_Tarviketilaus (ei työasemaan)" class="option">&nbsp;&nbsp;&nbsp;&nbsp;Tarviketilaus (ei työasemaan)</option>
                       <option value="Työpyyntö_Muiden palveluiden tilaukset_Tietoliikennetilaus" class="option">&nbsp;&nbsp;&nbsp;&nbsp;Tietoliikennetilaus</option>
                       <option value="Työpyyntö_Muiden palveluiden tilaukset_Verkkotulostintilaus" class="option">&nbsp;&nbsp;&nbsp;&nbsp;Verkkotulostintilaus</option>
                   </optgroup>
                   <option value="Työpyyntö_Raportointi" class="option">&nbsp;&nbsp;&nbsp;&nbsp;Raportointi</option>
                   <option value="Työpyyntö_Sovelluspaketointipyyntö" class="option">&nbsp;&nbsp;&nbsp;&nbsp;Sovelluspaketointipyyntö</option>
                   <option value="Työpyyntö_Tiedoston palautus" class="option">&nbsp;&nbsp;&nbsp;&nbsp;Tiedoston palautus</option>
                   <optgroup label="&nbsp;&nbsp;&nbsp;&nbsp;Työasemapalvelu" class="header2-dropdown">
                       <option value="Työpyyntö_Työasemapalvelu_Asset-tietojen muutospyyntö" class="option">&nbsp;&nbsp;&nbsp;&nbsp;Asset-tietojen muutospyyntö</option>
                       <option value="Työpyyntö_Työasemapalvelu_Elinkaarivaihdolla ratkaistava" class="option">&nbsp;&nbsp;&nbsp;&nbsp;Elinkaarivaihdolla ratkaistava</option>
                       <option value="Työpyyntö_Työasemapalvelu_Elinkaarivaihtojen tilaus" class="option">&nbsp;&nbsp;&nbsp;&nbsp;Elinkaarivaihtojen tilaus</option>
                       <option value="Työpyyntö_Työasemapalvelu_Tablet-tilaus" class="option">&nbsp;&nbsp;&nbsp;&nbsp;Tablet-tilaus</option>
                       <option value="Työpyyntö_Työasemapalvelu_Takuuhuoltotilaus" class="option">&nbsp;&nbsp;&nbsp;&nbsp;Takuuhuoltotilaus</option>
                       <option value="Työpyyntö_Työasemapalvelu_Tarviketilaus" class="option">&nbsp;&nbsp;&nbsp;&nbsp;Tarviketilaus</option>
                       <option value="Työpyyntö_Työasemapalvelu_Työasemapoisto" class="option">&nbsp;&nbsp;&nbsp;&nbsp;Työasemapoisto</option>
                       <option value="Työpyyntö_Työasemapalvelu_Työasematilaus, pienet erät" class="option">&nbsp;&nbsp;&nbsp;&nbsp;Työasematilaus, pienet erät</option>
                       <option value="Työpyyntö_Työasemapalvelu_Työasematilaus, suuret erät" class="option">&nbsp;&nbsp;&nbsp;&nbsp;Työasematilaus, suuret erät</option>
                       <option value="Työpyyntö_Työasemapalvelu_Varalaitetilaus" class="option">&nbsp;&nbsp;&nbsp;&nbsp;Varalaitetilaus</option>
                       <optgroup label="&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Viallinen toimitus" class="header3-dropdown">
                           <option value="Työpyyntö_Työasemapalvelu_Viallinen toimitus: DA/WLAN/Verkko" class="option">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;DA/WLAN/Verkko</option>
                           <option value="Työpyyntö_Työasemapalvelu_Viallinen toimitus: Sovelluspuutteet" class="option">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Sovelluspuutteet</option>
                           <option value="Työpyyntö_Työasemapalvelu_Viallinen toimitus: Työasemavirhe" class="option">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Työasemavirhe</option>
                       </optgroup>
                       <option value="Työpyyntö_Työasemapalvelu_Vuokralaitetilaus" class="option">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Vuokralaitetilaus</option>
                  </optgroup>
               </optgroup>
             </select>
             <span class="question" value="Valitse ongelmaasi sopiva ongelmatyyppi. Mikäli et osaa nimetä kategoriaa, voit jättää tämän kentän tyhjäksi">?</span>
             <h4 class="formheader1">Ongelman otsikko</h4>
             <input type="text" name="ongelmanOtsikko" id="ongelmaotsikko" placeholder="Otsikko" />
             <span class="question" value="Anna ongelmallesi kuvaava nimi. Malli: Tietokoneeni ei saa yhteyttä verkkoon">?</span>
             <h4 class="formheader1">Ongelman kuvaus</h4>
             <textarea name="kuvaus" id="ongelmakuvaus" placeholder="Kuvaus"></textarea>
             <span id="questionHankala" value="Kirjoita omin sanoin, mitä ongelmasi koskee">?</span>
             <h4 class="formheader1">Liite</h4>
             <input type="file" name="liite" id="liite" style="background-color:white" />
             <span class="question" value="Liitä tähän haluamasi tiedosto">?</span>
             <input type="button" name="previous" class="previous action-button" value="Edellinen" />
             <input type="button" name="next" id ="tokanappi" class="next action-button" value="Seuraava" />
         </fieldset>
         <fieldset>
             <h2 class="fs-title">Uuden työpyynnön lähetys</h2>
             <h3 class="fs-subtitle">Yhteenveto ja tietojen tarkistus</h3>
             <script>
                 $(function () {
                     $('#tokanappi').on('click', function () {
                         var koonti = $('#koonti');
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
                         koonti.val(koonti.val() + '---------- Ongelman tiedot ----------');
                         koonti.val(koonti.val() + '\n\n');
                         koonti.val(koonti.val() + 'Ongelman luokittelu: ' + document.getElementById("ongelmaluokka").value);
                         koonti.val(koonti.val() + '\n\n');
                         koonti.val(koonti.val() + 'Ongelman otsikko: ' + document.getElementById("ongelmaotsikko").value);
                         koonti.val(koonti.val() + '\n\n');
                         koonti.val(koonti.val() + 'Ongelman kuvaus: ' + document.getElementById("ongelmakuvaus").value);
                         koonti.val(koonti.val() + '\n\n');
                         koonti.val(koonti.val() + 'Liitetty/liitetyt tiedostot:' + document.getElementById("liite").value);
                         koonti.val(koonti.val() + '\n\n');
                         koonti.val(koonti.val() + 'Käyttöjärjestelmän nimi: <%=osName%> \n');

                     });
                 });
             </script>
             <textarea id ="koonti"></textarea>
             <input type="button" name="previous" class="previous action-button" value="Edellinen" />
             <input type="button" name="next" class="next action-button" value="Lähetä" />
         </fieldset>
        </form>
        </div>
        </body>
    </html>