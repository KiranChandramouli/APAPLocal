*
*--------------------------------------------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------------------------------------------
SUBROUTINE DR.REG.RIEN4.AZ.EXT.OUT4
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
    $INSERT I_F.DR.REG.RIEN4.AZ.REP.OUT4
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

    FN.DR.REG.RIEN4.AZ.REP.OUT4 = 'F.DR.REG.RIEN4.AZ.REP.OUT4'
    F.DR.REG.RIEN4.AZ.REP.OUT4 = ''
    CALL OPF(FN.DR.REG.RIEN4.AZ.REP.OUT4,F.DR.REG.RIEN4.AZ.REP.OUT4)
*
RETURN
*-------------------------------------------------------------------
PROCESS.PARA:
*-----------*
*
    SEL.CMD1 = ''
    ID.LIST1 = ''
    ID.CNT1 = ''
    ERR.SEL1 = ''
    SEL.CMD1 = "SELECT ":FN.DR.REG.RIEN4.AZ.REP4:" WITH TOTAL NE ''"
    CALL EB.READLIST(SEL.CMD1, ID.LIST1, "", ID.CNT1, ERR.SEL1)
    ID.CTR1 = 1
    LOOP
    WHILE ID.CTR1 LE ID.CNT1
        AZ.ID = ID.LIST1<ID.CTR1>
*    READ R.DR.REG.RIEN4.AZ.REP4 FROM F.DR.REG.RIEN4.AZ.REP4,AZ.ID THEN ;*Tus Start
        CALL F.READ(FN.DR.REG.RIEN4.AZ.REP4,AZ.ID,R.DR.REG.RIEN4.AZ.REP4,F.DR.REG.RIEN4.AZ.REP4,R.DR.REG.RIEN4.AZ.REP4.ERR)
        IF R.DR.REG.RIEN4.AZ.REP4 THEN  ;* Tus End
            RATE.VAL = R.DR.REG.RIEN4.AZ.REP4<DR.RIEN4.REP4.INT.RATE>
            DAY.RANGE.VAL = R.DR.REG.RIEN4.AZ.REP4<DR.RIEN4.REP4.DAY.RANGE>
            DAYS.VAL = R.DR.REG.RIEN4.AZ.REP4<DR.RIEN4.REP4.DAYS>
            TOT.VAL = R.DR.REG.RIEN4.AZ.REP4<DR.RIEN4.REP4.TOTAL>
            CALL F.READ(FN.DR.REG.RIEN4.AZ.REP.OUT4,RATE.VAL,R.DR.REG.RIEN4.AZ.REP.OUT4,F.DR.REG.RIEN4.AZ.REP.OUT4,DR.REG.RIEN4.AZ.REP.OUT4.ERR)
            R.DR.REG.RIEN4.AZ.REP.OUT4<DR.RIEN4.OUT4.RATE> = RATE.VAL
            GOSUB GET.RANGE.TOTAL
            CALL F.WRITE(FN.DR.REG.RIEN4.AZ.REP.OUT4,RATE.VAL,R.DR.REG.RIEN4.AZ.REP.OUT4)
        END
        ID.CTR1 += 1
    REPEAT
*
RETURN
*-------------------------------------------------------------------
GET.RANGE.TOTAL:
*--------------*
*
    BEGIN CASE
        CASE DAY.RANGE.VAL EQ 1
            R.DR.REG.RIEN4.AZ.REP.OUT4<DR.RIEN4.OUT4.RANGE.0.15> = TOT.VAL
        CASE DAY.RANGE.VAL EQ 2
            R.DR.REG.RIEN4.AZ.REP.OUT4<DR.RIEN4.OUT4.RANGE.16.30> = TOT.VAL
        CASE DAY.RANGE.VAL EQ 3
            R.DR.REG.RIEN4.AZ.REP.OUT4<DR.RIEN4.OUT4.RANGE.31.60> = TOT.VAL
        CASE DAY.RANGE.VAL EQ 4
            R.DR.REG.RIEN4.AZ.REP.OUT4<DR.RIEN4.OUT4.RANGE.61.90> = TOT.VAL
        CASE DAY.RANGE.VAL EQ 5
            R.DR.REG.RIEN4.AZ.REP.OUT4<DR.RIEN4.OUT4.RANGE.91.180> = TOT.VAL
        CASE DAY.RANGE.VAL EQ 6
            R.DR.REG.RIEN4.AZ.REP.OUT4<DR.RIEN4.OUT4.RANGE.181.360> = TOT.VAL
        CASE DAY.RANGE.VAL EQ 7
            R.DR.REG.RIEN4.AZ.REP.OUT4<DR.RIEN4.OUT4.RANGE.361.720> = TOT.VAL
        CASE DAY.RANGE.VAL EQ 8
            R.DR.REG.RIEN4.AZ.REP.OUT4<DR.RIEN4.OUT4.RANGE.721.1080> = TOT.VAL
        CASE DAY.RANGE.VAL EQ 9
            R.DR.REG.RIEN4.AZ.REP.OUT4<DR.RIEN4.OUT4.RANGE.1081.1440> = TOT.VAL
        CASE DAY.RANGE.VAL EQ 10
            R.DR.REG.RIEN4.AZ.REP.OUT4<DR.RIEN4.OUT4.RANGE.1441.1800> = TOT.VAL
        CASE DAY.RANGE.VAL EQ 11
            R.DR.REG.RIEN4.AZ.REP.OUT4<DR.RIEN4.OUT4.RANGE.1881> = TOT.VAL
    END CASE
*
RETURN
*-------------------------------------------------------------------
END
