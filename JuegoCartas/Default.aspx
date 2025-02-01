<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="Memoria.Default" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Juego de Memoria</title>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
        body { text-align: center; font-family: Arial, sans-serif; }
        .tablero { display: grid; grid-template-columns: repeat(4, 100px); gap: 10px; justify-content: center; }
        .carta { 
            width: 100px; 
            height: 100px; 
            background-color: gray; 
            display: flex; 
            align-items: center; 
            justify-content: center; 
            font-size: 24px; 
            cursor: pointer; 
            color: transparent; /* Oculta el número al inicio */
            border: 1px solid black;
        }
        .descubierta { 
            background-color: white; 
            color: black !important; /* Asegura que los números sean visibles */
            border: 2px solid black;
        }
        .vidas { margin: 20px; }
        .corazon { font-size: 24px; color: red; margin: 5px; }
        .gris { color: gray; }
        .btn-reiniciar {
            margin-top: 20px;
            padding: 10px 20px;
            font-size: 16px;
            cursor: pointer;
        }
    </style>
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
