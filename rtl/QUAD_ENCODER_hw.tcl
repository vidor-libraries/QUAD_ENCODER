# Copyright 2018 ARDUINO SA (http://www.arduino.cc/)
# This file is part of Vidor IP.
# Copyright (c) 2018
# Authors: Dario Pennisi
#
# This software is released under:
# The GNU General Public License, which covers the main part of
# Vidor IP
# The terms of this license can be found at:
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# You can be released from the requirements of the above licenses by purchasing
# a commercial license. Buying such a license is mandatory if you want to modify or
# otherwise use the software for commercial activities involving the Arduino
# software without disclosing the source code of your own applications. To purchase
# a commercial license, send an email to license@arduino.cc.

#
# request TCL package from ACDS 16.1
#
package require -exact qsys 16.1


#
# module QUAD_ENCODER
#
set_module_property DESCRIPTION ""
set_module_property NAME QUAD_ENCODER
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property GROUP ipTronix
set_module_property AUTHOR ""
set_module_property DISPLAY_NAME "Quadrature Encoder"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false
set_module_property ELABORATION_CALLBACK            elaboration_callback


#
# file sets
#
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL QUAD_ENCODER
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file QUAD_ENCODER.sv SYSTEM_VERILOG PATH QUAD_ENCODER.sv TOP_LEVEL_FILE


#
# parameters
#
add_parameter pENCODERS INTEGER 2
set_parameter_property pENCODERS DEFAULT_VALUE 2
set_parameter_property pENCODERS DISPLAY_NAME "Number of Encoders"
set_parameter_property pENCODERS TYPE INTEGER
set_parameter_property pENCODERS UNITS None
set_parameter_property pENCODERS HDL_PARAMETER true
set_parameter_property pENCODERS ALLOWED_RANGES {1:32}

add_parameter pENCODER_PRECISION INTEGER 32
set_parameter_property pENCODER_PRECISION DEFAULT_VALUE 32
set_parameter_property pENCODER_PRECISION DISPLAY_NAME "Counter Bits"
set_parameter_property pENCODER_PRECISION TYPE INTEGER
set_parameter_property pENCODER_PRECISION UNITS None
set_parameter_property pENCODER_PRECISION HDL_PARAMETER true
set_parameter_property pENCODER_PRECISION ALLOWED_RANGES {1:32}

#
# display items
#


#
# connection point avalon_slave
#
add_interface avalon_slave avalon end
set_interface_property avalon_slave addressUnits WORDS
set_interface_property avalon_slave associatedClock clk
set_interface_property avalon_slave associatedReset reset
set_interface_property avalon_slave bitsPerSymbol 8
set_interface_property avalon_slave burstOnBurstBoundariesOnly false
set_interface_property avalon_slave burstcountUnits WORDS
set_interface_property avalon_slave explicitAddressSpan 0
set_interface_property avalon_slave holdTime 0
set_interface_property avalon_slave linewrapBursts false
set_interface_property avalon_slave maximumPendingReadTransactions 0
set_interface_property avalon_slave maximumPendingWriteTransactions 0
set_interface_property avalon_slave readLatency 1
set_interface_property avalon_slave readWaitTime 0
set_interface_property avalon_slave setupTime 0
set_interface_property avalon_slave timingUnits Cycles
set_interface_property avalon_slave writeWaitTime 0
set_interface_property avalon_slave ENABLED true
set_interface_property avalon_slave EXPORT_OF ""
set_interface_property avalon_slave PORT_NAME_MAP ""
set_interface_property avalon_slave CMSIS_SVD_VARIABLES ""
set_interface_property avalon_slave SVD_ADDRESS_GROUP ""

add_interface_port avalon_slave oAVL_READ_DATA readdata Output 32
add_interface_port avalon_slave iAVL_READ read Input 1
set_interface_assignment avalon_slave embeddedsw.configuration.isFlash 0
set_interface_assignment avalon_slave embeddedsw.configuration.isMemoryDevice 0
set_interface_assignment avalon_slave embeddedsw.configuration.isNonVolatileStorage 0
set_interface_assignment avalon_slave embeddedsw.configuration.isPrintableDevice 0


#
# connection point clk
#
add_interface clk clock end
set_interface_property clk clockRate 0
set_interface_property clk ENABLED true
set_interface_property clk EXPORT_OF ""
set_interface_property clk PORT_NAME_MAP ""
set_interface_property clk CMSIS_SVD_VARIABLES ""
set_interface_property clk SVD_ADDRESS_GROUP ""

add_interface_port clk iCLOCK clk Input 1


#
# connection point reset
#
add_interface reset reset end
set_interface_property reset associatedClock clk
set_interface_property reset synchronousEdges DEASSERT
set_interface_property reset ENABLED true
set_interface_property reset EXPORT_OF ""
set_interface_property reset PORT_NAME_MAP ""
set_interface_property reset CMSIS_SVD_VARIABLES ""
set_interface_property reset SVD_ADDRESS_GROUP ""

add_interface_port reset iRESET reset Input 1


#
# connection point encoder
#
add_interface encoder conduit end
set_interface_property encoder associatedClock clk
set_interface_property encoder associatedReset ""
set_interface_property encoder ENABLED true
set_interface_property encoder EXPORT_OF ""
set_interface_property encoder PORT_NAME_MAP ""
set_interface_property encoder CMSIS_SVD_VARIABLES ""
set_interface_property encoder SVD_ADDRESS_GROUP ""


# -----------------------------------------------------------------------------
proc log2 {value} {
  set value [expr $value-1]
  for {set log2 0} {$value>0} {incr log2} {
     set value  [expr $value>>1]
  }
  return $log2;
}

# -----------------------------------------------------------------------------
# callbacks
# -----------------------------------------------------------------------------

proc elaboration_callback {} {
  set encoders  [get_parameter_value pENCODERS]
  add_interface_port avalon_slave iAVL_ADDRESS address Input [log2 $encoders]
  add_interface_port encoder iENCODER_A encoder_a Input $encoders
  add_interface_port encoder iENCODER_B encoder_b Input $encoders
}

