SUBROUTINE LAPAP.MIGRACION.COVI.POST

*-----------------------------------------------------------------------------

*MODIFICATION HISTORY:

*

* DATE              WHO                REFERENCE                 DESCRIPTION

* 21-APR-2023     Conversion tool    R22 Auto conversion       FM to @FM

*-----------------------------------------------------------------------------
    
    $INSERT I_COMMON ;*R22 Auto conversion - START
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_TSA.COMMON
    $INSERT I_F.AA.BILL.DETAILS
    $INSERT I_F.AA.PAYMENT.SCHEDULE
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.AA.ACCOUNT.DETAILS ;*R22 Auto conversion - END


    GOSUB MAIN.PROCESS

RETURN

MAIN.PROCESS:
    GOSUB OPEN.FILES
    GOSUB PROCESS

RETURN



OPEN.FILES:
    FN.L.APAP.CONVI.MIG = "F.L.APAP.CONVI.MIG"
    FV.L.APAP.CONVI.MIG = ""
    CALL OPF (FN.L.APAP.CONVI.MIG,FV.L.APAP.CONVI.MIG)

    Y.PARTE1.ARCHIVO.GRUPO.A = ""
    Y.PARTE1.ARCHIVO.GRUPO.B = ""
    Y.SEGUNDO.ARCHIVO.GRUPO.A = ""
    Y.SEGUNDO.ARCHIVO.GRUPO.B = ""
***directorio de salidad
    FN.CHK.DIR1 = "DMFILES"
    F.CHK.DIR1 = ""
    CALL OPF(FN.CHK.DIR1,F.CHK.DIR1)

RETURN

PROCESS:
    SEL.CMD  = ''; NO.OF.RECS = ''; F.CHK.DIR = "" ; SEL.LIST= ''
    SEL.CMD = " SELECT " : FN.L.APAP.CONVI.MIG
    CALL EB.READLIST(SEL.CMD, SEL.LIST, '',NO.OF.RECS,SE L.ERR)

    LOOP
        REMOVE Y.ID.RECORD FROM SEL.LIST SETTING REGISTRO.POS
    WHILE Y.ID.RECORD  DO
        CALL F.READ(FN.L.APAP.CONVI.MIG,Y.ID.RECORD,R.L.APAP.CONVI.MIG,FV.L.APAP.CONVI.MIG,ERROR.MIGR)
        Y.ID = Y.ID.RECORD
        Y.ID = CHANGE(Y.ID,'*',@FM)
        BEGIN CASE
            CASE Y.ID<2> EQ 'GRUPO1A'
                Y.PARTE1.ARCHIVO.GRUPO.A<-1> = R.L.APAP.CONVI.MIG
            CASE Y.ID<2> EQ 'GRUPO1B'
                Y.PARTE1.ARCHIVO.GRUPO.B<-1> = R.L.APAP.CONVI.MIG
            CASE Y.ID<2> EQ 'GRUPO2A'
                Y.SEGUNDO.ARCHIVO.GRUPO.A<-1> = R.L.APAP.CONVI.MIG
            CASE Y.ID<2> EQ 'GRUPO2B'
                Y.SEGUNDO.ARCHIVO.GRUPO.B<-1> = R.L.APAP.CONVI.MIG
            CASE 1
                Y.VALOR = "NO REGISTRO"
        END CASE
    REPEAT
****Generacion de archivo grupo A cuota pagada  constante
    Y.FILE.NAME = 'CUOTA.PAGADA.CONSTANTE.txt'
    Y.ARREGLO = Y.PARTE1.ARCHIVO.GRUPO.A
    GOSUB CHECK.ARCHIVO.FILES

***Generacion de archivo grupo B cuota pagada solo interes
    Y.FILE.NAME = 'CUOTA.PAGADA.SOLO.INTERES.txt'
    Y.ARREGLO = Y.PARTE1.ARCHIVO.GRUPO.B
    GOSUB CHECK.ARCHIVO.FILES

***Generacion archivo fase 2 grupo A cuota pagada solo interes
    Y.FILE.NAME = 'CUOTA.SINPAGAR.CONSTANTE.txt'
    Y.ARREGLO =  Y.SEGUNDO.ARCHIVO.GRUPO.A
    GOSUB CHECK.ARCHIVO.FILES

***Generacion archivo fase 2 grupo B cuota pagada solo interes
    Y.FILE.NAME = 'CUOTA.SINPAGAR.SOLO.INTERES.txt'
    Y.ARREGLO = Y.SEGUNDO.ARCHIVO.GRUPO.B
    GOSUB CHECK.ARCHIVO.FILES

RETURN

CHECK.ARCHIVO.FILES:
    R.FIL = ''; READ.FIL.ERR = ''
    CALL F.READ(FN.CHK.DIR1,Y.FILE.NAME,R.FIL,F.CHK.DIR1,READ.FIL.ERR)
    IF R.FIL THEN
        DELETE F.CHK.DIR1,Y.FILE.NAME
    END
    WRITE Y.ARREGLO ON F.CHK.DIR1, Y.FILE.NAME ON ERROR
        CALL OCOMO("Error en la escritura del archivo en el directorio":F.CHK.DIR1)
    END
RETURN

END
