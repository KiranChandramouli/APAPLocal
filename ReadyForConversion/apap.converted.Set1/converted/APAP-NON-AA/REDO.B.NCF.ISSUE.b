*-----------------------------------------------------------------------------
* <Rating>-42</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.B.NCF.ISSUE(Y.TXN.UNMAP.LIST)
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
*This Routine will select all the charges generated during the particular
*month and ganerates NCF for all the charges
*routine
* Input/Output:
*--------------
* IN  : Y.TXN.UNMAP.LIST
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS : -NA-
* CALLED BY : -NA-
*
* Revision History:
*------------------
*   Date               who           Reference            Description
* 25-MAR-2010        Prabhu.N       ODR-2009-10-0321     Initial Creation
*--------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.NCF.ISSUED
$INSERT I_F.REDO.L.NCF.STATUS
$INSERT I_F.REDO.L.NCF.UNMAPPED
$INSERT I_F.REDO.L.NCF.STOCK
$INSERT I_REDO.B.NCF.ISSUE.COMMON
$INSERT I_F.STMT.ENTRY
  GOSUB INIT
  GOSUB PROCESS
  GOSUB ASSIGN
  RETURN
*----
INIT:
*----

  Y.TXN.UNMAP.LIST=CHANGE(Y.TXN.UNMAP.LIST,"*",SM)
  Y.TXN.UNMAP.LIST=CHANGE(Y.TXN.UNMAP.LIST,"+",VM)
  VAR.NCF.UNMAP.LIST=Y.TXN.UNMAP.LIST<1,2>
  CHANGE SM TO FM IN VAR.NCF.UNMAP.LIST
  RETURN
*-------
PROCESS:
*-------
  LOOP
    REMOVE VAR.NCF.UNMAP.ID FROM VAR.NCF.UNMAP.LIST SETTING UNMAP.POS
  WHILE VAR.NCF.UNMAP.ID:UNMAP.POS
    CALL F.READ(FN.REDO.L.NCF.UNMAPPED,VAR.NCF.UNMAP.ID,R.NCF.UNMAPPED,F.REDO.L.NCF.UNMAPPED,UNMAP.ERR)
    IF R.NCF.ISSUED<ST.IS.TXN.ID> NE '' THEN
      R.NCF.ISSUED<ST.IS.TXN.ID>    =R.NCF.ISSUED<ST.IS.TXN.ID>:VM:R.NCF.UNMAPPED<ST.UN.TXN.ID>
      R.NCF.ISSUED<ST.IS.TXN.CHARGE>=R.NCF.ISSUED<ST.IS.TXN.CHARGE>:VM:R.NCF.UNMAPPED<ST.UN.TXN.CHARGE>
      R.NCF.ISSUED<ST.IS.TXN.TAX>   =R.NCF.ISSUED<ST.IS.TXN.TAX>:VM:R.NCF.UNMAPPED<ST.UN.TXN.TAX>
    END
    ELSE
      R.NCF.ISSUED<ST.IS.TXN.ID>=R.NCF.UNMAPPED<ST.UN.TXN.ID>
      R.NCF.ISSUED<ST.IS.TXN.CHARGE>=R.NCF.UNMAPPED<ST.UN.TXN.CHARGE>
      R.NCF.ISSUED<ST.IS.TXN.TAX>   =R.NCF.UNMAPPED<ST.UN.TXN.TAX>
    END
    R.NCF.ISSUED<ST.IS.CHARGE.AMOUNT> =R.NCF.ISSUED<ST.IS.CHARGE.AMOUNT>+R.NCF.UNMAPPED<ST.UN.CHARGE.AMOUNT>
    R.NCF.ISSUED<ST.IS.TAX.AMOUNT>    =R.NCF.ISSUED<ST.IS.TAX.AMOUNT>+R.NCF.UNMAPPED<ST.UN.TAX.AMOUNT>
  REPEAT
  RETURN
