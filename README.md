
# To simulate:

1) start Modelsim

2) Go to "transcript" window

    cd <demo_directory>
    do compile_all.tcl
    vsim bemicro_tb

3) Go back to "transcript" window

    log -r *
    run -all

4) Go back to "transcript" window

    do bemicro_wave.do

# In waveform viewer:

* f to zoom out fully
* c to center and zoom in at selected time
* + and - to zoom in and out

# To recompile:

Go to "transcript" window

    do compile_all.tcl
    restart -force; run -all
