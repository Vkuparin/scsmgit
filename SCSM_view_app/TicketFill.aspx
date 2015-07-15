<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Site.Master" %>

<asp:Content runat="server" ID="BodyContent" ContentPlaceHolderID="MainContent">

    <link rel="stylesheet" type="text/css" media="screen" href="Content/jquery-form-theme.css" />

    <hgroup class="title">
        <h1>Työpyyntö: <%: Title %> <asp:Label ID="parametri" runat="server"/></h1>
    </hgroup>


	<script type="text/javascript">
	    $(function () {
	        $("form").form();
	    });
	</script>
	<div id="container">
		<h1>Create form using jQuery UI</h1>
		<form action="" method="post" id="customtheme">
			<p>
				<label for="username">Username</label>
				<input type="text" name="username" id="username" />
			</p>
			
			<p>
				<label for="password">Password</label>
				<input type="text" name="password" id="password" />
			</p>

			<p>
				<label for="email">Email</label>
				<input type="text" name="email" id="email" />
			</p>
			
			<p>
				<label for="gender">Gender</label>
				<select name="gender" id="gender">
					<option value="">--select--</option>
					<option value="male">male</option>
					<option value="female">female</option>
				</select>
                			</p>

			<p>
				<label for="date">Birth Date</label>
				<input type="text" class="date" id="date" name="date" />
			</p>
			
			<p>
				<label for="active">Active</label>
				<input type="radio" name="active" title="Active"/>Active
				<input type="radio" name="active" title="InActive"/>InActive
			</p>
			
			<p>
				<label for="description" style="vertical-align: top;">Description</label>
				<textarea name="description" id="description" cols="30" rows="10"></textarea>
			</p>
			
			<p>
				<input type="button" name="submit" value="Submit" id="submitbutton" onClick="alert('Submitted.');"/>
			</p>
		</form>
	</div>
    <aside>
        <h3>APUAA</h3>
        <p>        
            Hjälp, Hjsdad393
        </p>
    </aside>
</asp:Content>
