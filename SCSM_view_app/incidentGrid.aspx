<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Site.Master" CodeBehind="incidentGrid.aspx.cs" Inherits="show_incident.incidentGrid" %>

<asp:Content runat="server" ID="BodyContent" ContentPlaceHolderID="MainContent">

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
