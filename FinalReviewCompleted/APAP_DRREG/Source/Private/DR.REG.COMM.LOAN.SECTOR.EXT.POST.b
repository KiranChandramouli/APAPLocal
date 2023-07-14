* @ValidationCode : MjotOTQ2ODg0NzQ3OkNwMTI1MjoxNjg0ODU2ODcwNzAzOklUU1M6LTE6LTE6Njc2OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 21:17:50
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 676
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.DRREG
*
*--------------------------------------------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------------------------------------------
SUBROUTINE DR.REG.COMM.LOAN.SECTOR.EXT.POST
*----------------------------------------------------------------------------------------------------------------------------------
*
* Description  : This routine will get the details from work file and writes into text file.
*
*-------------------------------------------------------------------------
*MODIFICATION HISTORY:
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*04-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   NO CHANGE
*04-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.BATCH
    $INSERT I_F.DATES
    $INSERT I_F.DR.REG.213IF01.PARAM
*
    GOSUB OPEN.FILES
    GOSUB PROCESS.PARA
*
RETURN

*----------------------------------------------------------
OPEN.FILES:
***********

    FN.DR.REG.213IF01.PARAM = 'F.DR.REG.213IF01.PARAM'
    FV.DR.REG.213IF01.PARAM = ''
    CALL OPF(FN.DR.REG.213IF01.PARAM, FV.DR.REG.213IF01.PARAM)

    FN.DR.REG.COM.LOAN.SECTOR.WORKFILE = 'F.DR.REG.COM.LOAN.SECTOR.WORKFILE'
    F.DR.REG.COM.LOAN.SECTOR.WORKFILE = ''
    CALL OPF(FN.DR.REG.COM.LOAN.SECTOR.WORKFILE,F.DR.REG.COM.LOAN.SECTOR.WORKFILE)
*
*  CALL F.READ(FN.DR.REG.213IF01.PARAM, "SYSTEM", R.DR.REG.213IF01.PARAM, F.DR.REG.213IF01.PARAM, DR.REG.213IF01.PARAM.ERR)        ;*/ TUS START/END
    CALL CACHE.READ(FN.DR.REG.213IF01.PARAM, "SYSTEM", R.DR.REG.213IF01.PARAM, DR.REG.213IF01.PARAM.ERR)
    FN.CHK.DIR = R.DR.REG.213IF01.PARAM<DR.213IF01.OUT.PATH>
    F.CHK.DIR = ''
    CALL OPF(FN.CHK.DIR,F.CHK.DIR)
    EXTRACT.FILE.ID = 'Sectores de prestamos Commerciales':TODAY:'.txt' ;* Parameterise
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

    SEL.CMD = "SELECT ":FN.DR.REG.COM.LOAN.SECTOR.WORKFILE
    CALL EB.READLIST(SEL.CMD, ID.LIST, "", ID.CNT, ERR.SEL)
    ID.CTR = 1
    LOOP
    WHILE ID.CTR LE ID.CNT
        R.REC = ''
        REC.ID = ID.LIST<ID.CTR>
        CALL F.READ(FN.DR.REG.COM.LOAN.SECTOR.WORKFILE, REC.ID, R.REC, F.DR.REG.COM.LOAN.SECTOR.WORKFILE, RD.ERR)
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
