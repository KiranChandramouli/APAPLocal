* @ValidationCode : MjotODk4OTAxMjEyOkNwMTI1MjoxNjg5NTcwOTM5NzU3OjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 17 Jul 2023 10:45:39
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP

SUBROUTINE REDO.APAP.AUT.ADMIN.CHQ
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.AUT.ADMIN.CHQ
*--------------------------------------------------------------------------------------------------------
*Description       : This is an AUTHORISATION routine, the routine checks if the transaction type is
*                    related to ADMIN CHEQUES then updates the table REDO.ADMIN.CHQ.DETAILS
*                    with cheque status as ISSUED
*Linked With       : Version T24.FUND.SERVICES,REDO.MULTI.TXN
*In  Parameter     : N/A
*Out Parameter     : N/A
*Files  Used       : T24.FUND.SERVICES                   As          I       Mode
*                    REDO.ADMIN.CHQ.DETAILS              As          I-O     Mode
*                    REDO.H.ADMIN.CHEQUES                As          I-O     Mode
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date              Who                  Reference                 Description
*   ------            -----               -------------              -------------
* 22 Dec 2010     Shiva Prasad Y       ODR-2009-10-0318 B.126        Initial Creation
*
*DATE                 WHO                    REFERENCE                     DESCRIPTION
*13/07/2023      Conversion tool            R22 Auto Conversion            T.NO TO C$T24.SESSION.NO, VM TO @VM
*13/07/2023      Suresh                     R22 Manual Conversion           Nochange
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.T24.FUND.SERVICES
    $INSERT I_F.REDO.ADMIN.CHQ.DETAILS
    $INSERT I_F.REDO.H.ADMIN.CHEQUES
    $INSERT I_F.USER
*--------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
* This is the para from where the execution of the code starts
    GOSUB OPEN.PARA
    GOSUB PROCESS.PARA

RETURN
*--------------------------------------------------------------------------------------------------------
**********
OPEN.PARA:
**********
* In this para of the code, file variables are initialised and opened
    FN.REDO.ADMIN.CHQ.DETAILS = 'F.REDO.ADMIN.CHQ.DETAILS'
    F.REDO.ADMIN.CHQ.DETAILS  = ''
    CALL OPF(FN.REDO.ADMIN.CHQ.DETAILS,F.REDO.ADMIN.CHQ.DETAILS)

    FN.REDO.H.ADMIN.CHEQUES = 'F.REDO.H.ADMIN.CHEQUES'
    F.REDO.H.ADMIN.CHEQUES  = ''
    CALL OPF(FN.REDO.H.ADMIN.CHEQUES,F.REDO.H.ADMIN.CHEQUES)

RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* This is the main processing para
    Y.TXN.CODES = R.NEW(TFS.TRANSACTION)
    Y.FLAG = ''

    GOSUB FIND.MULTI.LOCAL.REF

    LOCATE 'ADMCHQGOVWITTAX' IN Y.TXN.CODES<1,1> SETTING Y.TXN.POS THEN
        Y.FLAG += 1
        GOSUB PROCESS.ADMIN.CHQ
    END

    LOCATE 'ADMCHQGOVWOTAX'IN Y.TXN.CODES<1,1> SETTING Y.TXN.POS THEN
        Y.FLAG += 1
        GOSUB PROCESS.ADMIN.CHQ
    END

    LOCATE 'ADMCHQOTHERS'IN Y.TXN.CODES<1,1> SETTING Y.TXN.POS THEN
        Y.FLAG += 1
        GOSUB PROCESS.ADMIN.CHQ
    END

RETURN
*--------------------------------------------------------------------------------------------------------
******************
PROCESS.ADMIN.CHQ:
******************
    GOSUB UPDATE.REDO.ADMIN.CHQ.DETAILS
    GOSUB UPDATE.REDO.H.ADMIN.CHEQUES
RETURN
*--------------------------------------------------------------------------------------------------------
******************************
UPDATE.REDO.ADMIN.CHQ.DETAILS:
******************************
    REDO.ADMIN.CHQ.DETAILS.ID = R.NEW(TFS.LOCAL.REF)<1,LOC.L.TFS.ADMIN.CHQ.POS,Y.FLAG>

    R.REDO.ADMIN.CHQ.DETAILS<ADMIN.CHQ.DET.CHEQUE.INT.ACCT> = R.NEW(TFS.ACCOUNT.NUMBER)<1,Y.TXN.POS,1>
    R.REDO.ADMIN.CHQ.DETAILS<ADMIN.CHQ.DET.STATUS>          = 'ISSUED'
    R.REDO.ADMIN.CHQ.DETAILS<ADMIN.CHQ.DET.AMOUNT>          = R.NEW(TFS.AMOUNT)<1,Y.TXN.POS>
    R.REDO.ADMIN.CHQ.DETAILS<ADMIN.CHQ.DET.ISSUE.ACCOUNT>   = R.NEW(TFS.ACCOUNT.NUMBER)<1,Y.TXN.POS,2>
    R.REDO.ADMIN.CHQ.DETAILS<ADMIN.CHQ.DET.ISSUE.DATE>      = TODAY
    R.REDO.ADMIN.CHQ.DETAILS<ADMIN.CHQ.DET.COMPANY.CODE>    = ID.COMPANY
    R.REDO.ADMIN.CHQ.DETAILS<ADMIN.CHQ.DET.BENEFICIARY>     = R.NEW(TFS.LOCAL.REF)<1,LOC.L.TT.BENEFICIAR.POS>
    R.REDO.ADMIN.CHQ.DETAILS<ADMIN.CHQ.DET.TRANS.REFERENCE> = ID.NEW
    R.REDO.ADMIN.CHQ.DETAILS<ADMIN.CHQ.DET.USER>            = OPERATOR

    R.REDO.ADMIN.CHQ.DETAILS<ADMIN.CHQ.DET.INPUTTER>        = C$T24.SESSION.NO:'_':OPERATOR ;*R22 Auto Conversion

    Y.TEMP.TIME = OCONV(TIME(),"MTS")
    Y.TEMP.TIME = Y.TEMP.TIME[1,5]
    CHANGE ':' TO '' IN Y.TEMP.TIME
    Y.CHECK.DATE = DATE()

    Y.DATE.TIME = OCONV(Y.CHECK.DATE,"DY2"):FMT(OCONV(Y.CHECK.DATE,"DM"),'R%2'):FMT(OCONV(Y.CHECK.DATE,"DD"),'R%2'):Y.TEMP.TIME

    R.REDO.ADMIN.CHQ.DETAILS<ADMIN.CHQ.DET.DATE.TIME>       = Y.DATE.TIME
    R.REDO.ADMIN.CHQ.DETAILS<ADMIN.CHQ.DET.AUTHORISER>      = C$T24.SESSION.NO:'_':OPERATOR ;*R22 Auto Conversion
    R.REDO.ADMIN.CHQ.DETAILS<ADMIN.CHQ.DET.CO.CODE>         = ID.COMPANY
    R.REDO.ADMIN.CHQ.DETAILS<ADMIN.CHQ.DET.DEPT.CODE>       = R.USER<EB.USE.DEPARTMENT.CODE>

    GOSUB WRITE.REDO.ADMIN.CHQ.DETAILS

