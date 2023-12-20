* @ValidationCode : MjoxMDM1NDA4NDM4OkNwMTI1MjoxNzAyOTYzOTkwNDA2OjMzM3N1Oi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 19 Dec 2023 11:03:10
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.DRREG
*
*-----------------------------------------------------------------------------
*---------------------------------------------------------------------------------------
*MODIFICATION HISTORY:
*DATE          WHO                 REFERENCE               DESCRIPTION
*14-07-2023    CONVERSION TOOL     R22 AUTO CONVERSION     NO CHANGE
*14-07-2023    AJITHKUMAR S        R22 MANUAL CONVERSION   Variable MM.CAT1 and MM.CAT2 added in I_DR.REG.RIEN8.EXTRACT.COMMON
*14/12/2023    Suresh              R22 Manual Conversion   CALL routine Modified

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
*   $INSERT I_BATCH.FILES ;*R22 Manual Conversion
    $INSERT I_DR.REG.RIEN8.EXTRACT.COMMON
    $INSERT I_F.DR.REG.RIEN8.PARAM
    
    
    $USING EB.Service ;*R22 Manual Conversion

    IF NOT(CONTROL.LIST) THEN
        GOSUB BUILD.CONTROL.LIST
    END

    GOSUB SEL.PROCESS

RETURN

*-----------------------------------------------------------------------------
BUILD.CONTROL.LIST:
*******************

*  CALL EB.CLEAR.FILE(FN.DR.REG.RIEN8.WORKFILE, F.DR.REG.RIEN8.WORKFILE)
    EB.Service.ClearFile(FN.DR.REG.RIEN8.WORKFILE, F.DR.REG.RIEN8.WORKFILE) ;*R22 Manual Conversion
*   CALL EB.CLEAR.FILE(FN.DR.REG.RIEN8.WORKFILE.FCY, F.DR.REG.RIEN8.WORKFILE.FCY)
    EB.Service.ClearFile(FN.DR.REG.RIEN8.WORKFILE.FCY, F.DR.REG.RIEN8.WORKFILE.FCY) ;*R22 Manual Conversion
    
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
*     CALL BATCH.BUILD.LIST(LIST.PARAMETER, "")
            EB.Service.BatchBuildList(LIST.PARAMETER, "") ;*R22 Manual Conversion
        CASE CONTROL.LIST<1,1> EQ "SEC.TRADE.FCY"
            LIST.PARAMETER<2> = "F.SEC.TRADE"
            LIST.PARAMETER<3> = "SECURITY.CURRENCY NE ":LCCY
*           CALL BATCH.BUILD.LIST(LIST.PARAMETER, "")
            EB.Service.BatchBuildList(LIST.PARAMETER, "") ;*R22 Manual Conversion
            

        CASE CONTROL.LIST<1,1> EQ "MM.LCY"
            LIST.PARAMETER<2> = "F.MM.MONEY.MARKET"
            LIST.PARAMETER<3> = "CURRENCY EQ ":LCCY:" AND WITH CATEGORY GE ":MM.CAT1:" AND CATEGORY LE ":MM.CAT2
*       CALL BATCH.BUILD.LIST(LIST.PARAMETER, "")
            EB.Service.BatchBuildList(LIST.PARAMETER, "") ;*R22 Manual Conversion

        CASE CONTROL.LIST<1,1> EQ "MM.LCY"
            LIST.PARAMETER<2> = "F.MM.MONEY.MARKET"
            LIST.PARAMETER<3> = "CURRENCY NE ":LCCY:" AND WITH CATEGORY GE ":MM.CAT1:" AND CATEGORY LE ":MM.CAT2
*         CALL BATCH.BUILD.LIST(LIST.PARAMETER, "")
            EB.Service.BatchBuildList(LIST.PARAMETER, "") ;*R22 Manual Conversion

        CASE 1
            DUMMY.LIST = ""
*           CALL BATCH.BUILD.LIST("",DUMM.LIST)
            EB.Service.BatchBuildList("",DUMM.LIST) ;*R22 Manual Conversion
    END CASE


RETURN
*-----------------------------------------------------------------------------
END
