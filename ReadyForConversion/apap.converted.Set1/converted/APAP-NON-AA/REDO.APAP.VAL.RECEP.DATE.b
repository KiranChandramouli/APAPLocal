SUBROUTINE REDO.APAP.VAL.RECEP.DATE
*********************************************************************************************************
*Company   Name    : APAP Bank
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.VAL.RECEPTION.DATE
*--------------------------------------------------------------------------------------------------------
*Description       : This routine ia a validation routine. It is used to check if the Security Documents
*                    have been given, if YES then make the field Reception Date mandatory and also check
*                    the reception date is not greater than TODAY
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
* 04/05/2011    Kavitha            PACS00054322 B.180C          Bug Fix
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

    IF COMI GT TODAY THEN
        ETEXT = 'CO-DOC.REC.GT.TODAY'
        CALL STORE.END.ERROR
    END
RETURN
END
