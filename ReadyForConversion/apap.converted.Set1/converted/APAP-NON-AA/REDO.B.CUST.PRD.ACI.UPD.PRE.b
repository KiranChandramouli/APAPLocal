SUBROUTINE REDO.B.CUST.PRD.ACI.UPD.PRE(Y.ACCT.NO)
*------------------------------------------------------------------------------------
* REDO.B.CUST.PRD.ACI.UPD.SELECT is multithreaded to write the account id to REDO.BATCH.JOB.LIST.FILE
*
*------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.ACCOUNT.CREDIT.INT
    $INSERT I_F.BASIC.INTEREST
    $INSERT I_F.DATES
    $INSERT I_F.REDO.CUST.PRD.LIST
    $INSERT I_REDO.B.CUST.PRD.ACI.UPD.COMMON
    $INSERT I_F.REDO.ACC.CR.INT

    GOSUB INIT
    GOSUB PROCESS
RETURN
*

INIT:
*----

    PREV.WORKING.DAY = R.DATES(EB.DAT.LAST.WORKING.DAY)
    R.REDO.CUST.PRD.LIST = ''
    ACC.UPD.ERR = ''

    VAR.CUST.PRD.ID = Y.ACCT.NO
RETURN


PROCESS:
*-------



    CALL F.READ(FN.REDO.CUST.PRD.LIST,VAR.CUST.PRD.ID,R.REDO.CUST.PRD.LIST,F.REDO.CUST.PRD.LIST,ACC.UPD.ERR)

    VAR.LAST.WORKING.DAY = R.REDO.CUST.PRD.LIST<PRD.DATE>
    CHANGE @VM TO @FM IN VAR.LAST.WORKING.DAY
    DATE.COUNT = 1
    DATE.FOUND = 1
    GOSUB GET.ACCOUNT

RETURN


*-----------------------------
GET.ACCOUNT:
*------------------------------
*This para is used to final list of account id's for active status
    LOOP
    WHILE DATE.FOUND EQ 1
        DATE.POS = ''
        FIND PREV.WORKING.DAY IN VAR.LAST.WORKING.DAY,DATE.COUNT SETTING DATE.POS THEN
            DATE.COUNT += 1
            VAR.STATUS = R.REDO.CUST.PRD.LIST<PRD.PRD.STATUS,DATE.POS>
            IF VAR.STATUS EQ 'ACTIVE' THEN
                VAR.ACCOUNT = R.REDO.CUST.PRD.LIST<PRD.PRODUCT.ID,DATE.POS>
                GOSUB CHK.ACCOUNT
            END
        END ELSE
            DATE.FOUND = 0
        END
    REPEAT
RETURN
*----------------------------------
CHK.ACCOUNT:
*---------------------------------

    IF VAR.ACCOUNT THEN
        CALL F.READ(FN.ACCOUNT,VAR.ACCOUNT,R.ACCOUNT.CHK,F.ACCOUNT,ACC.ER)
        VAR.OPENING.DATE = R.ACCOUNT.CHK<AC.OPENING.DATE>
        IF VAR.OPENING.DATE NE PREV.WORKING.DAY THEN
            R.Rec = ''
            Err = ''
* lock and read the record
            CALL F.READU(FN.REDO.BATCH.JOB.LIST.FILE, VAR.ACCOUNT, R.Rec, F.REDO.BATCH.JOB.LIST.FILE, Err, 'E')
            IF ((R.Rec EQ '') AND (Err NE 'RECORD LOCKED')) THEN   ;* record not found & Record NOT locked

                CALL F.WRITE(FN.REDO.BATCH.JOB.LIST.FILE, VAR.ACCOUNT, VAR.ACCOUNT)     ;* write record
            END
        END
    END
RETURN
*------------------------------------------------------------------------------------------------------

END
