* @ValidationCode : MjotNTUzMDc3ODk1OkNwMTI1MjoxNjgxMjc4NjUxMzM4OmFqaXRoOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 12 Apr 2023 11:20:51
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ajith
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.CONV.ACC.BAL
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.CONV.ACC.BAL
*--------------------------------------------------------------------------------------------------------
*Description       : This is a CONVERSION routine attached to an enquiry, the routine fetches the
*                    from account and limit application and returns it to O.DATA
*Linked With       : Enquiry REDO.ACCT.OFFICER
*In  Parameter     : N/A
*Out Parameter     : N/A
*Files  Used       : N/A
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*      Date          Who             Reference                                 Description
*     ------         -----           -------------                             -------------
* 05 Oct 2010     Arulpraksam P   ODR-2010-09-0148                           Initial Creation
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*12-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   NO CHANGE
*12-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION ONE DOT REMOVED FROM Y.ONLINE..BAL
*----------------------------------------------------------------------------------------
*
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.LIMIT
    $INSERT I_ENQUIRY.COMMON
*Tus Start
    $INSERT I_F.EB.CONTRACT.BALANCES
*Tus End
*-------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
* This is the para from where the execution of the code starts
    GOSUB INIT
    GOSUB PROCESS.PARA

RETURN
*--------------------------------------------------------------------------------------------------------
*************
INIT:
*************

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT  = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.LIMIT = 'F.LIMIT'
    F.LIMIT  = ''
    CALL OPF(FN.LIMIT,F.LIMIT)

RETURN

*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* This is the main processing para
    Y.ACCOUNT = O.DATA
    CALL F.READ(FN.ACCOUNT,Y.ACCOUNT,R.ACCOUNT,F.ACCOUNT,ACCT.ERR)
    R.ECB='' ; ECB.ERR= '' ;*Tus Start
    CALL EB.READ.HVT("EB.CONTRACT.BALANCES",Y.ACCOUNT,R.ECB,ECB.ERR)
*Y.ONLINE..BAL = R.ACCOUNT<AC.ONLINE.ACTUAL.BAL>
    Y.ONLINE.BAL  = R.ECB<ECB.ONLINE.ACTUAL.BAL> ;*Tus End
    Y.LOCKED.AMT  = R.ACCOUNT<AC.LOCKED.AMOUNT>
    Y.LIMIT.REF   = R.ACCOUNT<AC.LIMIT.REF>
    Y.CUSTOMER    = R.ACCOUNT<AC.CUSTOMER>
    Y.LIMIT.REF = FMT(Y.LIMIT.REF,'R%10')

    LIMIT.ID = Y.CUSTOMER : '.' : Y.LIMIT.REF
    CALL F.READ(FN.LIMIT,LIMIT.ID,R.LIMIT,F.LIMIT,LIMIT.ERR)

    VAR.AVAIL.AMT = R.LIMIT<LI.AVAIL.AMT>

    Y.ACC.BAL = Y.ONLINE.BAL + VAR.AVAIL.AMT - Y.LOCKED.AMT ;*R22 MANUAL CODE CONVERSION

    O.DATA = Y.ACC.BAL

RETURN
*--------------------------------------------------------------------------------------------------------
END       ;* End of program
