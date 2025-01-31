<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="JuegoCartas.Default" %>

<!DOCTYPE html>
<html lang="es">
<head runat="server">
    <meta charset="utf-8" />
    <title>Juego de Memoria</title>
    <link rel="stylesheet" type="text/css" href="Content/styles.css" />
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
    <form id="form1" runat="server">
        <h1>Juego de Memoria</h1>
        
        <div class="contenedor-juego">
            <asp:Repeater ID="rptCartas" runat="server">
                <HeaderTemplate>
                    <table class="juego-grid">
                        <tr>
                </HeaderTemplate>

                <ItemTemplate>
                    <td>
                        <asp:ImageButton ID="imgCarta" runat="server"
                            ImageUrl='<%# Eval("Descubierta").ToString() == "True" || Eval("Emparejada").ToString() == "True" ? "~/Images/" + Eval("Imagen") : "~/Images/cartabase.PNG" %>'
                            OnClick="VoltearCarta"
                            CommandArgument='<%# Eval("ID") %>'
                            CssClass="carta"/>
                    </td>
                    <%# (Container.ItemIndex + 1) % 4 == 0 ? "</tr><tr>" : "" %>
                </ItemTemplate>

                <FooterTemplate>
                        </tr>
                    </table>
                </FooterTemplate>
            </asp:Repeater>
        </div>

        <asp:Button ID="btnReiniciar" runat="server" Text="Reiniciar Juego"
            OnClick="ReiniciarJuego" CssClass="boton-reiniciar"/>
    </form>
</body>
</html>
