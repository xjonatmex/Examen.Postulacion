using System;
using System.Collections.Generic;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Memoria
{
    public partial class Default : Page
    {
        private static readonly int[] valoresCartas = { 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8};

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                IniciarJuego();
            }
        }

        private void IniciarJuego()
        {
            List<int> cartasMezcladas = new List<int>(valoresCartas);
            cartasMezcladas.Sort((a, b) => Guid.NewGuid().CompareTo(Guid.NewGuid()));
            ViewState["Cartas"] = cartasMezcladas;
            ViewState["Vidas"] = 5;
            ViewState["Aciertos"] = new List<int>(); // Guarda los aciertos

            RenderizarTablero();
            RenderizarVidas();
        }

        private void RenderizarTablero()
        {
            List<int> cartas = (List<int>)ViewState["Cartas"];
            List<int> aciertos = (List<int>)ViewState["Aciertos"];
            tablero.Controls.Clear();

            for (int i = 0; i < cartas.Count; i++)
            {
                string claseCarta = aciertos.Contains(i) ? "descubierta" : "carta";
                string contenidoCarta = aciertos.Contains(i) ? cartas[i].ToString() : cartas[i].ToString();

                Literal carta = new Literal
                {
                    Text = $"<div class='{claseCarta}' onclick='voltearCarta(this, {i})'>{contenidoCarta}</div>"
                };
                tablero.Controls.Add(carta);
            }
        }

        private void RenderizarVidas()
{
    int vidas = ViewState["Vidas"] != null ? (int)ViewState["Vidas"] : 5;
    string corazones = "";

    for (int i = 0; i < 5; i++)
    {
        if (i < vidas)
        {
            corazones += "❤️ ";
        }
        else
        {
            corazones += "<span class='corazon' style='color: red;'>❌</span> ";
        }
    }

    contadorVidas.Text = corazones;
}


        protected void ReiniciarJuego_Click(object sender, EventArgs e)
        {
            IniciarJuego();
        }
    }
}
