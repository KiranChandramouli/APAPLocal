* @ValidationCode : Mjo5NjY2Mjc5ODQ6Q3AxMjUyOjE2OTg0MDU1MzkyNDg6SVRTUzE6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 27 Oct 2023 16:48:59
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
$PACKAGE APAP.IBS
*-----------------------------------------------------------------------------
* <Rating>-30</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE ITSS.MF.EOM.BALANCE(ACTION.INFO, REQUEST, MOB.RESPONSE, MOB.ERROR)
*-----------------------------------------------------------------------------------------------------------------------------------
*Modification HISTORY:
*DATE                          AUTHOR                   Modification                            DESCRIPTION
*25/10/2023                VIGNESHWARI        MANUAL R23 CODE CONVERSION                VM TO @VM,SM TO @SM,FM TO @FM
*-----------------------------------------------------------------------------------------------------------------------------------
*---------------------------------------------------------------------------------------------------
* Description :
*---------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCT.ACTIVITY
    $INSERT I_EB.MOB.FRMWRK.COMMON
*---------------------------------------------------------------------------------------------------

    GOSUB INITIALISE

    GOSUB PROCESS

    RETURN

*---------------------------------------------------------------------------------------------------
INITIALISE:
*----------

    MOB.RESPONSE = ''

    ACCT.LIST = REQUEST

    CHANGE ',' TO @FM IN ACCT.LIST

    ACCTCNT = DCOUNT(ACCT.LIST, @FM)

    FN.ACCT.ACTIVITY = 'F.ACCT.ACTIVITY'
    F.ACCT.ACTIVITY = ''
    CALL OPF(FN.ACCT.ACTIVITY, F.ACCT.ACTIVITY)

    CURR.MON = TODAY[1,6]

    MOB.RESPONSE<1, 1> = 'ACCOUNT.NO':@SM:'YEAR.MON':@SM:'BALANCE'

    RETURN

*---------------------------------------------------------------------------------------------------
PROCESS:
*-------

    FOR ACCT=1 TO ACCTCNT
        ACCT.NO = ACCT.LIST<ACCT>
        FOR YMON=1 TO 6
            E.ACT = ''
            YEAR.MON = CURR.MON - YMON
            IF YEAR.MON[5,2] GT 12 THEN
                YEAR.MON = YEAR.MON[1,4]: (13 - (100 - YEAR.MON[5,2]))
            END
            ACT.ID = ACCT.NO:'-':YEAR.MON
            CALL F.READ(FN.ACCT.ACTIVITY, ACT.ID, R.ACT, F.ACCT.ACTIVITY, E.ACT)
            IF NOT(E.ACT) THEN
                GOSUB GET.ACCT.BALANCE
            END
        NEXT YMON
    NEXT ACCT

    RETURN

*---------------------------------------------------------------------------------------------------
GET.ACCT.BALANCE:

    IF R.ACT<IC.ACT.BALANCE> NE '' THEN
        BALANCE = R.ACT<IC.ACT.BALANCE, DCOUNT(R.ACT<IC.ACT.BALANCE>, @VM)>
    END ELSE
        BALANCE = R.ACT<IC.ACT.BK.BALANCE, DCOUNT(R.ACT<IC.ACT.BK.BALANCE>, @VM)>
    END

    MOB.RESPONSE<1, -1, 1> =  ACCT.NO:@SM:YEAR.MON:@SM:BALANCE

    RETURN

*---------------------------------------------------------------------------------------------------

END
