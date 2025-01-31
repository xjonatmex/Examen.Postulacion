using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace JuegoCartas.Modelo
{
    public class Carta
    {
        public int ID { get; set; }
        public string Imagen { get; set; }
        public bool Descubierta { get; set; }
        public bool Emparejada { get; set; }
    }

}