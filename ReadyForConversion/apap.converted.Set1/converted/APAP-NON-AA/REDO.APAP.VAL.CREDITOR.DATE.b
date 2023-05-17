SUBROUTINE REDO.APAP.VAL.CREDITOR.DATE
*********************************************************************************************************
*Company   Name    : APAP Bank
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.VAL.CREDITOR.DATE
*--------------------------------------------------------------------------------------------------------
*Description       : This routine ia a validation routine. It is used to check if the Creditor Date
*                    doesnot exceed 180 days from TODAY
*Linked With       : COLLATERAL,DOC.RECEPTION
*In  Parameter     :
*Out Parameter     :
*Files  Used       : COLLATERAL             As          I Mode
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 20/05/2010    Shiva Prasad Y     ODR-2009-10-0310 B.180C      Initial Creation
*
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_GTS.COMMON
    $INSERT I_F.COLLATERAL
*--------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********

    Y.REGION = ''
    IF NOT(COMI) THEN
        RETURN
    END
    Y.DIFF.DAYS = 'C'
    CALL CDD(Y.REGION,TODAY,COMI,Y.DIFF.DAYS)

    IF Y.DIFF.DAYS GT 180 THEN
        ETEXT = 'CO-DELV.GT.180'
        CALL STORE.END.ERROR
    END ELSE
        TASK.NAME = "ENQ REDO.ENQ.LOAN.DETS DATE EQ ":COMI
        CALL EB.SET.NEW.TASK(TASK.NAME)
    END

RETURN
*--------------------------------------------------------------------------------------------------------
END
