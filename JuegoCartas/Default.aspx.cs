using System;
using System.Collections.Generic;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Memoria
{
    public partial class Default : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                int dificultad = Request.QueryString["dificultad"] != null ? int.Parse(Request.QueryString["dificultad"]) : 4;
                ViewState["Dificultad"] = dificultad;
                IniciarJuego(dificultad);
            }
        }

        private void IniciarJuego(int dificultad)
        {
            int totalCartas = dificultad * dificultad;
            List<int> valoresCartas = new List<int>();

            for (int i = 1; i <= totalCartas / 2; i++)
            {
                valoresCartas.Add(i);
                valoresCartas.Add(i);
            }

            valoresCartas.Sort((a, b) => Guid.NewGuid().CompareTo(Guid.NewGuid()));
            ViewState["Cartas"] = valoresCartas;
            ViewState["Vidas"] = 5;
            ViewState["Aciertos"] = new List<int>();

            RenderizarTablero(dificultad);
            RenderizarVidas();
        }

        private void RenderizarTablero(int dificultad)
        {
            List<int> cartas = (List<int>)ViewState["Cartas"];
            List<int> aciertos = (List<int>)ViewState["Aciertos"];
            tablero.Controls.Clear();

            string gridTemplate = $"repeat({dificultad}, 100px)";

            tablero.Controls.Add(new Literal
            {
                Text = $"<style>.tablero {{ display: grid; grid-template-columns: {gridTemplate}; gap: 10px; justify-content: center; }}</style>"
            });

            for (int i = 0; i < cartas.Count; i++)
            {
                string claseCarta = aciertos.Contains(i) ? "descubierta" : "carta";
                string contenidoCarta = aciertos.Contains(i) ? cartas[i].ToString() : "";

                Literal carta = new Literal
                {
                    Text = $"<div class='{claseCarta}' onclick='voltearCarta(this, {i})' data-numero='{cartas[i]}'>{contenidoCarta}</div>"
                };
                tablero.Controls.Add(carta);
            }
        }

        private void RenderizarVidas()
        {
            int vidas = (int)ViewState["Vidas"];
            string corazones = "";

            for (int i = 0; i < 5; i++)
            {
                corazones += (i < vidas) ? "❤️ " : "<span class='corazon' style='color: red;'>❌</span> ";
            }

            contadorVidas.Text = corazones;
        }

        protected void ReiniciarJuego_Click(object sender, EventArgs e)
        {
            int dificultad = (int)ViewState["Dificultad"];
            IniciarJuego(dificultad);
        }
    }
}
