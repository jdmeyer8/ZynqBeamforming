if strcmp(computer, 'PCWIN64')
    hdlsetuptoolpath('ToolName','Xilinx Vivado','ToolPath','C:\Xilinx\Vivado\2017.4\bin')
else
    hdlsetuptoolpath('Toolname', 'Xilinx Vivado', 'Toolpath', '/opt/Xilinx/Vivado/2017.4/bin/vivado')
end