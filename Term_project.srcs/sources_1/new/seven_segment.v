module seven_segment(
    input wire clk,
    input wire rst,
    input wire [6:0] score,
    input wire score_pulse,
    output reg [7:0] seg, // Segment (A~G, DP)
    output reg [7:0] an   // Digit Select (Common)
);

    // 1. Refresh Counter & Timing Reference
    reg [26:0] refresh_counter;
    always @(posedge clk or posedge rst) begin
        if (rst) refresh_counter <= 0;
        else refresh_counter <= refresh_counter + 1;
    end

    wire digit_sel = refresh_counter[18]; 
    wire timer_tick = refresh_counter[23]; 
    reg timer_tick_prev;

    // 2. BCD 변환
    wire [7:0] score_mod_100 = score % 100;
    reg [3:0] bcd_tens, bcd_ones;

    always @(*) begin
        bcd_tens = score_mod_100 / 10;
        bcd_ones = score_mod_100 % 10;
    end

    // ==========================================
    // [수정] 자릿수 배치 교체 (Swap)
    // ==========================================
    reg [3:0] digit_value;
    always @(*) begin
        case (digit_sel)
            1'b0: begin
                // 아까 1의 자리가 떴던 곳 -> 이제 [10의 자리]를 띄움
                an = 8'b0000_0001; 
                digit_value = bcd_ones; // <--- 여기를 tens로 변경
            end
            1'b1: begin
                // 아까 10의 자리가 떴던 곳 -> 이제 [1의 자리]를 띄움
                an = 8'b0000_0010; 
                digit_value = bcd_tens; // <--- 여기를 ones로 변경
            end
        endcase
    end
    // ==========================================

    // 4. Score Flash Logic
    reg [3:0] flash_count;
    reg is_flashing;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            flash_count <= 0;
            is_flashing <= 0;
            timer_tick_prev <= 0;
        end else begin
            timer_tick_prev <= timer_tick;

            if (score_pulse) begin
                flash_count <= 4'd10;
                is_flashing <= 1;
            end
            else if ((timer_tick && !timer_tick_prev) && (flash_count > 0)) begin
                flash_count <= flash_count - 1;
                if (flash_count == 1) is_flashing <= 0;
            end
        end
    end

    // 깜빡임 효과
    wire blank_display = is_flashing && refresh_counter[25]; 

    // 5. Segment Pattern (Active High: 1=ON)
    always @(*) begin
        if (blank_display) begin
            seg = 8'b0000_0000; 
        end else begin
            case (digit_value)
                4'h0: seg = 8'b1111_1100; 
                4'h1: seg = 8'b0110_0000; 
                4'h2: seg = 8'b1101_1010; 
                4'h3: seg = 8'b1111_0010; 
                4'h4: seg = 8'b0110_0110; 
                4'h5: seg = 8'b1011_0110; 
                4'h6: seg = 8'b1011_1110; 
                4'h7: seg = 8'b1110_0000; 
                4'h8: seg = 8'b1111_1110; 
                4'h9: seg = 8'b1111_0110; 
                default: seg = 8'b0000_0000;
            endcase
        end
    end

endmodule