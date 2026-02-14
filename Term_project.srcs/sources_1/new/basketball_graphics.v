module basketball_graphics (
    input wire [10:0] hcount,
    input wire [10:0] vcount,
    input wire blank,
    input wire [10:0] ball_x,
    input wire [10:0] ball_y,
    output reg [3:0] red,
    output reg [3:0] green,
    output reg [3:0] blue
);

    // 객체 크기 정의
    localparam BALL_SIZE = 10;
    localparam PLAYER_W = 20;
    localparam PLAYER_H = 40;
    localparam BASKET_W = 40;
    localparam BASKET_H = 5;

    // 고정된 객체 위치
    localparam PLAYER_X = 580;
    localparam PLAYER_Y = 400;
    localparam BASKET_X = 100;
    localparam BASKET_Y = 250;

    // ==========================================
    // [수정] 텍스트 "JIHOON" 위치 변경 (화면 중앙 상단)
    // ==========================================
    // 화면 너비(640)의 중앙 - 글자 전체 폭의 절반
    localparam TEXT_X = 302; 
    // 화면 상단에서 적당히 내려온 위치 (스코어보드 느낌)
    localparam TEXT_Y = 100; 
    
    wire [10:0] dx = hcount - TEXT_X;
    wire [10:0] dy = vcount - TEXT_Y;
    reg text_on;

    // 5x7 픽셀 폰트 로직
    always @(*) begin
        text_on = 0;
        // 텍스트 영역 안에 있을 때만 계산
        if (vcount >= TEXT_Y && vcount < TEXT_Y + 7) begin
            
            // J (0~4)
            if (hcount >= TEXT_X && hcount < TEXT_X + 5) begin
                if (dy == 0 || dx == 2 || (dy == 6 && dx <= 2) || (dx == 0 && dy >= 4))
                    text_on = 1;
            end
            
            // I (6~10)
            else if (hcount >= TEXT_X + 6 && hcount < TEXT_X + 11) begin
                if (dy == 0 || dy == 6 || (dx == 8)) 
                    text_on = 1;
            end

            // H (12~16)
            else if (hcount >= TEXT_X + 12 && hcount < TEXT_X + 17) begin
                if (dx == 12 || dx == 16 || dy == 3) 
                    text_on = 1;
            end

            // O (18~22)
            else if (hcount >= TEXT_X + 18 && hcount < TEXT_X + 23) begin
                if (dx == 18 || dx == 22 || dy == 0 || dy == 6) 
                    text_on = 1;
            end

            // O (24~28)
            else if (hcount >= TEXT_X + 24 && hcount < TEXT_X + 29) begin
                if (dx == 24 || dx == 28 || dy == 0 || dy == 6) 
                    text_on = 1;
            end

            // N (30~34)
            else if (hcount >= TEXT_X + 30 && hcount < TEXT_X + 35) begin
                if (dx == 30 || dx == 34 || (dx - 30 == dy)) 
                    text_on = 1;
            end
        end
    end
    // ==========================================

    always @(*) begin
        if (blank) begin
            red = 0; green = 0; blue = 0;
        end else begin
            
            // 0. 텍스트 출력 (흰색)
            if (text_on) begin
                red = 4'hF; green = 4'hF; blue = 4'hF; 
            end
            
            // 1. 공 그리기 (오렌지색)
            else if ((hcount >= ball_x) && (hcount < ball_x + BALL_SIZE) &&
                (vcount >= ball_y) && (vcount < ball_y + BALL_SIZE)) begin
                red = 4'hF; green = 4'h8; blue = 4'h0;
            end
            
            // 2. 플레이어 그리기 (초록색)
            else if ((hcount >= PLAYER_X) && (hcount < PLAYER_X + PLAYER_W) &&
                     (vcount >= PLAYER_Y) && (vcount < PLAYER_Y + PLAYER_H)) begin
                red = 4'h0; green = 4'hF; blue = 4'h0;
            end

            // 3. 골대(림) 그리기 (빨간색)
            else if ((hcount >= BASKET_X) && (hcount < BASKET_X + BASKET_W) &&
                     (vcount >= BASKET_Y) && (vcount < BASKET_Y + BASKET_H)) begin
                red = 4'hF; green = 4'h0; blue = 4'h0;
            end
            
            // 4. 골대(백보드) 그리기 (흰색)
            else if ((hcount >= BASKET_X - 5) && (hcount < BASKET_X) &&
                     (vcount >= BASKET_Y - 20) && (vcount < BASKET_Y + 10)) begin
                red = 4'hF; green = 4'hF; blue = 4'hF;
            end
            
            // 5. 배경색 (Dark Grey)
            else begin
                red = 4'h1; green = 4'h1; blue = 4'h1;
            end
        end
    end
endmodule