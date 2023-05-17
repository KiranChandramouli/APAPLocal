*--------------------------------------------------------------------------------------------------------------------------------
* <Rating>-22</Rating>
*--------------------------------------------------------------------------------------------------------------------------------
  SUBROUTINE DR.REG.INT.TAX.PAYMENT.POST
*----------------------------------------------------------------------------------------------------------------------------------
*
* Description  : This routine will get the details from work file and writes into text file.
*
*-------------------------------------------------------------------------
* Date              Author                 Description
* ==========        ==============        ============
* 01-Aug-2014     V.P.Ashokkumar          PACS00305231 - Clearing the date field in parameter file.
*-------------------------------------------------------------------------

  $INSERT I_COMMON
  $INSERT I_EQUATE
  $INSERT I_F.BATCH
  $INSERT I_F.DATES
$INSERT I_F.DR.REG.INT.TAX.PAY.PARAM
*
  GOSUB OPEN.FILES
  GOSUB PROCESS.PARA
*
  RETURN

*----------------------------------------------------------
OPEN.FILES:
***********

  FN.DR.REG.INT.TAX.PAY.PARAM = 'F.DR.REG.INT.TAX.PAY.PARAM'
  F.DR.REG.INT.TAX.PAY.PARAM = ''
  CALL OPF(FN.DR.REG.INT.TAX.PAY.PARAM,F.DR.REG.INT.TAX.PAY.PARAM)

  FN.DR.REG.INT.TAX.PAY.WORKFILE = "F.DR.REG.INT.TAX.PAYMENT.WORKFILE"
  F.DR.REG.INT.TAX.PAY.WORKFILE = ""
  CALL OPF(FN.DR.REG.INT.TAX.PAY.WORKFILE, F.DR.REG.INT.TAX.PAY.WORKFILE)
*
  R.DR.REG.INT.TAX.PAY.PARAM = ''; DR.REG.INT.TAX.PAY.PARAM.ERR = ''
  CALL CACHE.READ(FN.DR.REG.INT.TAX.PAY.PARAM,'SYSTEM',R.DR.REG.INT.TAX.PAY.PARAM,DR.REG.INT.TAX.PAY.PARAM.ERR)

  FN.CHK.DIR = R.DR.REG.INT.TAX.PAY.PARAM<INT.TAX.PAY.PARAM.OUT.PATH>
  F.CHK.DIR = ''
  CALL OPF(FN.CHK.DIR,F.CHK.DIR)

  Y.DATE = R.DATES(EB.DAT.LAST.WORKING.DAY)
  REP.NAME = R.DR.REG.INT.TAX.PAY.PARAM<INT.TAX.PAY.PARAM.FILE.NAME>
  EXTRACT.FILE.ID = REP.NAME:'_':Y.DATE:'.txt'

  R.FILE.DATA = ''
  R.FIL = ''
  FIL.ERR = ''
  CALL F.READ(FN.CHK.DIR,EXTRACT.FILE.ID,R.FIL,F.CHK.DIR,READ.FIL.ERR)
  IF R.FIL THEN
    DELETE F.CHK.DIR,EXTRACT.FILE.ID
  END
  RETURN

*-------------------------------------------------------------------
PROCESS.PARA:
*************

  SEL.CMD = "SELECT ":FN.DR.REG.INT.TAX.PAY.WORKFILE
  CALL EB.READLIST(SEL.CMD, ID.LIST, "", ID.CNT, ERR.SEL)

  LOOP
    REMOVE REC.ID FROM ID.LIST SETTING ID.POS
  WHILE REC.ID:ID.POS
    R.REC = ''
    CALL F.READ(FN.DR.REG.INT.TAX.PAY.WORKFILE, REC.ID, R.REC, F.DR.REG.INT.TAX.PAY.WORKFILE, RD.ERR)
    IF R.REC THEN
*WRITESEQ R.REC TO FV.EXTRACT.FILE ELSE NULL
      R.FILE.DATA<-1> = R.REC
    END
  REPEAT
*
  WRITE R.FILE.DATA ON F.CHK.DIR, EXTRACT.FILE.ID ON ERROR
    CALL OCOMO("Unable to write to the file":F.CHK.DIR)
  END

  R.DR.REG.INT.TAX.PAY.PARAM<INT.TAX.PAY.PARAM.FROM.DATE> = ''
  R.DR.REG.INT.TAX.PAY.PARAM<INT.TAX.PAY.PARAM.TO.DATE> = ''
  CALL F.WRITE(FN.DR.REG.INT.TAX.PAY.PARAM,'SYSTEM',R.DR.REG.INT.TAX.PAY.PARAM)
*
  RETURN
*-------------------------------------------------------------------
END
