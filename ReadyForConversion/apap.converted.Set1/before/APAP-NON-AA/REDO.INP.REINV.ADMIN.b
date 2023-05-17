*-----------------------------------------------------------------------------
* <Rating>-43</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE REDO.INP.REINV.ADMIN

*-------------------------------------------
* DESCRIPTION: This routine is to update the REDO.TEMP.VERSION.IDS.


*----------------------------------------------------------------------------
* Modification History :
*----------------------------------------------------------------------------
*
* DATE WHO REFERENCE DESCRIPTION
* 14-Jul-2011 H Ganesh PACS00072695 - N.11 Initial Draft.
* 15-Mar-2013 Vignesh Kumaar R PACS00251345 To include FT records posted through FUNDS.TRANSFER,CHQ.GOVT.WITH.TAX
*----------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.FUNDS.TRANSFER
$INSERT I_F.REDO.TEMP.VERSION.IDS

GOSUB INIT
GOSUB PROCESS

RETURN
*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------

FN.REDO.TEMP.VERSION.IDS = 'F.REDO.TEMP.VERSION.IDS'
F.REDO.TEMP.VERSION.IDS = ''
CALL OPF(FN.REDO.TEMP.VERSION.IDS,F.REDO.TEMP.VERSION.IDS)

RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------

LOC.REF.APPLICATION = "FUNDS.TRANSFER"
LOC.REF.FIELDS = 'L.FT.AZ.TXN.REF'
LOC.REF.POS = ''
CALL GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,POS.L.FT.AZ.TXN.REF)


* Fix for PACS00251345 [To include FT records posted through FUNDS.TRANSFER,CHQ.GOVT.WITH.TAX]

Y.VERSION.ID.LIST = 'FUNDS.TRANSFER,CHQ.OTHERS.DEPOSIT':FM:'FUNDS.TRANSFER,CHQ.NO.TAX.DEPOSIT':FM:'FUNDS.TRANSFER,CHQ.GOVT.WITH.TAX'

LOOP
REMOVE Y.VERSION.ID FROM Y.VERSION.ID.LIST SETTING VERSION.POST
WHILE Y.VERSION.ID:Y.VERSION.ID.LIST

CALL F.READ(FN.REDO.TEMP.VERSION.IDS,Y.VERSION.ID,R.VERSION.IDS,F.REDO.TEMP.VERSION.IDS,VERSION.ERR)
Y.FT.ID = R.NEW(FT.LOCAL.REF)<1,POS.L.FT.AZ.TXN.REF>

LOCATE Y.FT.ID IN R.VERSION.IDS<REDO.TEM.AUT.TXN.ID,1> SETTING POS.ID THEN

GOSUB WRITE.AUTH
EXIT
END

REPEAT

* End of Fix

RETURN
*-----------------------------------------------------------------------------
WRITE.AUTH:
*-----------------------------------------------------------------------------

DEL R.VERSION.IDS<REDO.TEM.AUT.TXN.ID,POS.ID>
DEL R.VERSION.IDS<REDO.TEM.PROCESS.DATE,POS.ID>
R.VERSION.IDS<REDO.TEM.REV.TXN.ID,POS.ID> = Y.FT.ID
R.VERSION.IDS<REDO.TEM.REV.TXN.DATE,POS.ID> = TODAY
CALL F.WRITE(FN.REDO.TEMP.VERSION.IDS,Y.VERSION.ID,R.VERSION.IDS)

Y.VER.ID = 'FUNDS.TRANSFER,CHQ.REV.AUTH'
CALL F.READ(FN.REDO.TEMP.VERSION.IDS,Y.VER.ID,R.VERSION.IDS,F.REDO.TEMP.VERSION.IDS,VERSION.ERR)
R.VERSION.IDS<REDO.TEM.REV.TXN.ID,-1> = ID.NEW
R.VERSION.IDS<REDO.TEM.REV.TXN.DATE,-1> = TODAY
CALL F.WRITE(FN.REDO.TEMP.VERSION.IDS,Y.VER.ID,R.VERSION.IDS)

RETURN
*-----------------------------------------------------------------------------
END
