<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Site.Master" CodeBehind="incidentGrid.aspx.cs" Inherits="show_incident.incidentGrid" %>

<asp:Content runat="server" ID="BodyContent" ContentPlaceHolderID="MainContent">
    <script type="text/javascript">
              $(document).ready(function () {
                  $.extend($.jgrid.defaults,
                      { datatype: 'json' },
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
                  jQuery("#Grid1").jqGrid({
                      url: 'incidentGrid.aspx/GetDataTable', //Osuukohan tämä oikeaan. funktio GetDataTable tiedostossa incidentGrid.aspx.cs
                      datatype: 'json',
                      mtype: 'POST',
                      colNames: ['Title', 'Id', 'ClosedDate', 'CreatedDate', 'Id1', 'WorkItemDimKey', 'WorkItemDimKey1', 'WorkItemAffectedUser_UserDimKey', 'UserName', 'UserDimKey'],
                      colModel: [{ name: 'IncidentDim.Title', index: 'IncidentDim.Title', width: 250 },
                       { name: 'Id', index: 'Id', width: 100 },
                      { name: 'ClosedDate', index: 'ClosedDate', width: 150 },
                      { name: 'CreatedDate', index: 'CreatedDate', width: 150 },
                      { name: 'Id1', index: 'Id1', width: 150 },
                      { name: 'WorkItemDimKey', index: 'WorkItemDimKey', width: 150 },
                      { name: 'WorkItemDimKey1', index: 'WorkItemDimKey1', width: 150 },
                      { name: 'WorkItemAffectedUser_UserDimKey', index: 'WorkItemAffectedUser_UserDimKey', width: 250 },
                      { name: 'UserName', index: 'UserName', width: 100 },
                      { name: 'UserDimKey', index: 'UserDimKey', width: 100 }, ],
                      pager: '#pager', sortname: 'CreatedDate',
                      viewrecoreds: true,
                      imgpath: 'Content/images',
                      serializeGridData: function (data) {
                          return JSON.stringify(data);
                      }


                  });
              });
    </script>
    <hgroup class="title">
        <h1> Title  <asp:Label ID="parametri" runat="server"/></h1>
    </hgroup>

    <table id="Grid1" class="scroll" align="center" width="100%"></table>
    <div id="pager" class="scroll" style="text-align:center;">
    </div>
        
    <aside>
        <h3>APUAA</h3>
        <p>        
            Hjälp, Hjsdad393
        </p>
    </aside>
</asp:Content>
