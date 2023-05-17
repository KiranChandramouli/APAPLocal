SUBROUTINE REDO.APAP.S.LOCK.BAL.UPDATE
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.S.LOCK.BAL.UPDATE
*--------------------------------------------------------------------------------------------------------
*Description       : This is an VERSION.CONTROL routine, this routine is used to update the local reference
*                    field L.AC.AV.BAL which will be difference between the amount of WORKING.BALANCE and
*                    LOCKED.AMOUNT
*Linked With       : VERSION.CONTROL > AC.LOCKED.EVENTS
*In  Parameter     :
*Out Parameter     :
*Files  Used       :
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date               Who                    Reference                  Description
*   ------             -----                 -------------               -------------
* 23 SEP 2011       KAVITHA                   PACS00055620                PACS00055620 FIX
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AC.LOCKED.EVENTS

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
    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* This is the main processing para


    Y.FLAG = ''
    GOSUB CHECK.ACCOUNT

    IF Y.FLAG THEN
        RETURN
    END

    GOSUB FIND.MULTI.LOCAL.REF
    GOSUB CALC.AV.BAL

RETURN
*--------------------------------------------------------------------------------------------------------
**************
CHECK.ACCOUNT:
**************
    ACCOUNT.ID = R.NEW(AC.LCK.ACCOUNT.NUMBER)
    IF NOT(ACCOUNT.ID) THEN
        Y.FLAG = 1
        RETURN
    END

    GOSUB READ.ACCOUNT

    IF NOT(R.ACCOUNT<AC.CUSTOMER>) THEN
        Y.FLAG = 1
    END

RETURN
*--------------------------------------------------------------------------------------------------------
************
CALC.AV.BAL:
************
    Y.AC.AV.BAL = 0
    Y.AMT = R.ACCOUNT<AC.WORKING.BALANCE>

    GOSUB GET.LOCKED.AMOUNT

    Y.AC.AV.BAL = Y.AMT - Y.LOCK.AMT

    IF R.ACCOUNT<AC.LOCAL.REF,LOC.L.AC.AV.BAL.POS> EQ Y.AC.AV.BAL THEN
        RETURN
    END

    R.ACCOUNT<AC.LOCAL.REF,LOC.L.AC.AV.BAL.POS> = Y.AC.AV.BAL

    GOSUB WRITE.ACCOUNT

RETURN
*--------------------------------------------------------------------------------------------------------
******************
GET.LOCKED.AMOUNT:
******************

    Y.LOCK.AMT = R.NEW(AC.LCK.LOCKED.AMOUNT)

RETURN
*--------------------------------------------------------------------------------------------------------
*************
READ.ACCOUNT:
*************
    R.ACCOUNT  = ''
    ACCOUNT.ER = ''
    CALL F.READ(FN.ACCOUNT,ACCOUNT.ID,R.ACCOUNT,F.ACCOUNT,ACCOUNT.ER)

RETURN
*--------------------------------------------------------------------------------------------------------
**************
WRITE.ACCOUNT:
**************
    CALL F.WRITE(FN.ACCOUNT,ACCOUNT.ID,R.ACCOUNT)

RETURN
*--------------------------------------------------------------------------------------------------------
*********************
FIND.MULTI.LOCAL.REF:
*********************
    APPL.ARRAY = 'ACCOUNT'
    FLD.ARRAY  = 'L.AC.AV.BAL'
    FLD.POS    = ''

    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)

    LOC.L.AC.AV.BAL.POS =  FLD.POS<1,1>

RETURN
*--------------------------------------------------------------------------------------------------------
END       ;* ENd of Program