RETURN
*--------------------------------------------------------------------------------------------------------
****************************
UPDATE.REDO.H.ADMIN.CHEQUES:
****************************
    REDO.H.ADMIN.CHEQUES.ID = R.NEW(TFS.LOCAL.REF)<1,LOC.L.TFS.ADMIN.CHQ.POS,Y.FLAG>

    GOSUB READ.REDO.H.ADMIN.CHEQUES

    IF NOT(R.REDO.H.ADMIN.CHEQUES) THEN
        RETURN
    END

    R.REDO.H.ADMIN.CHEQUES<REDO.ADMIN.STATUS>     = 'ISSUED'

    R.REDO.H.ADMIN.CHEQUES<REDO.ADMIN.INPUTTER>   = C$T24.SESSION.NO:'_':OPERATOR ;*R22 Auto Conversion
    Y.TEMP.TIME = OCONV(TIME(),"MTS")
    Y.TEMP.TIME = Y.TEMP.TIME[1,5]
    CHANGE ':' TO '' IN Y.TEMP.TIME
    Y.CHECK.DATE = DATE()
    Y.DATE.TIME = OCONV(Y.CHECK.DATE,"DY2"):FMT(OCONV(Y.CHECK.DATE,"DM"),'R%2'):FMT(OCONV(Y.CHECK.DATE,"DD"),'R%2'):Y.TEMP.TIME

    R.REDO.H.ADMIN.CHEQUES<REDO.ADMIN.DATE.TIME>  = Y.DATE.TIME
    R.REDO.H.ADMIN.CHEQUES<REDO.ADMIN.AUTHORISER> = C$T24.SESSION.NO:'_':OPERATOR ;*R22 Auto Conversion
    R.REDO.H.ADMIN.CHEQUES<REDO.ADMIN.CO.CODE>    = ID.COMPANY
    R.REDO.H.ADMIN.CHEQUES<REDO.ADMIN.DEPT.CODE>  = R.USER<EB.USE.DEPARTMENT.CODE>

    GOSUB WRITE.REDO.H.ADMIN.CHEQUES

RETURN
*--------------------------------------------------------------------------------------------------------
**************************
READ.REDO.H.ADMIN.CHEQUES:
**************************
* In this para of the code, file REDO.H.ADMIN.CHEQUES is read
    R.REDO.H.ADMIN.CHEQUES  = ''
    REDO.H.ADMIN.CHEQUES.ER = ''
    CALL F.READ(FN.REDO.H.ADMIN.CHEQUES,REDO.H.ADMIN.CHEQUES.ID,R.REDO.H.ADMIN.CHEQUES,F.REDO.H.ADMIN.CHEQUES,REDO.H.ADMIN.CHEQUES.ER)

RETURN
*--------------------------------------------------------------------------------------------------------
*****************************
WRITE.REDO.ADMIN.CHQ.DETAILS:
*****************************
* In this para of the code, values are written to file REDO.ADMIN.CHQ.DETAILS
    CALL F.WRITE(FN.REDO.ADMIN.CHQ.DETAILS,REDO.ADMIN.CHQ.DETAILS.ID,R.REDO.ADMIN.CHQ.DETAILS)

RETURN
*--------------------------------------------------------------------------------------------------------
***************************
WRITE.REDO.H.ADMIN.CHEQUES:
***************************
* In this para of the code, values are written to file REDO.H.ADMIN.CHEQUES
    CALL F.WRITE(FN.REDO.H.ADMIN.CHEQUES,REDO.H.ADMIN.CHEQUES.ID,R.REDO.H.ADMIN.CHEQUES)

RETURN
*--------------------------------------------------------------------------------------------------------
*********************
FIND.MULTI.LOCAL.REF:
*********************
* In this para of the code, local reference field positions are obtained
    APPL.ARRAY = 'T24.FUND.SERVICES'
    FLD.ARRAY = 'L.TFS.ADMIN.CHQ':@VM:'L.TT.BENEFICIAR'
    FLD.POS = ''

    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)
    LOC.L.TFS.ADMIN.CHQ.POS  =  FLD.POS<1,1>
    LOC.L.TT.BENEFICIAR.POS  =  FLD.POS<1,2>

RETURN
*--------------------------------------------------------------------------------------------------------
END       ;* End of Program
