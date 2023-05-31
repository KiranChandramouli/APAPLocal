* @ValidationCode : MjoxNDM2MDIwMjcyOkNwMTI1MjoxNjgyMzMxNTY1MTg5OklUU1M6LTE6LTE6LTc6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 24 Apr 2023 15:49:25
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -7
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE REDO.B.ABANDONADAS.SELECT
*-------------------------------------------------------------------------------
* Company Name      : PAGE SOLUTIONS, INDIA
* Developed By      : Nirmal.P
* Reference         :
*-------------------------------------------------------------------------------
* Subroutine Type   : B
* Attached to       :
* Attached as       : Multi threaded Batch Routine.
*-------------------------------------------------------------------------------
* Input / Output :
*----------------
* IN     :
* OUT    :
*-------------------------------------------------------------------------------
* Description: This is a .SELECT Subroutine
*
*-------------------------------------------------------------------------------
* Modification History
*-----------------------------------------------------------------------------------------------------------------
* Defect Reference       Modified By                    Date of Change        Change Details
*(RTC/TUT/PACS)                                        (YYYY-MM-DD)
*-----------------------------------------------------------------------------------------------------------------
* PACS00392015          Ashokkumar.V.P                  19/11/2014           Changes based on mapping

*
* Date             Who                   Reference      Description
* 21.04.2023       Conversion Tool       R22            Auto Conversion     - INSERT file folder name removed T24.BP, TAM.BP, LAPAP.BP
* 21.04.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
*
*-----------------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON               ;** R22 Auto conversion
    $INSERT I_EQUATE               ;** R22 Auto conversion
    $INSERT I_F.DATES              ;** R22 Auto conversion
    $INSERT I_REDO.B.ABANDONADAS.COMMON       ;** R22 Auto conversion
    $INSERT I_F.REDO.H.REPORTS.PARAM          ;** R22 Auto conversion

    GOSUB PROCESS.DATE.SELECT
RETURN

PROCESS.DATE.SELECT:
*------------------
    CALL EB.CLEAR.FILE(FN.DR.REG.ABANDON.WORKFILE, F.DR.REG.ABANDON.WORKFILE)

*    SEL.CMD = "SELECT ":FN.ACCOUNT:" WITH WORKING.BALANCE NE '0' AND L.AC.STATUS1 EQ 'ABANDONED' AND L.AC.STATUS2 EQ ''"
    SEL.CMD = "SELECT ":FN.ACCOUNT:" WITH L.AC.STATUS1 EQ 'ABANDONED' AND L.AC.STATUS2 EQ ''"
    LIST.ACC = ''; NO.OF.ACC = ''; ACC.ERR = ''
    CALL EB.READLIST(SEL.CMD,LIST.ACC,'',NO.OF.ACC,ACC.ERR)
    CALL BATCH.BUILD.LIST("",LIST.ACC)
RETURN
END
