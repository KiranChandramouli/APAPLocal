* @ValidationCode : Mjo4NjI4Mjg3NjY6Q3AxMjUyOjE2ODA3NjgwMzgxMzg6YWppdGg6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 06 Apr 2023 13:30:38
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ajith
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.DRREG
*
*--------------------------------------------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------------------------------------------
SUBROUTINE DR.REG.RIEN4.AZ.EXT.OUT
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
    $INSERT I_F.DR.REG.RIEN4.AZ.REP
    $INSERT I_F.DR.REG.RIEN4.AZ.REP.OUT
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

    FN.DR.REG.RIEN4.AZ.REP = 'F.DR.REG.RIEN4.AZ.REP'
    F.DR.REG.RIEN4.AZ.REP = ''
    CALL OPF(FN.DR.REG.RIEN4.AZ.REP,F.DR.REG.RIEN4.AZ.REP)

    FN.DR.REG.RIEN4.AZ.REP.OUT = 'F.DR.REG.RIEN4.AZ.REP.OUT'
    F.DR.REG.RIEN4.AZ.REP.OUT = ''
    CALL OPF(FN.DR.REG.RIEN4.AZ.REP.OUT,F.DR.REG.RIEN4.AZ.REP.OUT)
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
    SEL.CMD1 = "SELECT ":FN.DR.REG.RIEN4.AZ.REP:" WITH TOTAL NE ''"
    CALL EB.READLIST(SEL.CMD1, ID.LIST1, "", ID.CNT1, ERR.SEL1)
    ID.CTR1 = 1
    LOOP
    WHILE ID.CTR1 LE ID.CNT1
        AZ.ID = ID.LIST1<ID.CTR1>
*    READ R.DR.REG.RIEN4.AZ.REP FROM F.DR.REG.RIEN4.AZ.REP,AZ.ID THEN ;*Tus Start
        CALL F.READ(FN.DR.REG.RIEN4.AZ.REP,AZ.ID,R.DR.REG.RIEN4.AZ.REP,F.DR.REG.RIEN4.AZ.REP,R.DR.REG.RIEN4.AZ.REP.ERR)
        IF R.DR.REG.RIEN4.AZ.REP THEN  ;* Tus End
            RATE.VAL = R.DR.REG.RIEN4.AZ.REP<DR.RIEN4.INT.RATE>
            DAY.RANGE.VAL = R.DR.REG.RIEN4.AZ.REP<DR.RIEN4.DAY.RANGE>
            DAYS.VAL = R.DR.REG.RIEN4.AZ.REP<DR.RIEN4.DAYS>
            TOT.VAL = R.DR.REG.RIEN4.AZ.REP<DR.RIEN4.TOTAL>
            CALL F.READ(FN.DR.REG.RIEN4.AZ.REP.OUT,RATE.VAL,R.DR.REG.RIEN4.AZ.REP.OUT,F.DR.REG.RIEN4.AZ.REP.OUT,DR.REG.RIEN4.AZ.REP.OUT.ERR)
            R.DR.REG.RIEN4.AZ.REP.OUT<DR.RIEN4.OUT.RATE> = RATE.VAL
            GOSUB GET.RANGE.TOTAL
            CALL F.WRITE(FN.DR.REG.RIEN4.AZ.REP.OUT,RATE.VAL,R.DR.REG.RIEN4.AZ.REP.OUT)
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
            R.DR.REG.RIEN4.AZ.REP.OUT<DR.RIEN4.OUT.RANGE.0.15> = TOT.VAL
        CASE DAY.RANGE.VAL EQ 2
            R.DR.REG.RIEN4.AZ.REP.OUT<DR.RIEN4.OUT.RANGE.16.30> = TOT.VAL
        CASE DAY.RANGE.VAL EQ 3
            R.DR.REG.RIEN4.AZ.REP.OUT<DR.RIEN4.OUT.RANGE.31.60> = TOT.VAL
        CASE DAY.RANGE.VAL EQ 4
            R.DR.REG.RIEN4.AZ.REP.OUT<DR.RIEN4.OUT.RANGE.61.90> = TOT.VAL
        CASE DAY.RANGE.VAL EQ 5
            R.DR.REG.RIEN4.AZ.REP.OUT<DR.RIEN4.OUT.RANGE.91.180> = TOT.VAL
        CASE DAY.RANGE.VAL EQ 6
            R.DR.REG.RIEN4.AZ.REP.OUT<DR.RIEN4.OUT.RANGE.181.360> = TOT.VAL
        CASE DAY.RANGE.VAL EQ 7
            R.DR.REG.RIEN4.AZ.REP.OUT<DR.RIEN4.OUT.RANGE.361.720> = TOT.VAL
        CASE DAY.RANGE.VAL EQ 8
            R.DR.REG.RIEN4.AZ.REP.OUT<DR.RIEN4.OUT.RANGE.721.1080> = TOT.VAL
        CASE DAY.RANGE.VAL EQ 9
            R.DR.REG.RIEN4.AZ.REP.OUT<DR.RIEN4.OUT.RANGE.1081.1440> = TOT.VAL
        CASE DAY.RANGE.VAL EQ 10
            R.DR.REG.RIEN4.AZ.REP.OUT<DR.RIEN4.OUT.RANGE.1441.1800> = TOT.VAL
        CASE DAY.RANGE.VAL EQ 11
            R.DR.REG.RIEN4.AZ.REP.OUT<DR.RIEN4.OUT.RANGE.1881> = TOT.VAL
    END CASE
*
RETURN
*-------------------------------------------------------------------
END
