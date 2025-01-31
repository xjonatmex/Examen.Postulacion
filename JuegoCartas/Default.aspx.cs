using JuegoCartas.Modelo;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace JuegoCartas
{
    public partial class Default : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                IniciarJuego();
            }
        }

        private void IniciarJuego()
        {
            List<Carta> cartas = GenerarCartas();
            Session["Cartas"] = cartas;
            Session["PrimeraCarta"] = null;
            Session["SegundaCarta"] = null;
            Session["Bloqueo"] = false;

            rptCartas.DataSource = cartas;
            rptCartas.DataBind();
        }

        private List<Carta> GenerarCartas()
        {
            List<string> imagenes = new List<string> { "carta1.PNG", "carta2.PNG", "carta3.PNG", "carta4.PNG" };
            imagenes.AddRange(imagenes); 
            imagenes = imagenes.OrderBy(a => Guid.NewGuid()).ToList(); // Barajar

            List<Carta> cartas = new List<Carta>();
            for (int i = 0; i < imagenes.Count; i++)
            {
                cartas.Add(new Carta { ID = i, Imagen = imagenes[i], Descubierta = false });
            }
            return cartas;
        }

        protected void VoltearCarta(object sender, ImageClickEventArgs e)
        {
            if ((bool)Session["Bloqueo"]) return; // Bloquear clics mientras se comparan cartas

            ImageButton clickedButton = (ImageButton)sender;
            int idCarta = Convert.ToInt32(clickedButton.CommandArgument);
            List<Carta> cartas = (List<Carta>)Session["Cartas"];

            Carta cartaSeleccionada = cartas.FirstOrDefault(c => c.ID == idCarta);
            if (cartaSeleccionada == null || cartaSeleccionada.Descubierta || cartaSeleccionada.Emparejada) return;

            cartaSeleccionada.Descubierta = true;

            if (Session["PrimeraCarta"] == null)
            {
                Session["PrimeraCarta"] = cartaSeleccionada;
            }
            else if (Session["SegundaCarta"] == null)
            {
                Session["SegundaCarta"] = cartaSeleccionada;
                Session["Bloqueo"] = true; // Evitar más clics mientras se comparan cartas

                // Comparar cartas después de 1 segundo
                System.Threading.Timer timer = new System.Threading.Timer((state) =>
                {
                    ComprobarCartas();
                }, null, 1000, System.Threading.Timeout.Infinite);
            }

            Session["Cartas"] = cartas;
            rptCartas.DataSource = cartas;
            rptCartas.DataBind();
        }

        private void ComprobarCartas()
        {
            List<Carta> cartas = (List<Carta>)Session["Cartas"];
            Carta primera = (Carta)Session["PrimeraCarta"];
            Carta segunda = (Carta)Session["SegundaCarta"];

            if (primera != null && segunda != null)
            {
                if (primera.Imagen == segunda.Imagen)
                {
                    primera.Emparejada = true;
                    segunda.Emparejada = true;
                }
                else
                {
                    primera.Descubierta = false;
                    segunda.Descubierta = false;
                }
            }

            // Resetear selección
            Session["PrimeraCarta"] = null;
            Session["SegundaCarta"] = null;
            Session["Bloqueo"] = false;

            Session["Cartas"] = cartas;
            rptCartas.DataSource = cartas;
            rptCartas.DataBind();
        }

        protected void ReiniciarJuego(object sender, EventArgs e)
        {
            IniciarJuego();
        }
    }
}