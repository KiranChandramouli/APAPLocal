* @ValidationCode : MjoxOTM5ODMxNTExOkNwMTI1MjoxNjkwMTY3NDY5ODgzOklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIyX1NQNS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 24 Jul 2023 08:27:49
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.DRREG
*
*-----------------------------------------------------------------------------
*---------------------------------------------------------------------------------------
*MODIFICATION HISTORY:
*DATE          WHO                 REFERENCE               DESCRIPTION
*14-07-2023    CONVERSION TOOL     R22 AUTO CONVERSION     NO CHANGE
*14-07-2023    AJITHKUMAR S        R22 MANUAL CONVERSION   Variable MM.CAT1 and MM.CAT2 added in I_DR.REG.RIEN8.EXTRACT.COMMON
*---------------------------------------------------------------------------------------	-
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
*
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
