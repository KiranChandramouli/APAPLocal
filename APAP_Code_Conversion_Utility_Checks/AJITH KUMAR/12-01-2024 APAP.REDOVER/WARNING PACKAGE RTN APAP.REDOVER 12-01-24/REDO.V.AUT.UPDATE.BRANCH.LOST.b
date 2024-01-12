$PACKAGE APAP.REDOVER

SUBROUTINE REDO.V.AUT.UPDATE.BRANCH.LOST
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.V.AUT.UPDATE.BRANCH.STK
*--------------------------------------------------------------------------------------------------------
*Description  : This is an authorisation routine to update STOCK.REGISTER
*Linked With  : STOCK.ENTRY,REDO.CARDMV
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 11 Mar 2011    Swaminathan            ODR-2010-03-0400         Initial Creation
*14-07-2023    CONVERSION TOOL     R22 AUTO CONVERSION     VM TO @VM,FM TO @FM,SM TO @SM,++ TO +=1
*14-07-2023    VICTORIA S          R22 MANUAL CONVERSION   VARIABLE NAME MODIFIED
*--------------------------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.STOCK.ENTRY
$INSERT I_F.REDO.BRANCH.REQ.STOCK

GOSUB INITIALIZE
GOSUB PROCESS
RETURN

*-----------------------------------------------------------------------------
INITIALIZE:
*-----------------------------------------------------------------------------

FN.BRANCH.REQ.STOCK = 'F.REDO.BRANCH.REQ.STOCK'
F.BRANCH.REQ.STOCK = ''
CALL OPF(FN.BRANCH.REQ.STOCK,F.BRANCH.REQ.STOCK)


*In this para of code local reference field positions are identified

APPL.ARRAY='STOCK.ENTRY'
FLD.ARRAY='L.SE.DAMAGED.NO':@VM:'L.SE.CARDS.LOST':@VM:'L.SE.CRD.SERIES':@VM:'L.SE.BATCH.NO' ;*R22 AUTO CONVERSION
FLD.POS=''
CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)
L.SE.DAMAGE.NO.POS   = FLD.POS<1,1>
L.SE.CARDS.LOST.POS  = FLD.POS<1,2>
L.SE.CRD.SERIES.POS  = FLD.POS<1,3>
L.SE.BATCH.NO.POS    = FLD.POS<1,4>

RETURN
*-------------------------------------------------------------------------
PROCESS:
*-------------------------------------------------------------------------

Y.SERIES.STOCK = R.NEW(STO.ENT.LOCAL.REF)<1,L.SE.CRD.SERIES.POS>
CHANGE @SM TO @VM IN Y.SERIES.STOCK ;*R22 AUTO CONVERSION START
CHANGE @FM TO @VM IN Y.SERIES.STOCK
Y.COUNT = DCOUNT(Y.SERIES.STOCK,@VM) ;*R22 AUTO CONVERSION END
Y.CNT = 1
LOOP
WHILE Y.CNT LE Y.COUNT
Y.CUEENT.STOCK = Y.SERIES.STOCK<1,Y.CNT>
Y.ID = Y.CUEENT.STOCK[1,2]
GOSUB SUBPROCESS
Y.CNT += 1 ;*R22 AUTO CONVERSION
REPEAT
RETURN
*-------------------------------------------------------------------------
SUBPROCESS:
*-------------------------------------------------------------------------

*CALL F.READ(FN.BRANCH.REQ.STOCK,Y.ID,R.BRANCH.REQ.STOCK,F.BRANCH.REQ.STOCK,Y.ERR)
CALL F.READU(FN.BRANCH.REQ.STOCK,Y.ID,R.BRANCH.REQ.STOCK,F.BRANCH.REQ.STOCK,Y.ERR,'');* R22 AUTO CONVERSION
Y.REQ.ID = R.BRANCH.REQ.STOCK<BRAN.STK.REQUEST.ID>
Y.AGENCY = R.BRANCH.REQ.STOCK<BRAN.STK.AGENCY>
CHANGE @VM TO @FM IN Y.REQ.ID ;*R22 AUTO CONVERSION
Y.BATCH.NUMBER = R.NEW(STO.ENT.LOCAL.REF)<1,L.SE.BATCH.NO.POS>
Y.LOST =   R.NEW(STO.ENT.LOCAL.REF)<1,L.SE.CARDS.LOST.POS>
Y.DAMAGE = R.NEW(STO.ENT.LOCAL.REF)<1,L.SE.DAMAGE.NO.POS>
IF Y.LOST OR Y.DAMAGE THEN
LOCATE Y.BATCH.NUMBER IN Y.REQ.ID SETTING POS THEN
GOSUB BRANCH.UPDATE
END
END
RETURN
*-------------------------------------------------------------------------
BRANCH.UPDATE:
*-------------------------------------------------------------------------
R.BRANCH.REQ.STOCK<BRAN.STK.LOST,POS> = Y.LOST
R.BRANCH.REQ.STOCK<BRAN.STK.DAMAGE,POS> = Y.DAMAGE
*Y.FINAL = R.BRANCH.REQ.STOCK<BRAN.STK.FINALY.QTY,POS>
Y.FINAL = R.BRANCH.REQ.STOCK<BRAN.STK.CURRENT.QTY,POS> ;*R22 MANUAL CONVERSION
Y.INITIAL = R.BRANCH.REQ.STOCK<BRAN.STK.INITIAL.STK,POS>
Y.QTY.REQ = R.BRANCH.REQ.STOCK<BRAN.STK.QTY.REQUEST,POS>
CALL F.WRITE(FN.BRANCH.REQ.STOCK,Y.ID,R.BRANCH.REQ.STOCK)
RETURN
*-------------------------------------------------------------------------
END
