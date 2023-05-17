SUBROUTINE REDO.V.AUT.UPD.CLAIMS.OPEN
*---------------------------------------------------------------------------------
*This is an auth routine for the version REDO.ISSUE.CLAIMS,OPEN & REDO.ISSUE.CLAIMS,PROCESS
*----------------------------------------------------------------------------------
* Company Name  : ASOCIACION POPUL
* Developed By  : PRadeep S
* Program Name  : REDO.V.AUT.UPD.CLAIMS.OPEN
* ODR NUMBER    :
* HD Reference  : PACS00071941
* LINKED WITH   : REDO.ISSUE.CLAIMS
*----------------------------------------------------------------------
*Input param = none
*output param =none
*-----------------------------------------------------------------------
* MODIFICATION DETAILS:
* Who               Who              Reference           Description
* 12-05-2011        Pradeep S        PACS00071941        Initial Creation
*----------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_System
    $INSERT I_F.REDO.ISSUE.CLAIMS

    GOSUB INIT
    GOSUB PROCESS
RETURN

INIT:
******
    FN.REDO.CLAIM.OPEN = 'F.REDO.CRM.CLAIMS.OPEN'
    F.REDO.CLAIM.OPEN = ''
    CALL OPF(FN.REDO.CLAIM.OPEN,F.REDO.CLAIM.OPEN)

    Y.WRITE.FLAG = @FALSE

RETURN

PROCESS:
**********
    Y.CUST.ID = R.NEW(ISS.CL.CUSTOMER.CODE)
    Y.PRDT.TYPE = R.NEW(ISS.CL.PRODUCT.TYPE)
    Y.STATUS = R.NEW(ISS.CL.STATUS)
    Y.TXN.AMT = R.NEW(ISS.CL.TRANSACTION.AMOUNT)
    Y.ACCT.NO = R.NEW(ISS.CL.ACCOUNT.ID)
    Y.CC.NO = R.NEW(ISS.CL.CARD.NO)

    IF Y.ACCT.NO THEN
        Y.VALUE = ID.NEW:"*":Y.ACCT.NO:"*":Y.TXN.AMT
    END
    IF Y.CC.NO THEN
        Y.VALUE = ID.NEW:"*":Y.CC.NO:"*":Y.TXN.AMT
    END

    Y.FILE.ID = Y.CUST.ID:'-':Y.PRDT.TYPE
    R.FILE.REC = ''
    CALL F.READ(FN.REDO.CLAIM.OPEN,Y.FILE.ID,R.FILE.REC,F.REDO.CLAIM.OPEN,FILE.ERR)

    BEGIN CASE
        CASE Y.STATUS EQ 'OPEN'
            GOSUB WRITE.FILE
        CASE Y.STATUS EQ 'IN-PROCESS'
            GOSUB DELETE.FILE
    END CASE

    IF Y.WRITE.FLAG THEN
        CALL F.WRITE(FN.REDO.CLAIM.OPEN,Y.FILE.ID,R.FILE.REC)
    END

RETURN

WRITE.FILE:
************

    Y.WRITE.FLAG = @TRUE

    IF R.FILE.REC THEN
        R.FILE.REC<-1> = Y.VALUE
    END ELSE
        R.FILE.REC = Y.VALUE
    END

RETURN

DELETE.FILE:
*************

    Y.WRITE.FLAG = @TRUE

    IF R.FILE.REC THEN
        Y.CLAIM.ID = FIELDS(R.FILE.REC,'*',1,1)
        LOCATE ID.NEW IN Y.CLAIM.ID SETTING Y.ID.POS THEN
            DEL R.FILE.REC<Y.ID.POS>
        END
    END

RETURN

END
