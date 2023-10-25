* @ValidationCode : Mjo3Mzc1OTE5MDk6Q3AxMjUyOjE2OTgyMzgyMTc0MDQ6dmlnbmVzaHdhcmk6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 25 Oct 2023 18:20:17
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
* <Rating>-14</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE MB.REDO.SET.VAR.FT.AA
*-----------------------------------------------------------------------------
* Description :
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------------------------------------
*Modification HISTORY:
*DATE                          AUTHOR                   Modification                            DESCRIPTION
*25/10/2023                VIGNESHWARI        MANUAL R23 CODE CONVERSION                 FM TO @FM
*-----------------------------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_System
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_EB.EXTERNAL.COMMON
    $INSERT I_EB.MOB.FRMWRK.COMMON
*-----------------------------------------------------------------------------

    GOSUB PROCESS

    RETURN

*-----------------------------------------------------------------------------
* Main Process
PROCESS:
*-------
*    CALL System.getVariable('CURRENT.CREDIT.CARD.NO',Y.VAL)
*    DEBUG
    EB.EXTERNAL$CHANNEL = "INTERNET"
*    R.NEW(FT.PAYMENT.DETAILS)<1,1> = DCOUNT(COMI,"-")
*    R.NEW(FT.PAYMENT.DETAILS)<1,-1> = System.getVariable('CURRENT.CARD.ORG.NO') : ' ' : System.getVariable('CURRENT.CREDIT.CARD.NO')
    IF DCOUNT(COMI,"-") GT 1 THEN
    END
    ELSE
        Y.CARD.ACC.NO = COMI
        Y.CARD.ORG.NO = Y.CARD.ACC.NO
        Y.CUSTOMER =  R.NEW(FT.DEBIT.CUSTOMER)
        Y.CARD.CCD.BIN = Y.CARD.ACC.NO[1,6]
        CALL System.setVariable('CURRENT.CREDIT.CARD.NO',Y.CARD.ACC.NO)
        CALL System.setVariable('CURRENT.CARD.ORG.NO',Y.CARD.ORG.NO)
        CALL System.setVariable('CURRENT.CARD.ACCT',Y.CARD.ACC.NO)
        CALL System.setVariable('CURRENT.CARD.LIST.CUS',Y.CARD.ACC.NO)
        CALL System.setVariable('CURRENT.CCD.BIN',Y.CARD.CCD.BIN)

        CALL System.setVariable('CURRENT.ARC.AMT','10150.38')
        CALL System.setVariable('EXT.SMS.CUSTOMERS',Y.CUSTOMER)

        USRVARSCNT = DCOUNT(MOB.USER.VARIABLES, @FM)
        USRVARSCNT++
        MOB.USER.VARIABLES<USRVARSCNT,1> = 'CURRENT.CREDIT.CARD.NO'
        MOB.USER.VARIABLES<USRVARSCNT,2> = Y.CARD.ACC.NO
        USRVARSCNT++
        MOB.USER.VARIABLES<USRVARSCNT,1> = 'CURRENT.CARD.ORG.NO'
        MOB.USER.VARIABLES<USRVARSCNT,2> = Y.CARD.ORG.NO
        USRVARSCNT++
        MOB.USER.VARIABLES<USRVARSCNT,1> = 'CURRENT.CARD.ACCT'
        MOB.USER.VARIABLES<USRVARSCNT,2> = Y.CARD.ACC.NO
        USRVARSCNT++
        MOB.USER.VARIABLES<USRVARSCNT,1> = 'CURRENT.CARD.LIST.CUS'
        MOB.USER.VARIABLES<USRVARSCNT,2> = Y.CARD.ACC.NO
        USRVARSCNT++
        MOB.USER.VARIABLES<USRVARSCNT,1> = 'CURRENT.CCD.BIN'
        MOB.USER.VARIABLES<USRVARSCNT,2> = Y.CARD.CCD.BIN

        USRVARSCNT++
        MOB.USER.VARIABLES<USRVARSCNT,1> = 'CURRENT.ARC.AMT'
        MOB.USER.VARIABLES<USRVARSCNT,2> = '10150.38'
        USRVARSCNT++
        MOB.USER.VARIABLES<USRVARSCNT,1> = 'EXT.SMS.CUSTOMERS'
        MOB.USER.VARIABLES<USRVARSCNT,2> = Y.CUSTOMER


    END
    Y.NAME = ""
    Y.VALUES = ""
    CALL System.getUserVariables(Y.NAME ,Y.VALUES)

    CALL REDO.V.VAL.CREDIT.VP

    RETURN

*-----------------------------------------------------------------------------

END
