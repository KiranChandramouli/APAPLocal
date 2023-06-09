*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.B.CHG.INACTIVE.ACCT.SELECT
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.B.CHG.INACTIVE.ACCT.SELECT
*--------------------------------------------------------------------------------------------------------
*Description  : This is a select routine whcih will select all ACCOUNT records
*
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 30 Mar 2011    Krishna Murthy T.S   ODR-2011-03-0142           Initial Creation
*--------------------------------------------------------------------------------------------------------
$INSERT I_EQUATE
$INSERT I_COMMON
$INSERT I_F.ACCOUNT
$INSERT I_REDO.B.CHG.INACTIVE.ACCT.COMMON

  SEL.CMD   = "SELECT ":FN.ACCOUNT
  SEL.LIST  = ''
  NO.OF.REC = ''
  RET.CODE  = ''

  CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,RET.CODE)
  CALL BATCH.BUILD.LIST('',SEL.LIST)
  RETURN
END
