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
using GXml;
public class Lscl.tDataTypeTemplates : Serializable
{
    [Description(blurb="Logical Node Types templates")]
    public tLNodeType.HashMap logical_node_types { get; set; }
    [Description(blurb="Data Object Types templates")]
    public tDOType.HashMap data_object_types { get; set; }
    [Description(blurb="Data Attributes Types templates")]
    public tDAType.HashMap data_attribute_types { get; set; }
    [Description(nick="EnumType",blurb="Data Attributes Types templates")]
    public tEnumType.HashMap enum_types { get; set; }
    // Serializable
    public override void init_containers ()
    {
      if (data_object_types == null)
        data_object_types = new tDOType.HashMap ();
      if (logical_node_types == null)
        logical_node_types = new tLNodeType.HashMap ();
      if (data_attribute_types == null)
        data_attribute_types = new tDAType.HashMap ();
      if (enum_types == null)
        enum_types = new tEnumType.HashMap ();
    }
}
