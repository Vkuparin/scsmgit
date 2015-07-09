<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Site.Master" CodeBehind="incident.aspx.cs" Inherits="show_incident.incident" %>


<asp:Content runat="server" ID="BodyContent" ContentPlaceHolderID="MainContent">
    <hgroup class="title">
        <h1><%: Title %> <asp:Label ID="parametri" runat="server"/></h1>
    </hgroup>

    <article>

        <p>
         <asp:Label ID="palautus" runat="server"/>
        </p>
        <p>
            <asp:GridView runat="server" AutoGenerateColumns="true" ShowHeader="False" ID="GridView1">
        <Columns>
        </Columns>
    </asp:GridView>
        </p>
    </article>
    
    <aside>
        <h3>APUAA</h3>
        <p>        
            Hjälp, Hjälp.
        </p>
    </aside>
</asp:Content>