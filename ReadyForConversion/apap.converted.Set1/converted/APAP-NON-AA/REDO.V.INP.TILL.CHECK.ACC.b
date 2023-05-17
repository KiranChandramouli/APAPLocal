*-----------------------------------------------------------------------------
* <Rating>-42</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE REDO.V.INP.TILL.CHECK.ACC
*--------------------------------------------------------------------------------
*Company Name :Asociacion Popular de Ahorros y Prestamos
*Developed By :PRABHU.N
*Program Name :REDO.V.INP.FT.CHECK.ACC
*---------------------------------------------------------------------------------

*DESCRIPTION :Input routine generates override when TT involves Account which
* is not active
*LINKED WITH :

* ----------------------------------------------------------------------------------
*Modification Details:
*=====================
* DATE WHO REFERENCE DESCRIPTION
* NA PRABHU ODR-2009-10-0339 Initial Creation
* 19-Apr-11 H Ganesh PACS00054881 Override with account number for inactive status.
*-----------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.USER
$INSERT I_F.TELLER
$INSERT I_F.ACCOUNT


GOSUB INIT
GOSUB PROCESS
GOSUB ASSIGN
RETURN
*----
INIT:
*----
FN.ACCOUNT='F.ACCOUNT'
F.ACCOUNT=''
LREF.APP='ACCOUNT'
LREF.FIELD='L.AC.STATUS1'
RETURN
*-------
PROCESS:
*-------
CALL OPF(FN.ACCOUNT,F.ACCOUNT)
CALL GET.LOC.REF(LREF.APP,LREF.FIELD,LREF.POS)
RETURN
*------
ASSIGN:
*------

Y.CR.DEB.ID=R.NEW(TT.TE.ACCOUNT.1)
GOSUB OVERRIDE.GEN
Y.CR.DEB.ID=R.NEW(TT.TE.ACCOUNT.2)
GOSUB OVERRIDE.GEN
RETURN
*-----------
OVERRIDE.GEN:
*-----------

CALL F.READ(FN.ACCOUNT,Y.CR.DEB.ID,R.ACCOUNT,F.ACCOUNT,DEB.ERR)
Y.STATUS=R.ACCOUNT<AC.LOCAL.REF,LREF.POS>
VIRTUAL.TAB.ID='L.AC.STATUS1'
IF Y.STATUS NE 'ACTIVE' AND Y.STATUS NE '' AND R.ACCOUNT<AC.CUSTOMER> NE '' THEN
CALL EB.LOOKUP.LIST(VIRTUAL.TAB.ID)
Y.LOOKUP.LIST=VIRTUAL.TAB.ID<2>
Y.LOOKUP.DESC=VIRTUAL.TAB.ID<11>
CHANGE '_' TO FM IN Y.LOOKUP.LIST
CHANGE '_' TO FM IN Y.LOOKUP.DESC
LOCATE Y.STATUS IN Y.LOOKUP.LIST SETTING POS1 THEN
IF R.USER<EB.USE.LANGUAGE> EQ 1 THEN ;* This is for english user
Y.MESSAGE=Y.LOOKUP.DESC<POS1,1>
END
IF R.USER<EB.USE.LANGUAGE> EQ 2 AND Y.LOOKUP.DESC<POS1,2> NE '' THEN
Y.MESSAGE=Y.LOOKUP.DESC<POS1,2> ;* This is for spanish user
END ELSE
Y.MESSAGE=Y.LOOKUP.DESC<POS1,1>
END
END
TEXT="REDO.AC.CHECK.ACTIVE":FM:Y.CR.DEB.ID:VM:Y.MESSAGE
OVERRIDE.FIELD.VALUE = R.NEW(AC.OVERRIDE)
CURR.NO = DCOUNT(OVERRIDE.FIELD.VALUE,VM) + 1
CALL STORE.OVERRIDE(CURR.NO)
END

RETURN
END
