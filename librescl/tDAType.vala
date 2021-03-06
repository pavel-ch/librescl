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
 *  Copyright (c) 2013, 2014 Daniel Espinosa
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
using Gee;
using GXml;
namespace Lscl
{
  public class tDAType : tIDNaming, SerializableMapKey<string>
  {
    [Description(blurb="Basic Data Attribute Types")]
    public tBDA.HashMap bdas { get; set; }
    [Description(nick="iedType", blurb="it is used to define the relation of a specific LN type to an IED type.")]
    public string ied_type { get; set; }
    // SerializableMapDualId
    public string get_map_key () { return id; }
    // Serializable
    public override void init_containers ()
    {
      if (bdas == null)
        bdas = new tBDA.HashMap ();
    }
    public class HashMap : Lscl.HashMap<string,tDAType> {}
  }
}

