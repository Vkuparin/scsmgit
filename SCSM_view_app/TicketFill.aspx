<%@ Page Language="C#" CodeBehind="TicketFill.aspx.cs" Inherits="TicketFill" AutoEventWireup="True" %>

<!DOCTYPE html>
<html>
    <head runat="server">
    <title>Uuden työpyynnön luominen</title>
    <!-- main css -->
    <link rel="stylesheet" type="text/css" media="screen" href="Content/TicketFill.css" />
    <!-- drag-n-drop upload css -->
    <link rel="stylesheet" type="text/css" media="screen" href="Content/upload.css" />
    <!-- drag-n-drop upload muotoilut tiedostolistalle -->
	<style type="text/css">
        .filelists { margin: 20px 0; }
	    .filelists h5 { margin: 10px 0 0; text-align: left; font-size: 12px; padding-left: 10px }
	    .filelist { margin: 0; padding: 10px 0; }
	    .filelist li { background: #fff; border-bottom: 1px solid #eee; font-size: 14px; list-style: none; padding: 5px; }
	    .filelist li:before { display: none; }
	    .filelist li .file { color: #333; }
	    .filelist li .progress { color: #666; float: right; font-size: 10px; text-transform: uppercase; }
	    .filelist li .delete { color: red; cursor: pointer; float: right; font-size: 10px; text-transform: uppercase; }
	    .filelist li.complete .progress { color: green; }
	    .filelist li.error .progress { color: red; }
    </style>
    <style type="text/css">
        html, body {
            color: white;
            font-size: 75%;
            padding: 10px;
            text-align: center;
        }
     </style>
     <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
     <script src="Scripts/jquery.json.min.js" type="text/javascript"></script>
     <script src="http://thecodeplayer.com/uploads/js/jquery.easing.min.js" type="text/javascript"></script>
     <!--scripti drag-n-drop upload kentälle -->
     <script src="Scripts/core.js" type="text/javascript"></script>
     <script src="Scripts/upload.js" type="text/javascript"></script>
     <script>
        //muuttujat drag-n-drop upload kentälle
        var $filequeue,
		$filelist;
        //muuttuja koontikentälle
        var $koontidata;
         //document.ready
        $(function () {

            /*
            * Drag-n-drop upload kenttää
            * 
            */
            $.upload("defaults", {

                label: "Pudota tiedostot tähän tai napsauta tästä valitaksesi tiedostot tietokoneeltasi"
            });

            $filequeue = $(".filelist.queue");
            $filelist = $(".filelist.complete");

            $(".liite").upload({
                maxSize: 1048576
            }).on("start.upload", onStart)
              .on("complete.upload", onComplete)
              .on("filestart.upload", onFileStart)
              .on("fileprogress.upload", onFileProgress)
              .on("filecomplete.upload", onFileComplete)
              .on("fileerror.upload", onFileError);

            /*
            * Funktiot lomakkeen toiminnallisuudelle, navigoimiselle ja
            * animoinnille
            */
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
       /*
        * Funktiot drag-n-drop upload kentän
        * toiminnallisuudelle
        */
        function onStart(e, files) {
            console.log("Start");
            var html = '';
            for (var i = 0; i < files.length; i++) {
                html += '<li data-index="' + files[i].index + '"><span class="file">' + files[i].name + '</span><span class="progress">Queued</span></li>';
            }
            $filequeue.append(html);
        }

        function onComplete(e) {
            console.log("Complete");
            // All done!
        }

        function onFileStart(e, file) {
            console.log("File Start");
            $filequeue.find("li[data-index=" + file.index + "]")
                      .find(".progress").text("0%");
        }

        function onFileProgress(e, file, percent) {
            console.log("File Progress");
            $filequeue.find("li[data-index=" + file.index + "]")
                      .find(".progress").text(percent + "%");
        }

        function onFileComplete(e, file, response) {
            console.log("File Complete");
            if (response.trim() === "" || response.toLowerCase().indexOf("error") > -1) {
                $filequeue.find("li[data-index=" + file.index + "]").addClass("error")
                          .find(".progress").text(response.trim());
            } else {
                var $target = $filequeue.find("li[data-index=" + file.index + "]");
                $target.find(".file").text(file.name);
                $target.find(".progress").remove();
                $target.appendTo($filelist);
            }
        }

        function onFileError(e, file, error) {
            console.log("File Error");
            $filequeue.find("li[data-index=" + file.index + "]").addClass("error")
                      .find(".progress").text("Error: " + error);
        }
        //Kutsuu mailin lähetysfunktiota
        function sendMail() {
            var dataToSend = $koontidata;
            console.log(dataToSend)
            var options =
                       {
                           url: 'TicketFill.aspx/sendMail',
                           data: JSON.stringify(dataToSend),
                           contentType:'application/json; charset=utf-8',
                           dataType: 'JSON',
                           type: 'POST',
                           success: function (data) {
                               alert(data.d)
                               console.log("success")
                           },
                           failure: function (data) {
                               alert("Error");
                               console.log("failure")
                           }
                       }
            $.ajax(options);
            console.log("lähetetty");
        }
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
	        	<li class="active" style="color:white">Perustiedot</li>
        		<li style="color:white">Ongelman kuvaus</li>
        		<li style="color:white">Yhteenveto ja tietojen tarkistus</li>
        	</ul>
        	<!-- fieldsets -->
          <fieldset>
             <h2 class="fs-title" style="color:white">Uuden työpyynnön lähetys</h2>
             <h3 class="fs-subtitle" style="color:white">Ongelman kuvaus</h3>
             <h4 class="formheader1" style="color:white">Asiani koskee:<span style="color:#ed0c6e">&ast;</span></h4>
             <select id="tukiryhmä">
                 <option selected="selected" disabled="disabled">-Valitse sopiva vaihtoehto-</option>
                 <option value="servicedesk.dotku@turku.fi">Dotku-tuki</option>
                 <option value="servicedesk.hpk@turku.fi">Henkilöstöpalvelukeskus</option>
                 <option value="servicedesk@turku.fi">IT-palvelut</option>
                 <option value="servicedesk.joutsenet@turku.fi">JoutseNet-tuki</option>
                 <option value="servicedesk.pegasos@turku.fi">Pegasos-tuki</option>
                 <option value="servicedesk.trimble@turku.fi">Trimble-tuki</option>
             </select>
             <span class="question" value="Valitse asiaasi koskeva tukiryhmä">?</span>
             <h4 class="formheader1">Ongelman otsikko<span style="color:#ed0c6e">&ast;</span></h4>
             <input type="text" name="ongelmanOtsikko" id="ongelmaotsikko" placeholder="Otsikko" />
             <span class="question" value="Anna ongelmallesi kuvaava nimi. Malli: Tietokoneeni ei saa yhteyttä verkkoon">?</span>
             <h4 class="formheader1">Ongelman kuvaus</h4>
             <textarea name="kuvaus" id="ongelmakuvaus" placeholder="Kuvaus"></textarea>
             <span id="questionHankala" value="Kirjoita omin sanoin, mitä ongelmasi koskee">?</span>
             <h4 class="formheader1">Liite</h4>
             <div class="liite" id="liite"></div>
             <div class="filelists">
		        <h5>Valmiina</h5><hr />
		        <ol class="filelist complete">
		        </ol>
		        <h5>Jonossa</h5><hr />
		        <ol class="filelist queue">
		        </ol>
	        </div>
             <input type="button" name="next" class="next action-button" value="Seuraava" />
         </fieldset>
         <fieldset>
             <h2 class="fs-title" style="color:white">Uuden työpyynnön lähetys</h2>
             <h3 class="fs-subtitle" style="color:white">Perustiedot</h3>
             <h4 class="formheader1" style="color:white">Toimiala<span style="color:#ed0c6e">&ast;</span></h4>
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
             <h4 class="formheader1">Osasto<span style="color:#ed0c6e">&ast;</span></h4>
             <input type="text" name="osasto" id="osasto" value="<%=userDepartment%>" required />
             <span class="question" value="Kirjoita tähän osastosi, mikäli oletus ei täsmää tietojesi kanssa">?</span>
             <h4 class="formheader1">Toimipisteen nimi<span style="color:#ed0c6e">&ast;</span></h4>
             <input type="text" name="toimipiste" id="yksikkö" value="<%=userOffice%>" required />
             <span class="question" value="Kirjoita tähän yksikkösi nimi, mikäli oletus ei täsmää tietojesi kanssa">?</span>
             <h4 class="formheader1">Toimipisteen osoite</h4>
             <input type="text" name="osoite" id="osoite" placeholder="Toimipisteen osoite" required />
             <span class="question" value="Kirjoita tähän toimipisteesi osoite. Malli: Ruukinkatu 4">?</span>
             <h4 class="formheader1">Henkilö, jota työpyyntö koskee<span style="color:#ed0c6e">&ast;</span></h4>
             <input type="text" name="nimi" id="nimi" value="<%=userFullName%>" required />
             <span class="question" value="Kirjoita tähän sen henkilön etu- ja sukunimi, jota työpyyntö koskee. Oletuksena on, että pyyntö koskee kirjautuneena olevaa käyttäjää">?</span>
             <h4 class="formheader1">Sähköpostiosoite<span style="color:#ed0c6e">&ast;</span></h4>
             <input type="text" name="sähköposti" id="sähköposti" value="<%=userEmail%>" />
             <span class="question" value="Kirjoita tähän yhteydenpidossa käytettävä sähköpostiosoite. Oletuksena käytetään kirjautuneena olevan käyttäjän sähköpostiosoitetta">?</span>
             <h4 class="formheader1">Puhelinnumero</h4>
             <input type="text" name="puhelinnumero" id="puhelinnumero" value="<%=userPhone%>" />
             <span class="question" value="Kirjoita tähän yhteydenpidossa käytettävä puhelinnumero">?</span>
             <h4 class="formheader1">Tietokone, jota työpyyntö koskee<span style="color:#ed0c6e">&ast;</span></h4>
             <input type="text" name="tietokoneenNimi" id="tietokoneenNimi" value="<%=computerName%>" />
             <span class="question" value="Tietokoneesi nimi löytyy Käynnistä-valikkoa painaessa Ohjauspaneeli-valinnan yläpuolelta. Tietokoneet on myös nimetty tarroilla, jotka löytyvät useimmiten näppäimistön yläpäästä. Malli: VARA11">?</span>
             <input type="button" name="previous" class="previous action-button" value="Edellinen" />
             <input type="button" name="next" id ="tokanappi" class="next action-button" value="Seuraava" />
         </fieldset>
         <fieldset>
             <h2 class="fs-title" style="color:white">Uuden työpyynnön lähetys</h2>
             <h3 class="fs-subtitle" style="color:white">Yhteenveto ja tietojen tarkistus</h3>
             <script>
                 $(function () {
                     $('#tokanappi').on('click', function () {
                         //muuttuja koontikentälle
                         var koonti = $('#koonti');
                         //Päivitetään koontikentän arvoa
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
                         koonti.val(koonti.val() + 'Asiani koskee: ' + document.getElementById("tukiryhmä").value);
                         koonti.val(koonti.val() + '\n\n');
                         koonti.val(koonti.val() + 'Ongelman otsikko: ' + document.getElementById("ongelmaotsikko").value);
                         koonti.val(koonti.val() + '\n\n');
                         koonti.val(koonti.val() + 'Ongelman kuvaus: ' + document.getElementById("ongelmakuvaus").value);
                         koonti.val(koonti.val() + '\n\n');
                         koonti.val(koonti.val() + 'Liitetty/liitetyt tiedostot:' + document.getElementById("liite").value);
                         koonti.val(koonti.val() + '\n\n');
                         koonti.val(koonti.val() + 'Käyttöjärjestelmän nimi: <%=osName%> \n');

                         //Sijoitetaan koontikentän tiedot koontidata-muuttujaan
                         $koontidata = koonti.val();
                     });
                 });
             </script>
             <textarea id ="koonti"></textarea>
             <input type="button" name="previous" class="previous action-button" value="Edellinen" />
             <!--<input type="button" name="next" class="next action-button" onclick="sendMail()" value="Lähetä" />-->
             <asp:Button id="MailButton" class="next action-button" onclick="SendButton_Click" Text="Lähetä" runat="server" />  
         </fieldset>
        </form>
        </div>
        </body>
    </html>