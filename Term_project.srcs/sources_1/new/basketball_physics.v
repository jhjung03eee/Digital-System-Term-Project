module basketball_physics (
    input wire clk,             // 100MHz System Clock
    input wire rst,
    input wire vsync,           // Timing Signal
    input wire shoot_cmd,
    input wire [3:0] init_vx,
    input wire [3:0] init_vy,
    output reg [10:0] ball_x,   
    output reg [10:0] ball_y,
    output reg [6:0] score,
    output reg score_pulse
);

    localparam PLAYER_X = 580;
    localparam PLAYER_Y = 400;
    localparam BASKET_X = 100;
    localparam BASKET_Y = 250;
    localparam RIM_SIZE = 40;
    
    // [NEW] 물리 상수 정의
    localparam FLOOR_Y = 470;   // 바닥 위치 (화면 끝 480 - 공크기 10)
    localparam BACKBOARD_X = 90; // 백보드 위치 (골대보다 살짝 뒤)

    localparam S_IDLE = 0;
    localparam S_FLYING = 1;
    localparam S_SCORED = 2;
    reg [1:0] state;

    integer i_ball_x;
    integer i_ball_y;
    integer i_vel_x;
    integer i_vel_y;

    reg [2:0] gravity_tick;

    // Vsync 엣지 디텍션
    reg vsync_prev;
    wire frame_tick;

    always @(posedge clk) begin
        vsync_prev <= vsync;
    end
    assign frame_tick = (vsync == 1'b1) && (vsync_prev == 1'b0);

    // 출력 연결
    always @(*) begin
        ball_x = i_ball_x[10:0];
        ball_y = i_ball_y[10:0];
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= S_IDLE;
            i_ball_x <= PLAYER_X;
            i_ball_y <= PLAYER_Y;
            score <= 0;
            i_vel_x <= 0;
            i_vel_y <= 0;
            gravity_tick <= 0;
            score_pulse <= 0;
        end else if (frame_tick) begin
            
            score_pulse <= 0; 

            case (state)
                S_IDLE: begin
                    gravity_tick <= 0;
                    i_ball_x <= PLAYER_X;
                    i_ball_y <= PLAYER_Y;
                    if (shoot_cmd) begin
                        // 초기 속도 설정
                        i_vel_x <= -1 * (init_vx + 2); 
                        i_vel_y <= -1 * (init_vy + 2);    
                        state <= S_FLYING;
                    end
                end

                S_FLYING: begin
                    // 1. 위치 이동
                    i_ball_x <= i_ball_x + i_vel_x;
                    i_ball_y <= i_ball_y + i_vel_y;

                    // 2. 중력 적용 (2프레임마다 가속)
                    gravity_tick <= gravity_tick + 1;
                    if (gravity_tick >= 1) begin 
                        i_vel_y <= i_vel_y + 1; 
                        gravity_tick <= 0;
                    end

                    // ==========================================
                    // [NEW] 백보드 튕김 로직 (Bank Shot)
                    // ==========================================
                    // 공이 백보드 X위치에 도달했고, 높이가 백보드 근처라면?
                    if (i_ball_x <= BACKBOARD_X && i_ball_x >= BACKBOARD_X - 10 && 
                        i_ball_y >= BASKET_Y - 50 && i_ball_y <= BASKET_Y + 10) begin
                        
                        i_vel_x <= -1 * i_vel_x; // X 속도 반전 (튕겨 나옴)
                        i_ball_x <= BACKBOARD_X + 2; // 끼임 방지 (살짝 앞으로)
                    end

                    // ==========================================
                    // [NEW] 바닥 튕김 로직 (Bouncing)
                    // ==========================================
                    if (i_ball_y >= FLOOR_Y) begin
                        // 땅에 박히지 않게 위치 보정
                        i_ball_y <= FLOOR_Y;

                        // 속도가 어느 정도 빠를 때만 튕김 (무한 튕김 방지)
                        if (i_vel_y > 4) begin
                            // 속도 반전(-) + 에너지 25% 손실 (>>> 2는 나누기 4)
                            // 즉, 원래 속도의 75%로 튀어오름
                            i_vel_y <= -1 * (i_vel_y - (i_vel_y >>> 2)); 
                        end else begin
                            // 속도가 너무 느리면 튕기지 않고 바닥에 굴러감 (Y 속도 0)
                            i_vel_y <= 0;
                            
                            // 바닥에서 굴러가다가 멈추면 리셋 (마찰력 흉내)
                            if (i_vel_x != 0) 
                                i_vel_x <= i_vel_x - (i_vel_x > 0 ? 1 : -1); // 서서히 멈춤
                            else 
                                state <= S_IDLE; // 완전히 멈추면 리셋
                        end
                    end

                    // 3. 득점 판정
                    // 골대 림(Rim)을 위에서 아래로 통과할 때만 인정하면 좋겠지만,
                    // 지금은 간단히 영역 겹침으로 유지합니다.
                    if ((i_ball_x >= BASKET_X && i_ball_x <= BASKET_X + RIM_SIZE) &&
                        (i_ball_y >= BASKET_Y && i_ball_y <= BASKET_Y + 10)) begin
                        score <= score + 1;
                        score_pulse <= 1;
                        state <= S_SCORED;
                    end
                    
                    // 4. 화면 밖 리셋 (왼쪽이나 오른쪽 멀리 나갔을 때만)
                    // 바닥(480)은 튕겨야 하므로 리셋 조건에서 제외했습니다!
                    else if (i_ball_x < -20 || i_ball_x > 660) begin
                        state <= S_IDLE;
                    end
                end

                S_SCORED: begin
                    // 득점 후 바로 리셋하지 않고, 잠시 보여줌 (선택사항)
                    state <= S_IDLE;
                end
            endcase
        end
    end
endmodule