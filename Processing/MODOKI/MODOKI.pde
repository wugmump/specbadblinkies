// MODOKI_8.0

int Nmax = 500 ; int Cmax = 50 ;

float X[] = new float[Nmax] ; float Y[] = new float[Nmax] ; float A[] = new float[Nmax] ; int BN[] = new int[Nmax] ;
float R[] = new float[Nmax] ; int AGE[] = new int[Nmax] ; int J[] = new int[Nmax] ; int NC[] = new int[Nmax] ; int PM[] = new int[Nmax] ;

float dR[] = new float[Cmax] ; int AGEmax[] = new int[Cmax] ; float NA[][] = new float[Cmax][2] ;
float Rmax[] = new float[Cmax] ; int Jmax[] = new int[Cmax] ; int Cext[] = new int[Cmax] ; int Bage[] = new int[Cmax] ;

float KX ; float KY ; int KN ; 
int I ; int II ; int III ; float L ; int OKNG ; 

//OPC opc;


void setup(){
  
  size(320,200) ;
  
  //opc = new OPC(this, "127.0.0.1", 7890);

  //opc.ledGrid(0, 16, 10, width/2, height/2, 30, 30, 0, false, false);
  //opc.enableShowLocations = true;
  
  strokeWeight(2) ;
  stroke(255,255,255) ;
  noFill() ;
  
  X[0] = 350 ; Y[0] = 350 ; A[0] = 0 ; R[0] = 0.1 ; NC[0] = 0 ; BN[0] = 0 ; PM[0] = +1 ;
  dR[0] = 0.25 ; AGEmax[0] = 100 ; NA[0][0] = -0.1 ; NA[0][1] = +1.1 ; 
  Rmax[0] = 7.5 ; Jmax[0] = 5 ; Cext[0] = 1 ; Bage[0] = 20 ;
  
} // setup()



void draw(){
  
  background(0,0,0) ;
  
  for ( I = 0 ; I < Nmax ; I++ ){
    
    for ( II = I+1 ; II < Nmax ; II++ ){
      L = sqrt(((X[I]-X[II])*(X[I]-X[II]))+((Y[I]-Y[II])*(Y[I]-Y[II]))) ;
      if ( L < R[I]+R[II] && R[I] > 0 && R[II] > 0 ){
        X[I] = X[I] - ((X[II]-X[I])*(R[I]+R[II]-L)/L/3) ;
        Y[I] = Y[I] - ((Y[II]-Y[I])*(R[I]+R[II]-L)/L/3) ;
        X[II] = X[II] + ((X[II]-X[I])*(R[I]+R[II]-L)/L/3) ;
        Y[II] = Y[II] + ((Y[II]-Y[I])*(R[I]+R[II]-L)/L/3) ; 
      }
      if ( ( BN[I] == II || BN[II] == I ) && L > R[I]+R[II] && R[I] > 0 && R[II] > 0 ){
        X[I] = X[I] - ((X[II]-X[I])*(R[I]+R[II]-L)/L/3) ;
        Y[I] = Y[I] - ((Y[II]-Y[I])*(R[I]+R[II]-L)/L/3) ;
        X[II] = X[II] + ((X[II]-X[I])*(R[I]+R[II]-L)/L/3) ;
        Y[II] = Y[II] + ((Y[II]-Y[I])*(R[I]+R[II]-L)/L/3) ; 
      }
    } // II
    
    if ( X[I] < R[I] ){ X[I] = X[I] + ((R[I]-X[I])/3) ; }
    if ( X[I] > 700-R[I] ){ X[I] = X[I] - ((X[I]-700+R[I])/3) ; }
    if ( Y[I] < R[I] ){ Y[I] = Y[I] + ((R[I]-Y[I])/3) ; }
    if ( Y[I] > 700-R[I] ){ Y[I] = Y[I] - ((Y[I]-700+R[I])/3) ; }
    
    if ( R[I] > 0 ){
      AGE[I] = AGE[I] + 1 ; 
      if ( AGE[I] < AGEmax[NC[I]] && R[I] < Rmax[NC[I]] ){ R[I] = R[I] + dR[NC[I]] ; }
                               else{ R[I] = R[I] - dR[NC[I]] ; }
      if ( R[I] <= 0 ){ 
        for ( II = 0 ; II < Nmax ; II++ ){
          if ( BN[II] == I ){ BN[II] = II ; }
        }
      }
      if ( AGE[I] == Bage[NC[I]] ){ glow() ; }
    } // R[I] > 0
    
    if ( R[I] > 0 ){ 
      ellipse(X[I],Y[I],2*R[I],2*R[I]) ; 
      if ( BN[I] != I && R[BN[I]] > 0 ){ line(X[I],Y[I],X[BN[I]],Y[BN[I]]) ; }
    }
    
  } // I
  
  for ( I = 0 ; I < Cmax ; I++ ){ Cext[I] = 0 ; }
  for ( I = 0 ; I < Nmax ; I++ ){ if ( R[I] > 0 ){ Cext[NC[I]] = 1 ; } }
  
} // draw()



