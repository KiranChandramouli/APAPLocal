*---------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.B.UPDATE.CHEQ.STOCK.SELECT
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : SUDHARSANAN S
* Program Name  : REDO.B.UPDATE.CHEQ.STOCK.SELECT
*-------------------------------------------------------------------------

* Description :This routine will form a list which will be processed
*               by the routine REDO.B.UPDATE.CHEQ.STOCK on an yearly basis

* In parameter : None
* out parameter : None
*------------------------------------------------------------------------------------------
* Modification History :
*-------------------------------------
* DATE               WHO          REFERENCE         DESCRIPTION
* 22.03.2010  SUDHARSANAN S     ODR-2009-10-0319  INITIAL CREATION
* ----------------------------------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.CERTIFIED.CHEQUE.STOCK
$INSERT I_F.CERTIFIED.CHEQUE.STOCK.HIS
$INSERT I_F.DATES
$INSERT I_REDO.B.UPDATE.CHEQ.STOCK.COMMON
  SEL.CMD=''
  SEL.LIST=''
  NO.OF.REC=''
  ERR=''
  VAR1=1
  SEL.CMD="SELECT ":FN.CERTIFIED.CHEQUE.STOCK:" WITH STATUS EQ AVAILABLE"
  CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,ERR)
  LOOP
  WHILE VAR1 LE NO.OF.REC
    SEL.LIST.ID=SEL.LIST<VAR1>
    Y.DATE.COMPARE=SEL.LIST.ID[2,2]
    Y.TODAY.DATE = R.DATES(EB.DAT.TODAY)
    Y.LEFT.TODAY.DATE = LEFT(Y.TODAY.DATE,4)
    Y.TODAY = RIGHT(Y.LEFT.TODAY.DATE,2)
    IF Y.DATE.COMPARE EQ Y.TODAY THEN
      ID.LIST<-1>=SEL.LIST.ID
    END
    VAR1++
  REPEAT
  CALL BATCH.BUILD.LIST('',ID.LIST)
  RETURN
END
