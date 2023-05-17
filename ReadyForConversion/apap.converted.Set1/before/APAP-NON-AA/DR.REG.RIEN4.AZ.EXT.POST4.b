*
*--------------------------------------------------------------------------------------------------------------------------------
* <Rating>-20</Rating>
*--------------------------------------------------------------------------------------------------------------------------------
  SUBROUTINE DR.REG.RIEN4.AZ.EXT.POST4
*----------------------------------------------------------------------------------------------------------------------------------
*
* Description  : This routine will get the details from work file and writes into text file.
*
*-------------------------------------------------------------------------
* Date              Author                    Description
* ==========        ====================      ============
*
*-------------------------------------------------------------------------

  $INSERT I_COMMON
  $INSERT I_EQUATE
  $INSERT I_F.BATCH
  $INSERT I_F.DATES
$INSERT I_F.DR.REG.RIEN4.PARAM
$INSERT I_F.DR.REG.RIEN4.AZ.REP4
*
  GOSUB OPEN.FILES
  GOSUB PROCESS.PARA
*
  RETURN

*----------------------------------------------------------
OPEN.FILES:
***********

  FN.DR.REG.RIEN4.PARAM = 'F.DR.REG.RIEN4.PARAM'
  F.DR.REG.RIEN4.PARAM = ''
  CALL OPF(FN.DR.REG.RIEN4.PARAM,F.DR.REG.RIEN4.PARAM)

  FN.DR.REG.RIEN4.AZ.REP4 = 'F.DR.REG.RIEN4.AZ.REP4'
  F.DR.REG.RIEN4.AZ.REP4 = ''
  CALL OPF(FN.DR.REG.RIEN4.AZ.REP4,F.DR.REG.RIEN4.AZ.REP4)
*
  RETURN
*-------------------------------------------------------------------
PROCESS.PARA:
*************

  SEL.CMD = "SELECT ":FN.DR.REG.RIEN4.AZ.REP4:" BY INT.RATE BY DAY.RANGE"
  CALL EB.READLIST(SEL.CMD, ID.LIST, "", ID.CNT, ERR.SEL)
  BALANCE = ''
  ID.CTR = 1
  LOOP
  WHILE ID.CTR LE ID.CNT
    CURR.REP.ID = ID.LIST<ID.CTR>
    NEXT.REP.ID = ID.LIST<ID.CTR+1>
    CALL F.READ(FN.DR.REG.RIEN4.AZ.REP4,CURR.REP.ID,R.DR.REG.RIEN4.AZ.REP4,F.DR.REG.RIEN4.AZ.REP4,DR.REG.RIEN4.AZ.REP4.ERR)
    CALL F.READ(FN.DR.REG.RIEN4.AZ.REP4,NEXT.REP.ID,R.DR.REG.RIEN4.AZ.REP4.1,F.DR.REG.RIEN4.AZ.REP4,DR.REG.RIEN4.AZ.REP4.ERR)
    CURR.RATE = R.DR.REG.RIEN4.AZ.REP4<DR.RIEN4.REP4.INT.RATE>
    CURR.DAY.RANGE = R.DR.REG.RIEN4.AZ.REP4<DR.RIEN4.REP4.DAY.RANGE>
    NEXT.RATE = R.DR.REG.RIEN4.AZ.REP4.1<DR.RIEN4.REP4.INT.RATE>
    NEXT.DAY.RANGE = R.DR.REG.RIEN4.AZ.REP4.1<DR.RIEN4.REP4.DAY.RANGE>
    CURR.PRIN.VAL = R.DR.REG.RIEN4.AZ.REP4<DR.RIEN4.REP4.PRINCIPAL>
    IF CURR.RATE NE NEXT.RATE THEN
      R.DR.REG.RIEN4.AZ.REP4<DR.RIEN4.REP4.TOTAL> = CURR.PRIN.VAL + BALANCE
      CALL F.WRITE(FN.DR.REG.RIEN4.AZ.REP4,CURR.REP.ID,R.DR.REG.RIEN4.AZ.REP4)
      BALANCE = ''
    END ELSE
      IF CURR.DAY.RANGE NE NEXT.DAY.RANGE THEN
        R.DR.REG.RIEN4.AZ.REP4<DR.RIEN4.REP4.TOTAL> = CURR.PRIN.VAL + BALANCE
        CALL F.WRITE(FN.DR.REG.RIEN4.AZ.REP4,CURR.REP.ID,R.DR.REG.RIEN4.AZ.REP4)
        BALANCE = ''
      END ELSE
        BALANCE += CURR.PRIN.VAL
      END
    END
    ID.CTR += 1
  REPEAT
*
  RETURN
*-------------------------------------------------------------------
END
