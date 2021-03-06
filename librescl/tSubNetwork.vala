/**
 *
 *  LibreSCL
 *
 *  Authors:
 *
 *       Daniel Espinosa <esodan@gmail.com>
 *       PowerMedia Consulting <pwmediaconsulting@gmail.com>
 *
 *
 *  Copyright (c) 2013 Daniel Espinosa
 *  Copyright (c) 2014 PowerMedia Consulting
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU Lesser General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU Lesser General Public License for more details.
 *
 *  You should have received a copy of the GNU Lesser General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
using GXml;

namespace Lscl
{
  public class tSubNetwork : tNaming, GXml.SerializableMapKey<string>
  {
    [Description(nick="BitRate", blurb="Defining the bit rate in Mbit/s")]
    public tBitRate bit_rate  { get; set; }
    [Description(blurb="Defining the bit rate in Mbit/s")]
    public tConnectedAP.DualKeyMap connected_aps { get; set; }
    [Description(nick="type", blurb="The SubNetwork protocol type")]
    public string network_type { get; set; }
    // SerializableMapId
    public string get_map_key () { return name; }
    // Serializable
    public override GXml.Node? deserialize (GXml.Node node)
                                    throws GLib.Error
                                    requires (node is Element)
    {
      var element = (Element) node;
      if (element.childs.size > 0) {
        if (connected_aps == null)
          connected_aps = new tConnectedAP.DualKeyMap ();
        connected_aps.deserialize (element);
      }
      return default_deserialize (node);
    }
    public class HashMap : GXml.SerializableHashMap<string,tSubNetwork> {}
    public class tBitRate : tBitRateInMbPerSec
    {
      public override string node_name () { return "BitRate"; }
    }
  }
}
