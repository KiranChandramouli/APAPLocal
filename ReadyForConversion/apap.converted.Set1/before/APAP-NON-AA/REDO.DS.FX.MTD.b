*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.DS.FX.MTD(Y.OUT.VAR)
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :Pradeep S
*Program   Name    :REDO.DS.FX.MTD
*---------------------------------------------------------------------------------
*DESCRIPTION       :This program is used to get the value from EB.LOOKUP TABLE
* ----------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.USER

  GOSUB PROCESS

  RETURN

*********
PROCESS:
*********

  Y.LOOKUP.ID   = "FX.PAY.RCP.MTD"
  Y.LOOOKUP.VAL = Y.OUT.VAR
  Y.DESC.VAL    = ''
  CALL REDO.EB.LOOKUP.LIST(Y.LOOKUP.ID,Y.LOOOKUP.VAL,Y.DESC.VAL,RES1,RES2)

  Y.OUT.VAR = Y.DESC.VAL

  RETURN

END
