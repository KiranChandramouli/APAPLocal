$PACKAGE APAP.TAM
* @ValidationCode : MjotNDUyNzgzNDg3OkNwMTI1MjoxNjgwNzgzNzU2MTI3OjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 06 Apr 2023 17:52:36
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
SUBROUTINE REDO.CHQ.RETURN.CHARGES
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.CHQ.RETURN.CHARGES
*--------------------------------------------------------------------------------------------------------
*Description       :This routine is attached as POST-ROTUINE for Apply payment Activity for Payment.rules - Pre.Bill action

*Linked With       : Post Routine in ACTIVITY.API for APPLY.PAYMENT Activity
*In  Parameter     : RE.STAT.LINE.CONT.ID - Id of file RE.STAT.LINE.CONT
*Out Parameter     : NA
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date               Who                    Reference                 Description
*   ------             -----                 -------------              -------------
* 09 DEC 2010        SRIRAMAN.C              ODR-2009-10-1678              Initial Creation
*
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*06/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             NOCHANGE
*06/04/2023         SURESH           MANUAL R22 CODE CONVERSION        CALL Rtn format modified
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_AA.LOCAL.COMMON
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.AA.ARRANGEMENT.ACTIVITY
*--------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
* This is the para from where the execution of the code starts

    GOSUB INIT
    GOSUB PROCESS.PARA

RETURN
*--------------------------------------------------------------------------------------------------------
************
INIT:
*************


    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.ARRANGEMENT = 'F.AA.ARRANGEMENT'
    F.ARRANGEMENT = ''
    CALL OPF(FN.ARRANGEMENT, F.ARRANGEMENT)

    CREDIT.ACCT.NO = R.NEW(FT.CREDIT.ACCT.NO)

    CALL F.READ(FN.ACCOUNT, CREDIT.ACCT.NO, R.ACCOUNT, F.ACCOUNT, ACC.ERR)

    Y.ARR.ID = R.ACCOUNT<AC.ARRANGEMENT.ID>

    CALL F.READ(FN.ARRANGEMENT, Y.ARR.ID, R.ARRANGEMENT, F.ARRANGEMENT, ARR.ERR)

    Y.PRODUCT.ID = R.ARRANGEMENT<AA.ARR.PRODUCT>


RETURN
*************
PROCESS.PARA:
*************
* This is the main processing para

    Y.ACTIVITY.STATUS = c_aalocActivityStatus

    IF R.NEW(FT.RECORD.STATUS) EQ 'RNAU' THEN

        Y.CHQ.NO = R.NEW(FT.CHEQUE.NUMBER)

        IF Y.CHQ.NO THEN
            APP.NAME = 'AA.ARRANGEMENT.ACTIVITY'
            OFS.FUNCTION='I'
            PROCESS='PROCESS'
            OFS.SOURCE.ID='REDO.CHQ.ISSUE'
            OFSVERSION='AA.ARRANGEMENT.ACTIVITY,'
            GTSMODE=''
            NO.OF.AUTH='0'
            TRANSACTION.ID= ''
            R.APP.RECORD=''
            OFS.STRING=''
            R.APP.RECORD<AA.ARR.ACT.ARRANGEMENT> = Y.ARR.ID
            R.APP.RECORD<AA.ARR.ACT.ACTIVITY> = 'LENDING-TRIGGER-CHEQUE.RETURN'
            R.APP.RECORD<AA.ARR.ACT.EFFECTIVE.DATE> = TODAY
            R.APP.RECORD<AA.ARR.ACT.PRODUCT> = Y.PRODUCT.ID
            CALL OFS.BUILD.RECORD(APP.NAME,OFS.FUNCTION,PROCESS,OFSVERSION,GTS.MODE,NO.OF.AUTH,TRANSACTION.ID,R.APP.RECORD,OFS.MESSAGE)
            OFS.MSG.ID = ''
            OPTIONS = ''
            OFS.ERR = ''

            CALL OFS.POST.MESSAGE(OFS.MESSAGE,OFS.MSG.ID,OFS.SOURCE.ID,OFS.ERR)

            CALL APAP.AA.REDO.UPDATE.CHQ.RETURN(Y.ARR.ID) ;*MANUAL R22 CODE CONVERSION
        END

    END

RETURN
*--------------------------------------------------------------------------------------------------------
END       ;* ENd of Program