*------
ASSIGN:
*------
  GOSUB NCF.ASSIGN
  IF R.NCF.ISSUED<ST.IS.NCF>  NE '' THEN

    VAR.TRANS.LIST=R.NCF.ISSUED<ST.IS.TXN.ID>
    VAR.TRANS.LIST.COUNT=DCOUNT(VAR.TRANS.LIST,VM)
    VAR.LAST.TRANS      =VAR.TRANS.LIST<1,VAR.TRANS.LIST.COUNT>
    VAR.STMT.ID=R.NCF.UNMAPPED<ST.UN.STMT.ID>
    CALL F.READ(FN.STMT.ENTRY,VAR.STMT.ID,R.STMT.ENTRY,F.STMT.ENTRY,ERR)
    VAR.NCF.LIST=R.STMT.ENTRY<AC.STE.LOCAL.REF,LREF.POS>
    CHANGE SM TO FM IN VAR.NCF.LIST
    VAR.NCF.LIST<-1>=R.NCF.ISSUED<ST.IS.NCF>
    CHANGE FM TO SM IN VAR.NCF.LIST
    R.STMT.ENTRY<AC.STE.LOCAL.REF,LREF.POS>=VAR.NCF.LIST
    VAR.UNMAP.SIZE=DCOUNT(VAR.NCF.UNMAP.LIST,FM)
    VAR.NCF.UNMAP.LAST.ID=VAR.NCF.UNMAP.LIST<VAR.UNMAP.SIZE>
    R.NCF.ISSUED<ST.IS.ACCOUNT>        =R.NCF.UNMAPPED<ST.UN.ACCOUNT>
    R.NCF.ISSUED<ST.IS.TXN.TYPE>       =R.NCF.UNMAPPED<ST.UN.TXN.TYPE>
    R.NCF.ISSUED<ST.IS.DATE>           =R.NCF.UNMAPPED<ST.UN.DATE>
    R.NCF.ISSUED<ST.IS.CUSTOMER>       =R.NCF.UNMAPPED<ST.UN.CUSTOMER>
    R.NCF.ISSUED<ST.IS.BATCH>          ='YES'
    R.NCF.STATUS<NCF.ST.TRANSACTION.ID>=R.NCF.ISSUED<ST.IS.TXN.ID>
    R.NCF.STATUS<NCF.ST.CUSTOMER.ID>   =R.NCF.UNMAPPED<ST.UN.CUSTOMER>
    R.NCF.STATUS<NCF.ST.STATUS>        ='AVAILABLE'
    CALL F.WRITE(FN.REDO.L.NCF.ISSUED,VAR.NCF.UNMAP.LAST.ID,R.NCF.ISSUED)
    CALL F.WRITE(FN.REDO.L.NCF.STOCK,'SYSTEM',R.NCF.STOCK)
    VAR.UNMAP.LIST=VAR.NCF.UNMAP.LIST
    LOOP
      REMOVE VAR.UNMAP.ID FROM VAR.UNMAP.LIST SETTING VAR.UNMAP.POS
    WHILE VAR.UNMAP.ID:UNMAP.POS
      CALL F.DELETE(FN.REDO.L.NCF.STATUS,VAR.UNMAP.ID)
      CALL F.DELETE(FN.REDO.L.NCF.UNMAPPED,VAR.UNMAP.ID)
    REPEAT
    CALL F.WRITE(FN.REDO.L.NCF.STATUS,VAR.NCF.UNMAP.LAST.ID,R.NCF.STATUS)
    CALL F.WRITE(FN.STMT.ENTRY,VAR.STMT.ID,R.STMT.ENTRY)
  END
  RETURN
*----------
NCF.ASSIGN:
*----------
 CALL F.READU(FN.REDO.L.NCF.STOCK,'SYSTEM',R.NCF.STOCK,F.REDO.L.NCF.STOCK,ST.ERR,RETRY) ;*Tus Start 
*CALL CACHE.READ(CALL F.READU(FN.REDO.L.NCF.STOCK,'SYSTEM',R.NCF.STOCK,ST.ERR) ; * Tus End
  IF R.NCF.STOCK<ST.QTY.AVAIL.ORG> GT '0' THEN
    R.NCF.ISSUED<ST.IS.NCF>=R.NCF.STOCK<ST.SERIES>:R.NCF.STOCK<ST.BUSINESS.DIV>:R.NCF.STOCK<ST.PECF>:R.NCF.STOCK<ST.AICF>:R.NCF.STOCK<ST.TCF>:R.NCF.STOCK<ST.SEQUENCE.NO>
  END
  VAR.PREV.RANGE=R.NCF.STOCK<ST.PRE.ED.RG.OR>
  VAR.PREV.RANGE=VAR.PREV.RANGE<1,DCOUNT(VAR.PREV.RANGE,VM)>
  IF R.NCF.STOCK<ST.SEQUENCE.NO> EQ VAR.PREV.RANGE THEN
    R.NCF.STOCK<ST.SEQUENCE.NO>=R.NCF.STOCK<ST.L.STRT.RNGE.ORG>
  END
  ELSE
    R.NCF.STOCK<ST.SEQUENCE.NO>=R.NCF.STOCK<ST.SEQUENCE.NO>+1
    R.NCF.STOCK<ST.SEQUENCE.NO>=FMT(R.NCF.STOCK<ST.SEQUENCE.NO>,'8"0"R')
  END
  R.NCF.STOCK<ST.NCF.ISSUED.ORG>=R.NCF.STOCK<ST.NCF.ISSUED.ORG>+1
  R.NCF.STOCK<ST.QTY.AVAIL.ORG>=R.NCF.STOCK<ST.QTY.AVAIL.ORG>-1
  IF  R.NCF.STOCK<ST.QTY.AVAIL.ORG> GE R.NCF.STOCK<ST.L.MIN.NCF.ORG>  THEN
    R.NCF.STOCK<ST.NCF.STATUS.ORG>='AVAILABLE'
  END
  ELSE
    R.NCF.STOCK<ST.NCF.STATUS.ORG>='UNAVAILABLE'
  END
  RETURN
END
