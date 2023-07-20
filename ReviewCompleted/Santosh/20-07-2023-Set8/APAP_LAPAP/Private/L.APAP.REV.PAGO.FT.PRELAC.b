* @ValidationCode : MjoyMzgyNjM1ODQ6Q3AxMjUyOjE2ODkyNTA5MTA5NjY6SGFyaXNodmlrcmFtQzotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 13 Jul 2023 17:51:50
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
*-----------------------------------------------------------------------------
* <Rating>-40</Rating>
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 13-07-2023     Conversion tool    R22 Auto conversion       No changes
* 13-07-2023     Harishvikram C   Manual R22 conversion       BP Removed
*-----------------------------------------------------------------------------
SUBROUTINE L.APAP.REV.PAGO.FT.PRELAC(ID.FT)
    $INSERT  I_COMMON
    $INSERT  I_EQUATE
    $INSERT  I_F.FUNDS.TRANSFER
    $INSERT  I_F.ST.L.APAP.PRELACION.COVI19.DET
    $INSERT  I_F.ST.L.APAP.COVI.PRELACIONIII
    $INSERT  I_L.APAP.REV.PAGO.FT.PRELAC.COMMON

    GOSUB MAIN.PROCESS

RETURN

MAIN.PROCESS:
    Y.FT.ID = ID.FT
    GOSUB READ.FT
    IF Y.RECORD.STATUS EQ 'REVE' AND Y.CURR.NO EQ '2' THEN
        GOSUB READ.ST.L.APAP.PRELACION.COVI19.DET
        GOSUB SET.PRELACION

    END
RETURN


READ.FT:
    CALL EB.READ.HISTORY.REC(F.FUNDS.TRANSFER$HIS, Y.FT.ID, R.FUNDS.TRANSFER$HIS,ERROR.FUNDS.TRANSFER$HIS)
    Y.RECORD.STATUS = R.FUNDS.TRANSFER$HIS<FT.RECORD.STATUS>
    Y.CURR.NO =   R.FUNDS.TRANSFER$HIS<FT.CURR.NO>
RETURN

READ.ST.L.APAP.PRELACION.COVI19.DET:

    CALL F.READ(FN.ST.L.APAP.PRELACION.COVID19.DET,ID.FT,R.L.APAP.PRELACION.COVID19.DET,FV.ST.L.APAP.PRELACION.COVID19.DET,Y.ERROR)
    Y.ESTADO = R.L.APAP.PRELACION.COVID19.DET<ST.L.A64.ESTADO>
    Y.MONTO.COVID19 = R.L.APAP.PRELACION.COVID19.DET<ST.L.A64.MONTO.COVI19>
    Y.ARRANGEMENT.ID = R.L.APAP.PRELACION.COVID19.DET<ST.L.A64.ARRANGEMENT>
    Y.MONTO.CUOTA.PR = R.L.APAP.PRELACION.COVID19.DET<ST.L.A64.MONTO.CUOTA>
RETURN

SET.PRELACION:
    IF Y.ESTADO EQ 'CURR' THEN
        CALL F.READ(FN.ST.L.APAP.COVID.PRELACIONIII,Y.ARRANGEMENT.ID,R.ST.L.APAP.COVID.PRELACIONIII,FV.ST.L.APAP.COVID.PRELACIONIII,Y.ERROR1)
        IF (R.ST.L.APAP.COVID.PRELACIONIII) THEN
            IF R.ST.L.APAP.COVID.PRELACIONIII<ST.L.A76.MONTO.COVI19> LE 0 AND Y.MONTO.CUOTA.PR GT 0 AND R.ST.L.APAP.COVID.PRELACIONIII<ST.L.A76.ESTADO> EQ 'PROCESADO' THEN
                R.ST.L.APAP.COVID.PRELACIONIII<ST.L.A76.ESTADO> = "";
            END
            R.ST.L.APAP.COVID.PRELACIONIII<ST.L.A76.MONTO.COVI19> = R.ST.L.APAP.COVID.PRELACIONIII<ST.L.A76.MONTO.COVI19> + Y.MONTO.CUOTA.PR

            CALL F.LIVE.WRITE(FN.ST.L.APAP.COVID.PRELACIONIII,Y.ARRANGEMENT.ID,R.ST.L.APAP.COVID.PRELACIONIII)
            R.L.APAP.PRELACION.COVID19.DET<ST.L.A64.ESTADO> = 'REVE'
            CALL  F.WRITE(FN.ST.L.APAP.PRELACION.COVID19.DET,ID.FT,R.L.APAP.PRELACION.COVID19.DET)

        END
    END
RETURN

END
