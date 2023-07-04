* @ValidationCode : MjoxMjQ5MDQ0NzI5OkNwMTI1MjoxNjgxMjgzNjI5MzU2OmFqaXRoOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 12 Apr 2023 12:43:49
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
SUBROUTINE REDO.APAP.CONV.RISK.AMT
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.CONV.RISK.AMT
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
*12-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------
*
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.LIMIT
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.REDO.APAP.CLEARING.INWARD

*-------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
* This is the para from where the execution of the code starts
    GOSUB INIT
    GOSUB FIND.GET.LOCAL.REF
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

    FN.REDO.APAP.CLEARING.INWARD = 'F.REDO.APAP.CLEARING.INWARD'
    F.REDO.APAP.CLEARING.INWARD = ''
    CALL OPF(FN.REDO.APAP.CLEARING.INWARD,F.REDO.APAP.CLEARING.INWARD)

RETURN

*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* This is the main processing para

    Y.CLR.ID = FIELD(O.DATA,"\",1)
    CALL F.READ(FN.REDO.APAP.CLEARING.INWARD,Y.CLR.ID,R.REDO.APAP.CLEARING.INWARD,F.REDO.APAP.CLEARING.INWARD,REDO.APAP.CLEARING.INWARD.ERR)

    Y.ACCOUNT = R.REDO.APAP.CLEARING.INWARD<CLEAR.CHQ.ACCOUNT.NO>
    IF NUM(Y.ACCOUNT[1,3]) ELSE ;* For Admin & Manager cheques no need to display Risk Amount.
        RETURN
    END
    Y.TAX.AMT = R.REDO.APAP.CLEARING.INWARD<CLEAR.CHQ.TAX.AMOUNT>
    Y.CHQ.AMT = R.REDO.APAP.CLEARING.INWARD<CLEAR.CHQ.AMOUNT>
    CALL F.READ(FN.ACCOUNT,Y.ACCOUNT,R.ACCOUNT,F.ACCOUNT,ACCT.ERR)
    Y.AVAILABLE.BAL   = R.ACCOUNT<AC.LOCAL.REF,Y.L.AC.AV.BAL.POS>
    Y.LIMIT.REF   = R.ACCOUNT<AC.LIMIT.REF>
    Y.CUSTOMER    = R.ACCOUNT<AC.CUSTOMER>
    Y.LIMIT.REF = FMT(Y.LIMIT.REF,'R%10')

    LIMIT.ID = Y.CUSTOMER : '.' : Y.LIMIT.REF
    CALL F.READ(FN.LIMIT,LIMIT.ID,R.LIMIT,F.LIMIT,LIMIT.ERR)

    VAR.AVAIL.AMT = R.LIMIT<LI.AVAIL.AMT>
    IF Y.LIMIT.REF NE '' THEN
        Y.ACC.BAL = Y.AVAILABLE.BAL + VAR.AVAIL.AMT - Y.CHQ.AMT - Y.TAX.AMT
    END ELSE
        Y.ACC.BAL = Y.AVAILABLE.BAL - Y.CHQ.AMT - Y.TAX.AMT
    END

    O.DATA = Y.ACC.BAL

RETURN

*******************
FIND.GET.LOCAL.REF:
*******************

    APPL.ARRAY = 'ACCOUNT'
    FLD.ARRAY  = 'L.AC.AV.BAL'
    FLD.POS    = ''
    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)

    Y.L.AC.AV.BAL.POS = FLD.POS<1,1>


RETURN
*--------------------------------------------------------------------------------------------------------
END       ;* End of program
