* @ValidationCode : MjotMTcyMzc2Mjk2NjpDcDEyNTI6MTY4OTIzMTAwMjg0NzpJVFNTOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 13 Jul 2023 12:20:02
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
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
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE LAPAP.CONTROL.ESTADOS.RT(HOLD.ID)

*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE                  
* 20-JULY-2023      Harsha                R22 Auto Conversion  - No changes
* 20-JULY-2023      Harsha                R22 Manual Conversion - BP removed from Inserts 

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_F.ST.LAPAP.CONTROL.ESTADOS
    $INSERT I_F.HOLD.CONTROL
    $INSERT I_CONTROL.ESTADOS.COMMON

    GOSUB OPERAR
RETURN

OPERAR:
    BEGIN CASE
        CASE CONTROL.LIST<1,1> EQ "SELECT.HC"
            CALL F.READ(FN.HC,HOLD.ID,R.HOLD, FV.HC, HC.ERR)

            R.CE = ''
            R.CE<ST.LAPCE.REPORT.NAME> = R.HOLD<HCF.REPORT.NAME>
            R.CE<ST.LAPCE.COMPANY.ID> = R.HOLD<HCF.COMPANY.ID>
            R.CE<ST.LAPCE.DATE.CREATED> = R.HOLD<HCF.DATE.CREATED>
            R.CE<ST.LAPCE.TIME.CREATED> = R.HOLD<HCF.TIME.CREATED>
            R.CE<ST.LAPCE.RUN.IN.BATCH> = R.HOLD<HCF.RUN.IN.BATCH>
            R.CE<ST.LAPCE.BATCH.DATE.TIME> = R.HOLD<HCF.BATCH.DATE.TIME>
            R.CE<ST.LAPCE.BANK.DATE> = R.HOLD<HCF.BANK.DATE>
            R.CE<ST.LAPCE.CUSTOMER.NO> = R.HOLD<HCF.CUSTOMER.NO>
            R.CE<ST.LAPCE.ACCOUNT.NO> = R.HOLD<HCF.ACCOUNT.NO>
            R.CE<ST.LAPCE.USER> = R.HOLD<HCF.USER>
            R.CE<ST.LAPCE.CARRIER.ADDR.NO> = R.HOLD<HCF.CARRIER.ADDR.NO>
            IF R.CE NE '' THEN
                CALL OCOMO("ESCRIBIENDO: " : HOLD.ID)
                CALL F.WRITE(FN.CE, HOLD.ID, R.CE)
                CALL JOURNAL.UPDATE(HOLD.ID)
            END

        CASE CONTROL.LIST<1,1> EQ "SELECT.EC"
            CALL OCOMO("BORRANDO: " : HOLD.ID)
            CALL F.DELETE(FN.ES,HOLD.ID)
            CALL F.DELETE(FN.CE,HOLD.ID)

    END CASE


RETURN

END
