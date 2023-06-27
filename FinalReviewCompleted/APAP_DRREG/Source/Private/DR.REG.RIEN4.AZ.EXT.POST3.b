* @ValidationCode : MjotNjQyOTk0MzM0OkNwMTI1MjoxNjg0ODU2ODc1MDMwOklUU1M6LTE6LTE6NTgwOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 21:17:55
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 580
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.DRREG
*
*--------------------------------------------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------------------------------------------
SUBROUTINE DR.REG.RIEN4.AZ.EXT.POST3
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
    $INSERT I_F.DR.REG.RIEN4.AZ.REP3
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

    FN.DR.REG.RIEN4.AZ.REP3 = 'F.DR.REG.RIEN4.AZ.REP3'
    F.DR.REG.RIEN4.AZ.REP3 = ''
    CALL OPF(FN.DR.REG.RIEN4.AZ.REP3,F.DR.REG.RIEN4.AZ.REP3)
*
RETURN
*-------------------------------------------------------------------
PROCESS.PARA:
*************

    SEL.CMD = "SELECT ":FN.DR.REG.RIEN4.AZ.REP3:" BY INT.RATE BY DAY.RANGE"
    CALL EB.READLIST(SEL.CMD, ID.LIST, "", ID.CNT, ERR.SEL)
    BALANCE = ''
    ID.CTR = 1
    LOOP
    WHILE ID.CTR LE ID.CNT
        CURR.REP.ID = ID.LIST<ID.CTR>
        NEXT.REP.ID = ID.LIST<ID.CTR+1>
        CALL F.READ(FN.DR.REG.RIEN4.AZ.REP3,CURR.REP.ID,R.DR.REG.RIEN4.AZ.REP3,F.DR.REG.RIEN4.AZ.REP3,DR.REG.RIEN4.AZ.REP3.ERR)
        CALL F.READ(FN.DR.REG.RIEN4.AZ.REP3,NEXT.REP.ID,R.DR.REG.RIEN4.AZ.REP3.1,F.DR.REG.RIEN4.AZ.REP3,DR.REG.RIEN4.AZ.REP3.ERR)
        CURR.RATE = R.DR.REG.RIEN4.AZ.REP3<DR.RIEN4.REP3.INT.RATE>
        CURR.DAY.RANGE = R.DR.REG.RIEN4.AZ.REP3<DR.RIEN4.REP3.DAY.RANGE>
        NEXT.RATE = R.DR.REG.RIEN4.AZ.REP3.1<DR.RIEN4.REP3.INT.RATE>
        NEXT.DAY.RANGE = R.DR.REG.RIEN4.AZ.REP3.1<DR.RIEN4.REP3.DAY.RANGE>
        CURR.PRIN.VAL = R.DR.REG.RIEN4.AZ.REP3<DR.RIEN4.REP3.PRINCIPAL>
        IF CURR.RATE NE NEXT.RATE THEN
            R.DR.REG.RIEN4.AZ.REP3<DR.RIEN4.REP3.TOTAL> = CURR.PRIN.VAL + BALANCE
            CALL F.WRITE(FN.DR.REG.RIEN4.AZ.REP3,CURR.REP.ID,R.DR.REG.RIEN4.AZ.REP3)
            BALANCE = ''
        END ELSE
            IF CURR.DAY.RANGE NE NEXT.DAY.RANGE THEN
                R.DR.REG.RIEN4.AZ.REP3<DR.RIEN4.REP3.TOTAL> = CURR.PRIN.VAL + BALANCE
                CALL F.WRITE(FN.DR.REG.RIEN4.AZ.REP3,CURR.REP.ID,R.DR.REG.RIEN4.AZ.REP3)
                BALANCE = ''
            END ELSE
                BALANCE += CURR.PRIN.VAL
            END
        END
**            END
**        END
        ID.CTR += 1
    REPEAT
*
RETURN
*-------------------------------------------------------------------
END
