set BDFILEPATH [get_files -quiet system.bd]
make_wrapper -files $BDFILEPATH -top
# Try adding both the Verilog and VHLD files
regsub -all "system.bd" [get_files -quiet system.bd] "hdl/system_wrapper.v" TOPFILEPATH
catch {
        add_files -norecurse $TOPFILEPATH
        update_compile_order -fileset sources_1
        }
regsub -all "system.bd" [get_files -quiet system.bd] "hdl/system_wrapper.vhd" TOPFILEPATH
catch {
        add_files -norecurse $TOPFILEPATH
        update_compile_order -fileset sources_1
        }