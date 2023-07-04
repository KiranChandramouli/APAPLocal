* @ValidationCode : Mjo3NTM5MjIyODg6Q3AxMjUyOjE2ODEzODQ0Mzc4MTk6SVRTUzotMTotMToyOTA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 13 Apr 2023 16:43:57
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 290
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOEB
SUBROUTINE MB.V.SDB.AUTH.FT
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 12-APR-2023     Conversion tool    R22 Auto conversion       No changes
* 12-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.MB.SDB.CHARGES
    $INSERT I_F.FUNDS.TRANSFER

* PACS00514342 - Routine written for the mentioned issue - Since we have changed OFS.POST.MESSAGE instead of OGM in MB.SDB.POST
* we need to update the transaction reference in MB.SDB.CHARGES through version routine
* This routine needs to be attached in SDB CHARGES version

    IF (V$FUNCTION EQ 'R') THEN
        RETURN
    END

    GOSUB INIT.FILE
    GOSUB WRITE.FILE
RETURN

INIT.FILE:

    FN.MB.SDB.CHARGES = 'F.MB.SDB.CHARGES'
    F.MB.SDB.CHARGES = ''

    CALL OPF(FN.MB.SDB.CHARGES,F.MB.SDB.CHARGES)
    Y.DEBIT.REF = R.NEW(FT.DEBIT.THEIR.REF)
    Y.CREDIT.REF = R.NEW(FT.CREDIT.THEIR.REF)
    Y.SDB.CHG.ID = ID.COMPANY:".":Y.DEBIT.REF

    RETRY = "P"

    CALL F.READU(FN.MB.SDB.CHARGES,Y.SDB.CHG.ID,R.SDB.CHARGES,F.MB.SDB.CHARGES,ERR.CHG,RETRY)
RETURN

WRITE.FILE:

    IF R.SDB.CHARGES THEN
        TXN.REF = R.SDB.CHARGES<SDB.CHG.TXN.REF>
        LOCATE Y.CREDIT.REF IN TXN.REF<1,1>SETTING TXN.POS THEN
            Y.TXN.ID = R.SDB.CHARGES<SDB.CHG.TXN.REF,TXN.POS>
            R.SDB.CHARGES<SDB.CHG.TXN.REF,TXN.POS> = Y.TXN.ID:"-":ID.NEW
            CALL F.WRITE(FN.MB.SDB.CHARGES,Y.SDB.CHG.ID,R.SDB.CHARGES)
        END
    END

RETURN

END
