*-----------------------------------------------------------------------------
* <Rating>-21</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.S.UPD.CUS.ACTANAC.SELECT

* Correction routine to update the file F.CUSTOMER.L.CU.ACTANAC
*

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.CUSTOMER
$INSERT I_REDO.S.UPD.CUS.ACTANAC.COMMON

  GOSUB PROCESS

  RETURN

*********
PROCESS:
*********
* Main process to selct all the customer with actanac id

  SEL.LIST = ''

  SEL.CMD = "SELECT ":FN.CUS:" WITH L.CU.ACTANAC NE '' "

  CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NOR,ERR)

  CALL BATCH.BUILD.LIST('',SEL.LIST)

  RETURN

END
