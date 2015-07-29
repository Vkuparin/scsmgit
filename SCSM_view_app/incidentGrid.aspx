<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Site.Master" CodeBehind="incidentGrid.aspx.cs" Inherits="show_incident.incidentGrid" %>


<asp:Content runat="server" ID="BodyContent" ContentPlaceHolderID="MainContent">
    <!-- Kaikki koodi asp-sivun Content (body) kohdassa. Ks. Site.Master perityt tiedot -->
    <style type="text/css">
        /*CSS-muotoilua: tekee taulukon riveille vuorotellen vaihtelevat taustat (sininen ja valkoinen)*/
        .myAltRowClass { background-color: #e4f0fa; background-image: none; }
        body {
                font-family: montserrat, arial, verdana;
                background: rgb(243, 253, 255);
                background: -moz-linear-gradient(90deg, rgb(243, 253, 255) 27%, rgb(178, 240, 255) 98%);
                background: -webkit-linear-gradient(90deg, rgb(243, 253, 255) 27%, rgb(178, 240, 255) 98%);
                background: -o-linear-gradient(90deg, rgb(243, 253, 255) 27%, rgb(178, 240, 255) 98%);
                background: -ms-linear-gradient(90deg, rgb(243, 253, 255) 27%, rgb(178, 240, 255) 98%);
                background: linear-gradient(180deg, rgb(243, 253, 255) 27%, rgb(178, 240, 255) 98%);
                background-size: 20px 1200px;
        }
    </style>

    <script type="text/javascript">
        $(function () {
                //Määritetään gridi viittaamaan vastaavaan html-taulukkoon (id: Grid1)
                $Grid1 = $("#Grid1"),
                
                //Päivänvalitsemisfunktio, tuo esiin kutsuttaessa perus jquery kalenterin
                initDatepicker = function (elem) {
                    $(elem).datepicker({
                        dateFormat: "dd-M-yy",
                        autoSize: true,
                        changeYear: true,
                        changeMonth: true,
                        showButtonPanel: true,
                        showWeek: true
                    });
                },
                //Funktio korostaa (highlight) taulukossa tekstin, joka on syötetty hakukenttään
                highlightFilteredData = function () {
                    var $self = $(this), filters, i, l, rules, rule, iCol,
                        isFiltered = $self.jqGrid("getGridParam", "search"),
                        postData = $self.jqGrid("getGridParam", "postData"),
                        colModel = $self.jqGrid("getGridParam", "colModel"),
                        colIndexByName = {};
                    // validate whether we have input for highlighting
                    if (!isFiltered || typeof postData !== "object") {
                        return;
                    }
                    filters = $.parseJSON(postData.filters);
                    if (filters == null || filters.rules == null && filters.rules.length <= 0) {
                        return;
                    }

                    // fill colIndexByName which get easy column index by the column name
                    for (i = 0, l = colModel.length; i < l; i++) {
                        colIndexByName[colModel[i].name] = i;
                    }

                    rules = filters.rules;
                    for (i = 0, l = rules.length; i < l; i++) {
                        rule = rules[i];
                        iCol = colIndexByName[rule.field];
                        if (iCol !== undefined) {
                            $self.find(">tbody>tr.jqgrow>td:nth-child(" + (iCol + 1) + ")").highlight(rule.data);
                        }
                    }
                };
           
                  //jqgridin defaulttien määrittelyä / laajennusta
                  $.extend($.jgrid.defaults,
                      {
                          datatype: 'json',
                          height: 'auto',
                          autowidth: true,
                          shrinkToFit: true,
                          altRows: true,
                          sortable: true,
                          altclass:'myAltRowClass',
                          toolbar: ['true',"top"]
                      },
                      {//Ajax valinnat. mm. näyttää / piilottaa loading-palkin
                          ajaxGridOptions: {
                              contentType: "application/json",
                              success: function (data, textStatus) {
                                  if (textStatus == "success") {
                                      var thegrid = $("#Grid1")[0];
                                      thegrid.addJSONData(data.d);
                                      thegrid.grid.hDiv.loading = false;
                                      switch (thegrid.p.loadui) {
                                          case "disable":
                                              break;
                                          case "enable":
                                              $("#load_" + thegrid.p.id).hide();
                                              break;
                                          case "block":
                                              $("#lui_" + thegrid.p.id).hide();
                                              $("#load_" + thegrid.p.id).hide();
                                              break;
                                      }
                                  }
                              }
                          }

                      });

                //Itse gridin luonti. 
                $Grid1.jqGrid({
                    url: 'incidentGrid.aspx/GetDataTable', //kutsuu funktiota GetDataTable tiedostossa incidentGrid.aspx.cs, joka hakee SQL:llä serveriltä käyttäjän tikettien tiedot
                    datatype: 'json',
                    mtype: 'POST',
                    colNames: ['Otsikko', 'ID / Linkki', 'Suljettu', 'Luotu', 'Id1', 'Työavain', 'WorkItemDimKey1', 'Vaikuttaa käyttäjään (nro)', 'Käyttäjänimi', 'Käyttäjänumero'],
                    colModel:
                     //Tiketin otsikko
                     [{ name: 'IncidentDim.Title', index: 'IncidentDim.Title', width: 300, sorttype: 'string' },
                     //Tiketin ID. Custom formatter, joka luo linkin yksittäisen tiketin incident-sivulle
                     {
                         name: 'Id', index: 'Id', width: 100, editable: true, align: "center", formatter: function (cellvalue, options, rowObject) {
                             var val = '<a href = "incident.aspx?id=' + cellvalue + '">' + cellvalue + '</a>';
                             return val;
                         },
                     },
                     //Milloin tiketti on suljettu
                    {
                        name: 'ClosedDate', index: 'ClosedDate', width: 100, align: "center", sorttype: "date",
                        formatter: "date", formatoptions: { newformat: "d-M-Y" },
                        searchoptions: { sopt: ["eq", "ne", "lt", "le", "gt", "ge"], dataInit: initDatepicker }
                    },
                    //Milloin tiketi on luotu
                    {
                        name: 'CreatedDate', index: 'CreatedDate', width: 100, align: "center", sorttype: "date",
                        formatter: "date", formatoptions: { newformat: "d-M-Y" },
                        searchoptions: { sopt: ["eq", "ne", "lt", "le", "gt", "ge"], dataInit: initDatepicker }
                    },
                    //Taas tiketin ID. Turha? Piilotettu
                    { name: 'Id1', index: 'Id1', width: 150, hidden: true, search: false },
                    //Työavain, ei oleellinen käyttäjälle, piilotettu
                    { name: 'WorkItemDimKey', index: 'WorkItemDimKey', width: 80, hidden:true, search:false},
                    //Työavain, ei oleellinen käyttäjälle, piilotettu
                    { name: 'WorkItemDimKey1', index: 'WorkItemDimKey1', hidden: true, search: false },
                    //Ketä tiketti koskee. Ei oleellinen käyttäjälle, piilotettu.
                    { name: 'WorkItemAffectedUser_UserDimKey', index: 'WorkItemAffectedUser_UserDimKey', hidden: true, search: false },
                    //Käyttäjänimi. Ei oleellinen käyttäjälle, piilotettu.
                    { name: 'UserName', index: 'UserName', width: 100, hidden:true, search:false},
                    //Käyttäjäavain. Ei oleellinen käyttäjälle, piilotettu.
                    { name: 'UserDimKey', index: 'UserDimKey', width: 100, hidden: true, search:false }],
                    //Lisää gridin määrittelyä
                    pager: '#pager', sortname: 'CreatedDate', sortorder: 'desc',
                    rowNum: 50,
                    rowTotal: 10000,
                    rowList: [20, 50, 100],
                    rownumbers: true,
                    gridview: true,
                    //loadonce: lataa kerralla kaiken oleellisen datan taulukkoon. Muuttaa sen jälkeen taulukon tyypiksi "local". Muokkaus, kuten haku, tapahtuu lokaalisti
                    loadonce: true,
                    ignoreCase: true,
                    viewrecords: true,
                    emptyrecords: "Ei hakutuloksia",
                    imgpath: 'Content/images',
                    serializeGridData: function (data) {
                        return JSON.stringify(data);
                    },
                    gridComplete: function () {
                    highlightFilteredData.call(this);
                    }
                  });
                  jQuery($Grid1).jqGrid("navGrid", "#pager", { add: false, edit: false, del: false, search: false }); //pager/sivunkääntäjä
                  //Lisätään top bariin hakukenttä ja -nappi
                  $('#t_' + $.jgrid.jqID($Grid1[0].id))
                 .append($("<div><label for=\"globalSearchText\">Etsi taulukosta:&nbsp;</label><input id=\"globalSearchText\" type=\"text\"></input>&nbsp;<button id=\"globalSearch\" type=\"button\">Search</button></div>"));
                  $("#globalSearchText").keypress(function (e) {
                      var key = e.charCode || e.keyCode || 0;
                      if (key === $.ui.keyCode.ENTER) { // 13
                          $("#globalSearch").click();
                      }
                  });
                  $("#globalSearch").button({
                      icons: { primary: "ui-icon-search" },
                      text: false
                  //Hakufunktio, joka suoritetaan kun hakunappia on klikattu
                  }).click(function () {
                      var postData = $Grid1.jqGrid("getGridParam", "postData"),
                          colModel = $Grid1.jqGrid("getGridParam", "colModel"),
                          rules = [],
                          searchText = $("#globalSearchText").val(),
                          l = colModel.length,
                          i,
                          cm;
                      for (i = 0; i < l; i++) {
                          cm = colModel[i];
                          if (cm.search !== false && (cm.stype === undefined || cm.stype === "text")) {
                              rules.push({
                                  field: cm.name,
                                  op: "cn",
                                  data: searchText
                              });
                          }
                      }
                      postData.filters = JSON.stringify({
                          groupOp: "OR",
                          rules: rules
                      });
                      $Grid1.jqGrid("setGridParam", { search: true });
                      $Grid1.trigger("reloadGrid", [{page: 1, current: true}]); //Ladataan grid uudelleen filttereiden kera
                      return false;
                  });
            });
    </script>

    <hgroup class="title">
        <h1> Omat työpyynnöt <asp:Label ID="parametri" runat="server"/></h1>
    </hgroup>
    <!-- Taulukko tulee tänne -->
    <div id="gridcontainer">

        <table id="Grid1" class="scroll" align="center" width="100%"></table>
        <div id="pager" class="scroll" style="text-align:center;">
        </div>
    </div>
        
</asp:Content>
