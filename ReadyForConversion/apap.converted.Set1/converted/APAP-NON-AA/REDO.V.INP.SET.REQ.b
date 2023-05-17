SUBROUTINE REDO.V.INP.SET.REQ
*---------------------------------------------------------------------------------
*This is an input routine for the version APAP.H.GARNISH.DETAILS,INP, it will check
*whether the registration of garnishment for APAP customer or not
*----------------------------------------------------------------------------------
* Company Name  : ASOCIACION POPUL
* Developed By  : PRABHU N
* Program Name  :
* ODR NUMBER    :
* HD Reference  : HD1100441
*LINKED WITH:
*----------------------------------------------------------------------
*Input param = none
*output param =none
*-----------------------------------------------------------------------
*MODIFICATION DETAILS:
* Date              Who              Reference      Description
* 16-02-2011        Prabhu.N         HD1100441      Auto Launch of Enquiry
* 24-05-2011        Ganesh H         PACS00071066   Document Received changes
*----------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_System
    $INSERT I_GTS.COMMON
    $INSERT I_F.REDO.FRONT.REQUESTS
    $INSERT I_REDO.SET.REQ.COMP.ID

    GOSUB OPEN.FILES
    GOSUB INITIAL.CHECK

RETURN
*-----------------------------------------------------
OPEN.FILES:
*-----------------------------------------------------
    FN.REDO.CRM.DOC.DATE='F.REDO.CRM.DOC.DATE'
    F.REDO.CRM.DOC.DATE=''
    CALL OPF(FN.REDO.CRM.DOC.DATE,F.REDO.CRM.DOC.DATE)

    FN.REDO.CRM.DOC.REQ='F.REDO.CRM.DOC.REQ'
    F.REDO.CRM.DOC.REQ=''
    CALL OPF(FN.REDO.CRM.DOC.REQ,F.REDO.CRM.DOC.REQ)

RETURN
PROCESS:

    FN.CUST.REQUESTS='F.REDO.CUSTOMER.REQUESTS'
    F.CUST.REQUESTS=''
    CALL OPF(FN.CUST.REQUESTS,F.CUST.REQUESTS)
    GOSUB DELETE.CONCAT
    Y.VAR.ID=R.NEW(FR.CM.CUSTOMER.CODE)
    CALL F.READ(FN.CUST.REQUESTS,Y.VAR.ID,R.REQUESTS,F.CUST.REQUESTS,ERR)
    Y.VAR.CUS.NO=1
    IF R.REQUESTS THEN
        Y.VAR.CUS.NO=R.REQUESTS
    END
    R.REQUESTS+=1
    Y.VAR.CUS.SEQ=FMT(Y.VAR.CUS.NO,"R%7")
    Y.ID.FORM=Y.VAR.ID : '.' : Y.VAR.CUS.SEQ : '.' : ID.NEW
    Y.CUST.ID=R.NEW(FR.CM.CUSTOMER.CODE)
    Y.ACC.ID=R.NEW(FR.CM.ACCOUNT.ID)
    MATBUILD Y.CURRENT.REC FROM R.NEW,1,86
    CHANGE @FM TO '*##' IN Y.CURRENT.REC
    CALL System.setVariable("CURRENT.REC",Y.CURRENT.REC)
    CALL F.WRITE(FN.CUST.REQUESTS,Y.VAR.ID,R.REQUESTS)
    CRM.CUR.TXN.ID=Y.ID.FORM


RETURN
*------------------------------------------------------------------
INITIAL.CHECK:
*------------------------------------------------------------------

    Y.DOC.NAME     = R.NEW(FR.CM.DOC.NAME)
    Y.DOC.RECEIVED = R.NEW(FR.CM.DOC.REV)
    IF Y.DOC.NAME THEN
        LOCATE 'NO' IN Y.DOC.RECEIVED<1,1> SETTING DOC.POS THEN
            GOSUB UPDATE.CONCAT
        END ELSE
            GOSUB PROCESS
        END
    END ELSE
        GOSUB PROCESS
    END
RETURN

*------------------------------------------------------------------
UPDATE.CONCAT:
*------------------------------------------------------------------

    CALL F.READ(FN.REDO.CRM.DOC.REQ,ID.NEW,R.REDO.CRM.DOC.REQ,F.REDO.CRM.DOC.REQ,DOC.REQ.ERR)
    IF NOT(R.REDO.CRM.DOC.REQ) THEN
        CALL F.READ(FN.REDO.CRM.DOC.DATE,TODAY,R.REDO.CRM.DOC.DATE,F.REDO.CRM.DOC.DATE,DOC.DATE.ERR)
        R.REDO.CRM.DOC.DATE<-1>=ID.NEW
        CALL F.WRITE(FN.REDO.CRM.DOC.DATE,TODAY,R.REDO.CRM.DOC.DATE)
        CALL F.WRITE(FN.REDO.CRM.DOC.REQ,ID.NEW,TODAY)
    END

RETURN
*------------------------------------------------------------------
DELETE.CONCAT:
*------------------------------------------------------------------
    CALL F.READ(FN.REDO.CRM.DOC.REQ,ID.NEW,R.REDO.CRM.DOC.REQ,F.REDO.CRM.DOC.REQ,DOC.REQ.ERR)
    Y.DATE=R.REDO.CRM.DOC.REQ
    CALL F.READ(FN.REDO.CRM.DOC.DATE,Y.DATE,R.REDO.CRM.DOC.DATE,F.REDO.CRM.DOC.DATE,DOC.DATE.ERR)
    LOCATE ID.NEW IN R.REDO.CRM.DOC.DATE SETTING POS.DATE THEN
        DEL R.REDO.CRM.DOC.DATE<POS.DATE>
        CALL F.WRITE(FN.REDO.CRM.DOC.DATE,Y.DATE,R.REDO.CRM.DOC.DATE)
    END
    CALL F.DELETE(FN.REDO.CRM.DOC.REQ,ID.NEW)

RETURN
END
