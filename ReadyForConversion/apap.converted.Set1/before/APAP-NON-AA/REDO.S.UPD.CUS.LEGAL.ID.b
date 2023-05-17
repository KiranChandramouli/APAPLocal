*-----------------------------------------------------------------------------
* <Rating>-44</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.S.UPD.CUS.LEGAL.ID

* Correction routine to update the file REDO.CUSTOMER.LEGAL.ID
* PACS00190839

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.CUSTOMER


  GOSUB INIT
  GOSUB PROCESS

  CALL JOURNAL.UPDATE(1)

  RETURN

******
INIT:
******
*Initialise all the variable

  FN.CUS = 'F.CUSTOMER'
  F.CUS  = ''
  CALL OPF(FN.CUS,F.CUS)

  FN.REDO.CUS.LEGAL.ID = 'F.REDO.CUSTOMER.LEGAL.ID'
  F.REDO.CUS.LEGAL.ID = ''
  CALL OPF(FN.REDO.CUS.LEGAL.ID,F.REDO.CUS.LEGAL.ID)

  RETURN

*********
PROCESS:
*********
* Main process to selct all the customer with legal id

  SEL.CMD = "SELECT ":FN.CUS:" WITH LEGAL.ID NE '' "
  SEL.LIST = ''

  CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NOR,ERR)

  LOOP
    REMOVE Y.CUS.ID FROM SEL.LIST SETTING POS
  WHILE Y.CUS.ID:POS
    R.CUS = ''
    CALL F.READ(FN.CUS,Y.CUS.ID,R.CUS,F.CUS,CUS.ERR)
    IF R.CUS THEN
      Y.LEGAL.ID = R.CUS<EB.CUS.LEGAL.ID,1>
      GOSUB UPD.FILE
    END
  REPEAT
  RETURN

**********
UPD.FILE:
**********
* Section to update the file REDO.CUSTOMER.LEGAL.ID

  R.LEGAL.ID = ''
  CALL F.READ(FN.REDO.CUS.LEGAL.ID,Y.LEGAL.ID,R.LEGAL.ID,F.REDO.CUS.LEGAL.ID,LEGAL.ERR)
  IF LEGAL.ERR THEN
    R.VALUE = R.CUS<EB.CUS.COMPANY.BOOK>:"*":Y.CUS.ID
    CALL F.WRITE(FN.REDO.CUS.LEGAL.ID,Y.LEGAL.ID,R.VALUE)
  END

  RETURN

END
