<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Site.Master" CodeBehind="incident.aspx.cs" Inherits="show_incident.incident" %>

<asp:Content runat="server" ID="BodyContent" ContentPlaceHolderID="MainContent">
    <style>
        .ui-jqgrid tr.jqgrow td {
        white-space: normal !important;
        height:auto;
        vertical-align:text-top;
        padding-top:2px;
        }
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
    <hgroup class="title">
        <h1>Työpyyntö: <%: Title %> <asp:Label ID="parametri" runat="server"/></h1>
    </hgroup>

    <script type="text/javascript">
            $(function () {
                $Grid1 = $("#Grid1"),

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

                numberTemplate = {formatter: "number", align: "right", sorttype: "number",
                editrules: {number: true, required: true},
                searchoptions: { sopt: ["eq", "ne", "lt", "le", "gt", "ge", "nu", "nn", "in", "ni"] }
                },

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
                          height: '100%',
                          autowidth: true,
                          shrinkToFit: true,
                          sortable: true,
                          toolbar: ['true', "top"],
                          scrollerbar: true,
                          height: "620"

                      },
                      {
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

                  //Rakennetaan jqgrid
                  $Grid1.jqGrid({
                      url: 'incident.aspx/GetIncidentTable',
                      datatype: 'json',
                      mtype: 'POST',
                      colNames: ['Prioriteetti', 'SulkemisPvm', 'InsertedBatchId', 'Id', 'Otsikko', 'Kuvaus', 'LuomisPvm', 'Kuukausi', 'Päivä', 'Vuosi', 'FirstAssignedDay', 'ID ja Otsikko', 'IsDeleted',
                                    'IncidentTierQueuesValue', 'Tila', 'Kiireellisyys', 'Vaikutus', 'Tyyppi', 'Lähde'],
                      colModel: [{ name: 'I.Priority', index: 'I.Priority', width: 75, align: "center",hidden:true},
                                { name: 'I.ClosedDate', index: 'I.ClosedDate', width: 150, align: "center", hidden:true},
                                { name: 'I.InsertedBatchId', index: 'I.InsertedBatchId', width: 50, align: "center", hidden:true},
                                { name: 'incidentId', index: 'incidentId', width: 120, align: "center", hidden:true},
                                { name: 'I.Title', index: 'I.Title', width: 150, align: "center", hidden:true},
                                { name: 'I.Description', index: 'I.Description', width: 450, height: 500},
                                { name: 'I.CreatedDate', index: 'I.CreatedDate', width: 75, align: "center"},
                                { name: 'slahdeti_month', index: 'slahdeti_month', width: 150, hidden:true},
                                { name: 'slahdeti_day', index: 'slahdeti_day', width: 250, hidden:true},
                                { name: 'slahdeti_year', index: 'slahdeti_year', width: 100, hidden:true},
                                { name: 'I.FirstAssignedDate', index: 'I.FirstAssignedDate', width: 100, hidden:true},
                                { name: 'ticket_DisplayName', index: 'ticket_DisplayName', width: 100, align: "center"},
                                { name: 'I.IsDeleted', index: 'I.IsDeleted', width: 75, align: "center", hidden:true},
                                { name: 'itq.IncidentTierQueuesValue', index: 'itq.IncidentTierQueuesValue', width: 100, hidden:true},
                                { name: 'ISt.IncidentStatusValue', index: 'ISt.IncidentStatusValue', width: 50, align: "center"},
                                { name: 'IU.IncidentUrgencyValue', index: 'IU.IncidentUrgencyValue', width: 100, align: "center", hidden:true},
                                { name: 'II.IncidentImpactValue', index: 'II.IncidentImpactValue', width: 100, align: "center", hidden:true},
                                { name: 'IC.IncidentClassificationValue,', index: 'IC.IncidentClassificationValue,', width: 100, align: "center", hidden:true},
                                { name: 'ISo.IncidentSourceValue', index: 'ISo.IncidentSourceValue', width: 100, align: "center", hidden: true } ],

                      pager: '#pager', sortname: 'I.CreatedDate', sortorder: 'desc',
                      rowNum: 50,
                      rowTotal: 10000,
                      rowList: [],
                      pgbuttons: false,
                      pgtext: false,
                      gridview: true,
                      loadonce: true,
                      ignoreCase: true,
                      viewrecoreds: false,
                      imgpath: 'Content/images',
                      serializeGridData: function (data) {
                          return JSON.stringify(data);
                      },
                      gridComplete: function () {
                      highlightFilteredData.call(this);
                      }
                  });
                  jQuery($Grid1).jqGrid("navGrid", "#pager", {add: false, edit: false, del: false, search: false});
                  //Fill top bar
                  $('#t_' + $.jgrid.jqID($Grid1[0].id))
                 .append($("<div><label for=\"globalSearchText\">Etsi taulukosta:&nbsp;</label><input id=\"globalSearchText\" type=\"text\"></input>&nbsp;<button id=\"globalSearch\" type=\"button\">Search</button></div>"));
                  $("#globalSearchText").keypress(function (e) {
                      var key = e.charCode || e.keyCode || 0;
                      if (key === $.ui.keyCode.ENTER) { // 13
                          $("#globalSearch").click();
                      }
                  });
                //Reorder columns
                  $Grid1.remapColumns([11,4,14,0,1,2,6,7,8,9,10,13,3,12,5,15,16,17,18], true, false);
                //Search
                  $("#globalSearch").button({
                      icons: { primary: "ui-icon-search" },
                      text: false
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
                      $Grid1.trigger("reloadGrid", [{page: 1, current: true}]);
                      return false;
                  });
            });
    </script>

    <div id="gridcontainer">
        <table id="Grid1" class="scroll" align="center" width="100%"></table>
        <div id="pager" class="scroll" style="text-align:center;">
        </div>
    </div>    

</asp:Content>
