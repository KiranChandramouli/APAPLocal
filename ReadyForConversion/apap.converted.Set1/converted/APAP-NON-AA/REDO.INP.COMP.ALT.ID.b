SUBROUTINE REDO.INP.COMP.ALT.ID
*-----------------------------------------------------------------------------
*----------------------------------------------------------------------------------------------------
*DESCRIPTION : This Input routine is used to update the alternate.id field
*-----------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : SUDHARSANAN S
* PROGRAM NAME : REDO.INP.COMP.ALT.ID
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO                REFERENCE         DESCRIPTION
* 27.08.2010      SUDHARSANAN S     ODR-2009-12-0283  INITIAL CREATION
* ----------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.REDO.ISSUE.COMPLAINTS
    $INSERT I_F.REDO.CUST.COMPLAINTS
    $INSERT I_F.CUSTOMER
    GOSUB INIT
    GOSUB PROCESS
RETURN
*------------------------------------------------------------------------------------------------------
INIT:
*------------------------------------------------------------------------------------------------------
    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.REDO.ISSUE.COMPLAINTS='F.REDO.ISSUE.COMPLAINTS'
    F.REDO.ISSUE.COMPLAINTS =''
    CALL OPF(FN.REDO.ISSUE.COMPLAINTS,F.REDO.ISSUE.COMPLAINTS)

    FN.REDO.CUST.COMPLAINTS = 'F.REDO.CUST.COMPLAINTS'
    F.REDO.CUST.COMPLAINTS = ''
    CALL OPF(FN.REDO.CUST.COMPLAINTS,F.REDO.CUST.COMPLAINTS)

RETURN
*--------------------------------------------------------------------------------------------------------
PROCESS:
*--------------------------------------------------------------------------------------------------------

    Y.CUST.ID          = R.NEW(ISS.COMP.CUSTOMER.CODE)

*  CALL F.READ(FN.REDO.CUST.COMPLAINTS,'SYSTEM',R.REDO.CUST.COM,F.REDO.CUST.COMPLAINTS,CUST.COM.ERR) ;*Tus Start
    CALL CACHE.READ(FN.REDO.CUST.COMPLAINTS,'SYSTEM',R.REDO.CUST.COM,CUST.COM.ERR) ; * Tus End
    VAR.CUST.ID        = R.REDO.CUST.COM<CUST.COM.CUST.ID>
    CHANGE @VM TO @FM IN VAR.CUST.ID
    LOCATE Y.CUST.ID IN VAR.CUST.ID SETTING POS1 THEN
        VAR.SEQ.NO     = R.REDO.CUST.COM<CUST.COM.CUST.SEQ.NO,POS1>
        VAR.CUS.SEQ.NO = VAR.SEQ.NO+1
        R.REDO.CUST.COM<CUST.COM.CUST.SEQ.NO,POS1> = VAR.CUS.SEQ.NO
        Y.APAP.SEQ     = R.REDO.CUST.COM<CUST.COM.APAP.SEQ.NO>
        Y.SEQ          = Y.APAP.SEQ+1
    END ELSE
        CNT            = DCOUNT(VAR.CUST.ID,@FM)
        VAR.CUS.SEQ.NO = '1'
        R.REDO.CUST.COM<CUST.COM.CUST.ID,CNT+1>      = Y.CUST.ID
        R.REDO.CUST.COM<CUST.COM.CUST.SEQ.NO,CNT+1>  = VAR.CUS.SEQ.NO
    END
    APAP.SEQ.NO        = R.REDO.CUST.COM<CUST.COM.APAP.SEQ.NO>
    IF APAP.SEQ.NO THEN
        Y.APAP.SEQ     = R.REDO.CUST.COM<CUST.COM.APAP.SEQ.NO>
        Y.SEQ          = Y.APAP.SEQ+1
        R.REDO.CUST.COM<CUST.COM.APAP.SEQ.NO> = Y.SEQ
    END ELSE
        R.REDO.CUST.COM<CUST.COM.APAP.SEQ.NO> = '1'
        Y.SEQ = R.REDO.CUST.COM<CUST.COM.APAP.SEQ.NO>
        R.REDO.CUST.COM<CUST.COM.APAP.SEQ.NO> = Y.SEQ
    END

    R.NEW(ISS.COMP.ALTERNATE.ID)= Y.CUST.ID:'-':VAR.CUS.SEQ.NO:'-':Y.SEQ
    CUST.COM.ID = 'SYSTEM'
    CALL F.WRITE(FN.REDO.CUST.COMPLAINTS,CUST.COM.ID,R.REDO.CUST.COM)

RETURN
*------------------------------------------------------------------------------------------------------------
END
