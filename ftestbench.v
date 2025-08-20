module ftestbench;
    // Choose X here (acts like your "variable")
    localparam int X = 4;  

    logic clk, rst, wr_en, rd_en;
    logic [X-1:0] din;
    logic [X-1:0] dout;
    logic full, empty;

    f_i_f_o #(.X(X)) uut (
        .clk(clk),
        .rst(rst),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .din(din),
        .dout(dout),
        .full(full),
        .empty(empty)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, testbench);

        clk = 0; rst = 1; wr_en = 0; rd_en = 0; din = 0;
        #10 rst = 0;

        repeat (X) begin
            @(posedge clk);
            wr_en = 1;
            din = $urandom;
        end
        wr_en = 0;

        repeat (X) begin
            @(posedge clk);
            rd_en = 1;
        end
        rd_en = 0;

        #20 $finish;
    end
endmodule