void glow(){
  
  III = 0 ; OKNG = 0 ; 
  while( III < Nmax && OKNG == 0 ){
    if ( R[III] <= 0 ){ KN = III ; OKNG = 1 ; }
                  else{ III = III + 1 ; }
  }
  
  if ( OKNG == 1 ){
    KX = X[I] + ((R[I]+0.1)*cos(A[I]+(NA[NC[I]][0]*PM[I]))) ;
    KY = Y[I] + ((R[I]+0.1)*sin(A[I]+(NA[NC[I]][0]*PM[I]))) ;
    for ( III = 0 ; III < Nmax ; III++ ){
       L = sqrt(((KX-X[III])*(KX-X[III]))+((KY-Y[III])*(KY-Y[III]))) ;
       if ( R[III] > 0 && III != I && L < R[III]+0.1 ){ OKNG = 0 ; }
    }
    if ( KX < 0 ){ OKNG = 0 ; }
    if ( KX > 700 ){ OKNG = 0 ; }
    if ( KY < 0 ){ OKNG = 0 ; }
    if ( KY > 700 ){ OKNG = 0 ; }
    if ( OKNG == 1 ){
      X[KN] = KX ; Y[KN] = KY ; R[KN] = 0.1 ;
      A[KN] = A[I] + (NA[NC[I]][0]*PM[I]) ;
      AGE[KN] = 0 ; NC[KN] = NC[I] ; 
      BN[KN] = I ; PM[KN] = PM[I] ;
      if ( J[I] < Jmax[NC[I]] ){ J[KN] = J[I] + 1 ; }
                           else{ J[KN] = 0 ; }
    }
  }
  
  if ( J[I] == Jmax[NC[I]] ){
   
    III = 0 ; OKNG = 0 ; 
    while( III < Nmax && OKNG == 0 ){
      if ( R[III] <= 0 ){ KN = III ; OKNG = 1 ; }
                    else{ III = III + 1 ; }
    }
  
    if ( OKNG == 1 ){
      KX = X[I] + ((R[I]+0.1)*cos(A[I]+(NA[NC[I]][1])*PM[I])) ;
      KY = Y[I] + ((R[I]+0.1)*sin(A[I]+(NA[NC[I]][1])*PM[I])) ;
      for ( III = 0 ; III < Nmax ; III++ ){
         L = sqrt(((KX-X[III])*(KX-X[III]))+((KY-Y[III])*(KY-Y[III]))) ;
         if ( R[III] > 0 && III != I && L < R[III]+0.1 ){ OKNG = 0 ; }
      }
      if ( KX < 0 ){ OKNG = 0 ; }
      if ( KX > 700 ){ OKNG = 0 ; }
      if ( KY < 0 ){ OKNG = 0 ; }
      if ( KY > 700 ){ OKNG = 0 ; }
      if ( OKNG == 1 ){
        X[KN] = KX ; Y[KN] = KY ; R[KN] = 0.1 ;
        A[KN] = A[I] + (NA[NC[I]][1]*PM[I]) ;
        AGE[KN] = 0 ; NC[KN] = NC[I] ; 
        BN[KN] = I ;
        J[KN] = 0 ; 
        PM[KN] = PM[I] * (-1) ;
        if ( random(0,100) > 80 ){ mutation() ; }
      }
    }
    
  }
  
} // glow



void mutation(){
  
  OKNG = 0 ; III = 0 ;
  while( III < Cmax && OKNG == 0 ){
    if ( Cext[III] == 0 ){ OKNG = 1 ; }
                     else{ III = III + 1 ; }
  }
  
  if ( OKNG == 1 ){
    dR[III] = dR[NC[KN]] ;
    AGEmax[III] = AGEmax[NC[KN]] ;
    NA[III][0] = NA[NC[KN]][0] ;
    NA[III][1] = NA[NC[KN]][1] ;
    Rmax[III] = Rmax[NC[KN]] ;
    Jmax[III] = Jmax[NC[KN]] ;
    Bage[III] = Bage[NC[KN]] ;
    NC[KN] = III ;
    Cext[III] = 1 ;
    if ( random(0,100) > 90 ){ dR[III] = random(0.01,0.50) ; }
    if ( random(0,100) > 90 ){ AGEmax[III] = int(random(10,500)) ; }
    if ( random(0,100) > 90 ){ NA[III][0] = random(-PI,+PI) ; }
    if ( random(0,100) > 90 ){ NA[III][1] = random(-PI,+PI) ; }
    if ( random(0,100) > 90 ){ Rmax[III] = random(1,50) ; }
    if ( random(0,100) > 90 ){ Jmax[III] = int(random(2,20)) ; }
    if ( random(0,100) > 90 ){ Bage[III] = int(random(1,AGEmax[III])) ; }
  }
  
} // mutation()
