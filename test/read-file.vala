/* -*- Mode: vala; indent-tabs-mode: nil; c-basic-offset: 2; tab-width: 2 -*-  */
/* librescl
 *
 * Copyright (C) 2013. 2014 Daniel Espinosa <esodan@gmail.com>
 *
 * librescl is free software: you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the
 * Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * librescl is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 * See the GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License along
 * with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
using Lscl;
using GXml;

public class LsclTest.ReadFile
{
  public static void add_funcs ()
  {
    Test.add_func ("/librescl-test-suite/read/set-file", 
    () => {
      try {
        string path = LsclTest.TEST_DIR + "/tests-files/scl.cid";
        var f = File.new_for_path (path);
        assert (f.query_exists ());
        var scl = new SclDocument ();
        scl.set_file (f);
        assert (scl.get_file () != null);
        assert (scl.get_file ().query_exists ());
        assert (scl.read ());
      }
      catch (GLib.Error e)
      {
        stdout.printf (@"ERROR: $(e.message)");
        assert_not_reached ();
      }
    });
    Test.add_func ("/librescl-test-suite/read/set-path", 
    () => {
      try {
        string path = LsclTest.TEST_DIR + "/tests-files/scl.cid";
        var scl = new SclDocument ();
        scl.set_file_path (path);
        assert (scl.get_file () != null);
        assert (scl.get_file ().query_exists ());
        assert (scl.read ());
      }
      catch (GLib.Error e)
      {
        stdout.printf (@"ERROR: $(e.message)");
        assert_not_reached ();
      }
    });
    Test.add_func ("/librescl-test-suite/read/from-file", 
    () => {
      try {
        string path = LsclTest.TEST_DIR + "/tests-files/scl.cid";
        var  f = File.new_for_path (path);
        var scl = new SclDocument ();
        assert (scl.read_from_file (f));
        assert (scl.get_file () != null);
        assert (scl.get_file ().query_exists ());
      }
      catch (GLib.Error e)
      {
        stdout.printf (@"ERROR: $(e.message)");
        assert_not_reached ();
      }
    });
    Test.add_func ("/librescl-test-suite/read/from-path", 
    () => {
      try {
        string path = LsclTest.TEST_DIR + "/tests-files/scl.cid";
        var scl = new SclDocument ();
        assert (scl.read_from_path (path));
      }
      catch (GLib.Error e)
      {
        stdout.printf (@"ERROR: $(e.message)");
        assert_not_reached ();
      }
    });
    Test.add_func ("/librescl-test-suite/read-string", 
    () => {
      try {
        string str = "<SCL><Header></Header></SCL>";
        var scl = new SclDocument ();
        scl.read_from_string (str);
        assert (scl.header != null);
      }
      catch (GLib.Error e)
      {
        stdout.printf (@"ERROR: $(e.message)");
        assert_not_reached ();
      }
    });
    Test.add_func ("/librescl-test-suite/read-scl", 
    () => {
      try {
        var doc = new GXml.xDocument.from_path (LsclTest.TEST_DIR + "/tests-files/scl.cid");
        var scl = new Scl ();
        scl.deserialize (doc);
      }
      catch (GLib.Error e)
      {
        stdout.printf (@"ERROR: $(e.message)");
        assert_not_reached ();
      }
    });
    Test.add_func ("/librescl-test-suite/read-header", 
    () => {
      try {
        var scl = new SclDocument ();
        scl.read_from_path (LsclTest.TEST_DIR + "/tests-files/header.cid");
        assert (scl.get_file () != null);
        assert (scl.get_file ().query_exists ());
        assert (scl.header != null);
        assert (scl.header.id == "SCL File");
        assert (scl.header.version == "0");
        assert (scl.header.revision == "1");
        assert (scl.header.tool_id == "LibreSclEditor");
        assert (scl.header.name_structure == tHeader.NameStructure.IED_NAME);
        var history = scl.header.history;
        assert (history != null);
        assert (history.size == 2);
        bool found1 = false;
        bool found2 = false;
        string hitems = "";
        foreach (tHitem hitem in history) {
          if (hitem.version=="0"
              && hitem.revision=="1"
              && hitem.when=="14/11/2013 10:56:00" 
              && hitem.who=="esodan"
              && hitem.what=="Added fake history item") found1 = true;
          if (hitem.version=="0"
              && hitem.revision=="1"
              && hitem.when=="14/11/2013 10:59:00" 
              && hitem.who=="esodan"
              && hitem.what=="Added new fake history item") found2 = true;
          hitems += @"$(hitem)\n";
        }
        assert (found1);
        assert (found2);
        assert (scl.communication == null);
      }
      catch (GLib.Error e)
      {
#if DEBUG
        GLib.message (@"ERROR: $(e.message)");
#endif
        assert_not_reached ();
      }
    });
    Test.add_func ("/librescl-test-suite/read-communication", 
    () => {
      try {
        var f = File.new_for_path (LsclTest.TEST_DIR + "/tests-files/communication.cid");
        var scl = new SclDocument ();
        scl.read_from_file (f);
        assert (scl.get_file () != null);
        assert (scl.get_file ().query_exists ());
        assert (scl.communication != null);
        assert (scl.communication.subnetworks != null);
        assert (scl.communication.subnetworks.size == 1);
        tSubNetwork subnetwork = (tSubNetwork) scl.communication.subnetworks.@get ("Net1");
        assert (subnetwork != null);
        assert (subnetwork.desc == "Network1");
        assert (subnetwork.connected_aps != null);
        tConnectedAP cap = subnetwork.connected_aps.@get ("IED1", "AccessPoint1");
        assert (cap != null);
        assert (cap.address != null);
        assert (cap.address.ps != null);
        assert (cap.address.ps.size == 6);
        bool foundip = false;
        bool foundsubnet = false;
        bool foundts = false;
        bool foundps = false;
        bool foundss = false;
        foreach (tP p in cap.address.ps) {
          if (p.get_enum () == tP.TypeEnum.IP) {
            if (p.get_value () == "19A.168.1.1")
              foundip = true;
          }
          if (p.get_enum () == tP.TypeEnum.IP_SUBNET) {
            if (p.get_value () == "255.255.255.0")
              foundsubnet = true;
          }
          if (p.get_enum () == tP.TypeEnum.OSI_TSEL)
            foundts = true;
          if (p.get_enum () == tP.TypeEnum.OSI_PSEL)
            foundps = true;
          if (p.get_enum () == tP.TypeEnum.OSI_SSEL)
            foundss = true;
        }
        assert (foundip);
        assert (foundsubnet);
        assert (foundts);
        assert (foundps);
        assert (foundss);
        // GSE tests
        assert (cap.gses != null);
        assert (cap.gses.size == 1);
        var gse1 = cap.gses.@get ("LDevice1","gcb");
        assert (gse1 != null);
        assert (gse1.ld_inst == "LDevice1");
        assert (gse1.cb_name == "gcb");
        assert (gse1.address != null);
        assert (gse1.address.ps != null);
        bool foundmac, foundvlanid, foundvlanp, foundappid;
        foundmac= foundvlanid= foundvlanp= foundappid = false;
         foreach (tP gsep in gse1.address.ps) {
           if (gsep.get_enum () == tP.TypeEnum.VLAN_ID) {
             if (gsep.get_value () == "000")
               foundvlanid = true;
           }
           if (gsep.get_enum () == tP.TypeEnum.VLAN_PRIORITY) {
             if (gsep.get_value () == "4")
               foundvlanp = true;
           }
            if (gsep.get_enum () == tP.TypeEnum.MAC_ADDRESS) {
              if (gsep.get_value () == "01-0C-CD-01-00-04")
                foundmac = true;
            }
           if (gsep.get_enum () == tP.TypeEnum.APPID) {
             if (gsep.get_value () == "0001")
               foundappid = true;
           }
         }
        assert(foundappid);
        assert(foundvlanid);
        assert(foundvlanp);
        assert(foundmac);
        // SMV tests
        assert (cap.smvs != null);
        assert (cap.smvs.size == 1);
        var sv1 = cap.smvs.@get ("LDevice1","svcb");
        assert (sv1 != null);
        assert (sv1.ld_inst == "LDevice1");
        assert (sv1.cb_name == "svcb");
        assert (sv1.address != null);
        assert (sv1.address.ps != null);
         foreach (tP svp in sv1.address.ps) {
           if (svp.get_enum () == tP.TypeEnum.VLAN_ID)
             assert (svp.get_value () == "001");
           if (svp.get_enum () == tP.TypeEnum.VLAN_PRIORITY)
             assert (svp.get_value () == "1");
            if (svp.get_enum () == tP.TypeEnum.MAC_ADDRESS)
            assert (svp.get_value () == "01-0C-CD-01-00-03");
           if (svp.get_enum () == tP.TypeEnum.APPID)
            assert (svp.get_value () == "0002");
         }
      }
      catch (GLib.Error e)
      {
        stdout.printf (@"ERROR: $(e.message)");
        assert_not_reached ();
      }
    });
    Test.add_func ("/librescl-test-suite/read-data-type-template", 
    () => {
      try {
        var doc = new GXml.xDocument.from_path (LsclTest.TEST_DIR + "/tests-files/data-type-template.cid");
        var scl = new Scl ();
        scl.deserialize (doc);
        if (scl.data_type_templates == null) {
          stdout.printf ("ERROR: no data type templates found\n");
          assert_not_reached ();
        }
        var dt = scl.data_type_templates;
        if (dt.logical_node_types == null) {
          stdout.printf ("ERROR: no logical nodes type templates found\n");
          assert_not_reached ();
        }
        // Logical Node Types
        var lnts = dt.logical_node_types;
        if (lnts.size != 7) {
          stdout.printf (@"ERROR: wrong logical nodes type templates number. Expected: 7 Got: $(lnts.size)\n");
          assert_not_reached ();
        }
        // Data Object Types
        if (dt.data_object_types == null) {
          stdout.printf (@"ERROR: no Data Object Types found\n");
          assert_not_reached ();
        }
        var dots = dt.data_object_types;
        if (dots.size != 44) {
          stdout.printf (@"ERROR: wrong data object type templates number. Expected: 44 Got: $(dots.size)\n");
          assert_not_reached ();
        }
        int k = 0;
        foreach (tDOType t1 in dots.values) {
          if (t1.ied_type == null)
            k++;
        }
        if (k != 33) {
          stdout.printf (@"ERROR: Counting Data Objects Types with IED type=NULL fail. Expected: 33 Got: $(k)\n");
          assert_not_reached ();
        }
        k=0;
        foreach (tDOType t1 in dots.values) {
          if (t1.ied_type == "")
            k++;
        }
        if (k != 11) {
          stdout.printf (@"ERROR: Counting Data Objects Types with IED type='' fail. Expected: 11 Got: $(k)\n");
          assert_not_reached ();
        }
        string[] ied_types2 = {"","","",null,null,
                               null,null,null,null};
        string[] ids2 = {"LLN01Mod","LPHD1PhyHealth","LPHD1NamPlt","XCBR5Loc","CSWI7NamPlt",
                        "RREC13Op","XCBR5OpCnt","CILO9EnaCls","RREC13NamPlt"};
        string[] cdcs = {"INC","INS","LPL","SPS","LPL",
                         "ACT","INS","SPS","LPL"};

        for (int j = 0; j < ied_types2.length; j++) {
          string ied = "NULL";
          string cdc = "NULL";
          if (cdcs[j] != null)
              cdc = cdcs[j];
          if (ied_types2[j] != null)
            ied = ied_types2[j];
          var dot = dots.get (ids2[j]);
          if (dot == null) {
            stdout.printf (@"ERROR: Logical Node Type: $(ied)/$(ids2[j])/$(cdc) not found\n");
            k = 0;
            foreach (tDOType t1 in dots.values) {
              string t1cdc = "NULL";
              string t1ied = "NULL";
              string t1id = "NULL";
              if (t1.cdc != null)
                t1cdc = t1.cdc;
              if (t1.ied_type != null)
                t1ied = t1.ied_type;
              if (t1.id != null)
                t1id = t1.id;
              k++;
              stdout.printf (@"LNT $(k): $(t1ied)/$(t1id)/$(t1cdc)\n");
            }
            assert_not_reached ();
          }
          if (dot.cdc != cdcs[j]) {
            string gcdc = "NULL";
            if (dot.cdc != null)
              gcdc = dot.cdc;
            stdout.printf (@"ERROR: Data Object Type: $(ied)/$(ids2[j])/$(cdc) CDC no match hope: $(gcdc) - got: $(cdc)\n");
            assert_not_reached ();
          }
          if (dot.ied_type != ied_types2[j]) {
            string doied = "NULL";
            if (dot.ied_type != null)
              doied = dot.ied_type;
            stdout.printf (@"ERROR: Data Object Type: $(ied)/$(ids2[j])/$(cdc) IED TYPE no match hope: $(ied) - got: $(doied)\n");
            assert_not_reached ();
          }
        }
        // Data Attribute Types
        if (dt.data_attribute_types == null) {
          stdout.printf (@"ERROR: no Data Attribute Types found\n");
          assert_not_reached ();
        }
        var dats = dt.data_attribute_types;
        if (dats.size != 12) {
          stdout.printf (@"ERROR: wrong data attribute type templates number. Expected: 13 Got: $(dats.size)\n");
          assert_not_reached ();
        }
        string[] ied_types3 = {"","",null,null,
                              null,null,null,null,
                               null,null,null,null};
        string[] ids3 = {"LLN01ModctlModel","LPHD1ModctlModel","XCBR5PosctlModel","XCBR5BlkOpnctlModel",
                        "XCBR5BlkClsctlModel","CSWI7PosctlModel","XCBR5ModctlModel","CSWI7ModctlModel",
                        "CILO9ModctlModel","PTOC11ModctlModel","RREC13ModctlModel","RRECRecModStruct"};
        for (int j = 0; j < ied_types3.length; j++) {
          var dat = dats.get (ids3[j]);
          if (dat == null) {
            string ied = "NULL";
            if (ied_types3[j] != null)
              ied = ied_types3[j];
            stdout.printf (@"ERROR: Data Attribute Type $(ied)/$(ids3[j]) not found\n");
            assert_not_reached ();
          }
        }
      }
      catch (GLib.Error e)
      {
        stdout.printf (@"ERROR: $(e.message)");
        assert_not_reached ();
      }
    });
    Test.add_func ("/librescl-test-suite/read-data-type-template/logical-node-types", 
    () => {
      try {
        var doc = new GXml.xDocument.from_path (LsclTest.TEST_DIR + "/tests-files/data-type-template.cid");
        var scl = new Scl ();
        scl.deserialize (doc);
        if (scl.data_type_templates == null) {
          stdout.printf ("ERROR: no data type templates found\n");
          assert_not_reached ();
        }
        var dt = scl.data_type_templates;
        if (dt.logical_node_types == null) {
          stdout.printf ("ERROR: no logical nodes type templates found\n");
          assert_not_reached ();
        }
        var lnts = dt.logical_node_types;
        if (lnts.size != 7) {
          stdout.printf (@"ERROR: wrong logical nodes type templates number. Expected: 7 Got: $(lnts.size)\n");
          assert_not_reached ();
        }
        string[] ied_types = {"","",null,null,null,null,null};
        string[] ids = {"LLN01","LPHD1","XCBR5","CSWI7","CILO9","PTOC11","RREC13"};
        string[] lncs = {"LLN0","LPHD","XCBR","CSWI","CILO","CCGR","RREC"};
        for (int i = 0; i < ied_types.length; i++) {
          var lnt = lnts.get (ids[i]);
          string ied = "NULL";
          if (ied_types[i] != null)
            ied = ied_types[i];
          if (lnt == null) {
            stdout.printf (@"ERROR: Logical Node Type: $(ied_types[i])/$(ids[i])/$(lncs[i]) not found\n");
            assert_not_reached ();
          }
          if (lnt.ln_class != lncs[i]) {
            stdout.printf (@"ERROR: Incorrect Value for LNType: $(ied_types[i])/$(ids[i])/$(lncs[i]). Expected $(lncs[i]), got $(lnt.ln_class)\n");
            assert_not_reached ();
          }
          if (lnt.ied_type != ied_types[i]) {
            stdout.printf (@"ERROR: Incorrect Value for LNType: $(ied_types[i])/$(ids[i])/$(lncs[i]). Expected $(ied_types[i]), got $(lnt.ied_type)\n");
            assert_not_reached ();
          }
        }
        // LNType - Data Objects Attributes
        var lnt = lnts.get ("XCBR5");
        if (lnt == null) {
          stdout.printf (@"ERROR: Logical Node Type: ''/XCBR5 not found\n");
          assert_not_reached ();
        }
        if (lnt.ied_type != null) {
          stdout.printf (@"ERROR: Incorrect IED Type for LNType: NULL/XCBR5/XCBR. Expected 'NULL', got: $(lnt.ied_type)\n");
          assert_not_reached ();
        }
        if (lnt.ln_class != "XCBR") {
          stdout.printf (@"ERROR: Incorrect LNClass for LNType: ''/XCBR5/XCBR. Expected 'XCBR', got: $(lnt.ln_class)\n");
          assert_not_reached ();
        }
        if (lnt.dos == null) {
          stdout.printf (@"ERROR: Data Object definitions not found for Logical Node Type: /XCBR5/XCBR \n");
          assert_not_reached ();
        }
        string[] doids = {"Pos","OpCnt","CBOpCap",
                          "BlkOpn","BlkCls","Loc",
                          "Mod","Beh","Health","NamPlt"};
        string[] dotypes = {"XCBR5Pos","XCBR5OpCnt","XCBR5CBOpCap",
                            "XCBR5BlkOpn","XCBR5BlkCls","XCBR5Loc",
                            "XCBR5Mod","XCBR5Beh","XCBR5Health","XCBR5NamPlt"};
        bool[] dotrns = {false,false,false,
                        false,false,true,
                        false,false,false,false};
        for (int i = 0; i < doids.length; i++) {
          var dobject = lnt.dos.get (doids[i]);
          if (dobject == null) {
            stdout.printf (@"ERROR: Data Object: $(doids[i]) not found\n");
            assert_not_reached ();
          }
          if (dobject.do_type != dotypes[i]) {
            stdout.printf (@"ERROR: Data Object: $(doids[i]) has wrong type. Expected $(dotypes[i]), got: $(dobject.do_type)\n");
            assert_not_reached ();
          }
          if (dobject.transient != dotrns[i]) {
            stdout.printf (@"ERROR: Data Object: $(doids[i]) has wrong transient value. Expected $(dotrns[i]), got: $(dobject.transient)\n");
            assert_not_reached ();
          }
        }
      }
      catch (GLib.Error e)
      {
        stdout.printf (@"ERROR: $(e.message)");
        assert_not_reached ();
      }
    });
    Test.add_func ("/librescl-test-suite/read-data-type-template/data-object-types", 
    () => {
      try {
        var doc = new GXml.xDocument.from_path (LsclTest.TEST_DIR + "/tests-files/data-type-template.cid");
        var scl = new Scl ();
        scl.deserialize (doc);
        if (scl.data_type_templates == null) {
          stdout.printf ("ERROR: no data type templates found\n");
          assert_not_reached ();
        }
        var dt = scl.data_type_templates;
        // Data Object Types
        if (dt.data_object_types == null) {
          stdout.printf (@"ERROR: no Data Object Types found\n");
          assert_not_reached ();
        }
        var dots = dt.data_object_types;
        if (dots.size != 44) {
          stdout.printf (@"ERROR: wrong data object type templates number. Expected: 44 Got: $(dots.size)\n");
          assert_not_reached ();
        }
        // Data Attributes
        var dot = dots.get ("LPHD1NamPlt");
        if (dot == null) {
          stdout.printf (@"ERROR: Data Object Type: NULL/LPHD1NamPlt not found\n");
          assert_not_reached ();
        }
        if (dot.cdc != "LPL") {
          stdout.printf (@"ERROR: Wrong CDC for Data Object Type: NULL/LPHD1NamPlt/LPL got: $(dot.cdc)\n");
          assert_not_reached ();
        }
        if (dot.das == null) {
          stdout.printf (@"ERROR: Data Attribute definitions not found for Data Object Type: NULL/LPHD1NamPlt/LPL \n");
          assert_not_reached ();
        }
        string[] danames = {"d","swRev","vendor"};
        //string[] dabtypes = {"VisString255","VisString255","VisString255"};
        //string[] davkinds = {"Set","Set","Set"};
        string[] dacounts = {"1","2","3"};
        bool[] dadchgs = {false,true,false};
        bool[] daqchgs = {false,false,true};
        bool[] dadupds = {true,false,false};
        for (int i = 0; i < danames.length; i++) {
          var da = dot.das.get (danames[i]);
          if (da == null) {
            stdout.printf (@"ERROR: Data Attribute: $(danames[i]) not found\n");
            assert_not_reached ();
          }
          if (da.name != danames[i]) {
            stdout.printf (@"ERROR: Data Attribute: $(danames[i]) has wrong name. Expected $(danames[i]), got: $(da.name)\n");
            assert_not_reached ();
          }
          if (da.count != dacounts[i]) {
            stdout.printf (@"ERROR: Data Attribute: $(danames[i]) has wrong count. Expected $(dacounts[i]), got: $(da.count)\n");
            assert_not_reached ();
          }
          if (da.dchg != dadchgs[i]) {
            stdout.printf (@"ERROR: Data Attribute: $(danames[i]) has wrong count. Expected $(dadchgs[i]), got: $(da.dchg)\n");
            assert_not_reached ();
          }
          if (da.qchg != daqchgs[i]) {
            stdout.printf (@"ERROR: Data Attribute: $(danames[i]) has wrong count. Expected $(daqchgs[i]), got: $(da.qchg)\n");
            assert_not_reached ();
          }
          if (da.dupd != dadupds[i]) {
            stdout.printf (@"ERROR: Data Attribute: $(danames[i]) has wrong count. Expected $(dadupds[i]), got: $(da.dupd)\n");
            assert_not_reached ();
          }
        }
      }
      catch (GLib.Error e)
      {
        stdout.printf (@"ERROR: $(e.message)");
        assert_not_reached ();
      }
    });
    Test.add_func ("/librescl-test-suite/read-data-type-template/data-attribute-types", 
    () => {
      try {
        var doc = new GXml.xDocument.from_path (LsclTest.TEST_DIR + "/tests-files/data-type-template-datypes.cid");
        var scl = new Scl ();
        scl.deserialize (doc);
        if (scl.data_type_templates == null) {
          stdout.printf ("ERROR: no data type templates found\n");
          assert_not_reached ();
        }
        var dt = scl.data_type_templates;
        // Data Attribute Types
        if (dt.data_attribute_types == null) {
          stdout.printf (@"ERROR: no Data Attribute Types found\n");
          assert_not_reached ();
        }
        var dats = dt.data_attribute_types;
        if (dats.size != 12) {
          stdout.printf (@"ERROR: wrong data object type templates number. Expected: 12 Got: $(dats.size)\n");
          assert_not_reached ();
        }
        var dat = dats.get ("RRECRecModStruct");
        if (dat == null) {
          stdout.printf (@"ERROR: Data Attribute Type: /XCBR5ModctlModel not found\n");
          assert_not_reached ();
        }
        if (dat.bdas == null) {
          stdout.printf (@"ERROR: Basic Data Attribute definitions not found for Data Attribute Type: /RRECRecModStruct \n");
          assert_not_reached ();
        }
        string[] bdas = {"SinglePhase","SingleBraker"};
        //string[] values = {"single_contact","single_contact"};
        tValKindEnum[] vkinds = {tValKindEnum.SET, tValKindEnum.CONF};
        string[] counts = {"0","0"};
        for (int i = 0; i < bdas.length; i++) {
          var bda = dat.bdas.get (bdas[i]);
          if (bda == null) {
            stdout.printf (@"ERROR: BDA: $(bdas[i]) not found\n");
            assert_not_reached ();
          }
          if (bda.name != bdas[i]) {
            stdout.printf (@"ERROR: BDA: $(bdas[i]) has wrong name. Expected $(bdas[i]), got: $(bda.name)\n");
            assert_not_reached ();
          }
          if (bda.count != counts[i]) {
            stdout.printf (@"ERROR: BDA: $(bdas[i]) has wrong count. Expected $(counts[i]), got: $(bda.count)\n");
            assert_not_reached ();
          }
          if (bda.val_kind != vkinds[i]) {
            stdout.printf (@"ERROR: BDA: $(bdas[i]) has wrong valKind. Expected $(vkinds[i]), got: $(bda.val_kind)\n");
            assert_not_reached ();
          }
        }
        var bda = dat.bdas.get ("Operated");
        if (bda == null) {
          stdout.printf (@"ERROR: BDA: Operated not found\n");
          assert_not_reached ();
        }
        if (bda.name != "Operated") {
          stdout.printf (@"ERROR: BDA: Wrong value for name. Expected Operated, got: $(bda.name)\n");
          assert_not_reached ();
        }
        if (bda.b_type != "BOOLEAN") {
          stdout.printf (@"ERROR: BDA: Wrong value for bType. Expected BOOLEAN, got: $(bda.b_type)\n");
          assert_not_reached ();
        }
        if (bda.val_kind != (Enumeration.parse (typeof (tValKindEnum), "RO")).value) {
          stdout.printf (@"ERROR: BDA: Wrong value for valKind. Expected RO, got: $(bda.val_kind)\n");
          assert_not_reached ();
        }
        if (bda.count != "2") {
          stdout.printf (@"ERROR: BDA: Wrong value for count. Expected 2, got: $(bda.count)\n");
          assert_not_reached ();
        }
        string[] vals = {"TRUE","FALSE"};
        for (int j = 0; j < vals.length; j++) {
          if ((bda.vals.get (j)).get_value () != vals[j]) {
            stdout.printf (@"ERROR: BDA: Wrong value for array element $j. Expected $(vals[j]), got: $((bda.vals.get (j)).get_value ())\n");
            assert_not_reached ();
          }
        }
        if (dat.bdas.duplicated.size != 1) {
          stdout.printf (@"ERROR: BDA: Wrong duplicated size. Expected 1, got: $(dat.bdas.duplicated.size)\n");
          assert_not_reached ();
        }
        var dup = dat.bdas.duplicated.get (0);
        if (dup == null) {
          stdout.printf (@"ERROR: BDA: No duplicated found!\n");
          assert_not_reached ();
        }
        if (dup.name != "Operated") {
          stdout.printf (@"ERROR: BDA: Duplicated bad name. Expected 'Operated', got: $(dup.name)\n");
          assert_not_reached ();
        }
        if (dup.b_type != "BOOLEAN") {
          stdout.printf (@"ERROR: BDA: Wrong value for bType. Expected BOOLEAN, got: $(dup.b_type)\n");
          assert_not_reached ();
        }
        if (dup.val_kind != (Enumeration.parse (typeof (tValKindEnum), "RO")).value) {
          stdout.printf (@"ERROR: BDA: Wrong value for valKind. Expected RO, got: $(dup.val_kind)\n");
          assert_not_reached ();
        }
        if (dup.count != "2") {
          stdout.printf (@"ERROR: BDA: Wrong value for count. Expected 2, got: $(dup.count)\n");
          assert_not_reached ();
        }
        string[] vals2 = {"FALSE","TRUE"};
        for (int k = 0; k < vals2.length; k++) {
          if ((dup.vals.get (k)).get_value () != vals2[k]) {
            stdout.printf (@"ERROR: BDA: Wrong value for array element $k. Expected $(vals2[k]), got: $((dup.vals.get (k)).get_value ())\n");
            assert_not_reached ();
          }
        }
      }
      catch (GLib.Error e)
      {
        stdout.printf (@"ERROR: $(e.message)");
        assert_not_reached ();
      }
    });
    Test.add_func ("/librescl-test-suite/read-ied", 
    () => {
      try {
        var doc = new GXml.xDocument.from_path (LsclTest.TEST_DIR + "/tests-files/ied.cid");
        var scl = new Scl ();
        scl.deserialize (doc);
        if (scl.ieds == null) {
          stdout.printf (@"ERROR: No ieds found!\n");
          assert_not_reached ();
        }
        if (scl.ieds.size != 1) {
          stdout.printf (@"ERROR: More IED than expected: found $(scl.ieds.size)\n");
          assert_not_reached ();
        }
        var ied = scl.ieds.get ("IED1");
        if (ied == null) {
          stdout.printf (@"ERROR: No IED 'IED1' found!\n");
          assert_not_reached ();
        }
        if (ied.name != "IED1") {
          stdout.printf (@"ERROR: Bad name for 'IED1' : $(ied.name)\n");
          assert_not_reached ();
        }
        if (ied.config_version != "0") {
          stdout.printf (@"ERROR: Bad config_version for 'IED1' : $(ied.config_version)\n");
          assert_not_reached ();
        }
        if (ied.manufacturer != "LibreSCLEditor") {
          stdout.printf (@"ERROR: Bad manufacturer for 'IED1' : $(ied.manufacturer)\n");
          assert_not_reached ();
        }
        if (ied.ied_type != "TEMPLATE") {
          stdout.printf (@"ERROR: Bad name for 'IED1' : $(ied.ied_type)\n");
          assert_not_reached ();
        }
        // Services Tests
        assert (ied.services != null);
        assert (ied.services.dyn_association != null);
        assert (ied.services.setting_groups == null);
        assert (ied.services.get_directory != null);
        assert (ied.services.get_data_object_definition != null);
        assert (ied.services.data_object_directory != null);
        assert (ied.services.get_data_set_value != null);
        assert (ied.services.set_data_set_value == null);
        assert (ied.services.data_set_directory != null);
        assert (ied.services.conf_data_set != null);
        assert (ied.services.conf_data_set.max == "8");
        assert (ied.services.conf_data_set.max_attributes == "64");
        assert (ied.services.dyn_data_set == null);
        assert (ied.services.read_write != null);
        assert (ied.services.timer_activated_control == null);
        assert (ied.services.conf_report_control != null);
        assert (ied.services.conf_report_control.max == "6");
        assert (ied.services.get_cb_values != null);
        assert (ied.services.conf_log_control == null);
        assert (ied.services.report_settings != null);
        assert (ied.services.report_settings.cb_name == tServiceSettingsEnum.Fix);
        assert (ied.services.report_settings.dat_set == tServiceSettingsEnum.Fix);
        assert (ied.services.report_settings.rpt_id == tServiceSettingsEnum.Dyn);
        assert (ied.services.report_settings.opt_fields == tServiceSettingsEnum.Dyn);
        assert (ied.services.report_settings.buf_time == tServiceSettingsEnum.Dyn);
        assert (ied.services.report_settings.trg_ops == tServiceSettingsEnum.Dyn);
        assert (ied.services.report_settings.intg_pd == tServiceSettingsEnum.Dyn);
        assert (ied.services.log_settings == null);
        assert (ied.services.gse_settings != null);
        assert (ied.services.gse_settings.app_id == tServiceSettingsEnum.Dyn);
        assert (ied.services.smv_settings == null);
        assert (ied.services.gse_dir == null);
        assert (ied.services.goose != null);
        assert (ied.services.goose.max == "9");
        assert (ied.services.gsse != null);
        assert (ied.services.gsse.max == "1");
        assert (ied.services.file_handling != null);
        assert (ied.services.conf_lns != null);
        assert (ied.services.conf_lns.fix_prefix == false);
        assert (ied.services.conf_lns.fix_ln_inst == true);
        // Acces Point Tests
        if (ied.access_points == null) {
          stdout.printf (@"ERROR: No access points found for 'IED1' \n");
          assert_not_reached ();
        }
        var ap = ied.access_points.get ("AccessPoint1");
        if (ap == null) {
          stdout.printf (@"ERROR: No Access Points found for 'IED1'\n");
          assert_not_reached ();
        }
        if (ap.name != "AccessPoint1") {
          stdout.printf (@"ERROR: Bad name for 'AccessPoint1' : $(ap.name)\n");
          assert_not_reached ();
        }
        if (ap.router != false) {
          stdout.printf (@"ERROR: Bad router for 'IED1.AccessPoint1' : $(ap.router)\n");
          assert_not_reached ();
        }
        if (ap.clock != true) {
          stdout.printf (@"ERROR: Bad clock for 'IED1.AccessPoint1' : $(ap.clock)\n");
          assert_not_reached ();
        }
        if (ap.server == null) {
          stdout.printf (@"ERROR: No server found for 'IED1.AccessPoint1'\n");
          assert_not_reached ();
        }
        // Server Tests
        var server = ap.server;
        assert (server.timeout == "30");
        if (server.authentication == null) {
          stdout.printf (@"ERROR: No authentication for 'IED1.AccessPoint1.Server'\n");
          assert_not_reached ();
        }
        // Tests for Authentication
        assert (server.authentication.none == true);
        assert (server.authentication.password == false);
        assert (server.authentication.@weak == false);
        assert (server.authentication.strong == false);
        assert (server.authentication.certificate == false);
        // TODO: Association Tests
        assert (server.association != null);
        assert (server.association.kind == tAssociationKindEnum.preestablished);
        assert (server.association.association_id == "0");
        assert (server.association.ied_name == "None");
        assert (server.association.ld_inst == "NoneLd");
        assert (server.association.prefix == "");
        assert (server.association.ln_class == "XCBR");
        assert (server.association.ln_inst == "1");
        // Logical Device Tests
        assert (server.logical_devices != null);
        var ld = server.logical_devices.@get ("LDevice1");
        assert (ld != null);
        assert (ld.inst == "LDevice1");
        assert (ld.ln0 != null);
        assert (ld.logical_nodes != null);
        if (ld.logical_nodes.size != 6) {
          stdout.printf (@"ERROR: Bad LD.LNs number for 'LDevice1' in 'IED1.AccessPoint1.Server': found $(ld.logical_nodes.size)\n");
          assert_not_reached ();
        }
      }
      catch (GLib.Error e)
      {
        stdout.printf (@"ERROR: $(e.message)");
        assert_not_reached ();
      }
    });
    Test.add_func ("/librescl-test-suite/read-ied/logical-device/LN0", 
    () => {
      try {
        var doc = new GXml.xDocument.from_path (LsclTest.TEST_DIR + "/tests-files/ied.cid");
        var scl = new Scl ();
        scl.deserialize (doc);
        assert (scl.ieds != null);
        var ied = scl.ieds.get ("IED1");
        assert (ied != null);
        assert (ied.access_points != null);
        var ap = ied.access_points.get ("AccessPoint1");
        assert (ap != null);
        assert (ap.server != null);
        var server = ap.server;
        assert (server.logical_devices != null);
        var ld = server.logical_devices.@get ("LDevice1");
        assert (ld != null);
        assert (ld.inst == "LDevice1");
        // Logical Node Cero
        assert (ld.ln0 != null);
        // GSE controls
        assert (ld.ln0.gse_controls != null);
        var gsec = ld.ln0.gse_controls.@get ("gcb");
        assert (gsec != null);
        assert (gsec.name =="gcb");
        assert(gsec.control_type == tGSEControlTypeEnum.GOOSE);
        assert (gsec.app_id == "DISPARO");
        assert (gsec.dat_set == "GOOSE1");
        assert (gsec.conf_rev == "1");
        // Data Object Information
        assert (ld.ln0.dois != null);
        assert (ld.ln0.dois.size == 4);
        var doi1 = ld.ln0.dois.@get ("Mod");
        assert (doi1 != null);
        assert (doi1.sdis != null);
        assert (doi1.sdis.size == 1);
        var sdi11 = doi1.sdis.@get ("ctlModel");
        assert (sdi11 != null);
        assert (sdi11.dais != null);
        assert (sdi11.dais.size == 1);
        var dai111 = sdi11.dais.@get ("ctlModels");
        assert (dai111 != null);
        assert (dai111.vals != null);
        assert (dai111.vals.size == 1);
        var val111 = dai111.vals.@get (0);
        assert (val111 != null);
        var val111v = val111.get_value ();
        assert (val111v != null);
        assert (val111v == "status_only");
        assert (doi1.dais != null);
        assert (doi1.dais.size == 3);
        var dai11 = doi1.dais.@get ("q");
        assert (dai11 != null);
        assert (dai11.name == "q");
        assert (dai11.val_kind == tValKindEnum.SET);
        // DataSets
        assert (ld.ln0.data_sets != null);
        var dt = ld.ln0.data_sets.@get ("GOOSE1");
        assert (dt != null);
        assert (dt.name =="GOOSE1");
        var fcda0 = dt.fcdas.@get (0);
        assert (fcda0 != null);
        assert (fcda0.ld_inst == "LDevice1");
        assert (fcda0.prefix == "");
        assert (fcda0.ln_class == "XCBR");
        assert (fcda0.ln_inst == "5");
        assert (fcda0.fc == tFCEnum.ST);
        assert (fcda0.do_name == "Pos");
        assert (fcda0.da_name == "stVal");
        var fcda1 = dt.fcdas.@get (1);
        assert (fcda1 != null);
        assert (fcda1.ld_inst == "LDevice1");
        assert (fcda1.prefix == "");
        assert (fcda1.ln_class == "XCBR");
        assert (fcda1.ln_inst == "5");
        assert (fcda1.fc == tFCEnum.ST);
        assert (fcda1.do_name == "Pos");
        assert (fcda1.da_name == "q");
        var fcda2 = dt.fcdas.@get (2);
        assert (fcda2 != null);
        assert (fcda2.ld_inst == "LDevice1");
        assert (fcda2.prefix == "");
        assert (fcda2.ln_class == "XCBR");
        assert (fcda2.ln_inst == "5");
        assert (fcda2.fc == tFCEnum.ST);
        assert (fcda2.do_name == "Pos");
        assert (fcda2.da_name == "t");
      }
      catch (GLib.Error e)
      {
        stdout.printf (@"ERROR: $(e.message)");
        assert_not_reached ();
      }
    });
    Test.add_func ("/librescl-test-suite/read-ied/logical-device/logical-nodes", 
    () => {
      try {
        var doc = new GXml.xDocument.from_path (LsclTest.TEST_DIR + "/tests-files/ied.cid");
        var scl = new Scl ();
        scl.deserialize (doc);
        assert (scl.ieds != null);
        var ied = scl.ieds.get ("IED1");
        assert (ied != null);
        assert (ied.access_points != null);
        var ap = ied.access_points.get ("AccessPoint1");
        assert (ap != null);
        assert (ap.server != null);
        var server = ap.server;
        assert (server.logical_devices != null);
        var ld = server.logical_devices.@get ("LDevice1");
        assert (ld != null);
        assert (ld.inst == "LDevice1");
        // Logical Nodes
        assert (ld.logical_nodes != null);
        var ln1 = ld.logical_nodes.find ("","XCBR","5");
        assert (ln1 != null);
        assert (ln1.dois != null);
        assert (ln1.dois.size == 10);
        var doi1 = ln1.dois.@get ("Beh");
        assert (doi1 != null);
        assert (doi1.sdis != null);
        assert (doi1.sdis.size == 0);
        assert (doi1.dais != null);
        var dai11 = doi1.dais.@get ("stVal");
        assert (dai11 != null);
        assert (dai11.name == "stVal");
        assert (dai11.val_kind == tValKindEnum.SET);
        assert (dai11.vals != null);
        assert (dai11.vals.size == 1);
        var val111 = dai11.vals.@get (0);
        assert (val111 != null);
        var val111v = val111.get_value ();
        assert (val111v == "on");
      }
      catch (GLib.Error e)
      {
        stdout.printf (@"ERROR: $(e.message)");
        assert_not_reached ();
      }
    });
    Test.add_func ("/librescl-test-suite/read-scd/initial-comments", 
    () => {
      try {
        var doc = new GXml.xDocument.from_path (LsclTest.TEST_DIR + "/tests-files/data-type-template-coments.cid");
        var scl = new Scl ();
        scl.deserialize (doc);
        // TODO: Add test for SDO y SDA in templates
      }
      catch (GLib.Error e) { Test.message (e.message); assert_not_reached (); }
    });
    Test.add_func ("/librescl-test-suite/read-scd/communication-tp-ns", 
    () => {
      try {
        var doc = new GXml.xDocument.from_path (LsclTest.TEST_DIR + "/tests-files/communication-xmlns-tp.cid");
        var scl = new Scl ();
        scl.deserialize (doc);
        assert (scl.communication != null);
        assert (scl.communication.subnetworks != null);
        var sn = scl.communication.subnetworks.get ("test");
        assert (sn != null);
        assert (sn.connected_aps != null);
        var cap = sn.connected_aps.get ("TEMPLATE", "AP");
        assert (cap != null);
        assert (cap.address != null);
        assert (cap.address.ps != null);
        foreach (tP p in cap.address.ps) {
          Test.message ("AP: "+p.to_string ());
        }
      }
      catch (GLib.Error e) { Test.message (e.message); assert_not_reached (); }
    });
    Test.add_func ("/librescl-test-suite/read-ied/logcontrol", 
    () => {
      try {
        var doc = new xDocument.from_path (LsclTest.TEST_DIR + "/tests-files/ied-logcb-settingscb.cid");
        var scl = new Scl ();
        scl.deserialize (doc);
        assert (scl.ieds != null);
        var ied = scl.ieds.get ("TEMPLATE");
        assert (ied != null);
        assert (ied.services != null);
        assert (ied.access_points != null);
        var ap = ied.access_points.get ("AP");
        assert (ap.server != null);
        assert (ap.server.authentication != null);
        assert (ap.server.logical_devices != null);
        var ld = ap.server.logical_devices.get ("LD");
        assert (ld != null);
        assert (ld.ln0 != null);
        assert (ld.logical_nodes != null);
        var ln = ld.logical_nodes.get ("GGIO", "1", "GENERIC");
        assert (ln != null);
        // Check LogControl
        assert (ld.ln0.log_controls != null);
        var logc = ld.ln0.log_controls.get ("GeneralLog");
        assert (logc != null);
        assert (logc.desc == "Test Logs");
        assert (logc.log_name == "LD");
        assert (logc.log_ena == true);
        assert (logc.intg_pd == "5000");
        assert (logc.reason_code = true);
      }
      catch (GLib.Error e) { Test.message (e.message); assert_not_reached (); }
    });
  }
}
