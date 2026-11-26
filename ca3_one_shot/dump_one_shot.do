# Run this script after: run 10000 ns
# If your hierarchy is different, replace only DMEM and REGFILE below.

set DMEM    {sim:/TopPipeline_tb/shadow_dmem}
set REGFILE {sim:/TopPipeline_tb/shadow_registerFile}
set OUTFILE {one_shot_results.txt}

set fp [open $OUTFILE w]
puts $fp "CA3 Phase 1 - One-Shot ModelSim Results"
puts $fp "simulation_time = [now]"
puts $fp ""
puts $fp "DMEM SUMMARY (authoritative results)"

for {set i 60} {$i <= 78} {incr i} {
    set signal_path [format {%s[%d]} $DMEM $i]
    if {[catch {examine -radix hex $signal_path} value]} {
        puts $fp [format {dmem[%02d] = ERROR (%s)} $i $value]
    } else {
        puts $fp [format {dmem[%02d] = %s} $i $value]
    }
}

puts $fp ""
puts $fp "REGISTER SNAPSHOT (diagnostic only)"

for {set i 0} {$i <= 31} {incr i} {
    set signal_path [format {%s[%d]} $REGFILE $i]
    if {[catch {examine -radix hex $signal_path} value]} {
        puts $fp [format {r%02d = ERROR (%s)} $i $value]
    } else {
        puts $fp [format {r%02d = %s} $i $value]
    }
}

close $fp
echo "Created $OUTFILE in [pwd]"
