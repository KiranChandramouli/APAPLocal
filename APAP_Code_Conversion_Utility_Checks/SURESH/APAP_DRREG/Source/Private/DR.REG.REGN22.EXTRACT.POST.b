
* @ValidationCode : MjotMTgwNDA2MTI3OkNwMTI1MjoxNzAyNTU3MzkzMzIzOjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 14 Dec 2023 18:06:33
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.DRREG
*
*--------------------------------------------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------------------------------------------
SUBROUTINE DR.REG.REGN22.EXTRACT.POST
*----------------------------------------------------------------------------------------------------------------------------------
*
* Description  : This routine will get the details from work file and writes into text file.
*
*-------------------------------------------------------------------------
* Date              Author                    Description
* ==========        ====================      ============
*
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*06-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   NO CHANGE
*06-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*14/12/2023       Suresh                      R22 Manual Conversion      Change Hardcoding the value to IDVAR
*----------------------------------------------------------------------------------------

*-------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.BATCH
    $INSERT I_F.DATES
    $INSERT I_F.DR.REGREP.PARAM
*
    GOSUB OPEN.FILES
    GOSUB INIT.PARA
    GOSUB OPEN.EXTRACT.FILE
    GOSUB PROCESS.PARA
*
RETURN

*----------------------------------------------------------
OPEN.FILES:
***********

    FN.DR.REG.213IF01.PARAM = 'F.DR.REGREP.PARAM'
*FV.DR.REG.213IF01.PARAM = ''
*CALL OPF(FN.DR.REG.213IF01.PARAM, FV.DR.REG.213IF01.PARAM)

    FN.DR.REG.REGN22.WORKFILE = "F.DR.REG.REGN22.WORKFILE"
    FV.DR.REG.REGN22.WORKFILE = ""
    CALL OPF(FN.DR.REG.REGN22.WORKFILE, FV.DR.REG.REGN22.WORKFILE)
*
RETURN
*-------------------------------------------------------------------
INIT.PARA:
**********


*CALL F.READ(FN.DR.REG.213IF01.PARAM, "SYSTEM", R.DR.REG.213IF01.PARAM, F.DR.REG.213IF01.PARAM, DR.REG.213IF01.PARAM.ERR)                ;*TUS START
    IDVAR="SYSTEM" ;*R22 Manual Conversion
    CALL CACHE.READ(FN.DR.REG.213IF01.PARAM, IDVAR, R.DR.REG.213IF01.PARAM, DR.REG.213IF01.PARAM.ERR)                ;*TUS END ;*R22 Manual Conversion
    FN.CHK.DIR = R.DR.REG.213IF01.PARAM<DR.REG.REPORT.PATH>

RETURN

*-------------------------------------------------------------------
OPEN.EXTRACT.FILE:
******************
    OPEN.ERR = ''
*    EXTRACT.FILE.ID = 'REGN22_':TODAY:'.txt'      ;* Parameterise
    EXTRACT.FILE.ID = 'REGN22_':TODAY:'.csv'
    OPENSEQ FN.CHK.DIR,EXTRACT.FILE.ID TO FV.EXTRACT.FILE THEN
        DELETESEQ FN.CHK.DIR,EXTRACT.FILE.ID ELSE NULL          ;* In case if it exisit DELETE, for Safer side
        OPENSEQ FN.CHK.DIR,EXTRACT.FILE.ID TO FV.EXTRACT.FILE ELSE        ;* After DELETE file pointer will be closed, hence reopen the file
            CREATE FV.EXTRACT.FILE ELSE OPEN.ERR = 1
        END
    END ELSE
        CREATE FV.EXTRACT.FILE ELSE OPEN.ERR = 1
    END

    IF OPEN.ERR THEN
        TEXT = "Unable to Create a File -> ":EXTRACT.FILE.ID
        CALL FATAL.ERROR("DR.REG.REGN22.EXTRACT.POST")
    END

RETURN

*-------------------------------------------------------------------
PROCESS.PARA:
*************

    SEL.CMD = "SELECT ":FN.DR.REG.REGN22.WORKFILE
    CALL EB.READLIST(SEL.CMD, ID.LIST, "", ID.CNT, ERR.SEL)
    ID.CTR = 1
    LOOP
**        REMOVE REC.ID FROM ID.LIST SETTING ID.POS
**    WHILE REC.ID:ID.POS
    WHILE ID.CTR LE ID.CNT
        REC.ID = ID.LIST<ID.CTR>
        CALL F.READ(FN.DR.REG.REGN22.WORKFILE, REC.ID, R.REC, FV.DR.REG.REGN22.WORKFILE, RD.ERR)
        IF R.REC THEN
            SEQ.NO = FMT(ID.CTR,"7'0'R")
            R.REC = SEQ.NO:'|':R.REC
            CRLF = CHARX(013):CHARX(010)
            CHANGE @FM TO CRLF IN R.REC ;*R22 AUTO CODE CONVERSION
            WRITESEQ R.REC TO FV.EXTRACT.FILE ELSE NULL
        END
        ID.CTR += 1
    REPEAT
*
RETURN
*-------------------------------------------------------------------
END
