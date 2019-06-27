logic reset;
enum logic[2:0] {LIMPADOR_DESLIGADO,Q1,Q2,Q3,LIPADOR_BAIXO,LIMPADOR_ALTO} estado;
logic[5:0] chuva;
logic[1:0] parabrisa;
logic clk_1;
always_ff @(posedge clk_2) clk_1 = ~clk_1;
always_comb begin
    reset <= SWI[6];
    chuva <= SWI[5:0];
end

always_ff @(posedge clk_1) begin
    if(reset) begin
        estado <= LIMPADOR_DESLIGADO;
        parabrisa <= 0;
    end
    else begin
        unique case(estado)
            LIMPADOR_DESLIGADO : begin 
            if((chuva[0]+chuva[1]+chuva[2]+chuva[3]+chuva[4]+chuva[5]) == 3) begin
                estado <= Q1;

            end
            else if((chuva[0]+chuva[1]+chuva[2]+chuva[3]+chuva[4]+chuva[5]) == 5) begin
                estado <= Q3;
            end
            end
            Q1: begin
                if((chuva[0]+chuva[1]+chuva[2]+chuva[3]+chuva[4]+chuva[5]) == 3) begin
                estado <= Q2;
            end
            else if((chuva[0]+chuva[1]+chuva[2]+chuva[3]+chuva[4]+chuva[5]) == 5) begin
                estado <= Q3;
            end
            end
            Q2: begin
                if((chuva[0]+chuva[1]+chuva[2]+chuva[3]+chuva[4]+chuva[5]) >= 3) begin
                estado <= LIPADOR_BAIXO;
                parabrisa <= 1;
            end
                else if((chuva[0]+chuva[1]+chuva[2]+chuva[3]+chuva[4]+chuva[5]) == 5) begin
                estado <= Q3;
            end
            end
            LIPADOR_BAIXO:
                if((chuva[0]+chuva[1]+chuva[2]+chuva[3]+chuva[4]+chuva[5]) < 2) begin
               		estado <= LIMPADOR_DESLIGADO;
                	parabrisa <= 0;
            	end
		else if ((chuva[0]+chuva[1]+chuva[2]+chuva[3]+chuva[4]+chuva[5]) == 5) begin
			estado <= Q3;
		end
            Q3: begin
                if((chuva[0]+chuva[1]+chuva[2]+chuva[3]+chuva[4]+chuva[5]) == 5) begin
                estado <= LIMPADOR_ALTO;
                parabrisa <= 2;
            end
            end
            LIMPADOR_ALTO: begin
                if((chuva[0]+chuva[1]+chuva[2]+chuva[3]+chuva[4]+chuva[5]) < 4) begin
                estado <= LIPADOR_BAIXO;
                parabrisa <= 1;
            end
            end
        endcase
    end
end

always_comb begin
    SEG[7] <= clk_1;
    LED[1:0] <= parabrisa;
end

