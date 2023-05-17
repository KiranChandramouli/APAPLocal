SUBROUTINE DR.REG.RIEN6.EXTRACT.SELECT
*-----------------------------------------------------------------------------
* Company Name   : APAP
* Developed By   : gangadhar@temenos.com
* Program Name   : DR.REG.RIEN6.EXTRACT
* Date           : 3-May-2013
*-----------------------------------------------------------------------------
* Description:
*------------
* This multi-thread job is meant for to extact the AZ.ACCOUNT in DOP and non DOP
*-----------------------------------------------------------------------------
*
* Modification History :
* ----------------------
*   Date          Author              Modification Description
* 15/09/2014    V.P.Ashokkumar        PACS00312508 - Removed the filter check
* 15/10/2014    V.P.Ashokkumar        PACS00312508 - Replaced the ACCOUNT with AZ.ACCOUNT file.
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_DR.REG.RIEN6.EXTRACT.COMMON

    IF NOT(CONTROL.LIST) THEN
        GOSUB BUILD.CONTROL.LIST
    END
    GOSUB SEL.PROCESS
RETURN

BUILD.CONTROL.LIST:
*******************

    CALL EB.CLEAR.FILE(FN.DR.REG.RIEN6.WORKFILE, F.DR.REG.RIEN6.WORKFILE)
    CALL EB.CLEAR.FILE(FN.DR.REG.RIEN6.WORKFILE.FCY, F.DR.REG.RIEN6.WORKFILE.FCY)
    CONTROL.LIST<-1> = "TERM.DEPOSIT"
    CONTROL.LIST<-1> = "ACCOUNT.CLOSE"
RETURN

SEL.PROCESS:
************

    LIST.PARAMETER = ""
    BEGIN CASE
        CASE CONTROL.LIST<1,1> EQ "TERM.DEPOSIT"
            LIST.PARAMETER<2> = "F.AZ.ACCOUNT"
            CALL BATCH.BUILD.LIST(LIST.PARAMETER, "")
        CASE CONTROL.LIST<1,1> EQ "ACCOUNT.CLOSE"
            LIST.PARAMETER<2> = "F.ACCOUNT.CLOSURE"
            LIST.PARAMETER<3> = "DATE.TIME[1,6] EQ ":Y.DTE.SEL
            CALL BATCH.BUILD.LIST(LIST.PARAMETER, "")
        CASE 1
            DUMMY.LIST = ""
            CALL BATCH.BUILD.LIST("",DUMM.LIST)
    END CASE
RETURN

END
