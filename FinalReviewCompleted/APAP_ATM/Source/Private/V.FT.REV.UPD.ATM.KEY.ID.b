* @ValidationCode : MjotOTYwNjE0OTAyOkNwMTI1MjoxNjgzNjMxOTgyNTcyOklUU1M6LTE6LTE6MjgwOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 09 May 2023 17:03:02
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 280
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.ATM
SUBROUTINE V.FT.REV.UPD.ATM.KEY.ID
*---------------------------------------------------------------------------------------
*MODIFICATION HISTORY:
*DATE           WHO                 REFERENCE               DESCRIPTION
*24-APR-2023    CONVERSION TOOL     R22 AUTO CONVERSION     NO CHANGE
*24-APR-2023    VICTORIA S          R22 MANUAL CONVERSION   NO CHANGE
*----------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.ATM.REVERSAL
*

    GOSUB INITIALISE
    GOSUB UPDATE.REC
RETURN

INITIALISE:
*----------*
*
    FN.ATM.REVERSAL = 'F.ATM.REVERSAL'
    CALL OPF(FN.ATM.REVERSAL,F.ATM.REVERSAL)

*
    REC.AT.REV =''
    CALL GET.LOC.REF('FUNDS.TRANSFER','AT.UNIQUE.ID',LRF.POSN)

RETURN          ;*From initialise
*------------------------------------------------------------------------*
UPDATE.REC:
*---------*
*Commented by liril

    AT.REV.ID  = R.NEW(FT.LOCAL.REF)<1,LRF.POSN>
*    AT.REV.ID = AT.REV.ID[1,19]:AT.REV.ID[25,6]
    TXN.AMT = R.NEW(FT.CREDIT.AMOUNT)
    REC.AT.REV<AT.REV.TRANSACTION.ID> = ID.NEW
    IF AT.REV.ID THEN
        CALL F.READ(FN.ATM.REVERSAL,AT.REV.ID,R.ATM.REVERSAL,F.ATM.REVERSAL,ER.ATM.REVERSAL)
        IF R.ATM.REVERSAL THEN
            REC.AT.REV<AT.REV.TRANSACTION.ID> ='R':ID.NEW
        END
        REC.AT.REV<AT.REV.TXN.DATE> =TODAY
        REC.AT.REV<AT.REV.TXN.AMOUNT> = TXN.AMT

        CALL F.WRITE(FN.ATM.REVERSAL,AT.REV.ID,REC.AT.REV)
    END

RETURN          ;*From update.rec


END
*----------------------------------------------------------------------*
