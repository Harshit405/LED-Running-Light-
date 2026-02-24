/// LED Running Light for DE2-115 Board
// Features: Clock Enable, Speed Control, Direction Control, Pause/Resume
module led_blink (
    input wire CLOCK_50,        // 50MHz clock on DE2-115
    input wire [3:0] KEY,       // Push buttons (active low)
    input wire [17:0] SW,       // Switches
    output reg [17:0] LEDR      // Red LEDs
);

    // Counter for clock division
    reg [25:0] counter;
    wire reset_n;
    wire clock_enable;
    wire pause;
    
    // KEY[0] = Reset (active low)
    assign reset_n = KEY[0];
    
    // KEY[1] = Pause (active low: pressed = paused)
    assign pause = ~KEY[1];
    
    // SW[0] = Speed: OFF = 1Hz (slow), ON = 5Hz (fast)
    wire [25:0] max_count;
    assign max_count = SW[0] ? 26'd9_999_999 : 26'd49_999_999;
    
    // Generate clock enable pulse
    assign clock_enable = (counter == max_count);
    
    // Counter logic
    always @(posedge CLOCK_50 or negedge reset_n) begin
        if (!reset_n) begin
            counter <= 26'd0;
        end
        else if (pause) begin
            counter <= counter;  // Hold counter when paused
        end
        else if (clock_enable) begin
            counter <= 26'd0;
        end
        else begin
            counter <= counter + 1'b1;
        end
    end
    
    // LED pattern logic
    // SW[1] = Direction: OFF = Left, ON = Right
    always @(posedge CLOCK_50 or negedge reset_n) begin
        if (!reset_n) begin
            LEDR <= 18'b000000000000000001;  // Start with first LED ON
        end
        else if (clock_enable && !pause) begin
            if (SW[1])
                LEDR <= {LEDR[0], LEDR[17:1]};  // Rotate RIGHT
            else
                LEDR <= {LEDR[16:0], LEDR[17]};  // Rotate LEFT
        end
    end

endmodule