* @ValidationCode : MjoxNjgzMDIzNDEwOkNwMTI1MjoxNjgxMjA3NDA2MzUxOmFqaXRoOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 11 Apr 2023 15:33:26
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
SUBROUTINE REDO.APAP.AUT.REPAY
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.AUT.REPAY
*--------------------------------------------------------------------------------------------------------
*Description       : This is an authorisation routine to update the concat table REDO.APAP.LOAN.CHEQUE.DETAILS
*Linked With       : Version TELLER,AA.REPAY.INTERNALCHEQUE, TELLER,AA.REPAY.EXTERNALCHEQUE
*In  Parameter     : N/A
*Out Parameter     : N/A
*Files  Used       : REDO.APAP.LOAN.CHEQUE.DETAILS  As     O     Mode
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date             Who                  Reference               Description
*   ------           -----               -------------            -------------
* 10 JUN 2010    Mohammed Anies K     ODR-2009-10-1678 B.10        Initial Creation
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*11-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   VM to @VM
*11-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------

*
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.APAP.LOAN.CHEQUE.DETAILS
    $INSERT I_F.TELLER
*--------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
    GOSUB OPEN.PARA
    GOSUB PROCESS.PARA

RETURN
*--------------------------------------------------------------------------------------------------------
**********
OPEN.PARA:
**********
* In this para of code file variables are initialised and opened

    FN.REDO.APAP.LOAN.CHEQUE.DETAILS = 'F.REDO.APAP.LOAN.CHEQUE.DETAILS'
    F.REDO.APAP.LOAN.CHEQUE.DETAILS  = ''
    CALL OPF(FN.REDO.APAP.LOAN.CHEQUE.DETAILS,F.REDO.APAP.LOAN.CHEQUE.DETAILS)

RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* Main processing section

    GOSUB FIND.MULTI.LOCAL.REF
    GOSUB GET.CHQ.DETAILS.REC

RETURN
*--------------------------------------------------------------------------------------------------------
*******************
GET.CHQ.DETAILS.REC:
*******************
*Loan cheque details record is checked for existence

    REDO.APAP.LOAN.CHEQUE.DETAILS.ID = R.NEW(TT.TE.LOCAL.REF)<1,LOC.L.TT.ARRANGE.ID.POS>
    GOSUB READ.REDO.APAP.LOAN.CHEQUE.DETAILS
    IF R.REDO.APAP.LOAN.CHEQUE.DETAILS THEN
        GOSUB APPEND.DETAILS
    END ELSE
        GOSUB ADD.DETAILS
    END

RETURN
*--------------------------------------------------------------------------------------------------------
**********************************
READ.REDO.APAP.LOAN.CHEQUE.DETAILS:
**********************************
* loan cheque details record is read

    R.REDO.APAP.LOAN.CHEQUE.DETAILS   = ''
    REDO.APAP.LOAN.CHEQUE.DETAILS.ERR = ''
    CALL F.READ(FN.REDO.APAP.LOAN.CHEQUE.DETAILS,REDO.APAP.LOAN.CHEQUE.DETAILS.ID,R.REDO.APAP.LOAN.CHEQUE.DETAILS,F.REDO.APAP.LOAN.CHEQUE.DETAILS,REDO.APAP.LOAN.CHEQUE.DETAILS.ERR)

RETURN
*--------------------------------------------------------------------------------------------------------
**************
APPEND.DETAILS:
**************
*Appending field values to the existing loan cheque details record

    Y.FLD.COUNT = DCOUNT(R.REDO.APAP.LOAN.CHEQUE.DETAILS<CHQ.DET.TRANS.REF>,@VM)+1
    GOSUB UPDATE.FIELDS
RETURN
*--------------------------------------------------------------------------------------------------------
***********
ADD.DETAILS:
***********
*Adding field values to the new loan cheque details record

    Y.FLD.COUNT = 1
    GOSUB UPDATE.FIELDS

RETURN
*--------------------------------------------------------------------------------------------------------
*************
UPDATE.FIELDS:
*************
*Obtaining values from the current opened teller record and writing it to the loan cheque details record

    R.REDO.APAP.LOAN.CHEQUE.DETAILS<CHQ.DET.TRANS.REF,Y.FLD.COUNT> = ID.NEW
    Y.CHQ.COUNT = DCOUNT(R.NEW(TT.TE.CHEQUE.NUMBER),@VM)
    Y.COUNT = 1
    LOOP
    WHILE Y.COUNT LE Y.CHQ.COUNT
        R.REDO.APAP.LOAN.CHEQUE.DETAILS<CHQ.DET.CHQ.NO,Y.FLD.COUNT,Y.COUNT> = R.NEW(TT.TE.CHEQUE.NUMBER)<1,Y.COUNT>
        Y.COUNT+=1
    REPEAT

    R.REDO.APAP.LOAN.CHEQUE.DETAILS<CHQ.DET.IN.TRANSIT.DAYS,Y.FLD.COUNT,1> = R.NEW(TT.TE.LOCAL.REF)<1,LOC.L.TT.TRANS.DAYS.POS>
    R.REDO.APAP.LOAN.CHEQUE.DETAILS<CHQ.DET.TRANSIT.RELEASE,Y.FLD.COUNT,1> = R.NEW(TT.TE.LOCAL.REF)<1,LOC.L.TT.TRANS.REL.POS>
    CALL F.WRITE(FN.REDO.APAP.LOAN.CHEQUE.DETAILS,REDO.APAP.LOAN.CHEQUE.DETAILS.ID,R.REDO.APAP.LOAN.CHEQUE.DETAILS)

RETURN
*--------------------------------------------------------------------------------------------------------
********************
FIND.MULTI.LOCAL.REF:
********************
*obtaining positions of the local reference fields

    APPL.ARRAY = 'TELLER'
    FLD.ARRAY = 'L.TT.ARRANGE.ID':@VM:'L.TT.TRANS.DAYS':@VM:'L.TT.TRANS.REL'
    FLD.POS = ''
    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)
    LOC.L.TT.ARRANGE.ID.POS = FLD.POS<1,1>
    LOC.L.TT.TRANS.DAYS.POS = FLD.POS<1,2>
    LOC.L.TT.TRANS.REL.POS  = FLD.POS<1,3>

RETURN
*--------------------------------------------------------------------------------------------------------

END
