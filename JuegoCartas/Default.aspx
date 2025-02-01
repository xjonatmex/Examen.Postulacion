<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="Memoria.Default" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Juego de Memoria</title>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
     <link rel="stylesheet" href="Content/styles.css"> 
</head>
<body>
    <form id="form1" runat="server">
        <h1>Juego de Memoria</h1>

        <!-- Contador de Vidas -->
        <div class="vidas">
            <asp:Literal ID="contadorVidas" runat="server"></asp:Literal>
        </div>

        <!-- Tablero del Juego -->
        <asp:Panel ID="tablero" runat="server" CssClass="tablero"></asp:Panel>

        <!-- Botón de Reinicio -->
<asp:Button ID="btnReiniciar" runat="server" Text="REINICIAR" OnClick="ReiniciarJuego_Click" CssClass="btn-reiniciar" />

    </form>

    <script>
        let primeraCarta = null;
        let segundaCarta = null;
        let bloqueo = false;
        let vidas = 3;

        function voltearCarta(elemento, indice) {
            if (bloqueo) return;
            if (elemento.classList.contains("descubierta")) return;

            elemento.classList.add("descubierta");
            elemento.style.color = "black"; // Muestra el número

            if (!primeraCarta) {
                primeraCarta = { elemento, indice };
            } else {
                segundaCarta = { elemento, indice };
                bloqueo = true;

                setTimeout(() => {
                    if (primeraCarta.elemento.innerText === segundaCarta.elemento.innerText) {
                        // Se mantienen descubiertas
                        primeraCarta = null;
                        segundaCarta = null;
                    } else {
                        // Se ocultan nuevamente
                        primeraCarta.elemento.classList.remove("descubierta");
                        segundaCarta.elemento.classList.remove("descubierta");
                        primeraCarta.elemento.style.color = "transparent";
                        segundaCarta.elemento.style.color = "transparent";

                        // Reducir vida
                        reducirVidas();
                    }
                    bloqueo = false;
                    primeraCarta = null;
                    segundaCarta = null;
                }, 1000);
            }
        }

        function reducirVidas() {
            vidas--;

            let corazones = "";
            for (let i = 0; i < 3; i++) {
                if (i < vidas) {
                    corazones += "❤️ ";
                } else {
                    corazones += "<span class='corazon' style='color: red;'>❌</span> ";
                }
            }
            document.querySelector(".vidas").innerHTML = corazones;

            if (vidas === 0) {
                Swal.fire({
                    title: "¡Perdiste!",
                    text: "Se acabaron tus vidas, volverás a empezar.",
                    icon: "error",
                    confirmButtonText: "Aceptar"
                }).then((result) => {
                    if (result.isConfirmed) {
                        document.getElementById("btnReiniciar").click(); // Simula el clic en el botón REINICIAR
                    }
                });
            }
        }

        
    </script>

</body>
</html>
