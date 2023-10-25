* @ValidationCode : Mjo1NjMwOTM1MjA6Q3AxMjUyOjE2OTgyMzczNDg4MTQ6dmlnbmVzaHdhcmk6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 25 Oct 2023 18:05:48
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : vigneshwari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.IBS
*-----------------------------------------------------------------------------
* <Rating>180</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE ITSS.MF.GET.MINI.STMT.OPTFMT(MOB.REQUEST, MOB.RESPONSE)
*---------------------------------------------------------------------------------------------------
* Description :

*-----------------------------------------------------------------------------------------------------------------------------------
*Modification HISTORY:
*DATE                          AUTHOR                   Modification                            DESCRIPTION
*25/10/2023                VIGNESHWARI        MANUAL R23 CODE CONVERSION                VM TO @VM,SM TO @SM
*-----------------------------------------------------------------------------------------------------------------------------------
*
*---------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_EB.MOB.FRMWRK.COMMON

*---------------------------------------------------------------------------------------------------

    GOSUB INITIALISE

    GOSUB PROCESS

    RETURN

*---------------------------------------------------------------------------------------------------
INITIALISE:
*----------

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT, F.ACCOUNT)

    MOB.RESPONSE.SAVE = MOB.RESPONSE

    MOB.RESPONSE = ""

    MOB.RESPONSE<1,1> = MOB.RESPONSE.SAVE<1,1>


    DATE.TO = TOKEN.ID[',', 3, 1]

    IF DATE.TO = "" THEN
        DATE.TO = TODAY
    END

    LOCATE 'AMOUNT.LCY' IN MOB.RESPONSE.SAVE<1, 1, 1> SETTING SUB.POS ELSE NULL
    LOCATE 'BOOKING.DATE' IN MOB.RESPONSE<1, 1, 1> SETTING DATE.TO.POS ELSE NULL

    LOCATE 'ACCOUNT.NUMBER' IN MOB.RESPONSE.SAVE<1, 1, 1> SETTING ACC.POS THEN
        CALL F.READ(FN.ACCOUNT, MOB.RESPONSE.SAVE<1, 2, ACC.POS>, R.ACCOUNT, F.ACCOUNT, ACC.ERR)
        TOT.BAL = R.ACCOUNT<AC.WORKING.BALANCE>
    END

    MOB.RESPONSE<1, 1, -1> = 'TOTAL.BALANCE'

    TRANS.CNT = DCOUNT(MOB.RESPONSE.SAVE, @VM)

    RETURN

*---------------------------------------------------------------------------------------------------
PROCESS:
*-------
    N.TCNT = 2
    FOR TCNT = 2 TO TRANS.CNT
        IF MOB.RESPONSE.SAVE<1, TCNT , DATE.TO.POS> LE DATE.TO THEN
            MOB.RESPONSE<1, N.TCNT> = MOB.RESPONSE.SAVE<1, TCNT>:@SM:TOT.BAL
            N.TCNT++
        END
        TOT.BAL -= MOB.RESPONSE.SAVE<1, TCNT, SUB.POS>
    NEXT TCNT

    RETURN

*---------------------------------------------------------------------------------------------------

END
