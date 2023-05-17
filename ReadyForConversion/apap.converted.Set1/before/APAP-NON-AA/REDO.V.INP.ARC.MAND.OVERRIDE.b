*-------------------------------------------------------------------------
* <Rating>-12</Rating>
*-------------------------------------------------------------------------
  SUBROUTINE  REDO.V.INP.ARC.MAND.OVERRIDE
*-------------------------------------------------------------------------
*DESCRIPTION:
*------------


* INPUT/OUTPUT:
*--------------

* OUT : N/A

* DEPENDDENCIES:
*-------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.AI.REDO.ARCIB.PARAMETER
$INSERT I_F.ACCOUNT
$INSERT I_GTS.COMMON
$INSERT I_F.FUNDS.TRANSFER
$INSERT I_F.STANDING.ORDER
  GOSUB PROCESS
  RETURN

*~~~~~~~~~~~~~~~
PROCESS:
*~~~~~~~~~~~~~~~

  TEXT  = 'EB-MINIMUM.SIGNATORY.NOT.REACHED'      ;* Set TEXT for Override
  CALL STORE.OVERRIDE(CURR.NO)          ;* Raise the Override

  RETURN
END
