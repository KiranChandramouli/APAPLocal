* @ValidationCode : MjotOTc4MjQ0MjQ2OkNwMTI1MjoxNjgyMzMxNTY2NDY5OklUU1M6LTE6LTE6Njc5OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 24 Apr 2023 15:49:26
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 679
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
*
*--------------------------------------------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------------------------------------------
SUBROUTINE REDO.B.COMMER.DEBTOR.DET.POST
*----------------------------------------------------------------------------------------------------------------------------------
*
* Description  : This routine will get the details from work file and writes into text file.
*
*-------------------------------------------------------------------------
* Date              Author                    Description
* ==========        ====================      ============


*
* Date             Who                   Reference      Description
* 21.04.2023       Conversion Tool       R22            Auto Conversion     - $INCLUDE TAM.BP TO $INSERT, INSERT file folder name removed T24.BP
* 21.04.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
*
*-------------------------------------------------------------------------

    $INSERT I_COMMON                      ;** R22 Auto conversion - START
    $INSERT I_EQUATE
    $INSERT I_F.BATCH
    $INSERT I_F.DATES                      ;** R22 Auto conversion - END
    $INSERT I_F.REDO.H.REPORTS.PARAM       ;** R22 Auto conversion - $INCLUDE TAM.BP TO $INSERT
*
    GOSUB OPEN.FILES
    GOSUB PROCESS.PARA
*
RETURN

*----------------------------------------------------------
OPEN.FILES:
***********

    FN.REDO.H.REPORTS.PARAM = "F.REDO.H.REPORTS.PARAM"
    F.REDO.H.REPORTS.PARAM  = ""
    CALL OPF(FN.REDO.H.REPORTS.PARAM,F.REDO.H.REPORTS.PARAM)

    FN.DR.REG.DE08DT.WORKFILE = 'F.DR.REG.DE08DT.WORKFILE'
    F.DR.REG.DE08DT.WORKFILE = ''
    CALL OPF(FN.DR.REG.DE08DT.WORKFILE,F.DR.REG.DE08DT.WORKFILE)
    Y.REPORT.PARAM.ID = 'REDO.DE08'
    CALL CACHE.READ(FN.REDO.H.REPORTS.PARAM,Y.REPORT.PARAM.ID,R.REDO.H.REPORTS.PARAM,PARAM.ERR)
    IF R.REDO.H.REPORTS.PARAM THEN
        FN.CHK.DIR = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.DIR>
        Y.OUT.FILE.NAME = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.FILE.NAME>
    END
    F.CHK.DIR = ''
    CALL OPF(FN.CHK.DIR,F.CHK.DIR)
    EXTRACT.FILE.ID = Y.OUT.FILE.NAME:R.DATES(EB.DAT.LAST.WORKING.DAY):'DETAIL.txt'          ;* Parameterise
    R.FILE.DATA = ''
*
    R.FIL = ''
    FIL.ERR = ''
    CALL F.READ(FN.CHK.DIR,EXTRACT.FILE.ID,R.FIL,F.CHK.DIR,READ.FIL.ERR)
    IF R.FIL THEN
        DELETE F.CHK.DIR,EXTRACT.FILE.ID
    END
*
RETURN
*-------------------------------------------------------------------
PROCESS.PARA:
*************
    SEL.CMD = "SELECT ":FN.DR.REG.DE08DT.WORKFILE
    CALL EB.READLIST(SEL.CMD, ID.LIST, "", ID.CNT, ERR.SEL)
    ID.CTR = 1
    LOOP
    WHILE ID.CTR LE ID.CNT
        R.REC = ''
        REC.ID = ID.LIST<ID.CTR>
        CALL F.READ(FN.DR.REG.DE08DT.WORKFILE, REC.ID, R.REC, F.DR.REG.DE08DT.WORKFILE, RD.ERR)
        IF R.REC THEN
            R.FILE.DATA<-1> = R.REC
        END
        ID.CTR += 1
    REPEAT
*
    WRITE R.FILE.DATA ON F.CHK.DIR, EXTRACT.FILE.ID ON ERROR
        CALL OCOMO("Unable to write to the file":F.CHK.DIR)
    END
*
RETURN
*-------------------------------------------------------------------
END
