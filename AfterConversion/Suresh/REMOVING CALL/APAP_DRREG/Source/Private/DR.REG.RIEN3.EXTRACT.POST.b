* @ValidationCode : MjoxNjEzMjgwOTQxOkNwMTI1MjoxNjg0ODU2ODczODUxOklUU1M6LTE6LTE6NjMwOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 21:17:53
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 630
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.DRREG
*
*--------------------------------------------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------------------------------------------
SUBROUTINE DR.REG.RIEN3.EXTRACT.POST
*----------------------------------------------------------------------------------------------------------------------------------
*
* Description  : This routine will get the details from work file and writes into text file.
*
*-------------------------------------------------------------------------
* Date              Author                    Description
* ==========        ====================      ============
* 6-June-2013       Gangadhar.S.V.            Initial creation
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*06-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   NO CHANGE
*06-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------


*-------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.BATCH
    $INSERT I_F.DATES
    $INSERT I_F.DR.REG.RIEN3.PARAM
*
    GOSUB OPEN.FILES
    GOSUB INIT.PARA
    GOSUB PROCESS.PARA
*
RETURN

*----------------------------------------------------------
OPEN.FILES:
***********

    FN.DR.REG.RIEN3.PARAM = 'F.DR.REG.RIEN3.PARAM'
    F.DR.REG.RIEN3.PARAM = ''
    CALL OPF(FN.DR.REG.RIEN3.PARAM,F.DR.REG.RIEN3.PARAM)

    FN.DR.REG.RIEN3.WORKFILE = 'F.DR.REG.RIEN3.WORKFILE'
    F.DR.REG.RIEN3.WORKFILE = ''
    CALL OPF(FN.DR.REG.RIEN3.WORKFILE, F.DR.REG.RIEN3.WORKFILE)
*
RETURN
*-------------------------------------------------------------------
INIT.PARA:
**********
*
    Y.DATE = R.DATES(EB.DAT.LAST.WORKING.DAY)

*  CALL F.READ(FN.DR.REG.RIEN3.PARAM,'SYSTEM',R.DR.REG.RIEN3.PARAM,F.DR.REG.RIEN3.PARAM,DR.REG.RIEN3.PARAM.ERR) ;*Tus Start
    CALL CACHE.READ(FN.DR.REG.RIEN3.PARAM,'SYSTEM',R.DR.REG.RIEN3.PARAM,DR.REG.RIEN3.PARAM.ERR) ; * Tus End
    FN.CHK.DIR = R.DR.REG.RIEN3.PARAM<RIEN3.PARAM.OUT.PATH>
    F.CHK.DIR = ''
    CALL OPF(FN.CHK.DIR,F.CHK.DIR)
    EXTRACT.FILE.ID = R.DR.REG.RIEN3.PARAM<RIEN3.PARAM.FILE.NAME>:'_':Y.DATE:'.csv'
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
SELECT.STMT:
************
*
    SEL.CMD = "SELECT ":FN.DR.REG.RIEN3.WORKFILE
    CALL EB.READLIST(SEL.CMD, ID.LIST, "", ID.CNT, ERR.SEL)
*
RETURN
*-------------------------------------------------------------------
PROCESS.PARA:
*************

    GOSUB SELECT.STMT

    GOSUB WRITE.HEADER

    LOOP
        REMOVE REC.ID FROM ID.LIST SETTING ID.POS
    WHILE REC.ID:ID.POS
        CALL F.READ(FN.DR.REG.RIEN3.WORKFILE, REC.ID, R.REC, F.DR.REG.RIEN3.WORKFILE, RD.ERR)
        IF R.REC THEN
            GOSUB WORK.PARA
        END
    REPEAT
*
    WRITE R.FILE.DATA ON F.CHK.DIR, EXTRACT.FILE.ID ON ERROR
        CALL OCOMO("Unable to write to the file":F.CHK.DIR)
    END
*
RETURN
*-------------------------------------------------------------------
WORK.PARA:
**********
*
*    CRLF = CHARX(013):CHARX(010)
*    CHANGE FM TO CRLF IN R.REC
    R.FILE.DATA<-1> = R.REC
*    WRITE R.FILE.DATA ON F.CHK.DIR, EXTRACT.FILE.ID ON ERROR
*        CALL OCOMO("Unable to write to the file":F.CHK.DIR)
*    END
*    WRITESEQ R.REC TO FV.EXTRACT.FILE ELSE NULL
*
RETURN
*---------------------------------------------------------------------------------
WRITE.HEADER:
*-----------*
*
    REP.HEADER = R.DR.REG.RIEN3.PARAM<RIEN3.PARAM.REP.HEADER,1>
    R.FILE.DATA<-1> = REP.HEADER
*    WRITESEQ R.DR.REG.RIEN3.PARAM<RIEN3.PARAM.REP.HEADER,1> TO FV.EXTRACT.FILE ELSE NULL
*    WRITESEQ R.DR.REG.RIEN3.PARAM<RIEN3.PARAM.REP.HEADER,2> TO FV.EXTRACT.FILE ELSE NULL
    REP.HEADER = R.DR.REG.RIEN3.PARAM<RIEN3.PARAM.REP.HEADER,2>
    R.FILE.DATA<-1> = REP.HEADER
    LAST.WORK.VAL = Y.DATE
    LAST.DATE = LAST.WORK.VAL[7,2]:"/":LAST.WORK.VAL[5,2]:"/":LAST.WORK.VAL[1,4]
**    CUT.OFF = R.DR.REG.RIEN3.PARAM<RIEN3.PARAM.REP.HEADER,3>:':':LAST.DATE
    CUT.OFF = LAST.DATE
    R.FILE.DATA<-1> = CUT.OFF
*    WRITESEQ CUT.OFF TO FV.EXTRACT.FILE ELSE NULL
    REP.FLD = R.DR.REG.RIEN3.PARAM<RIEN3.PARAM.REP.FIELD.NAMES>
    CHANGE @VM TO ',' IN REP.FLD
*    WRITESEQ REP.FLD TO FV.EXTRACT.FILE ELSE NULL
    R.FILE.DATA<-1> = REP.FLD
*
RETURN
*-------------------------------------------------------------------
END
