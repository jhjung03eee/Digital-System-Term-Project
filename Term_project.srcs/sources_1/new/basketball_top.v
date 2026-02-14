module basketball_top(
    input wire clk,             // 100MHz Main Clock
    input wire rst_n,           // Active Low Reset
    // 십자가 버튼 (속도 조절 및 발사)
    input wire btn_shoot,       // Center
    input wire btn_up,          // Up
    input wire btn_down,        // Down
    input wire btn_left,        // Left
    input wire btn_right,       // Right
    
    output wire hsync,
    output wire vsync,
    output wire [3:0] vgaRed,
    output wire [3:0] vgaGreen,
    output wire [3:0] vgaBlue,
    output wire [7:0] seg,      // 7-Segment Segments
    output wire [7:0] an        // 7-Segment Anodes (8 digits)
);

    wire rst = ~rst_n;

    // 1. Clock Divider (100MHz -> 25MHz)
    // 2비트 카운터의 [1]번 비트를 쓰면 정확히 4분주(25MHz)가 됩니다.
    reg [1:0] clk_div;
    always @(posedge clk or posedge rst) begin
        if (rst) clk_div <= 0;
        else clk_div <= clk_div + 1;
    end
    wire pixel_clk = clk_div[1]; 

    // 내부 연결 와이어
    wire [10:0] hcount;
    wire [10:0] vcount;
    wire blank;
    wire [10:0] ball_x;
    wire [10:0] ball_y;
    wire [6:0] score; 
    wire score_pulse;

    // =========================================================
    // 버튼으로 속도(파워) 조절 로직
    // =========================================================
    reg [3:0] r_speed_x;
    reg [3:0] r_speed_y;
    reg prev_up, prev_down, prev_left, prev_right;

    // Vsync(60Hz)를 클럭처럼 사용하여 버튼 입력 처리 (디바운싱 효과)
    always @(posedge vsync or posedge rst) begin
        if (rst) begin
            r_speed_x <= 4'd8;  // 기본 X 파워
            r_speed_y <= 4'd10; // 기본 Y 파워
            prev_up <= 0; prev_down <= 0; prev_left <= 0; prev_right <= 0;
        end else begin
            prev_up <= btn_up;
            prev_down <= btn_down;
            prev_left <= btn_left;
            prev_right <= btn_right;

            // Y 파워 조절 (위/아래)
            if (btn_up && !prev_up && r_speed_y < 15) r_speed_y <= r_speed_y + 1;
            else if (btn_down && !prev_down && r_speed_y > 1) r_speed_y <= r_speed_y - 1;

            // X 파워 조절 (오른쪽/왼쪽)
            if (btn_right && !prev_right && r_speed_x < 15) r_speed_x <= r_speed_x + 1;
            else if (btn_left && !prev_left && r_speed_x > 1) r_speed_x <= r_speed_x - 1;
        end
    end

    // 2. VGA Controller
    vga_controller_640_60 vga_inst (
        .pixel_clk(pixel_clk),
        .rst(rst),
        .hs(hsync),
        .vs(vsync),
        .hcount(hcount),
        .vcount(vcount),
        .blank(blank)
    );

    // 3. 게임 물리 엔진 (Vsync를 클럭으로 사용하여 60Hz로 부드럽게 이동)
    basketball_physics physics_inst (
        .clk(clk),               // 100MHz 클럭 사용
        .vsync(vsync),       // [중요] 이동의 기준이 되는 신호
        .rst(rst),
        .shoot_cmd(btn_shoot),
        .init_vx(r_speed_x), // 조절된 X 파워
        .init_vy(r_speed_y), // 조절된 Y 파워
        .ball_x(ball_x),
        .ball_y(ball_y),
        .score(score),
        .score_pulse(score_pulse) 
    );

    // 4. 그래픽 생성
    basketball_graphics graphics_inst (
        .hcount(hcount),
        .vcount(vcount),
        .blank(blank),
        .ball_x(ball_x),
        .ball_y(ball_y),
        .red(vgaRed),
        .green(vgaGreen),
        .blue(vgaBlue)
    );

    // 5. 7-Segment 점수판 (100MHz 클럭 사용)
    seven_segment fnd_inst (
        .clk(clk),
        .rst(rst),
        .score(score),
        .score_pulse(score_pulse),
        .seg(seg),
        .an(an)
    );

endmodule
