// foriage_scroll_6.0

int Nmax = 300 ; 
float CX[] = new float[Nmax+1] ; float CY[] = new float[Nmax+1] ; 
int LR[] = new int[Nmax+1] ; int EXT[] = new int[Nmax+1] ; 
int BN[] = new int[Nmax+1] ;
float Rmax[] = new float[Nmax+1] ; 
float Aone[] = new float[Nmax+1] ; float Azero[] = new float[Nmax+1] ;
float R = 0 ; int I = 0 ; int II = 0 ; float L = 0 ; int OKNG = 0 ; int MODE = 1 ;
float NX = 0 ; float NY = 0 ; float NRmax = 0 ; float RND = 0 ; int NN = 0 ; int Q = 0 ;
PImage img ; int CLR[] = new int[Nmax+1] ; int CLG[] = new int[Nmax+1] ; int CLB[] = new int[Nmax+1] ; 
int CLT[] = new int[Nmax+1] ;  int TR = 0 ; int TG = 0 ; int TB = 0 ;



void setup(){
  
  size(500,500) ;
  background(0,0,0) ;
  noStroke() ; fill(255,255,255) ;
  CX[0] = 300 ; CY[0] = 250 ; Rmax[0] = 50 ; LR[0] = +1 ; EXT[0] = 1 ; Azero[0] = -PI ; Aone[0] = Azero[0] ; 
  CX[1] = 200 ; CY[1] = 250 ; Rmax[1] = 50 ; LR[1] = +1 ; EXT[1] = 1 ; Azero[1] = 0 ; Aone[1] = Azero[1] ;
  CLR[0] = 125 ; CLG[0] = 125 ; CLB[0] = 125 ; CLR[1] = 125 ; CLG[1] = 125 ; CLB[1] = 125 ;
  CLT[0] = 7 ; CLT[1] = 7 ; 
  
} // setup()



void draw(){
  
  for ( I = 0 ; I <= Nmax ; I++ ){
    if ( EXT[I] == 1 ){
        R = Rmax[I] - ((Aone[I]-Azero[I])*LR[I]*3) ;
        fill(CLR[I],CLG[I],CLB[I]) ;
        ellipse(CX[I]+(R*cos(Aone[I])),CY[I]+(R*sin(Aone[I])),6,6) ;        
        if ( R > 5 ){ Aone[I] = Aone[I] + (0.05*LR[I]) ; }
        if ( LR[I] > 0 && abs(Azero[I]-Aone[I]) < (3*PI/2) ){ RND = random( Azero[I] , Aone[I] ) ; }
        if ( LR[I] < 0 && abs(Azero[I]-Aone[I]) < (3*PI/2) ){ RND = random( Aone[I] , Azero[I] ) ; }
        if ( LR[I] > 0 && abs(Azero[I]-Aone[I]) > (3*PI/2) ){ RND = random( Azero[I] , Azero[I]+(3*PI/2) ) ; }
        if ( LR[I] < 0 && abs(Azero[I]-Aone[I]) > (3*PI/2) ){ RND = random( Azero[I]-(3*PI/2) , Azero[I] ) ; }
        for ( II = 0 ; II <= Nmax ; II++ ){
          if ( EXT[II] == 0 ){ NN = II ; II = Nmax ; }
        }
        if ( EXT[NN] == 0 ){           
           NRmax = random(20,100) ;
           NX = CX[I] + ((Rmax[I]-((RND-Azero[I])*LR[I]*3)+NRmax)*cos(RND)) ;
           NY = CY[I] + ((Rmax[I]-((RND-Azero[I])*LR[I]*3)+NRmax)*sin(RND)) ;
           OKNG = 1 ;
           for ( II = 0 ; II <= Nmax ; II++ ){
             L = sqrt(((NX-CX[II])*(NX-CX[II]))+((NY-CY[II])*(NY-CY[II]))) ;
             if ( EXT[II] == 1 && II != I && L < NRmax+Rmax[II] ){ OKNG = 0 ; }
           } // II
           if ( NX < NRmax || NX > 500-NRmax || NY < NRmax || NY > 500-NRmax ){ OKNG = 0 ; }
           if ( OKNG == 1 ){ 
             EXT[NN] = 1 ;
             CX[NN] = NX ; CY[NN] = NY ; Rmax[NN] = NRmax ;
             Azero[NN] = RND + PI ; Aone[NN] = Azero[NN] ; 
             LR[NN] = LR[I] * (-1) ; BN[NN] = I ; 
             TR = int(CLT[I]/4) ; TG = int((CLT[I]-(TR*4))/2) ; TB = CLT[I]-(TR*4)-(TG*2) ; 
             CLR[NN] = CLR[I] ; CLG[NN] = CLG[I] ; CLB[NN] = CLB[I] ; 
             if ( TR == 1 && CLR[NN] < 245 ){ CLR[NN] = CLR[NN]+10 ; }
             if ( TG == 1 && CLG[NN] < 245 ){ CLG[NN] = CLG[NN]+10 ; }
             if ( TB == 1 && CLB[NN] < 245 ){ CLB[NN] = CLB[NN]+10 ; }
             if ( TR == 0 && CLR[NN] > 10 ){ CLR[NN] = CLR[NN]-10 ; }
             if ( TG == 0 && CLG[NN] > 10 ){ CLG[NN] = CLG[NN]-10 ; }
             if ( TB == 0 && CLB[NN] > 10 ){ CLB[NN] = CLB[NN]-10 ; }
             CLT[NN] = CLT[I] ; 
             if ( random(0,100) < 20 ){ CLT[NN] = int(random(1.00,7.99)) ; }
           } // OK
        } // EXT[NN] == 0
    } // EXT[I]==1
  } // 1<=I<=Nmax
  
  img = get() ;
  if ( MODE == 1 ){ image(img,0,1) ; }
  if ( MODE == 2 ){ image(img,1,0) ; }
  if ( MODE == 3 ){ image(img,0,-1) ; }
  if ( MODE == 4 ){ image(img,-1,0) ; }
  for ( II = 0 ; II < Nmax ; II++ ){
    if ( EXT[II] == 1 ){ 
      if ( MODE == 1 ){ CY[II] = CY[II] + 1 ; } 
      if ( MODE == 2 ){ CX[II] = CX[II] + 1 ; }
      if ( MODE == 3 ){ CY[II] = CY[II] - 1 ; } 
      if ( MODE == 4 ){ CX[II] = CX[II] - 1 ; }
      if ( CX[II] > 500+Rmax[II] ||  CY[II] > 500+Rmax[II] || CX[II] < -Rmax[II] || CY[II] < -Rmax[II] ){ EXT[II] = 0 ; }
    } 
  }
  
  Q = Q + 1 ; 
  if ( Q > 600 ){
    Q = 0 ; 
    if ( random(0,100) < 50 ){ MODE = MODE + 1 ; }else{ MODE = MODE - 1 ; }
    if ( MODE == 0 ){ MODE = 4 ; }
    if ( MODE == 5 ){ MODE = 1 ; }
  }
  
} // draw()
