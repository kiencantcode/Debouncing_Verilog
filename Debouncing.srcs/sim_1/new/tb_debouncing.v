module tb_debouncing;

    // Inputs
    reg clk;
    reg reset_n;
    reg noisy;
    reg timer_done;
    reg timer_flag;
    
    // Outputs
    wire timer_reset;
    wire debounced;
    wire p_edge, n_edge, _edge;
    // Instantiate the debouncing module
    debouncing dut (
        .clk(clk),
        .reset_n(reset_n),
        .noisy(noisy),
        .timer_done(timer_done),
        .timer_reset(timer_reset),
        .debounced(debounced),
        .timer_flag(timer_flag)
    );
    
    edge_detector uut (
            .clk(clk),
            .reset_n(reset_n),
            .level(debounced),
            .p_edge(p_edge),
            .n_edge(n_edge),
            ._edge(_edge)
        );
    // Clock generation
    always #5 clk = ~clk;

    // Initial values
    initial begin
        clk = 0;
        reset_n = 0;
        noisy = 0;
        timer_done = 0;
        timer_flag = 0;

        // Reset to active system
        #10 reset_n = 1;
    
        //Test simulation for case 0 -> 1 
        #5 noisy = 0;
        #5 noisy = 1;
        #5 noisy = 0;
        #5 noisy = 1;
        #5 noisy = 0;
        //Debounce signal from the button
        #5 noisy = 1;
        #20 timer_done = 1;
        // At this point, the debounced output should remain low
        if (debounced == 0) $display("Test case 0->1 failed!");
        else if (debounced == 1) $display("Test case 0->1 successfully!");
        #10 timer_done = 0; 
        #20 noisy = 0;
        #5 noisy = 1;
        #5 noisy = 0;
        #5 noisy = 1;
        #5 noisy = 0;
        #20 timer_done = 1;
        // At this point, the debounced output should remain low
        if (debounced == 0) $display("Test case 1->0 failed!");
        else if (debounced == 1) $display("Test case 1->0 successfully!");
        #50;
        $finish;
    end

endmodule