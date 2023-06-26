* @ValidationCode : MjotMTMxOTczMzgzNDpDcDEyNTI6MTY4Nzc4MzkwODc2ODpIYXJpc2h2aWtyYW1DOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 26 Jun 2023 18:21:48
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
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
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
SUBROUTINE DR.REG.RIEN8.EXTRACT.SELECT
*-----------------------------------------------------------------------------
* Company Name   : APAP
* Developed By   : gangadhar@temenos.com
* Program Name   : DR.REG.RIEN8.EXTRACT
* Date           : 3-May-2013
*-----------------------------------------------------------------------------
* Description:
*------------
* This multi-thread job is meant for to extact the MM and SEC.TRADE in DOP and non DOP.
*-----------------------------------------------------------------------------
*
* Modification History :
* ----------------------
*   Date          Author              Modification Description
* 26-June-2023     Conversion tool    R22 Auto conversion       No changes
* 26-JUNE-2023      Harishvikram C   Manual R22 conversion      MM.CAT1 & MM.CAT2 are initialised in I_DR.REG.RIEN8.EXTRACT.COMMON
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_DR.REG.RIEN8.EXTRACT.COMMON
    $INSERT I_F.DR.REG.RIEN8.PARAM

    IF NOT(CONTROL.LIST) THEN
        GOSUB BUILD.CONTROL.LIST
    END

    GOSUB SEL.PROCESS

RETURN

*-----------------------------------------------------------------------------
BUILD.CONTROL.LIST:
*******************

    CALL EB.CLEAR.FILE(FN.DR.REG.RIEN8.WORKFILE, F.DR.REG.RIEN8.WORKFILE)
    CALL EB.CLEAR.FILE(FN.DR.REG.RIEN8.WORKFILE.FCY, F.DR.REG.RIEN8.WORKFILE.FCY)
    CONTROL.LIST<-1> = "SEC.TRADE.LCY"
    CONTROL.LIST<-1> = "SEC.TRADE.FCY"
    CONTROL.LIST<-1> = "MM.LCY"
    CONTROL.LIST<-1> = "MM.LCY"

RETURN
*-----------------------------------------------------------------------------
SEL.PROCESS:
************

    LIST.PARAMETER = ""

    BEGIN CASE

        CASE CONTROL.LIST<1,1> EQ "SEC.TRADE.LCY"
            LIST.PARAMETER<2> = "F.SEC.TRADE"
            LIST.PARAMETER<3> = "SECURITY.CURRENCY EQ ":LCCY
            CALL BATCH.BUILD.LIST(LIST.PARAMETER, "")

        CASE CONTROL.LIST<1,1> EQ "SEC.TRADE.FCY"
            LIST.PARAMETER<2> = "F.SEC.TRADE"
            LIST.PARAMETER<3> = "SECURITY.CURRENCY NE ":LCCY
            CALL BATCH.BUILD.LIST(LIST.PARAMETER, "")

        CASE CONTROL.LIST<1,1> EQ "MM.LCY"
            LIST.PARAMETER<2> = "F.MM.MONEY.MARKET"
            LIST.PARAMETER<3> = "CURRENCY EQ ":LCCY:" AND WITH CATEGORY GE ":MM.CAT1:" AND CATEGORY LE ":MM.CAT2
            CALL BATCH.BUILD.LIST(LIST.PARAMETER, "")

        CASE CONTROL.LIST<1,1> EQ "MM.LCY"
            LIST.PARAMETER<2> = "F.MM.MONEY.MARKET"
            LIST.PARAMETER<3> = "CURRENCY NE ":LCCY:" AND WITH CATEGORY GE ":MM.CAT1:" AND CATEGORY LE ":MM.CAT2
            CALL BATCH.BUILD.LIST(LIST.PARAMETER, "")


        CASE 1
            DUMMY.LIST = ""
            CALL BATCH.BUILD.LIST("",DUMM.LIST)
    END CASE


RETURN
*-----------------------------------------------------------------------------
END
