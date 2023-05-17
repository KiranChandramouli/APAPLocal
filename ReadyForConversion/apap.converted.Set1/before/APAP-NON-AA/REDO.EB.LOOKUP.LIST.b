*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.EB.LOOKUP.LIST(Y.LOOKUP.ID,Y.LOOOKUP.VAL,Y.DESC.VAL,RES1,RES2)

*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :Pradeep S
*Program   Name    :REDO.EB.LOOKUP.LIST
*---------------------------------------------------------------------------------
*DESCRIPTION       : This routine will get the discription of EB.LOOKUP value
* ----------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.USER

  GOSUB PROCESS
  RETURN

PROCESS:
**********

  VIRTUAL.TAB.ID = Y.LOOKUP.ID
  LOOKUP.VAL     = Y.LOOOKUP.VAL
  Y.DESC.VAL     = ''

  CALL EB.LOOKUP.LIST(VIRTUAL.TAB.ID)
  Y.LOOKUP.LIST=VIRTUAL.TAB.ID<2>
  Y.LOOKUP.DESC=VIRTUAL.TAB.ID<11>
  CHANGE '_' TO FM IN Y.LOOKUP.LIST
  CHANGE '_' TO FM IN Y.LOOKUP.DESC

  LOCATE LOOKUP.VAL IN Y.LOOKUP.LIST SETTING POS1 THEN
    Y.DESC.VAL = Y.LOOKUP.DESC<POS1,LNGG>
    IF Y.DESC.VAL EQ '' THEN
      Y.DESC.VAL = Y.LOOKUP.DESC<POS1,1>
    END
  END

  RETURN
END
