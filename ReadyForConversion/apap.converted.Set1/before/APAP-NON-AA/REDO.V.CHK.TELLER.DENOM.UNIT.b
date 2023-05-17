*-----------------------------------------------------------------------------
* <Rating>-46</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.V.CHK.TELLER.DENOM.UNIT
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.V.CHK.TELLER.DENOM.UNIT
*--------------------------------------------------------------------------------------------------------
*Description       : chekc record routine to populate all the denominations of teller
*Linked With       : Versions TELLER.ID,REDO.TELLER.CLOSE
*In  Parameter     : N/A
*Out Parameter     : N/A
*Files  Used       : TELLER                              As          I       Mode
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
* Date           Who                 Reference         Description
* ------         -----               -------------     -------------
* 21-03-2013     Arundev             PACS00254640      Initial creation
* 03-05-2013     Arundev             PACS00273070      4740 Cadena 31525  ENQ-QUERY REDO.TILL.CLOSE-3 (Issues Criticos)
* 15-05-2013     Vignesh Kumaar R    PACS00289078      Don't populate the denom for the first time
* 22-05-2015     Vignesh Kumaar R                      Revamp of the complete routine
*--------------------------------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.COMPANY

$INSERT I_F.COMPANY
$INSERT I_F.TELLER.ID

$INSERT I_F.TELLER.DENOMINATION

  IF V$FUNCTION EQ 'I' THEN
    GOSUB INITIALISE
    GOSUB OPENFILES
    GOSUB PROCESS
  END

  RETURN

*-------------------------------------------------------------------------------------------------------
INITIALISE:
*-------------------------------------------------------------------------------------------------------

  RETURN

*-------------------------------------------------------------------------------------------------------
OPENFILES:
*-------------------------------------------------------------------------------------------------------

  FN.TELLER.DENOMINATION = 'F.TELLER.DENOMINATION'
  F.TELLER.DENOMINATION = ''
  CALL OPF(FN.TELLER.DENOMINATION,F.TELLER.DENOMINATION)

  RETURN

*--------------------------------------------------------------------------------------------------------
PROCESS:
*--------------------------------------------------------------------------------------------------------

*deleting old denominations and units
  Y.CURR.DENOM.LIST = R.NEW(TT.TID.DENOMINATION)<1,CCYCNT>
  Y.CURR.UNIT.LIST = R.NEW(TT.TID.UNIT)<1,CCYCNT>
  OLD.DENOM.CNT = DCOUNT(Y.CURR.DENOM.LIST,SM)
  LOOP
  UNTIL OLD.DENOM.CNT EQ 0
    DEL R.NEW(TT.TID.DENOMINATION)<1,CCYCNT,OLD.DENOM.CNT>
    DEL R.NEW(TT.TID.UNIT)<1,CCYCNT,OLD.DENOM.CNT>
    OLD.DENOM.CNT -= 1
  REPEAT

*loop through teller currency list
  Y.CURRENCY.LIST = R.NEW(TT.TID.CURRENCY)
  Y.CATEGORY.LIST = R.NEW(TT.TID.CATEGORY)
  CCYPOS = ''
  CCYCNT = 1
  LOOP
    REMOVE Y.CURRENCY FROM Y.CURRENCY.LIST SETTING CCYPOS
  WHILE Y.CURRENCY:CCYPOS
    GOSUB SELECT.TELLER.DENOMINATION
    CCYCNT +=1
  REPEAT

  R.NEW(TT.TID.TILL.BALANCE) = ''

  RETURN

*--------------------------------------------------------------------------------------------------------
SELECT.TELLER.DENOMINATION:
*--------------------------------------------------------------------------------------------------------

*read all the pre defined teller denominations and default in teller id record
*unit will be updated with quantity currently available in stock control
  SEL.DENOM.LIST = ''
  SEL.DENOM.CNT = ''
  SEL.CMD = 'SELECT ':FN.TELLER.DENOMINATION:' WITH @ID LIKE ':Y.CURRENCY:'... BY VALUE'
  CALL EB.READLIST(SEL.CMD,SEL.DENOM.LIST,'',SEL.DENOM.CNT,'')

  LOOP
  UNTIL SEL.DENOM.CNT EQ 0
    Y.TELLER.DENOM = SEL.DENOM.LIST<SEL.DENOM.CNT>
    R.NEW(TT.TID.DENOMINATION)<1,CCYCNT,-1> = Y.TELLER.DENOM
    R.NEW(TT.TID.UNIT)<1,CCYCNT,-1> = '0'
    SEL.DENOM.CNT -= 1
  REPEAT

  RETURN

*--------------------------------------------------------------------------------------------------------
END       ;* End of Program
