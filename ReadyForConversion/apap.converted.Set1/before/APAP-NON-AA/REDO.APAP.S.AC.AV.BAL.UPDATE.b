*-----------------------------------------------------------------------------
* <Rating>-99</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.APAP.S.AC.AV.BAL.UPDATE(APPL.TYPE,OPERATION.TYPE,STMT.ENT.ID,STMT.RECORD)
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.S.AC.AV.BAL.UPDATE
*--------------------------------------------------------------------------------------------------------
*Description       : This is an ACCOUNT.PARAMETER routine, this routine is used to update the local reference
*                    field L.AC.AV.BAL which will be difference between the amount of WORKING.BALANCE and
*                    LOCKED.AMOUNT
*Linked With       : ACCOUNT.PARAMETER
*In  Parameter     : APPL.TYPE, OPERATION.TYPE, STMT.ENT.ID, STMT.RECORD
*Out Parameter     : APPL.TYPE, OPERATION.TYPE, STMT.ENT.ID, STMT.RECORD
*Files  Used       : ACCOUNT                             As              I-O             Mode
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date               Who                    Reference                  Description
*   ------             -----                 -------------               -------------
* 22 Nov 2010       Shiva Prasad Y       ODR-2010-11-0196 CR012         Initial Creation
* 13 Apr 2011        H Ganesh              PACS00054323 - CR012         Changes made for locked amount calculation
* 05 JUN 2011       Prabhu N              PACS00071064                  Changes made for locked amount calculation
* 12 JUL 2011       Prabhu N              PACS00071064                  In line 118 instead of GT ,GE added
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
* Tus start
    $INSERT I_F.EB.CONTRACT.BALANCES
* Tus end
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
    ACCOUNT.ID = STMT.RECORD<1>
    IF NOT(ACCOUNT.ID) THEN
        Y.FLAG = 1
        RETURN
    END

    IF NOT(NUM(ACCOUNT.ID)) THEN
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
*Y.AMT = R.ACCOUNT<AC.WORKING.BALANCE> ;* Tus start
    Y.AMT = R.ECB<ECB.WORKING.BALANCE>  ;* Tus end

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
    Y.LOCK.AMT = 0
    IF NOT(R.ACCOUNT<AC.FROM.DATE>) THEN
        Y.LOCK.AMT = 0
        RETURN
    END

    Y.DATE.COUNT = DCOUNT(R.ACCOUNT<AC.FROM.DATE>,VM)
    Y.DATE.START = 1

    LOOP
*PACS00071064.1-S
    WHILE Y.DATE.START LE Y.DATE.COUNT
*PACS00071064.1-e
        IF R.ACCOUNT<AC.FROM.DATE,Y.DATE.START> LE TODAY THEN
            Y.LOCK.AMT = R.ACCOUNT<AC.LOCKED.AMOUNT,Y.DATE.START>
        END
*        IF TODAY GE R.ACCOUNT<AC.FROM.DATE,Y.DATE.START> AND TODAY LT R.ACCOUNT<AC.FROM.DATE,Y.DATE.START+1> THEN
*            Y.LOCK.AMT = R.ACCOUNT<AC.LOCKED.AMOUNT,Y.DATE.START>
*            BREAK
*        END


        Y.DATE.START += 1
    REPEAT

    RETURN
*--------------------------------------------------------------------------------------------------------
*************
READ.ACCOUNT:
*************
    R.ACCOUNT  = ''
    ACCOUNT.ER = ''
    CALL F.READ(FN.ACCOUNT,ACCOUNT.ID,R.ACCOUNT,F.ACCOUNT,ACCOUNT.ER)
* Tus start
    R.ECB = '' ; ECB.ERR = ''
    CALL EB.READ.HVT("EB.CONTRACT.BALANCES",ACCOUNT.ID,R.ECB,ECB.ERR)
* Tus end

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
