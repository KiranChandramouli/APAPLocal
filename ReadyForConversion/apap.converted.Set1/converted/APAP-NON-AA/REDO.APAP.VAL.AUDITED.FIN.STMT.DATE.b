SUBROUTINE REDO.APAP.VAL.AUDITED.FIN.STMT.DATE
*********************************************************************************************************
*Company   Name    : APAP Bank
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.VAL.AUDITED.FIN.STMT.DATE
*--------------------------------------------------------------------------------------------------------
*Description       : This routine ia a validation routine. It is used to check if the Financial
*                    Information Documents provided are "Audited Financial Statements", if YES then make
*                    the field Audited Financial Statement Date mandatory and also check the Audited
*                    Financial Statement Date is not greater than TODAY
*Linked With       : COLLATERAL,DOC.RECEPTION
*In  Parameter     :
*Out Parameter     :
*Files  Used       : COLLATERAL             As          I Mode
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 21/05/2010    Shiva Prasad Y     ODR-2009-10-0310 B.180C      Initial Creation
*
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.COLLATERAL
*--------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
    GOSUB PROCESS.PARA

RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
    GOSUB FIND.MULTI.LOCAL.REF

    IF R.NEW(COLL.LOCAL.REF)<1,LOC.L.CO.FIN.DOCS> NE '' AND NOT(COMI) THEN
        ETEXT = 'CO-MANDATORY.A.FIN.STMT.DATE'
        CALL STORE.END.ERROR
    END

    IF R.NEW(COLL.LOCAL.REF)<1,LOC.L.CO.FIN.DOCS> EQ "" AND COMI THEN
        ETEXT = 'CO-NO.A.FIN.STMT.DATE'
        CALL STORE.END.ERROR
    END

    IF COMI GT TODAY THEN
        ETEXT = 'CO-A.FIN.STMT.DATE.GT.TODAY'
        CALL STORE.END.ERROR
    END

RETURN
*--------------------------------------------------------------------------------------------------------
*********************
FIND.MULTI.LOCAL.REF:
*********************
    APPL.ARRAY = 'COLLATERAL'
    FLD.ARRAY  = 'L.CO.FIN.DOCS':@VM:'L.CO.A.FIN.DATE'
    FLD.POS    = ''
    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)
    LOC.L.CO.FIN.DOCS      = FLD.POS<1,1>
    LOC.L.CO.A.FIN.DATE    = FLD.POS<1,2>

RETURN
*---------------------------------------------------------------------------------------------------------------------------
END
