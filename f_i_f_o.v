module f_i_f_o #(
    parameter integer X = 16,                // user-configurable
    parameter integer DATA_WIDTH = X,      
    parameter integer DEPTH = 2*X           
)(
    input  wire clk,
    input  wire rst,                       
    input  wire wr_en,
    input  wire rd_en,
    input  wire [DATA_WIDTH-1:0] din,
    output reg  [DATA_WIDTH-1:0] dout,
    output wire full,
    output wire empty
);

    reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];   
    reg [$clog2(DEPTH):0] wr_ptr, rd_ptr, count;

    assign full  = (count == DEPTH);
    assign empty = (count == 0);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            wr_ptr <= 0;
            rd_ptr <= 0;
            count  <= 0;
            dout   <= 0;
        end else begin
            // Write operation
            if (wr_en && !full) begin
                mem[wr_ptr] <= din;
                wr_ptr <= wr_ptr + 1;
                count <= count + 1;
            end
            // Read operation
            if (rd_en && !empty) begin
                dout <= mem[rd_ptr];
                rd_ptr <= rd_ptr + 1;
                count <= count - 1;
            end
        end
    end
endmodule
