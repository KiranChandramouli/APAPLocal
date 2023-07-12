SUBROUTINE REDO.APAP.VAL.ORG.REF
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.VAL.ORG.REF
*--------------------------------------------------------------------------------------------------------
*Description       : This is a VALIDATION routine, attached to the local reference field Original Reference,
*                    the routine populates the local ref field Transaction Amount by reading the values
*                    from the file REDO.MULTI.TRANSACTION.DETAIL
*Linked With       : Version T24.FUND.SERVICES,MULTI.TXN
*In  Parameter     : N/A
*Out Parameter     : N/A
*Files  Used       : T24.FUND.SERVICES                   As          I       Mode
*                    REDO.MULTI.TRANSACTION.DETAIL       As          I       Mode
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date               Who                  Reference                 Description
*   ------             -----               -------------              -------------
* 13 July 2010     Shiva Prasad Y      ODR-2009-10-0318 B.126        Initial Creation
*
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.T24.FUND.SERVICES
    $INSERT I_F.REDO.MULTI.TRANSACTION.DETAIL
*--------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
* This is the para from where the execution of the code starts
    IF MESSAGE EQ 'VAL' THEN
        RETURN
    END

    IF NOT(COMI) THEN
        RETURN
    END
    GOSUB OPEN.PARA
    GOSUB PROCESS.PARA

RETURN
*--------------------------------------------------------------------------------------------------------
**********
OPEN.PARA:
**********
* In this para of the code, file variables are initialised and opened

    FN.REDO.MULTI.TRANSACTION.DETAIL = 'F.REDO.MULTI.TRANSACTION.DETAIL'
    F.REDO.MULTI.TRANSACTION.DETAIL  = ''
    CALL OPF(FN.REDO.MULTI.TRANSACTION.DETAIL,F.REDO.MULTI.TRANSACTION.DETAIL)

RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* This is the main processing para
    GOSUB CHECK.MULTI.TXN.DET

RETURN
*--------------------------------------------------------------------------------------------------------
********************
CHECK.MULTI.TXN.DET:
********************
* In this para of the code, a check is made if the record exists in the file REDO.MULTI.TRANSACTION.DETAIL for the
** user entered orginal reference number (TELLER transaction number)

    REDO.MULTI.TRANSACTION.DETAIL.ID = COMI
    GOSUB READ.REDO.MULTI.TRANSACTION.DETAIL
    GOSUB FIND.MULTI.LOCAL.REF
    IF NOT(R.REDO.MULTI.TRANSACTION.DETAIL) OR R.REDO.MULTI.TRANSACTION.DETAIL<MUL.TXN.TXN.DATE> NE R.NEW(TFS.LOCAL.REF)<1,LOC.L.TFS.TXN.DATE.POS> THEN
        GOSUB GENERATE.OVERRIDE
        RETURN
    END

    R.NEW(TFS.PRIMARY.ACCOUNT) = R.REDO.MULTI.TRANSACTION.DETAIL<MUL.TXN.ACCT.NUMBER>

    R.NEW(TFS.LOCAL.REF)<1,LOC.L.TFS.TXN.AMT.POS> = R.REDO.MULTI.TRANSACTION.DETAIL<MUL.TXN.TXN.AMOUNT>

RETURN
*--------------------------------------------------------------------------------------------------------
******************
GENERATE.OVERRIDE:
******************
* In this para of the code, an override is generated when there is not matching record in the file REDO.MULTI.TRANSACTION.DETAIL

    TEXT = 'TFS.NO.PENDING.RECONCILE'
    CURR.NO = DCOUNT(R.NEW(TFS.OVERRIDE),@VM) + 1
    CALL STORE.OVERRIDE(CURR.NO)

RETURN
*--------------------------------------------------------------------------------------------------------
***********************************
READ.REDO.MULTI.TRANSACTION.DETAIL:
***********************************
* In this para of the code, file REDO.MULTI.TRANSACTION.DETAIL is read
    R.REDO.MULTI.TRANSACTION.DETAIL  = ''
    REDO.MULTI.TRANSACTION.DETAIL.ER = ''
    CALL F.READ(FN.REDO.MULTI.TRANSACTION.DETAIL,REDO.MULTI.TRANSACTION.DETAIL.ID,R.REDO.MULTI.TRANSACTION.DETAIL,F.REDO.MULTI.TRANSACTION.DETAIL,REDO.MULTI.TRANSACTION.DETAIL.ER)

RETURN
*--------------------------------------------------------------------------------------------------------
*********************
FIND.MULTI.LOCAL.REF:
*********************
* In this para of the code, local reference field positions are obtained

    APPL.ARRAY = 'T24.FUND.SERVICES'
    FLD.ARRAY  = 'L.TFS.TXN.AMT':@VM:'L.TFS.TXN.DATE'
    FLD.POS    = ''
    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)

    LOC.L.TFS.TXN.AMT.POS  = FLD.POS<1,1>
    LOC.L.TFS.TXN.DATE.POS = FLD.POS<1,2>

RETURN
*--------------------------------------------------------------------------------------------------------
END       ;* End of program
