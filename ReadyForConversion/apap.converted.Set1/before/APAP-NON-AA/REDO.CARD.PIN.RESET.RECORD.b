*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.CARD.PIN.RESET.RECORD

****************************************************************
*DESCRIPTION:
*------------
*This routine is used to check whether the id is valid or not
*------------------------------------------------------------------------------------------
* Input/Output:
*--------------
* IN  : -NA-
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
* 12-05-2011           Prabhu.N      PACS00054646         Initial Creation
* 06-01-2012           Pradeep S     PACS00146405         Multi value logic considered
*----------------------------------------------------------------------------------------------
*------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.CARD.PIN.RESET
$INSERT I_F.REDO.CARD.BIN
$INSERT I_F.LATAM.CARD.ORDER
$INSERT I_F.CUSTOMER

  GOSUB INIT
  GOSUB PROCESS
  RETURN
*----
INIT:
*-----
  FN.REDO.CARD.BIN='F.REDO.CARD.BIN'
  F.REDO.CARD.BIN=''
  CALL OPF(FN.REDO.CARD.BIN,F.REDO.CARD.BIN)

  FN.LATAM.CARD.ORDER ='F.LATAM.CARD.ORDER'
  F.LATAM.CARD.ORDER =''
  CALL OPF(FN.LATAM.CARD.ORDER,F.LATAM.CARD.ORDER)

  FN.CUSTOMER='F.CUSTOMER'
  F.CUSTOMER=''
  CALL OPF(FN.CUSTOMER,F.CUSTOMER)
  RETURN
*-------
PROCESS:
*-------

  VAR.ID = ID.NEW[1,6]
  CALL F.READ(FN.REDO.CARD.BIN,VAR.ID,R.REDO.CARD.BIN,F.REDO.CARD.BIN,ERR)
  Y.CARD.TYPE=R.REDO.CARD.BIN<REDO.CARD.BIN.CARD.TYPE>
  CHANGE VM TO FM IN Y.CARD.TYPE
  Y.TOT.CARD.TYPE=DCOUNT(Y.CARD.TYPE,FM)
  Y.CARD.CNT=1
  LOOP
  WHILE Y.CARD.CNT LE Y.TOT.CARD.TYPE
    Y.LATAM.CARD.ID=Y.CARD.TYPE<Y.CARD.CNT>:'.':ID.NEW
    Y.CARD.ERR=''
    CALL F.READ(FN.LATAM.CARD.ORDER,Y.LATAM.CARD.ID,R.LATAM.CARD.ORDER,F.LATAM.CARD.ORDER,Y.CARD.ERR)
    IF NOT(Y.CARD.ERR) THEN
      R.NEW(RCPR.CUSTOMER.ID)     = R.LATAM.CARD.ORDER<CARD.IS.CUSTOMER.NO,1>
      R.NEW(RCPR.NAME.ON.PLASTIC) = R.LATAM.CARD.ORDER<CARD.IS.NAME.ON.PLASTIC,1>
      Y.CUSTOMER.ID               = R.LATAM.CARD.ORDER<CARD.IS.CUSTOMER.NO,1>

      R.NEW(RCPR.ACCOUNT.NO)      = R.LATAM.CARD.ORDER<CARD.IS.ACCOUNT,1>
      CALL F.READ(FN.CUSTOMER,Y.CUSTOMER.ID,R.CUSTOMER,F.CUSTOMER,ERR)
      R.NEW(RCPR.DATE.OF.BIRTH)   = R.CUSTOMER<EB.CUS.DATE.OF.BIRTH>
      R.NEW(RCPR.LAST.REST.DATE)  = R.OLD(RCPR.RESET.DATE)
      R.NEW(RCPR.RESET.DATE)      = TODAY
      R.NEW(RCPR.TIME.RESET)      = TIME()
      RETURN
    END
    Y.CARD.CNT++
  REPEAT
  RETURN
END
