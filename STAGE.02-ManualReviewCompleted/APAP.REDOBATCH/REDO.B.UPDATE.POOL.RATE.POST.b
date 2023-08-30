* @ValidationCode : MjoxOTIzMTE0ODIxOkNwMTI1MjoxNjgxNzA3NTk3MDMxOklUU1M6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 17 Apr 2023 10:29:57
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.UPDATE.POOL.RATE.POST
*-----------------------------------------------------------------------------
* Description:
* This routine is a post routine to remove the records from concat file for ACI / GCI
*------------------------------------------------------------------------------------------
* * Input / Output
*
* --------------
* IN     : -NA-
* OUT    : -NA-
*------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : Sudharsanan S
* PROGRAM NAME : REDO.B.UPDATE.POOL.RATE.POST
*------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO            REFERENCE         DESCRIPTION
* 21.09.2010  ganesh r           ODR-2010-09-0251   INITIAL CREATION
* 17-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - ++ TO += 1
* 17-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.DATES
    $INSERT I_REDO.B.UPDATE.POOL.RATE.COMMON
*------------------------------------------------------------------------------------------
    GOSUB PROCESS
RETURN

PROCESS:
*------------------------------------------------------------------------------------------
    VAR.NEXT.DATES = R.DATES(EB.DAT.NEXT.WORKING.DAY)
    VAR.TODAY.DATE = TODAY
    Y.REGION = ''
    Y.DIFF.DAYS = 'C'
    CALL CDD(Y.REGION,VAR.TODAY.DATE,VAR.NEXT.DATES,Y.DIFF.DAYS)
    VAR.DATE = VAR.TODAY.DATE
    GOSUB PROCESS.REMOVE.ACI.GCI
    CNT  = 1
    LOOP
    WHILE CNT LT Y.DIFF.DAYS
        VAR.DATE = VAR.TODAY.DATE
        NO.OF.DAYS = "+":CNT:"C"
        CALL CDT('',VAR.DATE,NO.OF.DAYS)
        GOSUB PROCESS.REMOVE.ACI.GCI
        CNT += 1
    REPEAT
RETURN
*---------------------------------------------------------------
PROCESS.REMOVE.ACI.GCI:
*----------------------------------------------------------------
    SEL.CMD = "SELECT ":FN.REDO.W.UPD.REVIEW.ACCT:" WITH @ID LIKE ...":VAR.DATE:"..."
    CALL EB.READLIST(SEL.CMD,FILE.LIST,'',NO.OF.REC,RET.ERR)
    IF FILE.LIST THEN
        LOOP
            REMOVE VAR.ID FROM FILE.LIST SETTING FILE.POS
        WHILE VAR.ID:FILE.POS

            DAEMON.CMD = "DELETE ":FN.REDO.W.UPD.REVIEW.ACCT:" ":VAR.ID
            EXECUTE DAEMON.CMD

        REPEAT
    END
RETURN
*---------------------------------------------------------------
END
