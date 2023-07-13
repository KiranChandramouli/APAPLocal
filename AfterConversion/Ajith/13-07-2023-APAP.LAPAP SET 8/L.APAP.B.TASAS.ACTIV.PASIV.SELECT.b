$PACKAGE APAP.LAPAP
*---------------------------------------------------------------------------------------
*MODIFICATION HISTORY:
*DATE          WHO                 REFERENCE               DESCRIPTION
*13-07-2023    CONVERSION TOOL     R22 AUTO CONVERSION     NO CHANGE
*13-07-2023    AJITHKUMAR S        R22 MANUAL CONVERSION   NO CHANGE
*----------------------------------------------------------------------------------------
SUBROUTINE L.APAP.B.TASAS.ACTIV.PASIV.SELECT
*
* Client Name   : APAP
* Develop By    : Ashokkumar
* Description   : The routine to generate the Activasa and Pasivas report AR010.
*

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_TSA.COMMON
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_L.APAP.B.TASAS.ACTIV.PASIV.COMMON


    YTODAY = TODAY
    IF NOT(CONTROL.LIST) THEN
        GOSUB BUILD.CONTROL.LIST
    END
    GOSUB SEL.PROCESS
RETURN

BUILD.CONTROL.LIST:
*******************
    CALL EB.CLEAR.FILE(FN.DR.REG.PASIVAS.ACTIV, F.DR.REG.PASIVAS.ACTIV)
    CONTROL.LIST<-1> = "SELECT.AZ"
    CONTROL.LIST<-1> = "SELECT.AA"
    CONTROL.LIST<-1> = "SELECT.AC"
RETURN

SEL.PROCESS:
************
    LIST.PARAMETER = ""
    BEGIN CASE
        CASE CONTROL.LIST<1,1> EQ "SELECT.AZ"
            LIST.PARAMETER<2> = "F.AZ.ACCOUNT"
            LIST.PARAMETER<3> = "VALUE.DATE GE ":LAST.WORK.DAY:" AND VALUE.DATE LT ":YTODAY

        CASE CONTROL.LIST<1,1> EQ "SELECT.AC"
            LIST.PARAMETER<2> = "F.ACCOUNT"
*        LIST.PARAMETER<3> = "OPENING.DATE EQ ":LAST.WORK.DAY
            LIST.PARAMETTER<3> = "CATEGORY GE 6000 AND CATEGORY LE 6599"

        CASE CONTROL.LIST<1,1> EQ "SELECT.AA"
            LIST.PARAMETER = ""
            LIST.PARAMETER<2> = "F.AA.ARRANGEMENT"
            LIST.PARAMETER<3> = "ARR.STATUS EQ 'CURRENT' AND START.DATE EQ ":LAST.WORK.DAY
    END CASE
    CALL BATCH.BUILD.LIST(LIST.PARAMETER, "")
RETURN
END
