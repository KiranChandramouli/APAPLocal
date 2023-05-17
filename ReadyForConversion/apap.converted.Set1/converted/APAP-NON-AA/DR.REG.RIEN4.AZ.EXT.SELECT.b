SUBROUTINE DR.REG.RIEN4.AZ.EXT.SELECT
*-----------------------------------------------------------------------------
* Company Name   : APAP
* Developed By   : gangadhar@temenos.com
* Program Name   : DR.REG.RIEN4.AZ.EXT
* Date           : 27-May-2013
*-----------------------------------------------------------------------------
* Description:
*------------
* This multi-thread job is meant for to extact the AZ.ACCOUNT Details product wise.
*-----------------------------------------------------------------------------
*
* Modification History :
* ----------------------
*   Date          Author              Modification Description
*16-09-2014   Ashokkumar             PACS00367490- Removed the multiple select statement on same file.
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_DR.REG.RIEN4.AZ.EXT.COMMON

    IF NOT(CONTROL.LIST) THEN
        GOSUB BUILD.CONTROL.LIST
    END
    GOSUB SEL.PROCESS
RETURN

BUILD.CONTROL.LIST:
*******************

    CALL EB.CLEAR.FILE(FN.DR.REG.RIEN4.AZ.REP,F.DR.REG.RIEN4.AZ.REP)
    CALL EB.CLEAR.FILE(FN.DR.REG.RIEN4.AZ.REP.OUT,F.DR.REG.RIEN4.AZ.REP.OUT)
    CALL EB.CLEAR.FILE(FN.DR.REG.RIEN4.AZ.REP2,F.DR.REG.RIEN4.AZ.REP2)
    CALL EB.CLEAR.FILE(FN.DR.REG.RIEN4.AZ.REP.OUT2,F.DR.REG.RIEN4.AZ.REP.OUT2)
    CALL EB.CLEAR.FILE(FN.DR.REG.RIEN4.AZ.REP3,F.DR.REG.RIEN4.AZ.REP3)
    CALL EB.CLEAR.FILE(FN.DR.REG.RIEN4.AZ.REP.OUT3,F.DR.REG.RIEN4.AZ.REP.OUT3)
    CALL EB.CLEAR.FILE(FN.DR.REG.RIEN4.AZ.REP4,F.DR.REG.RIEN4.AZ.REP4)
    CALL EB.CLEAR.FILE(FN.DR.REG.RIEN4.AZ.REP.OUT4,F.DR.REG.RIEN4.AZ.REP.OUT4)
    CALL EB.CLEAR.FILE(FN.DR.REG.RIEN4.AC.REP1,F.DR.REG.RIEN4.AC.REP1)
    CALL EB.CLEAR.FILE(FN.DR.REG.RIEN4.AC.REP2,F.DR.REG.RIEN4.AC.REP2)

    CONTROL.LIST<-1> = "REP1"
    CONTROL.LIST<-1> = "REP2"
RETURN

SEL.PROCESS:
************

    LIST.PARAMETER = ""

    BEGIN CASE
        CASE CONTROL.LIST<1,1> EQ "REP1"
            LIST.PARAMETER<2> = "F.AZ.ACCOUNT"
            LIST.PARAMETER<3> = "CATEGORY EQ ":YAZ.CAT.LIST
            CALL BATCH.BUILD.LIST(LIST.PARAMETER, "")

        CASE CONTROL.LIST<1,1> EQ "REP2"
            LIST.PARAMETER<2> = "F.ACCOUNT"
            LIST.PARAMETER<3> = "CATEGORY EQ ":YAC.CAT.LIST
            CALL BATCH.BUILD.LIST(LIST.PARAMETER, "")

        CASE 1
            DUMMY.LIST = ""
            CALL BATCH.BUILD.LIST("",DUMM.LIST)
    END CASE

RETURN

END
