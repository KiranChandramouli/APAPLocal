*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.B.UPD.USER.LOG.SELECT
*-------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.B.UPD.USER.LOG.SELECT
*-------------------------------------------------------------------------
*Description  : This is a validation routine to check the card is valid or
*               This routine has to be attached to versions used in ATM tr
*               to find out whether the status entered is valid or not
*In Parameter : N/A
*Out Parameter: N/A
*-------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Descript
*   ------         ------               -------------            ---------
* 01 NOV  2010     SRIRAMAN.C                                     Initial
* 01 May 2015      Ashokkumar            PACS00310287             Removed multiple filtering and added in main routine.
*-------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_REDO.B.UPD.USER.LOG.COMMON


  SEL.CMD.1 = "SELECT ":FN.PROTO
  SEL.CMD.1 : = " WITH APPLICATION EQ 'SIGN.ON'"
  CALL EB.READLIST(SEL.CMD.1,SEL.LIST,'',NO.REC,RET.CODE)
  CALL BATCH.BUILD.LIST("",SEL.LIST)
  RETURN
END
