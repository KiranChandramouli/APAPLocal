* @ValidationCode : MjoxMTEyMTU4MDExOlVURi04OjE2ODk3NDk2NTgwMTE6SVRTUzotMTotMToxMDg3OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 19 Jul 2023 12:24:18
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 1087
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE REDO.AZ.REINV.CONSULTA.POST
*-----------------------------------------------------------------------------
* Modification History
* DATE               AUTHOR              REFERENCE              DESCRIPTION
* 14-07-2023    Conversion Tool        R22 Auto Conversion     BP is removed in insert file,INCLUDE to INSERT,FM to @FM
* 17-07-2023    Narmadha V             R22 Manual Conversion   No Changes
*-----------------------------------------------------------------------------
    $INSERT I_COMMON ;*R22 Auto Conversion - START
    $INSERT I_EQUATE
    $INSERT I_F.DATES
    $INSERT I_F.REDO.H.REPORTS.PARAM
    $INSERT I_REDO.B.OVERDRAFT.ACCT.RTN.COMMON ;*R22 Auto Conversion - END

    GOSUB INITIALISE
    GOSUB PROCESS
RETURN

INITIALISE:
************
    FN.REDO.H.REPORTS.PARAM = "F.REDO.H.REPORTS.PARAM"
    F.REDO.H.REPORTS.PARAM = ""
    CALL OPF(FN.REDO.H.REPORTS.PARAM,F.REDO.H.REPORTS.PARAM)
*
    FN.DR.OPER.AZCONSL.WORKFILE = 'F.DR.OPER.AZCONSL.WORKFILE'
    F.DR.OPER.AZCONSL.WORKFILE = ''
    CALL OPF(FN.DR.OPER.AZCONSL.WORKFILE,F.DR.OPER.AZCONSL.WORKFILE)

    Y.RECORD.PARAM.ID = "REDO.OPER.RPT"
    R.REDO.H.REPORTS.PARAM = ''; PARAM.ERR = ''
    CALL CACHE.READ(FN.REDO.H.REPORTS.PARAM,Y.RECORD.PARAM.ID,R.REDO.H.REPORTS.PARAM,PARAM.ERR)
    IF R.REDO.H.REPORTS.PARAM THEN
        FN.CHK.DIR = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.DIR>
    END

    Y.OUT.FILE.NAME = 'DEPOSITO.CIERRE'
    F.CHK.DIR = ''; R.FIL = ''; FIL.ERR = ''
    CALL OPF(FN.CHK.DIR,F.CHK.DIR)
    EXTRACT.FILE.ID = Y.OUT.FILE.NAME:'.':R.DATES(EB.DAT.LAST.WORKING.DAY):'.csv'
    CALL F.READ(FN.CHK.DIR,EXTRACT.FILE.ID,R.FIL,F.CHK.DIR,READ.FIL.ERR)
    IF R.FIL THEN
        DELETE F.CHK.DIR,EXTRACT.FILE.ID
    END

    Y.OUT.FILE.NAME.1 = 'DEPOSITO.CANCELADO'
    F.CHK.DIR = ''; R.FIL = ''; FIL.ERR = ''
    CALL OPF(FN.CHK.DIR,F.CHK.DIR)
    EXTRACT.FILE.ID.1 = Y.OUT.FILE.NAME.1:'.':R.DATES(EB.DAT.LAST.WORKING.DAY):'.csv'
    CALL F.READ(FN.CHK.DIR,EXTRACT.FILE.ID.1,R.FIL,F.CHK.DIR,READ.FIL.ERR)
    IF R.FIL THEN
        DELETE F.CHK.DIR,EXTRACT.FILE.ID.1
    END
RETURN

PROCESS:
********
    SEL.CMD = ''; ID.LIST = ""; ID.CNT = ''; ERR.SEL = ''
    R.TOT.DATA = ''; RZR.TOT.DATA = ''; R.ARRY.DATA = ''; RZR.ARRY.DATA = ''
    YHDR.ARRAY = "Sucursal, Fecha de Apertura, No. Certificado, Nombre Cliente, No. Cuenta Reinvertida"
    YHDR.ARRAY.1 = "Sucursal, Fecha cancelacion AZ, No. Certificado, Nombre Cliente, No. Cuenta Reinvertida"
    SEL.CMD = "SELECT ":FN.DR.OPER.AZCONSL.WORKFILE
    CALL EB.READLIST(SEL.CMD, ID.LIST, "", ID.CNT, ERR.SEL)
    LOOP
        REMOVE REC.ID FROM ID.LIST SETTING OVER.POSN
    WHILE REC.ID:OVER.POSN
        R.DR.OPER.AZCONSL.WORKFILE = ''; RD.ERR = ''
        CALL F.READ(FN.DR.OPER.AZCONSL.WORKFILE, REC.ID, R.DR.OPER.AZCONSL.WORKFILE, F.DR.OPER.AZCONSL.WORKFILE, RD.ERR)
        IF REC.ID[1,4] EQ 'ZERO' THEN
            R.ARRY.DATA<-1> = R.DR.OPER.AZCONSL.WORKFILE
        END ELSE
            RZR.ARRY.DATA<-1> = R.DR.OPER.AZCONSL.WORKFILE
        END
    REPEAT
    R.TOT.DATA = YHDR.ARRAY:@FM:R.ARRY.DATA
    WRITE R.TOT.DATA ON F.CHK.DIR, EXTRACT.FILE.ID ON ERROR
        CALL OCOMO("Unable to write to the file":F.CHK.DIR)
    END
    RZR.TOT.DATA = YHDR.ARRAY.1:@FM:RZR.ARRY.DATA
    WRITE RZR.TOT.DATA ON F.CHK.DIR, EXTRACT.FILE.ID.1 ON ERROR
        CALL OCOMO("Unable to write to the file":F.CHK.DIR)
    END
RETURN
END
