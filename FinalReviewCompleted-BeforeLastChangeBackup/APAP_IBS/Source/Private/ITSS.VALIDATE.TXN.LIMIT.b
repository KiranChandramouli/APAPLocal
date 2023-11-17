* @ValidationCode : MjotNjUwMjAyOTQ4OkNwMTI1MjoxNjk4NDA1NTM5OTc2OklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
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
* <Rating>-47</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE ITSS.VALIDATE.TXN.LIMIT

*-----------------------------------------------------------------------------------------------------------------------------------
*Modification HISTORY:
*DATE                          AUTHOR                   Modification                            DESCRIPTION
*25/10/2023                VIGNESHWARI       MANUAL R23 CODE CONVERSION                FM TO @FM
*-----------------------------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.PROTECTION.USAGE
    $INSERT I_GTS.COMMON
    $INSERT I_System
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_EB.MOB.FRMWRK.COMMON

    GOSUB INITIALISE
*    GOSUB CHECK.PROTECTION
    RETURN

INITIALISE:

*    DEBUG
    USRVARSCNT = DCOUNT(MOB.USER.VARIABLES, @FM)

    FOR I=1 TO USRVARSCNT
        CALL System.setVariable(MOB.USER.VARIABLES<I, 1>, MOB.USER.VARIABLES<I, 2>)
    NEXT I

    Y.NAME = ""
    Y.VALUES = ""
    CALL System.getUserVariables(Y.NAME ,Y.VALUES)



    RETURN

CHECK.PROTECTION:

    PROTECTION.USAGE.ID =  System.getVariable('EXT.EXTERNAL.USER')
    PRINT PROTECTION.USAGE.ID: "******"
    GOSUB READ.PROTECTION.USAGE
    GOSUB CHECK.UTILISED.AMOUNT
    RETURN

*** <region name= READ.PROTECTION.USAGE>
READ.PROTECTION.USAGE:
*** <desc>Read the Protection Usage record and check for last updated</desc>

    R.PROTECTION.USAGE = ""
    YERR = ''
    RETRY = ""      ;* prompt the user after a lock
    CALL F.READU(FN.PROTECTION.USAGE, PROTECTION.USAGE.ID,R.PROTECTION.USAGE,F.PROTECTION.USAGE,YERR,RETRY)

    IF R.PROTECTION.USAGE<AC.PRCTU.DATE.TIME.UPD>[1,8] LT TODAY THEN
        R.PROTECTION.USAGE = ''
    END

    RETURN
*** </region>


*** <region name= CHECK.UTILISED.AMOUNT>
CHECK.UTILISED.AMOUNT:
*** <desc>Check and update the utilised amounts</desc>
    PROTECTION.UPDATED=1
    PROTECTION.LIMIT.ID = 'DAILYLIMITS'
    PROTECTION.LIMIT.AMOUNT.LM = '1000000'

    LOCATE PROTECTION.LIMIT.ID IN R.PROTECTION.USAGE<AC.PRCTU.PROTECTION.RULE,1> SETTING POS ELSE
*** Add protection info to the usage record
        R.PROTECTION.USAGE<AC.PRCTU.PROTECTION.RULE,POS> = PROTECTION.LIMIT.ID
        R.PROTECTION.USAGE<AC.PRCTU.AMOUNT,POS> = PROTECTION.LIMIT.AMOUNT.LM
    END


    AMOUNT.TO.USE = R.NEW(FT.LOC.AMT.DEBITED)

    IF (R.PROTECTION.USAGE<AC.PRCTU.UTILISED,POS> + AMOUNT.TO.USE) > PROTECTION.LIMIT.AMOUNT.LM   THEN
        PROTECTION.UPDATED=""
        ETEXT = 'Daily amount exceeded'
        CALL STORE.END.ERROR
        CALL F.RELEASE(FN.PROTECTION.USAGE,PROTECTION.USAGE.ID,F.PROTECTION.USAGE)
    END
    ELSE

        R.PROTECTION.USAGE<AC.PRCTU.UTILISED,POS> += AMOUNT.TO.USE

        R.PROTECTION.USAGE<AC.PRCTU.DATE.TIME.UPD> = TODAY:TIME.STAMP[1,2]:TIME.STAMP[4,2]
        CALL F.WRITE(FN.PROTECTION.USAGE,PROTECTION.USAGE.ID,R.PROTECTION.USAGE)
    END

    RETURN

*** </region>

END
