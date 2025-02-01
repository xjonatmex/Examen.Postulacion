<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="Memoria.Default" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Juego de Memoria</title>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <link rel="stylesheet" href="Content/styles.css">
    <link rel="stylesheet" href="Content/bootstrap.min.css"> <!-- Cargar Bootstrap desde tu proyecto -->
</head>
<body>
    <form id="form1" runat="server">
        <div class="container mt-4">
            
            <!-- Fila del Título -->
            <div class="row text-center">
                <div class="col-12">
                    <h1 class="text-black">Juego de Memoria</h1>
                </div>
            </div>

            <!-- Fila de Vidas -->
            <div class="row text-center">
                <div class="col-12">
                    <div class="vidas">
                        <asp:Literal ID="contadorVidas" runat="server"></asp:Literal>
                    </div>
                </div>
            </div>

            <!-- Fila principal con 3 columnas -->
            <div class="row justify-content-center mt-3">
                <!-- Primera columna (4 espacios vacíos) -->
                <div class="col-lg-4"></div>

                <!-- Segunda columna (Tablero de Juego) -->
                <div class="col-lg-4 text-center">
                    <asp:Panel ID="tablero" runat="server" CssClass="tablero"></asp:Panel>

                    <!-- Botón de Reinicio -->
                    <div class="mt-3">
                        <asp:Button ID="btnReiniciar" runat="server" Text="REINICIAR" OnClick="ReiniciarJuego_Click" CssClass="btn btn-primary btn-lg" />
                    </div>
                </div>

                <!-- Tercera columna (Indicaciones) -->
                <div class="col-lg-4">
                    <div class="indicaciones p-3">
                        <h2 class="text-center">INDICACIONES</h2>
                        <p>Encuentra todas las parejas de cartas antes de quedarte sin vidas.</p>
                        <p>Cada vez que falles, perderás una vida. Al perder todas, el juego reiniciará.</p>
                        <p>¡Buena suerte!</p>
                        <img id="imagenIndicaciones" src="Images/rostronormal.png" alt="Indicaciones" onclick="cambiarImagen()" class="img-fluid">
                    </div>
                </div>
            </div>
        </div>
    </form>

    <script>
        let primeraCarta = null;
        let segundaCarta = null;
        let bloqueo = false;
        let vidas = 5;

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
            for (let i = 0; i < 5; i++) {
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
                        document.getElementById("btnReiniciar").click();
                    }
                });
            }
        }

        function cambiarImagen() {
            let imagen = document.getElementById("imagenIndicaciones");
            if (imagen.src.includes("Images/rostroalegre.png")) {
                imagen.src = "Images/rostronormal.png";
            } else {
                imagen.src = "Images/rostroalegre.png";
            }
        }
    </script>

</body>
</html>

