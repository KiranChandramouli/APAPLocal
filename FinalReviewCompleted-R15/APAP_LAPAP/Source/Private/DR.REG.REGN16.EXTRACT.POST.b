* @ValidationCode : MjoxNjY1MDAyMzA5OkNwMTI1MjoxNjg2Njc0MjQ1NTI2OklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 13 Jun 2023 22:07:25
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE DR.REG.REGN16.EXTRACT.POST
*----------------------------------------------------------------------------------------------------------------------------------
*
* Description  : This routine will get the details from work file and writes into text file.
*
*-------------------------------------------------------------------------
* Date                 Author                    Description
* ==========        ====================      ============
* 05-09-2014            Ashokkumar            PACS00366332- Updated to remove the date field in param file.
* 28-11-2017            Ashokkumar            CN006499 - Changed the parameter file to add more data.
* 24-MARCH-2023         Conversion Tool       R22 Auto Conversion - Removed T24.BP in INSERT FILE
* 24-MARCH-2023         Conversion Tool       R22 Auto Conversion - changed $INCLUDE to $INSERT
* 24-MARCH-2023         Conversion Tool       R22 Auto Conversion - changed FM to @FM
* 07-JUN-2023           Ghayathri T           R22 Manual Conversion - Y.FIELD.VAL.ARR and Y.FIELD.NME.ARR variable Added in I_DR.REG.REGN16.EXTRACT.COMMON insert file
*------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.BATCH
    $INSERT I_F.DATES
    $INSERT I_F.REDO.H.REPORTS.PARAM
    $INSERT I_DR.REG.REGN16.EXTRACT.COMMON
*
    GOSUB OPEN.FILES
    GOSUB INIT.PARA
    GOSUB OPEN.EXTRACT.FILE
    GOSUB PROCESS.PARA
RETURN

*----------------------------------------------------------
OPEN.FILES:
***********

    FN.REDO.H.REPORTS.PARAM = "F.REDO.H.REPORTS.PARAM"
    F.REDO.H.REPORTS.PARAM  = ""
    CALL OPF(FN.REDO.H.REPORTS.PARAM,F.REDO.H.REPORTS.PARAM)

    FN.DR.REG.REGN16.WORKFILE = "F.DR.REG.REGN16.WORKFILE"
    FV.DR.REG.REGN16.WORKFILE = ""
    CALL OPF(FN.DR.REG.REGN16.WORKFILE, FV.DR.REG.REGN16.WORKFILE)
RETURN
*-------------------------------------------------------------------
INIT.PARA:
**********

    Y.REPORT.PARAM.ID = "PU01-REGN16"
    CALL CACHE.READ(FN.REDO.H.REPORTS.PARAM,Y.REPORT.PARAM.ID,R.REDO.H.REPORTS.PARAM,PARAM.ERR)
    FN.CHK.DIR = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.DIR>
RETURN

*-------------------------------------------------------------------
OPEN.EXTRACT.FILE:
******************
    OPEN.ERR = ''
    Y.DATE = TODAY
    REP.PERIOD = Y.DATE[5,2]:Y.DATE[1,4]
    EXTRACT.FILE.ID = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.FILE.NAME>:REP.PERIOD:'.txt'
    OPENSEQ FN.CHK.DIR,EXTRACT.FILE.ID TO FV.EXTRACT.FILE THEN
        DELETESEQ FN.CHK.DIR,EXTRACT.FILE.ID THEN
        END ELSE
            NULL    ;* In case if it exisit DELETE, for Safer side
        END
        OPENSEQ FN.CHK.DIR,EXTRACT.FILE.ID TO FV.EXTRACT.FILE ELSE    ;* After DELETE file pointer will be closed, hence reopen the file
            CREATE FV.EXTRACT.FILE THEN
            END ELSE
                OPEN.ERR = 1
            END
        END
    END ELSE
        CREATE FV.EXTRACT.FILE THEN
        END ELSE
            OPEN.ERR = 1
        END
    END

    IF OPEN.ERR THEN
        TEXT = "Unable to Create a File -> ":EXTRACT.FILE.ID
        CALL FATAL.ERROR("DR.REG.REGN16.EXTRACT.POST")
    END
RETURN

PROCESS.PARA:
*************

    SEL.CMD = "SELECT ":FN.DR.REG.REGN16.WORKFILE
    CALL EB.READLIST(SEL.CMD, ID.LIST, "", ID.CNT, ERR.SEL)

    LOOP
        REMOVE REC.ID FROM ID.LIST SETTING ID.POS
    WHILE REC.ID:ID.POS
        R.REC = ''; RD.ERR = ''
        CALL F.READ(FN.DR.REG.REGN16.WORKFILE, REC.ID, R.REC, FV.DR.REG.REGN16.WORKFILE, RD.ERR)
        IF R.REC THEN
            CRLF = CHARX(013):CHARX(010)
            CHANGE @FM TO CRLF IN R.REC
            WRITESEQ R.REC TO FV.EXTRACT.FILE THEN
            END ELSE
                NULL
            END
        END
    REPEAT
*

    LOCATE "START.DATE" IN Y.FIELD.NME.ARR<1,1> SETTING NMS.POS THEN;*R22 Manual conversion Y.FIELD.NME.ARR variable Added in I_DR.REG.REGN16.EXTRACT.COMMON
        Y.STR.VAL.ARR = Y.FIELD.VAL.ARR<1,NMS.POS>;*R22 Manual conversion Y.FIELD.VAL.ARR variable Added in I_DR.REG.REGN16.EXTRACT.COMMON
    END
    LOCATE "END.DATE" IN Y.FIELD.NME.ARR<1,1> SETTING NME.POS THEN
        Y.REL.VAL.ARR = Y.FIELD.VAL.ARR<1,NME.POS>
    END

    R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE,NMS.POS> = ''
    R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE,NME.POS> = ''
    CALL F.WRITE(FN.REDO.H.REPORTS.PARAM,Y.REPORT.PARAM.ID,R.REDO.H.REPORTS.PARAM)
RETURN
*-------------------------------------------------------------------
END
