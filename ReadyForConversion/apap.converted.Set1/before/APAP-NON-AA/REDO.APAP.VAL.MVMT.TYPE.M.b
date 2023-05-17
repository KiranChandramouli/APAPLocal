*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.APAP.VAL.MVMT.TYPE.M
*********************************************************************************************************
*Company   Name    : APAP Bank
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.VAL.MVMT.TYPE.M
*--------------------------------------------------------------------------------------------------------
*Description       : This routine ia a validation routine. It is used to check if the value selected is
*                    RECEIVED BY VAULT then throw an error
*Linked With       : COLLATERAL,DOC.RECEPTION
*In  Parameter     :
*Out Parameter     :
*Files  Used       : COLLATERAL                           As        I  Mode
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 20/05/2010        REKHA S         ODR-2009-10-0310 B.180C      Initial Creation
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

  IF COMI EQ "ReceivedbyVault" THEN
    ETEXT = 'CO-MVMT.TYPE.M'

    CALL STORE.END.ERROR
  END

  RETURN
*--------------------------------------------------------------------------------------------------------
END
