`timescale 1ns / 1ps

module mult(

    input [31:0] sayi1,
    input [31:0] sayi2,
    input clk,
    input reset,
    output reg [31:0] sonuc
    );
    
    localparam EXPONENT = 7'b1111111;
    
    reg [7:0]sumofex;
    reg [9:0]sumofexpo2;
    reg [7:0] ex1;
    reg [7:0] ex2;
    reg [23:0]t1;
    reg [23:0]t2;
    reg [48:0]temp;
    reg a;
    reg [5:0]ctr;
    reg signofexponent1;
    reg signofexponent2;
    reg signofsumofex;
    initial begin
    a= 1'b1;
    ctr=6'b110001;
    signofexponent1 = 1'b0;
    signofexponent2 = 1'b0;
    signofsumofex = 1'b0;
    end
    always@(*) begin//always@(*clk,reset) begin
    
      sonuc[31] = sayi1[31]*sayi2[31];//sayilarin soldan ilk bitlerinin carpimi sonucun da soldan ilk bitini verir yani isaret biti
    
      if(sayi1[30:23] >=EXPONENT)begin
        ex1 = sayi1[30:23]- EXPONENT ;//birinci sayinin exponent kisminden 127yi cikararak kaydirma sayisini 2^x olarak buluruz yani buldugumuz x olur.
      end
    
      else begin//127den kucuk ise 
         ex1 = EXPONENT - sayi1[30:23] ;// 127den birinci sayinin exponent kismini cikararak kaydirma sayisini 2^x olarak buluruz yani buldugumuz x olur.
         signofexponent1 = 1'b1;//negatif exponenti burada tutariz
      end
      
    //Ayni islemler sayi iki icin de yapilir
       if(sayi2[30:23] >=EXPONENT)begin
         ex2 = sayi2[30:23]- EXPONENT ;
       end
       else begin
          ex2 = EXPONENT - sayi2[30:23]  ;
          signofexponent2 = 1'b1;
       end
       
    //exponentler isaretlerine gore toplanir
      if(signofexponent1 == 1'b0 & signofexponent2 == 1'b0   )begin
         sumofex = ex1+ex2;
         signofsumofex=1'b0;
      end
      
      else if(signofexponent1 == 1'b1 & signofexponent2 == 1'b1   )begin
         sumofex = ex1+ex2;
         signofsumofex=1'b1;
      end
      
      else if(signofexponent1 == 1'b0 & signofexponent2 == 1'b1   )begin
          if(ex1>ex2)begin
                 sumofex = ex1-ex2;
                 signofsumofex=1'b0;
      end
      
          else begin//ex1<ex2
                sumofex = ex2-ex1;
                signofsumofex=1'b1;
          end
      end
    
      else if(signofexponent1 == 1'b1 & signofexponent2 == 1'b0   )begin
           if(ex1>ex2)begin
                sumofex = ex1-ex2;
                signofsumofex=1'b1;
           end
           else begin//ex1<ex2
        sumofex = ex2-ex1;
        signofsumofex=1'b0;
           end
         end
         
    //sumofexe ondalikli iki sayinin carpimindan ileri gelmesi beklenen arti bir burada eklenmistir     
        if(signofsumofex == 1'b0)begin
          sumofex = sumofex+1;
         end
    
        else begin
          sumofex = sumofex-1;
        end
        
        //yeni sayinin exponent kismi isaretine gore 127 ile isleme alinarak bulunur
        
        if(signofsumofex == 1'b0)begin
             sonuc[30:23]= sumofex+7'b1111111 ;
        end
        
         else begin //signofsumofex == 1'b1 negatif
           sonuc[30:23]= sumofex+7'b1111111-sumofex ;
          end
          
      //burada sayilarin mantissalari basa gelen 1 ile 1.111 gibi bir donusume sokulur    
      t1[23]=1'b1;
      t1[22:0]= sayi1[22:0];
      t2[23]=1'b1;
      t2[22:0]= sayi2[22:0];
      
         
      temp = t1 * t2 ;//sayi1_s*sayi2_s bu satirla yapilir
   
    while(a==1'b0)begin//soldaki ilk bir bulunur boylece o birden sonrasi mantissaya eklenir
    if(temp[ctr]==1'b1)begin
    a=1'b0;
    end
    temp[ctr] = temp[ctr]-1 ;
    end
    temp[ctr] = temp[ctr]+1 ;
    sonuc[30:23]= sumofex;
    sonuc[22:0]= temp[(ctr)-:23];
    
    if(reset == 1'b1 )begin
     sumofex =0;
     sumofexpo2 = 0;
     ex1 = 0;
     ex2 = 0;
     t1 = 0;
     t2 = 0;
     temp = 0;
     a = 0;
     ctr = 0;
     signofexponent1 = 0;
     signofexponent2 = 0;
     signofsumofex = 0;
    
    
    end 
    end
   

     

    
    //sayi1*sayi2=(sayi1_s*sayi2_s)*2**(sayi1_ex+sayi2_ex) videodaki formulune gore implement ettim
endmodule
