* @ValidationCode : MjoxOTg2NjM1NjI4OkNwMTI1MjoxNjg0ODU2ODc0NjQ0OklUU1M6LTE6LTE6NTY5OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 21:17:54
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 569
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.DRREG
*
*--------------------------------------------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------------------------------------------
SUBROUTINE DR.REG.RIEN4.AZ.EXT.OUT2
*----------------------------------------------------------------------------------------------------------------------------------
*
* Description  : This routine will get the details from work file and writes into text file.
*
*-------------------------------------------------------------------------
* Date              Author                    Description
* ==========        ====================      ============
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*06-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   NO CHANGE
*06-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------



*-------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.BATCH
    $INSERT I_F.DATES
    $INSERT I_F.DR.REG.RIEN4.PARAM
    $INSERT I_F.DR.REG.RIEN4.AZ.REP2
    $INSERT I_F.DR.REG.RIEN4.AZ.REP.OUT2
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

    FN.DR.REG.RIEN4.AZ.REP2 = 'F.DR.REG.RIEN4.AZ.REP2'
    F.DR.REG.RIEN4.AZ.REP2 = ''
    CALL OPF(FN.DR.REG.RIEN4.AZ.REP2,F.DR.REG.RIEN4.AZ.REP2)

    FN.DR.REG.RIEN4.AZ.REP.OUT2 = 'F.DR.REG.RIEN4.AZ.REP.OUT2'
    F.DR.REG.RIEN4.AZ.REP.OUT2 = ''
    CALL OPF(FN.DR.REG.RIEN4.AZ.REP.OUT2,F.DR.REG.RIEN4.AZ.REP.OUT2)
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
    SEL.CMD1 = "SELECT ":FN.DR.REG.RIEN4.AZ.REP2:" WITH TOTAL NE ''"
    CALL EB.READLIST(SEL.CMD1, ID.LIST1, "", ID.CNT1, ERR.SEL1)
    ID.CTR1 = 1
    LOOP
    WHILE ID.CTR1 LE ID.CNT1
        AZ.ID = ID.LIST1<ID.CTR1>
*    READ R.DR.REG.RIEN4.AZ.REP2 FROM F.DR.REG.RIEN4.AZ.REP2,AZ.ID THEN ;*Tus Start
        CALL F.READ(FN.DR.REG.RIEN4.AZ.REP2,AZ.ID,R.DR.REG.RIEN4.AZ.REP2,F.DR.REG.RIEN4.AZ.REP2,R.DR.REG.RIEN4.AZ.REP2.ERR)
        IF R.DR.REG.RIEN4.AZ.REP2 THEN  ;* Tus End
            RATE.VAL = R.DR.REG.RIEN4.AZ.REP2<DR.RIEN4.REP2.INT.RATE>
            DAY.RANGE.VAL = R.DR.REG.RIEN4.AZ.REP2<DR.RIEN4.REP2.DAY.RANGE>
            DAYS.VAL = R.DR.REG.RIEN4.AZ.REP2<DR.RIEN4.REP2.DAYS>
            TOT.VAL = R.DR.REG.RIEN4.AZ.REP2<DR.RIEN4.REP2.TOTAL>
            CALL F.READ(FN.DR.REG.RIEN4.AZ.REP.OUT2,RATE.VAL,R.DR.REG.RIEN4.AZ.REP.OUT2,F.DR.REG.RIEN4.AZ.REP.OUT2,DR.REG.RIEN4.AZ.REP.OUT2.ERR)
            R.DR.REG.RIEN4.AZ.REP.OUT2<DR.RIEN4.OUT2.RATE> = RATE.VAL
            GOSUB GET.RANGE.TOTAL
            CALL F.WRITE(FN.DR.REG.RIEN4.AZ.REP.OUT2,RATE.VAL,R.DR.REG.RIEN4.AZ.REP.OUT2)
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
            R.DR.REG.RIEN4.AZ.REP.OUT2<DR.RIEN4.OUT2.RANGE.0.15> = TOT.VAL
        CASE DAY.RANGE.VAL EQ 2
            R.DR.REG.RIEN4.AZ.REP.OUT2<DR.RIEN4.OUT2.RANGE.16.30> = TOT.VAL
        CASE DAY.RANGE.VAL EQ 3
            R.DR.REG.RIEN4.AZ.REP.OUT2<DR.RIEN4.OUT2.RANGE.31.60> = TOT.VAL
        CASE DAY.RANGE.VAL EQ 4
            R.DR.REG.RIEN4.AZ.REP.OUT2<DR.RIEN4.OUT2.RANGE.61.90> = TOT.VAL
        CASE DAY.RANGE.VAL EQ 5
            R.DR.REG.RIEN4.AZ.REP.OUT2<DR.RIEN4.OUT2.RANGE.91.180> = TOT.VAL
        CASE DAY.RANGE.VAL EQ 6
            R.DR.REG.RIEN4.AZ.REP.OUT2<DR.RIEN4.OUT2.RANGE.181.360> = TOT.VAL
        CASE DAY.RANGE.VAL EQ 7
            R.DR.REG.RIEN4.AZ.REP.OUT2<DR.RIEN4.OUT2.RANGE.361.720> = TOT.VAL
        CASE DAY.RANGE.VAL EQ 8
            R.DR.REG.RIEN4.AZ.REP.OUT2<DR.RIEN4.OUT2.RANGE.721.1080> = TOT.VAL
        CASE DAY.RANGE.VAL EQ 9
            R.DR.REG.RIEN4.AZ.REP.OUT2<DR.RIEN4.OUT2.RANGE.1081.1440> = TOT.VAL
        CASE DAY.RANGE.VAL EQ 10
            R.DR.REG.RIEN4.AZ.REP.OUT2<DR.RIEN4.OUT2.RANGE.1441.1800> = TOT.VAL
        CASE DAY.RANGE.VAL EQ 11
            R.DR.REG.RIEN4.AZ.REP.OUT2<DR.RIEN4.OUT2.RANGE.1881> = TOT.VAL
    END CASE
*
RETURN
*-------------------------------------------------------------------
END
