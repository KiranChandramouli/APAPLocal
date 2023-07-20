*-----------------------------------------------------------------------------
* <Rating>-50</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE LAPAP.SUMATORIA.QR.PIN
***********************************************************
* esvalerio - 05/10/22
* SUMATORIA PARA LAS CUENTAS PARA EL TOPE DIARIO
***********************************************************
* 500 PESOS! Se ve mucho doc pero luego me lo vas agradecer
***********************************************************
**Errores Y.CAJJJ.ERROR
*1 Fatal error creating thread
*2 Cannot create JVM
*3 Cannot find class
*4 Unicode conversion error
*5 Cannot find method
*6 Cannot find object constructor
*7 Cannot instantiate object
*************************************************************

    $INSERT T24.BP I_EQUATE
    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_F.TELLER
    $INSERT T24.BP I_F.FUNDS.TRANSFER
    $INSERT T24.BP I_GTS.COMMON
    $INSERT T24.BP I_F.DATES
    $INSERT BP I_F.ST.LAPAP.TRANSACTION.QR.PIN

     IF (V$FUNCTION EQ "A" OR V$FUNCTION EQ "R") THEN 
         GOSUB LOAD.VARIABLES
         GOSUB INIT

     END 
     RETURN
   
LOAD.VARIABLES:
***************
    Y.CUENTA = R.NEW(FT.DEBIT.ACCT.NO)
    Y.MONTO = R.NEW(FT.CREDIT.AMOUNT)
    Y.MONTO.SUMATORIA = 0

    FN.TRANSACTION.QR.PIN = 'F.ST.LAPAP.TRANSACTION.QR.PIN'
    F.TRANSACTION.QR.PIN = ''
    R.TRANSACTION.QR.PIN = ''
    CALL OPF(FN.TRANSACTION.QR.PIN,F.TRANSACTION.QR.PIN)

    RETURN

**********************
READ.TRANSACTION.QR.PIN:
**********************

  R.TRANSACTION.QR.PIN = ''
  TRANSACTION.QR.PIN.ERR = ''
  CALL F.READ(FN.TRANSACTION.QR.PIN,Y.CUENTA,R.TRANSACTION.QR.PIN,F.TRANSACTION.QR.PIN,TRANSACTION.QR.PIN.ERR)
 
  RETURN
*--------------------------------------------------------------------------------------------------------

************************
INIT:
************************
    GOSUB PROCESS
    RETURN

************************
PROCESS:
************************

    GOSUB READ.TRANSACTION.QR.PIN

     IF R.TRANSACTION.QR.PIN THEN
        Y.MONTO.TRANSAC = R.TRANSACTION.QR.PIN<ST.LAP38.SUMATORIA.MONTO>
        
        IF V$FUNCTION EQ "R" THEN 
           Y.MONTO.SUMATORIA = Y.MONTO.TRANSAC - Y.MONTO
        END
        ELSE 
           Y.MONTO.SUMATORIA = Y.MONTO.TRANSAC + Y.MONTO
        END  
     END
     ELSE 
        Y.MONTO.SUMATORIA = Y.MONTO
     END  

    GOSUB GUARDAR.TRANSACTION.QR.PIN

    RETURN

***************************
GUARDAR.TRANSACTION.QR.PIN:
****************************
   Y.TRANS.ID = Y.CUENTA
   Y.APP.NAME = "ST.LAPAP.TRANSACTION.QR.PIN"
   Y.VER.NAME = Y.APP.NAME :",REGISTRO.QR.PIN"
   Y.FUNC = "I"
   Y.PRO.VAL = "PROCESS"
   Y.GTS.CONTROL = ""
   Y.NO.OF.AUTH = ""
   FINAL.OFS = ""
   OPTIONS = ""
   R.ACR = ""

   R.ACR<ST.LAP38.CUENTA> = Y.CUENTA
   R.ACR<ST.LAP38.SUMATORIA.MONTO> = Y.MONTO.SUMATORIA
   
   CALL OFS.BUILD.RECORD(Y.APP.NAME,Y.FUNC,Y.PRO.VAL,Y.VER.NAME,Y.GTS.CONTROL,Y.NO.OF.AUTH,Y.TRANS.ID,R.ACR,FINAL.OFS)
   CALL OFS.POST.MESSAGE(FINAL.OFS,'',"QR.PIN.WD",'')

RETURN

END 
