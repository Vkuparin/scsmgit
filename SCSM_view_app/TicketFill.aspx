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
             <h4 class="formheader1">Yksikkö</h4>
             <input type="text" name="toimipiste" id="yksikkö" value="<%=userOffice%>" required />
             <span class="question" value="Kirjoita tähän yksikkösi nimi, mikäli oletus ei täsmää tietojesi kanssa">?</span>
             <h4 class="formheader1">Toimipisteen osoite ja työpisteen nimi</h4>
             <input type="text" name="työhuone" id="työhuone" placeholder="Toimipisteen osoite ja työaseman nimi" required />
             <span class="question" value="Kirjoita tähän toimipisteesi osoite ja työaseman nimi. Malli: Ruukinkatu 4, M1">?</span>
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
             <input list="ongelmaluokittelu">
             <datalist id="ongelmaluokittelu">
               <option value="Käyttöopastus_Oheislaitteet">
               <option value="Käyttöopastus_Sovellus">
               <option value="Käyttöopastus_Tietoliikenne_Direct Access">
               <option value="Käyttöopastus_Tietoliikenne_VPN">
               <option value="Käyttöopastus_Toimintatapa">
               <option value="Käyttöopastus_Tulostus">
               <option value="Käyttöopastus_Työasema">
               <option value="Puhepalveluongelma_Lanka-ja mobiililiittymät">
               <option value="Puhepalveluongelma_Puhelinvaihde">
               <option value="Puhepalveluongelma_TeleQ">
               <option value="Selvityspyyntö_Muu palvelu">
               <option value="Selvityspyyntö_Puhepalvelu_Lanka-ja mobiililiittymät">
               <option value="Selvityspyyntö_Puhepalvelu_TeleQ">
               <option value="Selvityspyyntö_Sovellus">
               <option value="Selvityspyyntö_Tietoliikenne">
               <option value="Selvityspyyntö_Toimintatapa">
               <option value="Selvityspyyntö_Tulostus">
               <option value="Selvityspyyntö_Työasema">
               <option value="Sovellusongelma_Paikallinen sovellus">
               <option value="Sovellusongelma_Palvelinsovellus">
               <option value="Sovellusongelma_Verkkosovellus">
               <option value="Tietoliikenneongelma_Dataliikenne_Lähiverkko_LAN">
               <option value="Tietoliikenneongelma_Dataliikenne_Lähiverkko_WLAN">
               <option value="Tietoliikenneongelma_Dataliikenne_Runkoverkko_Etätyöyhteydet">
               <option value="Tietoliikenneongelma_Dataliikenne_Runkoverkko_Mobiililaajakaista">
               <option value="Tietoliikenneongelma_Dataliikenne_Runkoverkko_Ulkoiset toimijat">
               <option value="Tietoliikenneongelma_Dataliikenne_Ulkoiset yhteydet">
               <option value="Tietoliikenneongelma_Puhelinliikenne">
               <option value="Tietoliikenneongelma_Tietoliikennepalvelut">
               <option value="Tietoliikenneongelma_Tietoturva">
               <option value="Tietoturva_Haittaohjelmat">
               <option value="Tietoturva_Muutoshallinta">
               <option value="Tietoturva_Roskaposti">
               <option value="Tietoturva_Virusilmoitukset">
               <option value="Työasemaongelma_Ajuriongelma">
               <option value="Työasemaongelma_Ajuriongelma (ratkaisuna Lenovo System Update">
               <option value="Työasemaongelma_Komponenttiongelma">
               <option value="Työasemaongelma_Oheislaiteongelma">
               <option value="Työasemaongelma_Windows-ongelma_Käyttäjän uloskirjaus">
               <option value="Työasemaongelma_Muut laitteet_iPad">
               <option value="Työasemaongelma_Uudelleenasennus">
               <option value="Työasemaongelma_Verkko-ongelma">
               <option value="Työpyyntö_Asennuspyyntö_Oheislaitteen kytkentä">
               <option value="Työpyyntö_Asennuspyyntö_Sovelluksen asennus (käsiasennus)">
               <option value="Työpyyntö_Asennuspyyntö_Sovelluksen asennus (SCCM)">
               <option value="Työpyyntö_Asennuspyyntö_Tietoliikennekytkentä">
               <option value="Työpyyntö_Asennuspyyntö_Työaseman kytkentä">
               <option value="Työpyyntö_Ilmoitus SD:lle">
               <option value="Työpyyntö_Käyttöoikeudet_iPad">
               <option value="Työpyyntö_Käyttöoikeudet_Nimenmuutos">
               <option value="Työpyyntö_Käyttöoikeudet_PUK-koodi">
               <option value="Työpyyntö_Käyttöoikeudet_Salasanan palautus">
               <option value="Työpyyntö_Käyttöoikeudet_Tunnuksen poisto">
               <option value="Työpyyntö_Käyttöoikeudet_Uusi verkkotunnus">
               <option value="Työpyyntö_Käyttöoikeudet_Verkko-oikeudet">
               <option value="Työpyyntö_Käyttöoikeudet_Verkkotunnuksen muutos">
               <option value="Työpyyntö_Käyttöoikeudet_VPN">
               <option value="Työpyyntö_Raportointi">
               <option value="Työpyyntö_Sovelluspaketointipyyntö">
               <option value="Työpyyntö_Tiedoston palautus">
               <option value="Työpyyntö_Muiden palveluiden tilaukset_Laitetilaus (ei työasemaan)">
               <option value="Työpyyntö_Muiden palveluiden tilaukset_Palvelintilaus">
               <option value="Työpyyntö_Muiden palveluiden tilaukset_Puhepalvelun tilaus">
               <option value="Työpyyntö_Muiden palveluiden tilaukset_Sovellustilaus">
               <option value="Työpyyntö_Muiden palveluiden tilaukset_Tarviketilaus (ei työasemaan)">
               <option value="Työpyyntö_Muiden palveluiden tilaukset_Tietoliikennetilaus">
               <option value="Työpyyntö_Muiden palveluiden tilaukset_Kaapelointitilaus">
               <option value="Työpyyntö_Muiden palveluiden tilaukset_Verkkotulostintilaus">
               <option value="Työpyyntö_Muiden palveluiden tilaukset_Oheistulostintilaus">
               <option value="Työpyyntö_Työasemapalvelu_Tarviketilaus">
               <option value="Työpyyntö_Työasemapalvelu_Työasematilaus, pienet erät">
               <option value="Työpyyntö_Työasemapalvelu_Työasematilaus, suuret erät">
               <option value="Työpyyntö_Työasemapalvelu_Elinkaarivaihtojen tilaus">
               <option value="Työpyyntö_Työasemapalvelu_Elinkaarivaihdolla ratkaistava">
               <option value="Työpyyntö_Työasemapalvelu_Asset-tietojen muutospyyntö">
               <option value="Työpyyntö_Työasemapalvelu_Takuuhuoltotilaus">
               <option value="Työpyyntö_Työasemapalvelu_Varalaitetilaus">
               <option value="Työpyyntö_Työasemapalvelu_Vuokralaitetilaus">
               <option value="Työpyyntö_Työasemapalvelu_Tablet-tilaus">
               <option value="Työpyyntö_Työasemapalvelu_Työasemapoisto">
               <option value="Työpyyntö_Työasemapalvelu_Viallinen toimitus: DA/WLAN/Verkko">
               <option value="Työpyyntö_Työasemapalvelu_Viallinen toimitus: Sovelluspuutteet">
               <option value="Työpyyntö_Työasemapalvelu_Viallinen toimitus: Työasemavirhe">
               <option value="Tulostusongelma_Oheistulostus_Ajuriongelma">
               <option value="Tulostusongelma_Oheistulostus_Laiteongelma">
               <option value="Tulostusongelma_Verkkotulostus_Laiteongelma">
               <option value="Tulostusongelma_Verkkotulostus_Tulostusjono">
               <option value="Dotku-tuki_Extranet">
               <option value="Dotku-tuki_Käyttöoikeudet">
               <option value="Dotku-tuki_Tukipyyntö">
               <option value="Dotku-tuki_Työtilat">
               <option value="Dotku-tuki_Dokumenttikirjastot">
               <option value="JoutseNet-tuki_Käyttöoikeudet">
               <option value="JoutseNet-tuki_Salasanan palautus">
               <option value="JoutseNet-tuki_Tukipyyntö">
               <option value="JoutseNet-tuki_Yhteisöpostilaatikot">
               <option value="HPK-tuki_SAP HR_Käyttöoikeudet">
               <option value="HPK-tuki_SAP HR_Tukipyyntö_Henkilön omat tiedot">
               <option value="HPK-tuki_SAP HR_Tukipyyntö_Kehityskeskustelut ja arvioinnit">
               <option value="HPK-tuki_SAP HR_Tukipyyntö_Koulutus ja kurssit">
               <option value="HPK-tuki_SAP HR_Tukipyyntö_Matkahallinta">
               <option value="HPK-tuki_SAP HR_Tukipyyntö_Organisaatio">
               <option value="HPK-tuki_SAP HR_Tukipyyntö_Osaamisen kartoittaminen ja ylläpito">
               <option value="HPK-tuki_SAP HR_Tukipyyntö_Palvelussuhteen tiedot">
               <option value="HPK-tuki_SAP HR_Tukipyyntö_Poissaolot ja vuosilomat">
               <option value="HPK-tuki_SAP HR_Tukipyyntö_Tehtäväluettelo">
               <option value="HPK-tuki_Kuntarekry_Käyttöoikeudet">
               <option value="HPK-tuki_Kuntarekry_Tukipyyntö">
               <option value="HPK-tuki_Vakanssit tai budjetoidut toimet_Budjetoitujen toimien ylläpito">
               <option value="HPK-tuki_Vakanssit tai budjetoidut toimet_Vakanssien ylläpito päätökseen perustuen">
               <option value="HPK-tuki_Vakanssit tai budjetoidut toimet_Vakanssitietojen ylläpito">
               <option value="HPK-tuki_Rekrytointi_Rekrytoinnin suunnittelu ja valmistelu">
               <option value="HPK-tuki_Rekrytointi_Rekrytointi">
               <option value="HPK-tuki_Rekrytointi_Sijaistilaus (Hyto)">
               <option value="HPK-tuki_Palvelussuhdeasiat_Palvelussuhdeneuvonta">
               <option value="HPK-tuki_Palvelussuhdeasiat_Työkokemuslisät">
               <option value="HPK-tuki_Palvelussuhdeasiat_Muut asiat">
               <option value="HPK-tuki_Palvelussuhdeasiat_Palvelu-ja työtodistukset">
               <option value="HPK-tuki_Palvelussuhdeasiat_Eläkeasiat">
               <option value="HPK-tuki_Palvelussuhdeasiat_Vuosilomat">
               <option value="HPK-tuki_Muut asiat_Koulutuspyynnöt">
               <option value="HPK-tuki_Muut asiat_Palaute">
               <option value="HPK-tuki_Muut asiat_Raportti-ja tilastopyynnöt">
               <option value="HPK-tuki_Muut asiat_Yhteydenottopyyntö">
               <option value="Pegasos-tuki_Kehitysehdotus">
               <option value="Pegasos-tuki_Käyttöoikeus">
               <option value="Pegasos-tuki_Käyttöopastus">
               <option value="Pegasos-tuki_Muu työpyyntö">
               <option value="Pegasos-tuki_Ohjelmavirhe">
               <option value="Pegasos-tuki_Ongelma">
               <option value="Pegasos-tuki_Raportointipyyntö">
               <option value="Trimble-tuki_Käyttöoikeudet">
               <option value="Trimble-tuki_Ongelmatilanne">
               <option value="Testitiketti">
               <option value="Roskapostitiketti">
             </datalist>
             <span class="question" value="Valitse ongelmaasi sopiva kategoria. Mikäli et osaa nimetä kategoriaa, voit jättää tämän kentän tyhjäksi">?</span>
             <h4 class="formheader1">Ongelman otsikko</h4>
             <input type="text" name="ongelmanOtsikko" id="ongelmaotsikko" placeholder="Otsikko" />
             <span class="question" value="Anna ongelmallesi kuvaava nimi. Malli: Tietokoneeni ei saa yhteyttä verkkoon">?</span>
             <h4 class="formheader1">Ongelman kuvaus</h4>
             <textarea name="kuvaus" id="ongelmakuvaus" placeholder="Kuvaus"></textarea>
             <span id="questionHankala" value="Kirjoita omin sanoin, mitä ongelmasi koskee">?</span>
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
                         koonti.val(koonti.val() + 'Yksikkö: ' + document.getElementById("yksikkö").value);
                         koonti.val(koonti.val() + '\n\n');
                         koonti.val(koonti.val() + 'Osoite ja työhuone: ' + document.getElementById("työhuone").value);
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