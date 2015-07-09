<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Site.Master" CodeBehind="indicentGrid.aspx.cs" Inherits="show_inident.indicentGrid" %>



<asp:Content runat="server" ID="BodyContent" ContentPlaceHolderID="MainContent">
    <hgroup class="title">
        <h1><%: Title %> <asp:Label ID="parametri" runat="server"/></h1>
    </hgroup>

    <article>

        <p>

        </p>
        <p>
            <asp:GridView runat="server" AutoGenerateColumns="true" ID="GridView1">
        <Columns>
        </Columns>
    </asp:GridView>
        </p>
    </article>
    
    <aside>
        <h3>APUAA</h3>
        <p>        
            Hjälp, Hjsdad393
        </p>
    </aside>
</asp:Content>