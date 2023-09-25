* @ValidationCode : MjotNTY5OTI3MzE5OkNwMTI1MjoxNjg5MzEwNzM5OTIyOklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 14 Jul 2023 10:28:59
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
* Limpieza de DEBIT.DIRECT - 2da Fase - Proyecto COVID19
* Fecha: 31/03/2020
* Autor: Oliver Fermin
*----------------------------------------

SUBROUTINE LAPAP.DEBIT.DIRECT.COVID19.POST
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE                  
* 13-JULY-2023      Harsha                R22 Auto Conversion  - FM to @FM
* 13-JULY-2023      Harsha                R22 Manual Conversion - BP removed from Inserts

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_TSA.COMMON
    $INSERT I_F.AA.PAYMENT.SCHEDULE
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_LAPAP.DEBIT.DIRECT.COVID19.COMO

    GOSUB PROCESS
    GOSUB CREAR.ARCHIVO.DMT
    GOSUB CREAR.ARCHIVO.VERIFICACION

RETURN

PROCESS:
*******

    Y.ARREGLO.VALIDACION.OUT<-1> = "ARRANGEMENT|PRESTAMO|PRODUCTO|L.AA.PAY.METHOD|L.AA.DEBT.AC"

    SEL.CMD  = ''; NO.OF.RECS = ''; F.CHK.DIR = "" ; SEL.LIST= ''
    SEL.CMD = " SELECT " : FN.LAPAP.DEBIT.DIRECT.COVID19
    CALL EB.READLIST(SEL.CMD, SEL.LIST, '',NO.OF.RECS,SEL.ERR)

    LOOP
        REMOVE Y.ID.RECORD FROM SEL.LIST SETTING REGISTRO.POS
    WHILE Y.ID.RECORD  DO
        CALL F.READ(FN.LAPAP.DEBIT.DIRECT.COVID19,Y.ID.RECORD,R.LAPAP.DEBIT.DIRECT.COVID19,F.LAPAP.DEBIT.DIRECT.COVID19,ERROR.DEBIT)
        Y.ID = Y.ID.RECORD
        Y.ID = CHANGE(Y.ID,'*',@FM)
        BEGIN CASE
            CASE Y.ID<2> EQ 'VALIDATION.FILE'
                Y.ARREGLO.VALIDACION.OUT<-1> = R.LAPAP.DEBIT.DIRECT.COVID19
            CASE Y.ID<2> EQ 'DMT.FILE'
                Y.ARREGLO.DMT.OUT<-1> = R.LAPAP.DEBIT.DIRECT.COVID19
            CASE 1
                Y.VALOR = "NO REGISTRO"
        END CASE
    REPEAT

    GOSUB CREAR.ARCHIVO.VERIFICACION
    GOSUB CREAR.ARCHIVO.DMT

RETURN


CREAR.ARCHIVO.VERIFICACION:
**************************

    R.FIL = ''; READ.FIL.ERR = ''
    CALL F.READ(FN.CHK.DIR1,Y.ARCHIVO.VALIDACION.OUT,R.FIL,F.CHK.DIR1,READ.FIL.ERR)

    IF R.FIL THEN
        DELETE F.CHK.DIR1,Y.ARCHIVO.VALIDACION.OUT
    END

    WRITE Y.ARREGLO.VALIDACION.OUT ON F.CHK.DIR1,Y.ARCHIVO.VALIDACION.OUT ON ERROR
        CALL OCOMO("Error en la escritura del archivo en el directorio":F.CHK.DIR1)
    END

RETURN

CREAR.ARCHIVO.DMT:
******************

    R.FIL = ''; READ.FIL.ERR = ''
    CALL F.READ(FN.CHK.DIR1,Y.ARCHIVO.NOMBRE.DMT.OUT,R.FIL,F.CHK.DIR1,READ.FIL.ERR)

    IF R.FIL THEN
        DELETE F.CHK.DIR1,Y.ARCHIVO.NOMBRE.DMT.OUT
    END

    WRITE Y.ARREGLO.DMT.OUT ON F.CHK.DIR1,Y.ARCHIVO.NOMBRE.DMT.OUT ON ERROR
        CALL OCOMO("Error en la escritura del archivo en el directorio":F.CHK.DIR1)
    END

RETURN

END
