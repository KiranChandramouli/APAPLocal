*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE REDO.V.AUTH.UPDATE.TELLER.TRANS
*--------------------------------------------------------------------------------
*Company Name :Asociacion Popular de Ahorros y Prestamos
*Developed By :PRABHU.N
*Program Name :REDO.V.AUTH.UPDATE.TELLER.TRANS
*---------------------------------------------------------------------------------

*DESCRIPTION :It is attached as authorization routine in all the version used
* in the development N.83.It will update local table
* REDO.CREDIT.TRANS.TELLER
*LINKED WITH :

* ----------------------------------------------------------------------------------
*Modification Details:
*=====================
* Date who Reference Description
* 16-APR-2010 Prabhu.N ODR-2009-10-0536 Initial Creation
*-----------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.TELLER
$INSERT I_F.REDO.CREDIT.TRANS.TELLER
GOSUB INIT
GOSUB PROCESS
RETURN
*-----
INIT:
*-----
FN.REDO.CREDIT.TRANS.TELLER='F.REDO.CREDIT.TRANS.TELLER'
F.REDO.CREDIT.TRANS.TELLER=''
CALL OPF(FN.REDO.CREDIT.TRANS.TELLER,F.REDO.CREDIT.TRANS.TELLER)
LREF.APPL='TELLER'
LREF.FIELDS='L.TT.CLIENT.COD'
LREF.POS=''
CALL GET.LOC.REF(LREF.APPL,LREF.FIELDS,LREF.POS)
VAR.CREDIT.CARD.NO=R.NEW(TT.TE.LOCAL.REF)<1,LREF.POS>
VAR.CREDIT.CARD.ID=VAR.CREDIT.CARD.NO:'.':TODAY
RETURN
*--------
PROCESS:
*--------

CALL F.READ(FN.REDO.CREDIT.TRANS.TELLER,VAR.CREDIT.CARD.ID,R.REDO.CREDIT.TRANS.TELLER,F.REDO.CREDIT.TRANS.TELLER,TILL.ERR)
IF R.NEW(TT.TE.RECORD.STATUS) NE 'RNAU' THEN
VAR.TRANS.LIST=R.REDO.CREDIT.TRANS.TELLER<CT.TRANSACTION.ID>
CHANGE VM TO FM IN VAR.TRANS.LIST
VAR.TRANS.LIST<-1>=ID.NEW

END
ELSE
VAR.TRANS.LIST=R.REDO.CREDIT.TRANS.TELLER<CT.TRANSACTION.ID>
CHANGE VM TO FM IN VAR.TRANS.LIST
LOCATE VAR.CREDIT.CARD.NO IN VAR.TRANS.LIST SETTING POS THEN
DEL VAR.TRANS.LIST<POS>
END
END
CHANGE FM TO VM IN VAR.TRANS.LIST
R.REDO.CREDIT.TRANS.TELLER<CT.TRANSACTION.ID>=VAR.TRANS.LIST
R.REDO.CREDIT.TRANS.TELLER<CT.DATE>=TODAY
CALL F.WRITE(FN.REDO.CREDIT.TRANS.TELLER,VAR.CREDIT.CARD.ID,R.REDO.CREDIT.TRANS.TELLER)
RETURN
END
