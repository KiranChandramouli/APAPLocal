* @ValidationCode : MjotNTk2MzU1OTg2OkNwMTI1MjoxNjkwMTY3NTI1NDI5OklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIyX1NQNS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 24 Jul 2023 08:28:45
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* <Rating>18</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE L.APAP.ACTUALIZAR.PRELACION(Y.ARREGLO.VALUES)
*-----------------------------------------------------------------------------
*---------------------------------------------------------------------------------------
*MODIFICATION HISTORY:
*DATE          WHO                 REFERENCE               DESCRIPTION

*13-07-2023    AJITHKUMAR S        R22 MANUAL CONVERSION    T24.BP,BP is Removed,CALL RTN FORMAT CAN BE CAHNGED , INSERT FILE MODIFIED
*----------------------------------------------------------------------------------------
    $INSERT  I_COMMON
    $INSERT  I_EQUATE
    $INSERT  I_BATCH.FILES ;*R22 MANUAL CONVERSION
    $INSERT  I_TSA.COMMON
    $INSERT  I_F.AA.ARRANGEMENT.ACTIVITY
    $INSERT  I_F.FUNDS.TRANSFER
    $INSERT  I_F.AA.PAYMENT.SCHEDULE ;*R22 MANUAL CONVERSION
    $INSERT   I_F.ST.L.APAP.PRELACION.COVI19.DET
    $INSERT  I_F.ST.L.APAP.COVI.PRELACIONIII
    $INSERT  I_L.APAP.ACTUALIZAR.PRELACION.COMMON ;*R22 MANUAL CONVERSION


    GOSUB PROCESS
RETURN


PROCESS:
    Y.ARREGLO = Y.ARREGLO.VALUES
    Y.ARREGLO  = CHANGE(Y.ARREGLO,"*",@FM)
    Y.ARR.ID = Y.ARREGLO<2>
    Y.AAA.ID = Y.ARREGLO<1>
    CALL F.READ(FN.L.APAP.COVI.PRELACIONIII,Y.ARR.ID,R.L.APAP.COVI.PRELACIONIII,FV.L.APAP.COVI.PRELACIONIII,ERROR.COVID)
    GOSUB SET.ACTIVIDAD
RETURN

SET.ACTIVIDAD:
    Y.INTERES = '';
* CALL L.APAP.MONTO.SOLO.COVID.PR(Y.AAA.ID,Y.INTERES)
    APAP.LAPAP.lApapMontoSoloCovidPr(Y.AAA.ID,Y.INTERES);*r22 MANUAL CODE CONVERSION
    IF Y.INTERES EQ 0 THEN
        RETURN
    END
    GOSUB DELETE.DETAILS.PRELACION
* CALL L.APAP.SET.PAY.COVID.IN(Y.AAA.ID)
    
    APAP.LAPAP.lApapSetPayCovidIn(Y.AAA.ID) ;*r22 MANUAL CODE CONVERSION

RETURN

DELETE.DETAILS.PRELACION:
    Y.CONTRATO = R.L.APAP.COVI.PRELACIONIII<ST.L.A76.CONTRATO>
    SEL.CMD.DET = "SELECT ":FN.L.APAP.PRELACION.COVI19.DET:" WITH CONTRATO EQ ":Y.CONTRATO
    CALL EB.READLIST(SEL.CMD.DET,SEL.LIST.DET,"",NO.OF.RECS.DET,ERROR.DET)
    LOOP
        REMOVE Y.ID FROM SEL.LIST.DET SETTING AAA.DET.POS
    WHILE Y.ID : AAA.DET.POS
        CALL F.READ(FN.L.APAP.PRELACION.COVI19.DET,Y.ID,R.L.APAP.PRELACION.COVI19.DET,FV.L.APAP.PRELACION.COVI19.DET,ERRO.DET)
        IF NOT (R.L.APAP.PRELACION.COVI19.DET) THEN
            CONTINUE
        END
        IF Y.ID[1,2] EQ 'FT' THEN
            SEL.CMD.AAA = ''; SEL.LIST.AAA = ''; NO.OF.RECS.AAA = ''; ERROR.AAA = '';
            SEL.CMD.AAA = "SELECT ":FN.AAA: " WITH ARRANGEMENT EQ ":Y.ARR.ID: " AND TXN.CONTRACT.ID EQ ":Y.ID
            CALL EB.READLIST(SEL.CMD.AAA,SEL.LIST.AAA,"",NO.OF.RECS.AAA,ERROR.AAA)
            LOOP
                REMOVE Y.RECORD.ID FROM SEL.LIST.AAA SETTING AAA.POST
            WHILE Y.RECORD.ID : AAA.POST
                CALL F.READ (FN.AAA,Y.RECORD.ID,R.AAA,FV.AAA,ERROR.AAA.2)
                Y.VALOR = R.AAA<AA.ARR.ACT.TXN.AMOUNT>
                IF R.AAA<AA.ARR.ACT.TXN.AMOUNT> EQ 0 THEN
                    CALL F.DELETE(FN.L.APAP.PRELACION.COVI19.DET, Y.ID)
                END

            REPEAT
        END

    REPEAT

RETURN


END
