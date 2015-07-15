﻿<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Site.Master" %>

<asp:Content runat="server" ID="BodyContent" ContentPlaceHolderID="MainContent">

    <hgroup class="title">
        <h1>Luo työpyyntö <%: Title %> <asp:Label ID="parametri" runat="server"/></h1>
    </hgroup>


	<script type="text/javascript">
	    $(function () {
	        $("form").form();
	    });
	</script>
	<div id="container">
		<h1>Uuden työpyynnön lähetys</h1>
		<form action="" method="post" id="customtheme">
            <p>
				<label for="gender">Toimiala/yksikkö</label>
				<select name="gender" id="gender">
					<option value="">--select--</option>
					<option value="male">male</option>
					<option value="female">female</option>
				</select>
            </p>

            <p>
				<label for="gender">Työpyynnön tyyppi</label>
				<select name="gender" id="gender">
					<option value="">--select--</option>
					<option value="male">male</option>
					<option value="female">female</option>
				</select>
            </p>

			<p>
				<label for="username">Otsikko</label>
				<input type="text" name="username" id="username" />
			</p>
			
			<p>
				<label for="password">Tietokoneen nimi</label>
				<input type="text" name="password" id="password" />
			</p>

			<p>
				<label for="email">Kenttä1</label>
				<input type="text" name="email" id="email" />
			</p>
			
			<p>
				<label for="date">Kenttä2</label>
				<input type="text" class="date" id="date" name="date" />
			</p>
			
			<p>
				<label for="active">Radio1</label>
				<input type="radio" name="active" title="Active"/>Active
				<input type="radio" name="active" title="InActive"/>InActive
			</p>
			
			<p>
				<label for="description" style="vertical-align: top;">Kuvaus</label>
				<textarea name="description" id="description" cols="30" rows="10"></textarea>
			</p>
			
			<p>
				<input type="button" name="submit" value="Yhteenveto & vahvistus" id="submitbutton" onClick="alert('Ohjaa Yhteenveto-ja vahvistusikkunaan.');"/>
			</p>
		</form>
	</div>
</asp:Content>
